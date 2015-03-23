require 'ember/es6_template/version'

require 'sprockets'
require 'babel/transpiler'

module Ember
  module ES6Template
    case Sprockets::VERSION
    when /^2\./
      autoload :ES6, 'ember/es6_template/es6_sprockets2'
      autoload :ES6Module, 'ember/es6_template/es6module_sprockets2'
    when /^3\./
      autoload :ES6, 'ember/es6_template/es6'
      autoload :ES6Module, 'ember/es6_template/es6module'
    else
      raise "Unsupported sprockets version: #{Sprockets::VERSION}"
    end
  end
end
