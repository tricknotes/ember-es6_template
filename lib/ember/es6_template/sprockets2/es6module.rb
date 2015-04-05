module Ember
  module ES6Template
    class ES6Module < ::Tilt::Template
      def self.default_mime_type
        'application/javascript'
      end

      def prepare; end

      def evaluate(scope, locals, &block)
        env = scope.environment

        result = Babel::Transpiler.transform(data,
          'modules' => 'amd',
          'moduleIds' => true,
          'sourceRoot' => env.root,
          'moduleRoot' => '',
          'filename' => module_name(scope.logical_path)
        )

        result['code']
      end

      private

      def module_name(path)
        [Ember::ES6Template.config.module_prefix, path].compact.join('/')
      end
    end
  end
end
