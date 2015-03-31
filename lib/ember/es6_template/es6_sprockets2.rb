module Ember
  module ES6Template
    class ES6 < ::Tilt::Template
      def self.default_mime_type
        'application/javascript'
      end

      def prepare; end

      def evaluate(scope, locals, &block)
        env = scope.environment

        result = Babel::Transpiler.transform(data,
          'sourceRoot' => env.root,
          'moduleRoot' => '',
          'filename' => scope.logical_path,
          'blacklist' => ['es6.modules']
        )

        result['code']
      end
    end
  end
end
