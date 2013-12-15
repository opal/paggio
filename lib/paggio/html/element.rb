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

  def self.defhelper(name, &block)
    define_method name do |*args, &body|
      instance_exec(*args, &block)

      self.do(&body) if body
      self
    end
  end

  def initialize(owner, name, attributes = {})
    @owner       = owner
    @name        = name
    @attributes  = attributes
    @children    = []
    @class_names = []
  end

  def each(&block)
    @children.each(&block)
  end

  def <<(what)
    @children << what

    self
  end

  def method_missing(name, content = nil, &block)
    if content
      self << ::Paggio::Utils.heredoc(content)
    end

    if name.to_s.end_with? ?!
      @attributes[:id] = name[0 .. -2]
    else
      @last = name
      @class_names.push(name)
    end

    @owner.extend!(self, &block) if block

    self
  end

  def [](*names)
    return unless @last

    @class_names.pop
    @class_names.push([@last, *names].join('-'))

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

  class Img < self
    defhelper :src do |url|
      @attributes[:src] = url.to_s
    end
  end

  class A < self
    defhelper :href do |url|
      @attributes[:href] = url.to_s
    end

    defhelper :text do |string|
      self << string
    end
  end

  class Input < self
    { type:         :type,
      name:         :name,
      value:        :value,
      size:         :size,
      place_holder: :placeholder,
      read_only:    :readonly,
      required:     :required
    }.each {|name, attribute|
      defhelper name do |value|
        @element[attribute] = value
      end
    }
  end
end

end; end
