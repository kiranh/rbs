# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplecov}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Olszowka"]
  s.date = %q{2011-04-02}
  s.description = %q{Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites}
  s.email = ["christoph at olszowka de"]
  s.files = [".document", ".gitignore", ".rvmrc", "Gemfile", "LICENSE", "README.rdoc", "Rakefile", "lib/simplecov.rb", "lib/simplecov/adapters.rb", "lib/simplecov/command_guesser.rb", "lib/simplecov/configuration.rb", "lib/simplecov/filter.rb", "lib/simplecov/formatter.rb", "lib/simplecov/formatter/simple_formatter.rb", "lib/simplecov/jruby_float_fix.rb", "lib/simplecov/merge_helpers.rb", "lib/simplecov/result.rb", "lib/simplecov/result_merger.rb", "lib/simplecov/source_file.rb", "lib/simplecov/version.rb", "simplecov.gemspec", "test/fixtures/app/controllers/sample_controller.rb", "test/fixtures/app/models/user.rb", "test/fixtures/deleted_source_sample.rb", "test/fixtures/frameworks/rspec_bad.rb", "test/fixtures/frameworks/rspec_good.rb", "test/fixtures/frameworks/testunit_bad.rb", "test/fixtures/frameworks/testunit_good.rb", "test/fixtures/resultset1.rb", "test/fixtures/resultset2.rb", "test/fixtures/sample.rb", "test/helper.rb", "test/shoulda_macros.rb", "test/test_1_8_fallbacks.rb", "test/test_command_guesser.rb", "test/test_deleted_source.rb", "test/test_filters.rb", "test/test_merge_helpers.rb", "test/test_result.rb", "test/test_return_codes.rb", "test/test_source_file.rb", "test/test_source_file_line.rb"]
  s.homepage = %q{http://github.com/colszowka/simplecov}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{simplecov}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites}
  s.test_files = ["test/fixtures/app/controllers/sample_controller.rb", "test/fixtures/app/models/user.rb", "test/fixtures/deleted_source_sample.rb", "test/fixtures/frameworks/rspec_bad.rb", "test/fixtures/frameworks/rspec_good.rb", "test/fixtures/frameworks/testunit_bad.rb", "test/fixtures/frameworks/testunit_good.rb", "test/fixtures/resultset1.rb", "test/fixtures/resultset2.rb", "test/fixtures/sample.rb", "test/helper.rb", "test/shoulda_macros.rb", "test/test_1_8_fallbacks.rb", "test/test_command_guesser.rb", "test/test_deleted_source.rb", "test/test_filters.rb", "test/test_merge_helpers.rb", "test/test_result.rb", "test/test_return_codes.rb", "test/test_source_file.rb", "test/test_source_file_line.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simplecov-html>, ["~> 0.4.4"])
      s.add_development_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
    else
      s.add_dependency(%q<simplecov-html>, ["~> 0.4.4"])
      s.add_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    end
  else
    s.add_dependency(%q<simplecov-html>, ["~> 0.4.4"])
    s.add_dependency(%q<shoulda>, ["= 2.10.3"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
  end
end
