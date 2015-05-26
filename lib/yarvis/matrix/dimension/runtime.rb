module Yarvis
  class Matrix
    module Dimension
      class Runtime
        attr_reader :runtime, :version
        def initialize(runtime, version)
          @runtime = runtime
          @version = version
        end

        def slug
          "runtime:#{@runtime}:#{@version}"
        end
      end
    end
  end
end
