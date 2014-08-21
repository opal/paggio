#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'paggio/css/unit'
require 'paggio/css/color'
require 'paggio/css/definition'

class Paggio

class CSS < BasicObject
  Rule = ::Struct.new(:selector, :definition, :media)

  def self.selector(list)
    result = ''

    list.each {|part|
      if part.start_with?('&')
        result += part[1 .. -1]
      else
        result += " " + part
      end
    }

    if result[0] == " "
      result[1 .. -1]
    else
      result
    end
  end

  attr_reader :rules, :media

  def initialize(&block)
    ::Kernel.raise ::ArgumentError, 'no block given' unless block

    @selector = []
    @current  = []
    @rules    = []

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def rule(*names, &block)
    return unless block

    if names.any? { |n| n.include? ',' }
      ::Kernel.raise ::ArgumentError, 'selectors cannot contain commas'
    end

    names.each {|name|
      @selector << name
      @current  << Rule.new(CSS.selector(@selector), Definition.new, @media)

      block.call(self)

      @selector.pop
      @rules << @current.pop
    }
  end

  def media(query, &block)
    old, @media = @media, query
    block.call(self)
    @media = old
  end

  # this is needed because the methods inside the rule blocks are actually
  # called on the CSS object
  def method_missing(name, *args, &block)
    @current.last.definition.__send__(name, *args, &block)
  end
end

class HTML < BasicObject
  def style(&block)
    (@current || @roots) << CSS.new(&block)
  end
end

end
