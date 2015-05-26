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
          @env.map{|e| "export #{e}"}.join('; ')
        end
      end
    end
  end
end
