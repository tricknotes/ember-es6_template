module Ember
  module ES6Template
    class CoffeeScript < Tilt::CoffeeScriptTemplate
      def evaluate(scope, locals, &block)
        filename = scope.pathname.to_s

        if es6?(filename)
          ::CoffeeScript.compile(data, bare: true)
        else
          super
        end
      end

      private

      def es6?(filename)
        filename =~ /\.(?:module|es6)\.coffee/
      end
    end
  end
end
