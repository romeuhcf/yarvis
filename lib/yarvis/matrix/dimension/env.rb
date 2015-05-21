module Yarvis
  class Matrix
    module Dimension
      class Env
        def initialize(env)
          @env = env
        end

        def slug
          @env.join('; ')
        end

        def to_script
          @env.join("\n")
        end
      end
    end
  end
end
