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
