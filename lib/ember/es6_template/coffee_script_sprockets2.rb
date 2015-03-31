module Ember
  module ES6Template
    class CoffeeScript < Tilt::CoffeeScriptTemplate
      def evaluate(scope, locals, &block)
        env = scope.environment

        filename = scope.pathname.to_s

        if es6_module?(filename)
          result = Babel::Transpiler.transform(
            ::CoffeeScript.compile(data, bare: true),
            'modules' => 'amd',
            'moduleIds' => true,
            'sourceRoot' => env.root,
            'moduleRoot' => '',
            'filename' => scope.logical_path,
            'blacklist' => ['es6.modules'] # Next precessor transpile module syntax
          )
        elsif es6?(filename)
          result = Babel::Transpiler.transform(
            ::CoffeeScript.compile(data, bare: true),
            'sourceRoot' => env.root,
            'moduleRoot' => '',
            'filename' => scope.logical_path
          )
        else
          return super
        end

        result['code']
      end

      private

      def es6_module?(filename)
        filename =~ /\.module\.(?:es6\.)?coffee/
      end

      def es6?(filename)
        filename =~ /\.(?:es6\.)?coffee/
      end
    end
  end
end

