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

        dependencies = [
          input[:load_path],
          input[:name],
          data
        ]

        result = input[:cache].fetch(_cache_key + dependencies) do
          transform(data, input)
        end

        result['code']
      end

      private

      def transform(data, input)
        actual_name = input[:name]
        if input[:filename][File.expand_path(input[:name] + '/index', input[:load_path])]
          if actual_name == '.'
            actual_name = 'index'
          else
            actual_name += '/index'
          end
        end

        Babel::Transpiler.transform(data,
          'modules' => 'amd',
          'moduleIds' => true,
          'sourceRoot' => input[:load_path],
          'moduleRoot' => '',
          'filename' => actual_name(input)
        )
      end

      def _cache_key
        [
          self.class.name,
          VERSION,
          Babel::Transpiler.version,
          Babel::Transpiler.source_version
        ]
      end

      def actual_name(input)
        actual_name = input[:name]

        if input[:filename][File.expand_path(input[:name] + '/index', input[:load_path])]
          if actual_name == '.'
            actual_name = 'index'
          else
            actual_name += '/index'
          end
        end

        actual_name
      end
    end
  end
end
