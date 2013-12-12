#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'paggio/html/element'

class Paggio

class HTML < BasicObject
  attr_reader :version

  def initialize(version = 5, &block)
    ::Kernel.raise ::ArgumentError, 'no block given' unless block

    @version = version
    @roots   = []
    @current = nil

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def <<(what)
    @current << what
  end

  def root!
    @roots.first
  end

  def roots!
    @roots
  end

  def element!
    @current
  end

  def extend!(element = nil, &block)
    old, @current = @current, element

    result = block.call(self)

    if ::String === result
      @current.inner_html = result
    end

    @current = old

    self
  end

  def each(&block)
    return enum_for :each unless block

    @roots.each(&block)

    self
  end

  def style(&block)
    (@current || @roots) << CSS.new(&block)
  end

  def method_missing(name, *args, &block)
    if name.to_s.end_with? ?!
      return super
    end

    if ::String === args.first
      content = args.shift
    end

    element = Element.new(self, name, *args)
    element << content if content

    if block
      parent   = @current
      @current = element
      result   = block.call(self)
      @current = parent

      if ::String === result
        element.inner_html = result
      end
    end

    (@current || @roots) << element

    element
  end

  def inspect
    if @roots.empty?
      "#<HTML(#@version)>"
    else
      "#<HTML(#@version): #{@roots.inspect[1 .. -2]}>"
    end
  end
end

end