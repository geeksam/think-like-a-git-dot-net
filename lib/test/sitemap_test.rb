require File.join(File.dirname(__FILE__), *%w[test_helper])
require File.join(File.dirname(__FILE__), *%w[.. sitemap])

describe Sitemap do
  describe '.indentation_level' do
    it 'returns numeric values for strings' do
      assert_equal 0, Sitemap.indentation_level('foo')
      assert_equal 1, Sitemap.indentation_level('  foo')
      assert_equal 2, Sitemap.indentation_level('    foo')
      assert_equal 5, Sitemap.indentation_level('          foo')
    end

    it 'returns nil for symbols' do
      assert_nil Sitemap.indentation_level(:foo)
    end
  end

  #(fold)
  GratuitousWhitespaceSexp = ['Foo', 'Bar', ['Barbarian'], 'Baz']
  GratuitousWhitespaceList = <<-EOF.strip
Foo

Bar
  Barbarian
  
Baz

  EOF
  FooBarbarianSexp = ['Foo', 'Bar', ['Barbarian'], 'Baz']
  FooBarbarianList = <<-EOF.strip
Foo
Bar
  Barbarian
Baz
  EOF
  SomewhatComplicatedSexp = ['a', ['a1', ['a1a', 'a1b'], 'a2', 'a3'], 'b', ['b1', 'b2'], 'c', 'd', 'e', ['e1', 'e2', ['e2a']]]
  SomewhatComplicatedList = <<-EOF.strip
a
  a1
    a1a
    a1b
  a2
  a3
b
  b1
  b2
c
d
e
  e1
  e2
    e2a
  EOF
  ListThatJumpsBackTwoLevelsInOneLineSexp = ['a', ['a1', ['a1a', 'a1b']], 'b']
  ListThatJumpsBackTwoLevelsInOneLine = <<-EOF.strip
a
  a1
    a1a
    a1b
b
  EOF
  #(end)

  describe '.parse_text' do
    it 'should return a flat array when given a flat list' do
      expected = %w[Foo Bar Baz]
      actual = Sitemap.parse_text "Foo\nBar\nBaz"
      assert_equal %w[Foo Bar Baz], actual
    end

    it 'should nest indented headings in an array' do
      assert_equal FooBarbarianSexp, Sitemap.parse_text(FooBarbarianList)
    end

    it 'should correctly parse a slightly more complicated example, with hanging indentation at the end' do
      assert_equal SomewhatComplicatedSexp, Sitemap.parse_text(SomewhatComplicatedList)
    end

    it 'should correctly parse a list that jumps back out more than one level of indentation at a time' do
      assert_equal ListThatJumpsBackTwoLevelsInOneLineSexp, Sitemap.parse_text(ListThatJumpsBackTwoLevelsInOneLine)
    end

    it 'should ignore empty lines' do
      assert_equal GratuitousWhitespaceSexp, Sitemap.parse_text(GratuitousWhitespaceList)
    end
  end

  describe '.from_text' do
    it 'should return an instance' do
      sitemap = Sitemap.from_text(FooBarbarianList)
      assert_equal FooBarbarianSexp, sitemap.sexp
    end
  end

  describe '#facilitate_traversal_of' do
    it 'should send the #accept_node method for each top-level string' do
      sitemap = Sitemap.from_text("Foo\nBar\nBaz")
      visitor = MiniTest::Mock.new
      visitor.expect :accept_node, nil, [[], 'Foo']
      visitor.expect :accept_node, nil, [[], 'Bar']
      visitor.expect :accept_node, nil, [[], 'Baz']
      sitemap.facilitate_traversal_of visitor
      visitor.verify
    end

    it 'should send the #accept_node method for each leaf string, with an ancestors list for each' do
      sitemap = Sitemap.from_text(FooBarbarianList)
      visitor = MiniTest::Mock.new
      visitor.expect :accept_node, nil, [[], 'Foo']
      visitor.expect :accept_node, nil, [[], 'Bar']
      visitor.expect :accept_node, nil, [['Bar'], 'Barbarian']
      visitor.expect :accept_node, nil, [[], 'Baz']
      sitemap.facilitate_traversal_of visitor
      visitor.verify
    end

    class Reprinter
      def out
        @out ||= []
      end

      def traverse(sitemap)
        sitemap.facilitate_traversal_of(self)
      end

      def accept_node(ancestors, node)
        indent = '  ' * ancestors.length
        out << indent + node.to_s
      end

      def output
        out.join("\n")
      end
    end

    it 'has an example with this Reprinter class' do
      sitemap = Sitemap.from_text(ListThatJumpsBackTwoLevelsInOneLine)
      reprinter = Reprinter.new
      reprinter.traverse sitemap
      assert_equal ListThatJumpsBackTwoLevelsInOneLine, reprinter.output
    end
  end
end
