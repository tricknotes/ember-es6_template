require 'minitest_helper'

class TestEmberES6Template < Minitest::Test
  def setup
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path('../fixtures', __FILE__)

    Ember::ES6Template.setup @env
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

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_import
    asset = @env['import.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
'use strict';

var _interopRequireWildcard = function (obj) { return obj && obj.__esModule ? obj : { 'default': obj }; };

var _Hi = require('hi');

var _Hi2 = _interopRequireWildcard(_Hi);
    JS

    assert { expected == asset.to_s.strip }
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

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_with_erb
    asset = @env['env.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("env", ["exports", "module"], function (exports, module) {
  "use strict";

  module.exports = {
    key: "1024"
  };
});
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_with_coffee_script
    asset = @env['boot.js']
    assert { 'application/javascript' == asset.content_type }

    expected = if Babel::Source::VERSION =~ /^4\./
      <<-JS.strip
"use strict";

var _interopRequire = function _interopRequire(obj) {
  return obj && obj.__esModule ? obj["default"] : obj;
};

var App = _interopRequire(require("application"));

App.create();
      JS
    else
      <<-JS.strip
'use strict';

var _interopRequireWildcard = function _interopRequireWildcard(obj) {
  return obj && obj.__esModule ? obj : { 'default': obj };
};

var _App = require('application');

var _App2 = _interopRequireWildcard(_App);

_App2['default'].create();
      JS
    end

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_module_syntax_with_coffee_script
    asset = @env['route.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("route", ["exports", "module"], function (exports, module) {
  "use strict";

  module.exports = Route;
  ;
});
    JS

    assert { expected == asset.to_s.strip }
  end
end
