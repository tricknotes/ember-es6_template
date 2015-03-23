require 'minitest_helper'

class TestEmberES6Template < Minitest::Test
  def setup
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path('../fixtures', __FILE__)

    if Sprockets::VERSION =~ /^3\./
      @env.register_engine '.es6', Ember::ES6Template::ES6, mime_type: 'application/javascript'
      @env.register_engine '.es6module', Ember::ES6Template::ES6Module, mime_type: 'application/javascript'
    else
      @env.register_engine '.es6', Ember::ES6Template::ES6
      @env.register_engine '.es6module', Ember::ES6Template::ES6Module
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Ember::ES6Template::VERSION
  end

  def test_transpile_template
    asset = @env['template.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
"use strict";

"1 + 1 = " + (1 + 1);
    JS

    assert { expected == asset.to_s }
  end

  def test_tranpile_module_syntax
    asset = @env['controller.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("controller", ["exports", "module"], function (exports, module) {
  "use strict";

  module.exports = Ember.Controller.extend({});
});
    JS

    assert { expected == asset.to_s }
  end
end
