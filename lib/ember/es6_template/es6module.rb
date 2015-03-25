module Ember
  module ES6Template
    class ES6Module
      def self.instance
        @instance ||= new
      end

      def self.call(input)
        instance.call(input)
      end

      def call(input)
        data = input[:data]

        result = input[:cache].fetch(cache_key + [data]) do
          Babel::Transpiler.transform(data,
            'modules' => 'amd',
            'moduleIds' => true,
            'sourceRoot' => input[:load_path],
            'moduleRoot' => '',
            'filename' => input[:name]
          )
        end

        result['code']
      end

      private

      def cache_key
        [
          self.class.name,
          VERSION,
          Babel::Transpiler.version,
          Babel::Transpiler.source_version
        ]
      end
    end
  end
end
