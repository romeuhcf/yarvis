class BuildLogCruncher
    attr_reader :crunches

  START_CHUNK_REGEXP  = /\A@@@ START: (?<stepname>[^@]+)@(?<timestamp>\d{10}) @@@\z/
  FINISH_CHUNK_REGEXP = /\A@@@ FINISH: (?<stepname>[^@]+)@(?<timestamp>\d{10}) @@@\z/

  class LogCrunch
    attr_reader :label
    attr_accessor :started_at
    attr_accessor :finished_at
    attr_accessor :is_last_on_pipeline
    attr_accessor :is_last_executed
    attr_accessor :pipeline_success
    attr_accessor :logs

    def initialize(build_job, label, started_at = nil)
      @build_job = build_job
      @label = label
      @started_at = started_at
      @logs = []
    end

    def duration
      finish = (self.finished_at || @build_job.finished_at || @build_job.updated_at)
      start = (self.started_at || @build_job.created_at)
      finish - start
    end


    #TODO... I need a running status
    def success?
      return true unless started_at

      true && (finished_at and (
      pipeline_success || !is_last_executed ) )
    end

    def add_log(fd, message)
      @logs << [fd, message]
    end
  end

  def initialize(build_job)
    @build_job = build_job
    parse_log!
  end

  def parse_log!
    @crunches = [
      @current_crunch = LogCrunch.new(@build_job, 'world')
    ]
    (@build_job.log || []).each do |log_item|
      fd, message = *log_item
      message.strip!
      if m = START_CHUNK_REGEXP.match(message)
        on_start_message( m[:stepname], m[:timestamp])
      elsif m = FINISH_CHUNK_REGEXP.match(message)
        on_finish_message(m[:stepname], m[:timestamp])
      else
        on_message(fd, message)
      end
    end
  end

  def on_start_message(stepname, timestamp)
    @current_crunch = LogCrunch.new(@build_job, stepname, Time.at(timestamp.to_i))
    @crunches << @current_crunch
  end

  def on_finish_message(stepname, timestamp)
    if @current_crunch.label != stepname
      fail "Unexpected current crunch with name #{@current_crunch.label}. Expected #{stepname}"
    end

    @current_crunch.finished_at = Time.at(timestamp.to_i)
  end

  def on_message(fd, message)
    @current_crunch.add_log(fd, message)
  end

  def each_crunch
    @crunches.each{|i| yield i}
  end

  def crunch_by_label(label)
    @crunches.find{|c| c.label.to_s == label}
  end

end
