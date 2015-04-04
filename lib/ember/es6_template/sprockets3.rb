module Ember
  module ES6Template
    autoload :ES6, 'ember/es6_template/sprockets3/es6'
    autoload :ES6Module, 'ember/es6_template/sprockets3/es6module'
    autoload :CoffeeScript, 'ember/es6_template/sprockets3/coffee_script'
    autoload :CoffeeScriptModule, 'ember/es6_template/sprockets3/coffee_script_module'
    autoload :CoffeeScriptHelper, 'ember/es6_template/sprockets3/coffee_script_helper'

    def self.setup(env)
      env.register_engine '.es6', ES6, mime_type: 'application/javascript'
      env.register_engine '.module.es6', ES6Module, mime_type: 'application/javascript'
      env.register_engine '.module.coffee', CoffeeScriptModule, mime_type: 'application/javascript'
      env.register_engine '.coffee', CoffeeScript, mime_type: 'application/javascript' # Force parse as ES6
    end
  end
end

