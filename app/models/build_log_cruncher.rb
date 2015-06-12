class LogCrunch
  STATUS_PENDING = 'pending'
  STATUS_SUCCESS = 'success'
  STATUS_FAILED  = 'failed'
  STATUS_RUNNING = 'running'
  STATUS_SKIPPED = 'skipped'

  attr_reader :label, :status
  attr_accessor :started_at
  attr_accessor :finished_at
  attr_accessor :is_last_on_pipeline
  attr_accessor :is_last_executed
  attr_accessor :pipeline_success
  attr_accessor :logs

  def initialize(build_job, label, started_at = nil)
    @status = started_at ? STATUS_RUNNING : STATUS_PENDING
    @build_job = build_job
    @label = label
    @logs = []
  end

  def started_at=(time)
    @started_at = time
    @status = STATUS_RUNNING
  end

  def duration
    case status
    when STATUS_SUCCESS
      self.finished_at - self.started_at
    when STATUS_FAILED
      self.finished_at - self.started_at
    when STATUS_RUNNING
      Time.now - self.started_at
    else
      nil
    end
  end

  def success?
    status == STATUS_SUCCESS
  end

  def add_log(message)
    @logs << [message]
  end

  def status_code=(status_code)
    @status_code = status_code
    @status = case status_code
              when 'success'
                STATUS_SUCCESS
              when 'skipped'
                STATUS_SKIPPED
              else
                STATUS_FAILED
              end
  end
end

class BuildLogCruncher
  attr_reader :crunches

  START_CHUNK_REGEXP  = /\A@@@ START:(?<stepname>[^@]+) MOMENT:(?<timestamp>\d{10}) @@@\z/
  FINISH_CHUNK_REGEXP = /\A@@@ FINISH:(?<stepname>[^@]+) MOMENT:(?<timestamp>\d{10}) STATUS:(?<status_code>[^ @]+) @@@\z/

  def initialize(build_job)
    @build_job = build_job
    parse_log!
  end

  def parse_log!
    @crunches = {
     'world' => @current_crunch = LogCrunch.new(@build_job, 'world')
    }

    @build_job.build_spec.command_set_list.each do |cs|
      @crunches[cs.label.to_s] = LogCrunch.new(@build_job, cs.label)
    end

    (@build_job.log || []).each do |message|
      message.strip!
      if m = START_CHUNK_REGEXP.match(message)
        on_start_message( m[:stepname], m[:timestamp])
      elsif m = FINISH_CHUNK_REGEXP.match(message)
        on_finish_message(m[:stepname], m[:timestamp], m[:status_code])
      else
        on_message(message)
      end
    end
  end

  def on_start_message(stepname, timestamp)
    @current_crunch = @crunches[stepname]
    @crunches[stepname].started_at = Time.at(timestamp.to_i)
  end

  def on_finish_message(stepname, timestamp, status_code)
    @crunches[stepname].finished_at = Time.at(timestamp.to_i)
    @crunches[stepname].status_code = status_code
  end

  def on_message(message)
    @current_crunch.add_log(message)
  end

  def each_crunch
    @crunches.each{|k, crunch| yield crunch}
  end

  def crunch_by_label(label)
    @crunches[label]
  end

end
