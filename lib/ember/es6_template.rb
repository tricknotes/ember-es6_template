require 'ember/es6_template/version'

require 'sprockets'
require 'babel/transpiler'

module Ember
  module ES6Template
    case Sprockets::VERSION
    when /^2\./
      autoload :ES6, 'ember/es6_template/es6_sprockets2'
      autoload :ES6Module, 'ember/es6_template/es6module_sprockets2'
      autoload :CoffeeScript, 'ember/es6_template/coffee_script_sprockets2'

      def self.setup(env)
        env.register_engine '.es6', ES6
        env.register_engine '.module', ES6Module
        env.register_engine '.coffee', CoffeeScript
      end
    when /^3\./
      autoload :ES6, 'ember/es6_template/es6'
      autoload :ES6Module, 'ember/es6_template/es6module'
      autoload :CoffeeScript, 'ember/es6_template/coffee_script'
      autoload :CoffeeScriptModule, 'ember/es6_template/coffee_script_module'
      autoload :CoffeeScriptHelper, 'ember/es6_template/coffee_script_helper'

      def self.setup(env)
        env.register_engine '.es6', ES6, mime_type: 'application/javascript'
        env.register_engine '.module.es6', ES6Module, mime_type: 'application/javascript'
        env.register_engine '.module.coffee', CoffeeScriptModule, mime_type: 'application/javascript'
        env.register_engine '.coffee', CoffeeScript, mime_type: 'application/javascript' # Force parse as ES6
      end
    else
      raise "Unsupported sprockets version: #{Sprockets::VERSION}"
    end
  end
end
