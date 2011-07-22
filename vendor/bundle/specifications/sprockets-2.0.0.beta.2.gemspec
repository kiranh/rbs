# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sprockets}
  s.version = "2.0.0.beta.2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Stephenson", "Joshua Peek"]
  s.date = %q{2011-05-02}
  s.description = %q{Sprockets is a Rack-based asset packaging system that concatenates and serves JavaScript, CoffeeScript, CSS, LESS, Sass, and SCSS.}
  s.email = %q{sstephenson@gmail.com}
  s.files = ["README.md", "LICENSE", "lib/sprockets/compressor.rb", "lib/sprockets/concatenated_asset.rb", "lib/sprockets/concatenation.rb", "lib/sprockets/context.rb", "lib/sprockets/directive_processor.rb", "lib/sprockets/engine_pathname.rb", "lib/sprockets/engines.rb", "lib/sprockets/environment.rb", "lib/sprockets/environment_index.rb", "lib/sprockets/errors.rb", "lib/sprockets/server.rb", "lib/sprockets/static_asset.rb", "lib/sprockets/utils.rb", "lib/sprockets.rb"]
  s.homepage = %q{http://getsprockets.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sprockets}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Rack-based asset packaging system}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hike>, ["~> 1.0"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.0"])
      s.add_development_dependency(%q<coffee-script-source>, ["~> 1.0"])
    else
      s.add_dependency(%q<hike>, ["~> 1.0"])
      s.add_dependency(%q<rack>, ["~> 1.0"])
      s.add_dependency(%q<tilt>, ["~> 1.0"])
      s.add_dependency(%q<coffee-script-source>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<hike>, ["~> 1.0"])
    s.add_dependency(%q<rack>, ["~> 1.0"])
    s.add_dependency(%q<tilt>, ["~> 1.0"])
    s.add_dependency(%q<coffee-script-source>, ["~> 1.0"])
  end
end
