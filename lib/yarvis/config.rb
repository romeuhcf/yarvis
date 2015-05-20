require 'yaml'
module Yarvis
  class Matrix

    class BuildCase
      def initialize(dims)
        @dims = dims
      end

      def to_s
        @dims.join(" | ")
      end
    end

    class EnvDim
      def initialize(env)
        @env = env
      end

      def to_s
        @env.join('; ')
      end
    end

    class DockerDim
      def initialize(docker)
        @docker = docker
      end

      def to_s
        "docker:#{label}"
      end

      def label
        if @docker.is_a? Hash
          @docker.keys.first
        else
          @docker
        end
      end
    end

    class RuntimeDim
      def initialize(language, runtime)
        @language = language
        @runtime = runtime
      end

      def to_s
        "runtime:#{@language}@#{@runtime}"
      end
    end

    def initialize(config)
      @config = config
    end

    def dimensions
      dimensionables.map{|k,v| [k,v.count]}
    end

    def dimensionables
      {docker: docker_dimensionables, runtime: runtime_dimensionables, env: env_dimensionables }
    end

    def env_dimensionables
      env_hash = {}
      @config.envs.each do |env_pair|
        key = env_pair.split('=', 2).first
        env_hash[key] ||= []
        env_hash[key] << env_pair
      end

      values = env_hash.values
      values.first.product(*values[1..-1]).map{|e| EnvDim.new(e)}
    end

    def docker_dimensionables
      @config.dockers.map{|d| DockerDim.new(d) }
    end

    def runtime_dimensionables
      @config.runtimes.map{|d| RuntimeDim.new(@config.language, d) }
    end

    def cases
      dim_sets = dimensionables.values
      case_sets = dim_sets.first.product(*dim_sets[1..-1])
      case_sets.map{|dims| BuildCase.new(dims)}
    end
  end

  class Config
    def self.from_yaml(file)
      config = YAML.load(IO.read(file))
      self.new(config)
    end

    def initialize(config)
      @config = config
    end

    def matrix
      @_matrix || Matrix.new(self)
    end

    def runtimes
      @config[language]
    end

    def dockers
      @config['docker']
    end

    def envs
      @config['env']
    end

    def language
      @config['language']
    end
  end
end
