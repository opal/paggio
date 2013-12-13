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
  OPTIONS = { indent: 0 }

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
    case item
    when HTML
      case item.version
      when 5
        print '<!DOCTYPE html>'
      end

      print '<html>'
      indent {
        item.each {|root|
          format(root)
        }
      }
      print '</html>'

    when CSS
      item.rules.reverse.each {|rule|
        next if rule.definition.empty?

        print "#{rule.selector} {"
        indent {
          rule.definition.each {|style|
            print "#{style.name}: #{style.value}#{' !important' if style.important?};"
          }
        }
        print '}'
      }

    when HTML::Element
      if item.attributes.empty? && item.class.empty?
        print "<#{item.name}>"
      else
        attrs = item.attributes.map {|name, value|
          %Q{#{escape(name)}="#{escape(value)}"}
        }

        unless item.class.empty?
          attrs << %Q{class="#{escape(item.class.join(' '))}"}
        end

        print "<#{item.name} #{attrs.join(' ')}>"
      end

      indent {
        if item.inner_html
          print item.inner_html
        else
          item.each {|child|
            case child
            when String
              print escape(child)

            when CSS
              print '<style>'
              indent {
                format(child)
              }
              print '</style>'

            else
              format(child)
            end
          }
        end
      }

      print "</#{item.name}>"
    end

    self
  end

  def to_s
    @io.string
  end

private
  def indent?(&block)
    !!@options[:indent]
  end

  def indent(&block)
    if indent?
      @options[:indent] += 1
      block.call
      @options[:indent] -= 1
    else
      block.call
    end
  end

  def print(text)
    if level = @options[:indent]
      text.lines.each {|line|
        @io.puts "#{"\t" * level}#{line.chomp}"
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

end
