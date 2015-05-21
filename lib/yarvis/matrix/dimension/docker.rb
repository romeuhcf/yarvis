module Yarvis
  class Matrix
    module Dimension
      class Docker
        attr_reader :docker, :docker_options
        def initialize(docker_options)
          interpret_docker_options(docker_options)
        end

        def slug
          "docker:#{@docker}"
        end

        def interpret_docker_options(options)
          case options
          when String
            @docker = options
          when Hash
            @docker = options.keys.first
            @docker_options = options.values
          end
        end
      end
    end
  end
end
