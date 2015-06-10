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
      @name      = container.json['Config']['Name']
    end
    obj
  end

  def initialize(root_path, build_spec, name)
    @root_path  = root_path
    @build_spec = build_spec
    @name       = name
    @container  = Docker::Container.create(docker_creation_params)
  end

  def docker_image_tag
    @build_spec.docker_dim.image_tag
  end

  def docker_creation_params
    puts '------------------------'
    puts @build_spec.build_script
    puts '------------------------'
    {
      'Cmd' => ['bash', '-lc', @build_spec.build_script ],
      'Image'      =>         docker_image_tag ,
      'WorkingDir' =>         @build_spec.working_directory,
      'Name'       =>         @name,
      #'User'       =>         'yarvis'
    }
  end

  def id
    @container.id
  end

  def start
    start_params = { "Binds" =>  [ "#{@root_path}:#{@build_spec.working_directory}:rw" ] }
    @container.start(start_params) unless running?
  end

  def logs(options = {stdout: true, stderr: true})
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
