module Ember
  module ES6Template
    class Config
      attr_accessor :module_prefix

      def to_hash
        {
          module_prefix: module_prefix
        }
      end
    end
  end
end
