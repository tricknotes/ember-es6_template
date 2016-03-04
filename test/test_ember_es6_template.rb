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

var _hi = require('hi');

_hi['default'].create();
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_tranpile_module_syntax
    asset = @env['controller.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("controller", ["exports"], function (exports) {
  "use strict";

  exports["default"] = Ember.Controller.extend({});
});
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_with_erb
    asset = @env['env.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("env", ["exports"], function (exports) {
  "use strict";

  exports["default"] = {
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
var App = _interopRequire(require("application"));

App.create();
      JS
    else
      <<-JS.strip
var _application = require('application');

_application['default'].create();
      JS
    end

    assert { Regexp.compile(Regexp.escape(expected)) =~ asset.to_s.strip }
  end

  def test_transpile_module_syntax_with_coffee_script
    asset = @env['route.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("route", ["exports"], function (exports) {
  "use strict";

  exports["default"] = Route;
  ;
});
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_coffee_script
    asset = @env['non-ember/just-coffee.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
(function() {
  "Hi, " + name;

}).call(this);
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_index_file
    asset = @env['index.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("index", ["exports"], function (exports) {
  "use strict";

  exports["default"] = IndexRoute;
});
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_transpile_index_file_with_directory
    asset = @env['controllers/index.js']
    assert { 'application/javascript' == asset.content_type }

    expected = <<-JS.strip
define("controllers/index", ["exports"], function (exports) {
  "use strict";

  exports["default"] = Controller;
});
    JS

    assert { expected == asset.to_s.strip }
  end

  def test_configure_module_prefix
    with_module_prefix('ping') do
      asset = @env['controller.js']
      assert { 'application/javascript' == asset.content_type }

      expected = <<-JS.strip
define("ping/controller", ["exports"], function (exports) {
  "use strict";

  exports["default"] = Ember.Controller.extend({});
});
      JS

      assert { expected == asset.to_s.strip }
    end
  end

  def test_configure_prefix_files
    with_module_prefix_with_prefix_files_and_dirs('hi', 'controller', nil) do
      asset = @env['controller.js']
      assert { %r{define\("hi/controller"} =~ asset.to_s.strip }

      asset = @env['controllers/index.js']
      assert { %r{define\("controllers/index"} =~ asset.to_s.strip }
    end
  end

  def test_configure_prefix_dirs
    with_module_prefix_with_prefix_files_and_dirs('hi', nil, 'controllers') do
      asset = @env['controllers/index.js']
      assert { %r{define\("hi/controllers/index"} =~ asset.to_s.strip }

      asset = @env['controller.js']
      assert { %r{define\("controller"} =~ asset.to_s.strip }
    end
  end

  def test_configure_prefix_files_and_dirs
    with_module_prefix_with_prefix_files_and_dirs('hi', 'index', 'controllers') do
      asset = @env['controllers/index.js']
      assert { %r{define\("hi/controllers/index"} =~ asset.to_s.strip }

      asset = @env['controllers/welcome.js']
      assert { %r{define\("hi/controllers/welcome"} =~ asset.to_s.strip }

      asset = @env['index.js']
      assert { %r{define\("hi/index"} =~ asset.to_s.strip }

      asset = @env['index.js']
      assert { %r{define\("hi/index"} =~ asset.to_s.strip }

      asset = @env['non-ember/boot.js']
      assert { %r{define\("non-ember/boot"} =~ asset.to_s.strip }
    end
  end

  private

  def with_module_prefix(prefix)
    with_module_prefix_with_prefix_files_and_dirs(prefix, nil, nil) do
      yield
    end
  end

  def with_module_prefix_with_prefix_files_and_dirs(prefix, files, dirs)
    Ember::ES6Template.configure do |config|
      prefix, config.module_prefix = config.module_prefix, prefix
      files, config.prefix_files = config.prefix_files, files
      dirs, config.prefix_dirs = config.prefix_dirs, dirs
    end

    yield
  ensure
    Ember::ES6Template.configure do |config|
      prefix, config.module_prefix = config.module_prefix, prefix
      files, config.prefix_files = config.prefix_files, files
      dirs, config.prefix_dirs = config.prefix_dirs, dirs
    end
  end
end
