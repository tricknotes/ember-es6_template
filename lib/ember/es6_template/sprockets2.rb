module Ember
  module ES6Template
    autoload :ES6, 'ember/es6_template/sprockets2/es6'
    autoload :ES6Module, 'ember/es6_template/sprockets2/es6module'
    autoload :CoffeeScript, 'ember/es6_template/sprockets2/coffee_script'

    def self.setup(env)
      env.register_engine '.es6', ES6
      env.register_engine '.module', ES6Module
      env.register_engine '.coffee', CoffeeScript
    end
  end
end
