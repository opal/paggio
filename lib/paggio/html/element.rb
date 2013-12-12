#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Paggio; class HTML < BasicObject

class Element < BasicObject
  def self.new(owner, name, attributes = {})
    return super unless self == Element

    const = name.capitalize

    if const_defined?(const)
      const_get(const).new(owner, name, attributes)
    else
      super
    end
  end

  attr_reader   :name, :attributes
  attr_accessor :inner_html

  def initialize(owner, name, attributes = {})
    @owner      = owner
    @name       = name
    @attributes = attributes
    @children   = []
    @class      = []
  end

  def each(&block)
    return enum_for :each unless block

    @children.each(&block)

    self
  end

  def <<(what)
    @children << what

    self
  end

  def text(text)
    @children << text.to_s

    self
  end

  def method_missing(name, content = nil, &block)
    if content
      self << content
    end

    if name.to_s.end_with? ?!
      @attributes[:id] = name[0 .. -2]
    else
      @last = name
      @class.push(name)
    end

    @owner.extend!(self, &block) if block

    self
  end

  def [](*names)
    return unless @last

    @class.delete(@last)
    @class.push([@last, *names].join('-'))

    self
  end

  def do(&block)
    @owner.extend!(self, &block)

    self
  end

  def inspect
    if @children.empty?
      "#<HTML::Element(#{@name.upcase})>"
    else
      "#<HTML::Element(#{@name.upcase}): #{@children.inspect[1 .. -2]}>"
    end
  end
end

end; end
