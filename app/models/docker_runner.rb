class DockerRunner
  attr_reader :container

  def self.from_container_id(container_id)
    from_container( Docker::Container.get(container_id) )
  end

  def self.from_container(container)
    obj = allocate
    obj.instance_eval do
      @container = container
      @root_path = container.json['Config']['WorkingDir']
    end
    obj
  end

  def initialize(root_path, build_spec)
    @root_path = root_path
    @build_spec = build_spec

    @container = Docker::Container.create({
      'Cmd' => ['bash', '-c', build_script ],
      'Image' => docker_image,
      'WorkingDir' => working_directory
    })
  end

  def id
    @container.id
  end

  def build_script
    script_lines = []
    build_steps.each do |step|
      script_lines << step_start_line(step)
      script_lines << step
      script_lines << step_finish_line(step)
    end
    script_lines.join(" && ")
  end

  def build_steps
    [
      "bundle install --without development --jobs=3 --retry=3" , # --deployment
      "bundle exec rspec spec",
    ] # TODO get from yaml
  end

  def step_start_line(step)
   "echo '@@@ START: #{step} @@@'"
  end

  def step_finish_line(step)
   "echo '@@@ FINISH: #{step} @@@'"
  end

  def docker_image
    'ruby' # TODO maybe overrided by yaml
  end

  def working_directory
    '/code' # TODO maybe overrided by yaml
  end

  def start
    @container.start( "Binds" =>  [ "#{@root_path}:#{working_directory}:rw" ]) unless running?
  end

  def logs(options = {stdout: true})
    output = []
    @container.streaming_logs(options) {|a, b| output << [a,b] }
    output
  end

  def pp_logs(*args)
    logs(*args).map{|a| a.join(': ')}.join("")
  end

  def terminate
    @container.delete(force: true)
  end

  def self.delete_all
    Docker::Container.all(:all => true).each do |container|
      container.delete(force: true)
    end
  end

  def running?
    state['Running']
  end

  def exit_status
    state['ExitCode']
  end

  def error_message
    state['Error']
  end

  def state
    @container.json['State']
  end

  def finished_at
    DateTime.parse state['FinishedAt'] if running?
  end
end
