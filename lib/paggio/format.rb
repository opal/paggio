#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Paggio

module Format
  def self.puts(io, text, level = 0)
    io.puts "#{"\t" * level}#{text}"
  end

  def self.print(io, text, level = 0)
    io.print "#{"\t" * level}#{text}"
  end

  def self.escape(string)
    string.to_s
  end
end

class HTML < BasicObject
  Format = ::Paggio::Format

  def format(io = ::StringIO.new, options = { indent: 0 })
    case @version
    when 5
      Format.puts io, "<!DOCTYPE html>", options[:indent]
    end

    Format.puts io, "<html>", options[:indent]

    each {|root|
      root.format(io, indent: options[:indent] + 1)
    }

    Format.puts io, "</html>", options[:indent]

    io
  end

  class Element < BasicObject
    Format = ::Paggio::Format

    def format(io = ::StringIO.new, options = { indent: 0 })
      if @attributes.empty? && @class.empty?
        Format.puts io, "<#{name}>", options[:indent]
      else
        attrs = @attributes.map {|name, value|
          "#{Format.escape(name)}=\"#{Format.escape(value)}\""
        }

        unless @class.empty?
          attrs << "class=\"#{Format.escape(@class.join(' '))}\""
        end

        Format.puts io, "<#{name} #{attrs.join(' ')}>", options[:indent]
      end

      each {|child|
        case child
        when ::String
          child.lines.each {|line|
            Format.puts io, line.strip, options[:indent] + 1
          }

        when CSS
          Format.puts io, "<style>", options[:indent] + 1
          child.format(io, indent: options[:indent] + 2)
          Format.puts io, "</style>", options[:indent] + 1

        else
          child.format(io, indent: options[:indent] + 1)
        end

        io.puts
      }

      io.seek(-1, ::IO::SEEK_CUR)

      Format.puts io, "</#{name}>", @children.empty? ? 0 : options[:indent]

      io
    end
  end
end

class CSS < BasicObject
  Format = ::Paggio::Format

  def format(io = ::StringIO.new, options = { indent: 0 })
    rules.reverse.each {|rule|
      next if rule.definition.empty?

      Format.puts io, "#{rule.selector} {", options[:indent]

      rule.definition.each {|style|
        Format.puts io, "#{style.name}: #{style.value}#{' !important' if style.important?};",
          options[:indent] + 1
      }

      Format.puts io, "}", options[:indent]
      io.puts
    }

    io.seek(-1, ::IO::SEEK_CUR)

    io
  end
end

end
