# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{prototype-rails}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Xavier Noria"]
  s.date = %q{2011-05-05}
  s.email = %q{fxn@hashref.com}
  s.files = ["README", "Rakefile", "Gemfile", "lib/action_view/helpers/prototype_helper.rb", "lib/action_view/helpers/scriptaculous_helper.rb", "lib/action_view/template/handlers/rjs.rb", "lib/prototype-rails/javascript_helper.rb", "lib/prototype-rails/on_load_action_controller.rb", "lib/prototype-rails/on_load_action_view.rb", "lib/prototype-rails/renderers.rb", "lib/prototype-rails/rendering.rb", "lib/prototype-rails/selector_assertions.rb", "lib/prototype-rails.rb", "vendor/assets/javascripts/controls.js", "vendor/assets/javascripts/dragdrop.js", "vendor/assets/javascripts/effects.js", "vendor/assets/javascripts/prototype.js", "vendor/assets/javascripts/prototype_ujs.js", "test/abstract_unit.rb", "test/assert_select_test.rb", "test/controller/caching_test.rb", "test/controller/content_type_test.rb", "test/controller/mime_responds_test.rb", "test/controller/new_base/content_type_test.rb", "test/controller/new_base/render_rjs_test.rb", "test/controller/render_js_test.rb", "test/fixtures/functional_caching/_partial.erb", "test/fixtures/functional_caching/formatted_fragment_cached.js.rjs", "test/fixtures/functional_caching/js_fragment_cached_with_partial.js.rjs", "test/fixtures/old_content_type/render_default_for_rjs.rjs", "test/fixtures/respond_to/all_types_with_layout.js.rjs", "test/fixtures/respond_to/layouts/standard.html.erb", "test/fixtures/respond_to/using_defaults.js.rjs", "test/fixtures/respond_to/using_defaults_with_type_list.js.rjs", "test/fixtures/respond_with/using_resource.js.rjs", "test/fixtures/test/_one.html.erb", "test/fixtures/test/_partial.html.erb", "test/fixtures/test/_partial.js.erb", "test/fixtures/test/_two.html.erb", "test/fixtures/test/delete_with_js.rjs", "test/fixtures/test/enum_rjs_test.rjs", "test/fixtures/test/greeting.js.rjs", "test/fixtures/test/render_explicit_html_template.js.rjs", "test/fixtures/test/render_implicit_html_template.js.rjs", "test/javascript_helper_test.rb", "test/lib/controller/fake_models.rb", "test/render_other_test.rb", "test/template/prototype_helper_test.rb", "test/template/render_test.rb", "test/template/scriptaculous_helper_test.rb"]
  s.homepage = %q{http://github.com/rails/prototype-rails}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Prototype, Scriptaculous, and RJS for Ruby on Rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.1.0.beta1"])
    else
      s.add_dependency(%q<rails>, ["~> 3.1.0.beta1"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.1.0.beta1"])
  end
end
