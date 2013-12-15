#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'stringio'

class Paggio

class Formatter
  def self.to_h
    @formatters ||= {}
  end

  def self.for(klass, &block)
    if block
      to_h[klass] = block
    else
      to_h[klass]
    end
  end

  def self.options(options, &block)
    old = OPTIONS.dup
    Utils.deep_merge!(OPTIONS, options)

    result = block.call

    OPTIONS.replace(old)

    result
  end

  OPTIONS = {
    indent: {
      level: 0,
      with:  "\t"
    }
  }

  def initialize(io = nil, options = {})
    if Hash === io
      @io      = StringIO.new
      @options = io
    else
      @io      = io || StringIO.new
      @options = options
    end

    @options = OPTIONS.merge(@options)
  end

  def format(item)
    Formatter.to_h.each {|klass, block|
      if klass === item
        block.call(self, item)
        break
      end
    }

    self
  end

  def to_s
    @io.string
  end

  def indent?(&block)
    @options[:indent][:level]
  rescue
    false
  end

  def indent(&block)
    if indent?
      @options[:indent][:level] += 1
      block.call
      @options[:indent][:level] -= 1
    else
      block.call
    end
  end

  def print(text)
    if level = indent?
      text.lines.each {|line|
        @io.puts "#{@options[:indent][:with] * level}#{line.chomp}"
      }
    else
      @io.print text
    end
  end

  def escape(string)
    string.to_s.gsub(/["><']|&(?!([a-zA-Z]+|(#\d+));)/, {
      '&' => '&amp;',
      '>' => '&gt;',
      '<' => '&lt;',
      '"' => '&quot;',
      "'" => '&#39;' })
  end
end

Formatter.for HTML do |f, item|
  case item.version
  when 5
    f.print '<!DOCTYPE html>'
  end

  f.print '<html>'
  f.indent {
    item.each {|root|
      f.format(root)
    }
  }
  f.print '</html>'
end

Formatter.for HTML::Element do |f, item|
  if item.attributes.empty? && item.class_names.empty?
    f.print "<#{item.name}>"
  else
    attrs = item.attributes.map {|name, value|
      %Q{#{f.escape(name)}="#{f.escape(value)}"}
    }

    unless item.class_names.empty?
      attrs << %Q{class="#{f.escape(item.class_names.join(' '))}"}
    end

    f.print "<#{item.name} #{attrs.join(' ')}>"
  end

  f.indent {
    if item.inner_html
      f.print item.inner_html
    else
      item.each {|child|
        case child
        when String
          f.print f.escape(child)

        when CSS
          f.print '<style>'
          f.indent {
            f.format(child)
          }
          f.print '</style>'

        else
          f.format(child)
        end
      }
    end
  }

  f.print "</#{item.name}>"
end

Formatter.for CSS do |f, item|
  item.rules.reverse.each {|rule|
    next if rule.definition.empty?

    f.print "#{rule.selector} {"
    f.indent {
      rule.definition.each {|style|
        f.print "#{style.name}: #{style.value}#{' !important' if style.important?};"
      }
    }
    f.print '}'
  }
end

end
