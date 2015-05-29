require 'yaml'
require 'yarvis/matrix'
module Yarvis
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
      @config.fetch(runtime)
    end

    def dockers
      @config.fetch('docker')
    end

    def envs
      @config.fetch('env')
    end

    def runtime
      @config.fetch('runtime')
    rescue KeyError => e
      raise KeyError, e.message + " in #{@config.keys}", e.backtrace
    end

    def script
      @config['script']
    end
  end
end
