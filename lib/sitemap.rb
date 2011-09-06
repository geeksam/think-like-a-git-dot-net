class Sitemap
  TabSize = 2
  Lft = :'['
  Rgt = :']'
  Brackets = [Lft, Rgt]

  def self.indentation_level(object)
    case object
    when String
      md = object.match(/^(\s*)/)
      return 0 if md.nil?
      md[0].length / TabSize
    when Symbol
      nil
    else raise ArgumentError.new("Don't know what to do with #{object.inspect}")
    end
  end

  def self.parse_text(text)
    #######################################

    ##     ##    #####   ########  ########
    ###    ##   ##   ##     ##     ##      
    ####   ##  ##     ##    ##     ##      
    ## ##  ##  ##     ##    ##     ######  
    ##  ## ##  ##     ##    ##     ##      
    ##   ####   ##   ##     ##     ##      
    ##    ###    #####      ##     ########

    #######################################
    # This method has a giant security hole (to wit, #eval) and should never be used with untrusted input.
    #######################################

    lines_in = text.split(/\n/).reject { |e| e =~ /^\s*$/ }
    lines_out = [Lft]
    until lines_in.empty?
      a = lines_out.last; a_indent = indentation_level(a)
      b = lines_in.shift; b_indent = indentation_level(b)
      a_indent ||= b_indent  # account for 'baseline' indentation on the first line
      shift = b_indent - a_indent
      # If we shifted left, insert one or more right brackets, and vice versa.
      bracket = shift < 0 ? Rgt : Lft
      shift.abs.times { lines_out << bracket }
      lines_out << b
    end

    # add right brackets until they balance out
    brackets = lines_out.select { |e| e == Lft || e == Rgt }
    lfts, rgts = brackets.partition { |e| e == Lft }.map(&:length)
    (lfts - rgts).times { lines_out << Rgt }

    # Now build a string representation of the array and eval it for the return value
    array_string = lines_out \
      .map { |e| Brackets.include?(e) ? e.to_s : e.strip.inspect } \
      .join(', ') \
      .gsub('[, ', '[') \
      .gsub(', ]', ']')
    eval(array_string)
  end

  def self.from_file(filename)
    from_text(File.read(File.expand_path(filename)))
  end

  def self.from_text(text)
    new(parse_text(text))
  end

  attr_reader :sexp
  def initialize(sexp)
    @sexp = sexp
  end

  def ==(other)
    self.sexp == other.sexp
  end

  def prev_and_next(item)
    flat_list = sexp.flatten
    idx = flat_list.index(item)
    prev_item = flat_list[idx-1]; prev_item = nil if idx.zero?
    next_item = flat_list[idx+1]
    return prev_item, next_item
  end

  class Traverser
    def self.for(sitemap)
      new.tap { |t| t.traverse(sitemap) }
    end

    def traverse(sitemap)
      sitemap.facilitate_traversal_of(self)
    end
    def begin_sublist(path)           ; end
    def accept_node(ancestors, node)  ; end
    def finalize_sublist(path)        ; end
  end

  def facilitate_traversal_of(traverser)
    traverse_sexp(traverser, sexp)
  end

  def traverse_sexp(traverser, sexp, ancestors = [])
    prev_leaf = nil
    traverser.begin_sublist ancestors
    sexp.each do |node|
      if node.kind_of? Array
        traverse_sexp traverser, node, (ancestors + [prev_leaf]).compact
      else
        traverser.accept_node(ancestors, node)
        prev_leaf = node
      end
    end
    traverser.finalize_sublist ancestors
  end

  class NavListBuilder < Sitemap::Traverser
    attr_reader :lines
    def initialize
      @lines = []
    end

    def begin_sublist(path)
      lines << '<ul>'
    end

    def accept_node(ancestors, node)
      title, section_name = node, node.downcase.gsub(' ', '-')
      lines << '<li><a href="/sections/%s.html">%s</a></li>' % [section_name, title]
    end

    def finalize_sublist(path)
      lines << '</ul>'
    end
  end
end
