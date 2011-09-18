require File.join(File.dirname(__FILE__), *%w[test_helper])
require File.join(File.dirname(__FILE__), *%w[.. lib sitemap])

class Reprinter < Sitemap::Traverser
  def out
    @out ||= []
  end

  def accept_node(ancestors, node)
    indent = ' ' * ancestors.length * Sitemap::TabSize
    out << indent + node.to_s
  end

  def output
    out.join("\n")
  end
end

class SexpBuilder < Sitemap::Traverser
  def initialize
    @sexp = []
  end

  def begin_sublist(_)
    @sexp << Sitemap::Lft
  end

  def accept_node(ancestors, node)
    @sexp << node
  end

  def finalize_sublist(_)
    @sexp << Sitemap::Rgt
  end

  def sexp_array
    array_string = @sexp \
      .map { |e| Sitemap::Brackets.include?(e) ? e.to_s : e.strip.inspect } \
      .join(', ') \
      .gsub('[, ', '[') \
      .gsub(', ]', ']')
    eval(array_string)
  end
end

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
  GratuitousWhitespaceListWithCommentedItems = <<-EOF.strip
Foo # this is foo
# this line is all comments, baby
Bar
  Barbarian
  # comments and indentation!
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
  WeirdAssErrorSexp = [
    'About This Site',
      ['Who This Site Is For',
      'What This Site Will Try to Teach You',
      'Why This Site?',
      'About the Author'],
    'Git Makes More Sense When You Understand X',
      ['Example 1: Kent Beck',
      'Example 2: Git for Ages 4 and Up',
      'Example 3: Homeomorphic Endofunctors',
      'Example 4: Acid and Chainsaws'],
    'Graph Theory',
      ['Seven Bridges of Königsberg',
      'Nodes and Edges',
      'Places To Go, and Ways to Get There',
      'Undirected Graphs'],
  ]
  WeirdAssError = <<-EOF.strip
About This Site
  Who This Site Is For
  What This Site Will Try to Teach You
  Why This Site?
  About the Author

Git Makes More Sense When You Understand X
  Example 1: Kent Beck
  Example 2: Git for Ages 4 and Up
  Example 3: Homeomorphic Endofunctors
  Example 4: Acid and Chainsaws

Graph Theory
  Seven Bridges of Königsberg
  Nodes and Edges
  Places To Go, and Ways to Get There
  Undirected Graphs
  EOF
  #(end)

  describe '.parse_text' do
    it 'returns a flat array when given a flat list' do
      expected = %w[Foo Bar Baz]
      actual = Sitemap.parse_text "Foo\nBar\nBaz"
      assert_equal %w[Foo Bar Baz], actual
    end

    it 'nests indented headings in an array' do
      assert_equal FooBarbarianSexp, Sitemap.parse_text(FooBarbarianList)
    end

    it 'correctly parses a slightly more complicated example, with hanging indentation at the end' do
      assert_equal SomewhatComplicatedSexp, Sitemap.parse_text(SomewhatComplicatedList)
    end

    it 'correctly parses a list that jumps back out more than one level of indentation at a time' do
      assert_equal ListThatJumpsBackTwoLevelsInOneLineSexp, Sitemap.parse_text(ListThatJumpsBackTwoLevelsInOneLine)
    end

    it 'ignores empty lines' do
      assert_equal GratuitousWhitespaceSexp, Sitemap.parse_text(GratuitousWhitespaceList)
    end
    
    it 'treats # as a comment character and ignores lines that consist entirely of comments and/or whitespace' do
      assert_equal GratuitousWhitespaceSexp, Sitemap.parse_text(GratuitousWhitespaceListWithCommentedItems)
    end
  end

  describe '.from_text' do
    it 'returns an instance' do
      sitemap = Sitemap.from_text(FooBarbarianList)
      assert_equal FooBarbarianSexp, sitemap.sexp
    end
  end

  it 'is == another Sitemap if their s-expressions are ==' do
    s1 = Sitemap.from_text(SomewhatComplicatedList)
    s2 = Sitemap.from_text(SomewhatComplicatedList)
    assert_equal s1, s2
  end

  describe '#traverse_sexp' do
    it 'sends the #accept_node method for each top-level string' do
      sitemap = Sitemap.from_text("Foo\nBar\nBaz")
      visitor = MiniTest::Mock.new
      def visitor.begin_sublist(*args); end
      def visitor.finalize_sublist(*args); end
      visitor.expect :accept_node, nil, [[], 'Foo']
      visitor.expect :accept_node, nil, [[], 'Bar']
      visitor.expect :accept_node, nil, [[], 'Baz']
      sitemap.facilitate_traversal_of visitor
      visitor.verify
    end

    it 'sends the #accept_node method for each leaf string, with an ancestors list for each' do
      sitemap = Sitemap.from_text(FooBarbarianList)
      visitor = MiniTest::Mock.new
      def visitor.begin_sublist(*args); end
      def visitor.finalize_sublist(*args); end
      visitor.expect :accept_node, nil, [[], 'Foo']
      visitor.expect :accept_node, nil, [[], 'Bar']
      visitor.expect :accept_node, nil, [['Bar'], 'Barbarian']
      visitor.expect :accept_node, nil, [[], 'Baz']
      sitemap.facilitate_traversal_of visitor
      visitor.verify
    end

    it 'has an example with this Reprinter class' do
      sitemap = Sitemap.from_text(ListThatJumpsBackTwoLevelsInOneLine)
      reprinter = Reprinter.new
      reprinter.traverse sitemap
      assert_equal ListThatJumpsBackTwoLevelsInOneLine, reprinter.output
    end

    it 'allows stuff to be done before a node and after its children' do
      sitemap = Sitemap.from_text(ListThatJumpsBackTwoLevelsInOneLine)
      sexp_builder = SexpBuilder.new
      sexp_builder.traverse sitemap
      assert_equal ListThatJumpsBackTwoLevelsInOneLineSexp, sexp_builder.sexp_array
    end
  end

  it 'can roundtrip an outline from text to sexp to text' do
    sitemap = Sitemap.from_text(SomewhatComplicatedList)
    reprinter = Reprinter.new
    reprinter.traverse sitemap
    second_sitemap = Sitemap.from_text(reprinter.output)
    assert_equal sitemap, second_sitemap
  end

  it 'gives you the prev and next items for a given item in its sexp, regardless of nesting' do
    sitemap = Sitemap.new(ListThatJumpsBackTwoLevelsInOneLineSexp)
    assert_equal [nil,   'a1' ], sitemap.prev_and_next('a')
    assert_equal ['a',   'a1a'], sitemap.prev_and_next('a1')
    assert_equal ['a1',  'a1b'], sitemap.prev_and_next('a1a')
    assert_equal ['a1a', 'b'  ], sitemap.prev_and_next('a1b')
    assert_equal ['a1b', nil  ], sitemap.prev_and_next('b')
  end
end
