module Yarvis
  class Matrix
    module Dimension
      class Runtime
        attr_reader :language, :runtime
        def initialize(language, runtime)
          @language = language
          @runtime = runtime
        end

        def slug
          "runtime:#{@language}@#{@runtime}"
        end
      end
    end
  end
end
