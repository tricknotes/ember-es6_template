require 'ember/es6_template/version'

require 'sprockets'
require 'babel/transpiler'

module Ember
  module ES6Template
    case Sprockets::VERSION
    when /^2\./
      require 'ember/es6_template/sprockets2'
    when /^3\./
      require 'ember/es6_template/sprockets3'
    else
      raise "Unsupported sprockets version: #{Sprockets::VERSION}"
    end
  end
end
