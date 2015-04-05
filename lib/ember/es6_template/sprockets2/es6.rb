module Ember
  module ES6Template
    class ES6 < ::Tilt::Template
      def self.default_mime_type
        'application/javascript'
      end

      def prepare; end

      def evaluate(scope, locals, &block)
        env = scope.environment

        return data if module?(scope.pathname.to_s)

        result = Babel::Transpiler.transform(data,
          'sourceRoot' => env.root,
          'moduleRoot' => '',
          'filename' => scope.logical_path
        )

        return result['code']
      end

      private

      def module?(filename)
        filename =~ /\.module\.es6/
      end
    end
  end
end
