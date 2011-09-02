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

  def self.from_text(text)
    new(parse_text(text))
  end

  attr_reader :sexp
  def initialize(sexp)
    @sexp = sexp
  end

  def facilitate_traversal_of(visitor)
    traverse_sexp(visitor, sexp)
  end

  def traverse_sexp(visitor, sexp, ancestors = [])
    prev_leaf = nil
    sexp.each do |node|
      if node.kind_of? Array
        traverse_sexp(visitor, node, (ancestors + [prev_leaf]).compact)
      else
        visitor.accept_node(ancestors, node)
        prev_leaf = node
      end
    end
  end
end
