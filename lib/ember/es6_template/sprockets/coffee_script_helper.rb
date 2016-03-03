module Ember
  module ES6Template
    module CoffeeScriptHelper
      def call(input)
        data = input[:data]

        result = input[:cache].fetch(_cache_key + [data]) do
          transform(
            Sprockets::Autoload::CoffeeScript.compile(data, bare: true),
            input
          )
        end

        result['code']
      end

      private

      def _cache_key
        [
          self.class.name,
          VERSION,
          Babel::Transpiler.version,
          Babel::Transpiler.source_version,
          Sprockets::Autoload::CoffeeScript.version
        ]
      end
    end
  end
end
