require "sprockets_test"

class DirectiveParserTest < Sprockets::TestCase
  test "parsing double-slash comments" do
    directive_parser("double_slash").tap do |parser|
      assert_equal "// Header\n//\n//\n(function() {\n})();\n", parser.processed_source
      assert_equal directives, parser.directives
    end
  end

  test "parsing hash comments" do
    directive_parser("hash").tap do |parser|
      assert_equal "# Header\n#\n#\n(->)()\n", parser.processed_source
      assert_equal directives, parser.directives
    end
  end

  test "parsing slash-star comments" do
    directive_parser("slash_star").tap do |parser|
      assert_equal "/* Header\n *\n *\n */\n\n(function() {\n})();\n", parser.processed_source
      assert_equal directives, parser.directives
    end
  end

  test "parsing single line slash-star comments" do
    directive_parser("slash_star_single").tap do |parser|
      assert_equal "\n\n(function() {\n})();\n", parser.processed_source
      assert_equal [[1, "require", "a"]], parser.directives
    end
  end

  test "parsing triple-hash comments" do
    directive_parser("triple_hash").tap do |parser|
      assert_equal "###\nHeader\n\n\n###\n\n(->)()\n", parser.processed_source
      assert_equal directives(1), parser.directives
    end
  end

  test "header comment without directives is unmodified" do
    directive_parser("comment_without_directives").tap do |parser|
      assert_equal "/*\n * Comment\n */\n\n(function() {\n})();\n", parser.processed_source
      assert_equal [], parser.directives
    end
  end

  test "directives in comment after header are not parsed" do
    directive_parser("directives_after_header").tap do |parser|
      assert_equal "/*\n * Header\n */\n\n// =require \"x\"\n\n(function() {\n})();\n", parser.processed_source
      assert_equal [], parser.directives
    end
  end

  test "headers must occur at the beginning of the file" do
    directive_parser("code_before_comment").tap do |parser|
      assert_equal "", parser.processed_header
      assert_equal directive_fixture("code_before_comment"), parser.processed_source
    end
  end

  test "no header" do
    directive_parser("no_header").tap do |parser|
      assert_equal directive_fixture("no_header"), parser.processed_source
      assert_equal [], parser.directives
    end
  end

  test "directive word splitting" do
    directive_parser("directive_word_splitting").tap do |parser|
      assert_equal [
        [1, "one"],
        [2, "one", "two"],
        [3, "one", "two", "three"],
        [4, "one", "two three"],
        [6, "six", "seven"]
      ], parser.directives
    end
  end

  test "space between = and directive word" do
    directive_parser("space_between_directive_word").tap do |parser|
      assert_equal "var foo;\n", parser.processed_source
      assert_equal [[1, "require", "foo"]], parser.directives
    end
  end

  def directive_parser(fixture_name)
    Sprockets::DirectiveProcessor.new(fixture_path("directives/#{fixture_name}"))
  end

  def directive_fixture(name)
    fixture("directives/#{name}")
  end

  def directives(offset = 0)
    [[3 + offset, "require", "a"], [4 + offset, "require", "b"], [6 + offset, "require", "c"]]
  end
end

class TestCustomDirectiveProcessor < Sprockets::TestCase
  def setup
    @env = Sprockets::Environment.new
    @env.append_path(fixture_path('context'))
  end

  class TestDirectiveProcessor < Sprockets::DirectiveProcessor
    def process_require_glob_directive(glob)
      Dir["#{base_path}/#{glob}"].sort.each do |filename|
        context.require_asset(filename)
      end
    end
  end

  test "custom processor using Context#sprockets_resolve and Context#sprockets_depend" do
    @env.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
    @env.register_processor('application/javascript', TestDirectiveProcessor)

    assert_equal "var Foo = {};\n\n", @env["require_glob.js"].to_s
  end
end
