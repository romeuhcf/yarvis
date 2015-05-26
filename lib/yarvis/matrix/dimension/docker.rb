module Yarvis
  class Matrix
    module Dimension
      class Docker
        attr_reader :image_tag, :commands
        def initialize(docker_options)
          interpret_docker_options(docker_options)
        end

        def slug
          "docker:#{@image_tag}"
        end

        def interpret_docker_options(options)
          case options
          when String
            @image_tag = options
          when Hash
            @image_tag = options.keys.first
            @commands = options.values
          end
        end
      end
    end
  end
end
