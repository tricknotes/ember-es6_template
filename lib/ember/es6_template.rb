require 'ember/es6_template/version'

require 'sprockets'
require 'babel/transpiler'

module Ember
  module ES6Template
    case Sprockets::VERSION
    when /^2\./
      autoload :ES6, 'ember/es6_template/es6_sprockets2'
      autoload :ES6Module, 'ember/es6_template/es6module_sprockets2'

      def self.setup(env)
        env.register_engine '.es6', ES6
        env.register_engine '.module', ES6Module
      end
    when /^3\./
      autoload :ES6, 'ember/es6_template/es6'
      autoload :ES6Module, 'ember/es6_template/es6module'

      def self.setup(env)
        env.register_mime_type 'text/ecmascript-6', extensions: ['.es6'], charset: :unicode
        env.register_transformer 'text/ecmascript-6', 'application/javascript', ES6
        env.register_preprocessor 'text/ecmascript-6', Sprockets::DirectiveProcessor

        env.register_mime_type 'text/ecmascript-6+module', extensions: ['.module.es6'], charset: :unicode
        env.register_transformer 'text/ecmascript-6+module', 'application/javascript', ES6Module
        env.register_preprocessor 'text/ecmascript-6+module', Sprockets::DirectiveProcessor
      end
    else
      raise "Unsupported sprockets version: #{Sprockets::VERSION}"
    end
  end
end
