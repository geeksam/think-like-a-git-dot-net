class String
  def dasherize
    strip.downcase.gsub('ö', 'o').gsub(/[^a-z0-9]+/, '-').gsub(/(^-|-$)/, '')
  end

  def blank?
    self =~ /^\s*$/
  end
end

class Sitemap
  unless const_defined?(:TabSize)
    TabSize = 2
    Lft = :'['
    Rgt = :']'
    Brackets = [Lft, Rgt]
    SectionsPath = 'content/sections'
  end
  class Traverser
  end

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

    lines_in = text.split(/\n/)
    lines_in.map! { |e| e.gsub(/#.*$/, '') }  # remove comments
    lines_in.reject! { |e| e =~ /^\s*$/ }     # drop whitespace-only lines
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

  def self.slug(*components)
    components.flatten.reject(&:blank?).map(&:dasherize).join('/')
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
    idx = flat_list.map(&:dasherize).index(item.dasherize)
    prev_item = flat_list[idx-1]; prev_item = nil if idx.zero?
    next_item = flat_list[idx+1]
    return prev_item, next_item
  end

  def depth(item)
    @depths ||= DepthCalculator.for(self).depths
    @depths[item]
  end

  def section_path(section_title)
    @section_path_map ||= Sitemap::PathMapBuilder.for(self).paths
    @section_path_map[section_title.dasherize]
  end
end

# Require all the various child classes of this one
Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), *%w[sitemap **.rb]))).each { |e| require e }
