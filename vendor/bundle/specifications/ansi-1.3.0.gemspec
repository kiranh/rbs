# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ansi}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thomas Sawyer", "Florian Frank"]
  s.date = %q{2011-06-30}
  s.description = %q{The ANSI project is a collection of ANSI escape code related libraries enabling ANSI code based colorization and stylization of output. It is very nice for beautifying shell output.}
  s.email = %q{rubyworks-mailinglist@googlegroups.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = [".ruby", "lib/ansi/bbcode.rb", "lib/ansi/chart.rb", "lib/ansi/code.rb", "lib/ansi/columns.rb", "lib/ansi/constants.rb", "lib/ansi/core.rb", "lib/ansi/diff.rb", "lib/ansi/logger.rb", "lib/ansi/mixin.rb", "lib/ansi/progressbar.rb", "lib/ansi/string.rb", "lib/ansi/table.rb", "lib/ansi/terminal/curses.rb", "lib/ansi/terminal/stty.rb", "lib/ansi/terminal/termios.rb", "lib/ansi/terminal/win32.rb", "lib/ansi/terminal.rb", "lib/ansi.rb", "lib/ansi.rbz", "lib/ansi.yml", "qed/01_ansicode.rdoc", "qed/02_bbcode.rdoc", "qed/03_logger.rdoc", "qed/04_progressbar.rdoc", "qed/05_mixin.rdoc", "qed/06_string.rdoc", "qed/07_columns.rdoc", "qed/08_table.rdoc", "qed/09_diff.rb", "qed/10_core.rdoc", "qed/applique/output.rb", "test/case_ansicode.rb", "test/case_bbcode.rb", "test/case_mixin.rb", "test/case_progressbar.rb", "HISTORY.rdoc", "LICENSE/BSD-2-Clause.txt", "LICENSE/GPL-2.0.txt", "LICENSE/MIT.txt", "LICENSE/RUBY.txt", "README.rdoc", "NOTICE.rdoc"]
  s.homepage = %q{http://rubyworks.github.com/ansi}
  s.licenses = ["Apache 2.0"]
  s.rdoc_options = ["--title", "ANSI API", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ansi}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{ANSI codes at your fingertips!}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<detroit>, [">= 0"])
      s.add_development_dependency(%q<qed>, [">= 0"])
      s.add_development_dependency(%q<lemon>, [">= 0"])
    else
      s.add_dependency(%q<detroit>, [">= 0"])
      s.add_dependency(%q<qed>, [">= 0"])
      s.add_dependency(%q<lemon>, [">= 0"])
    end
  else
    s.add_dependency(%q<detroit>, [">= 0"])
    s.add_dependency(%q<qed>, [">= 0"])
    s.add_dependency(%q<lemon>, [">= 0"])
  end
end
