require 'yaml'
require 'yarvis/build_spec'
require 'yarvis/matrix/dimension'

module Yarvis
  class Matrix
    def initialize(config)
      @config = config
    end

    def dimensions
      dimensionables.map{|k,v| [k,v.count]}
    end

    def dimensionables
      {
        docker: docker_dimensionables,
        runtime: runtime_dimensionables,
        env: env_dimensionables
      }
    end

    def env_dimensionables
      env_hash = {}
      @config.envs.each do |env_pair|
        key = env_pair.split('=', 2).first
        env_hash[key] ||= []
        env_hash[key] << env_pair
      end

      values = env_hash.values
      values.first.product(*values[1..-1]).map{|e| Dimension::Env.new(e)}
    end

    def docker_dimensionables
      @config.dockers.map{|d| Dimension::Docker.new(d) }
    end

    def runtime_dimensionables
      @config.runtimes.map{|d| Dimension::Runtime.new(@config.runtime, d) }
    end

    def specs
      dim_sets = dimensionables.values
      spec_sets = dim_sets.first.product(*dim_sets[1..-1])

      spec_sets.map do |dims|
        BuildSpec.new(@config, dimensions_to_hash(dims))
      end
    end

    def dimensions_to_hash(dims)
      hash = {}
      dims.each do |dim|
        key = dim.class.name.split('::').last.downcase.to_sym
        hash[key] = dim
      end
      hash
    end
  end
end
