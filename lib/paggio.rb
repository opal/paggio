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

require 'paggio/css'
require 'paggio/html'
require 'paggio/format'

class Paggio
  def self.css(*args, &block)
    CSS.new(*args, &block).format.string
  end

  def self.html(*args, &block)
    HTML.new(*args, &block).format.string
  end

  def self.html!(&block)
    HTML.new(&block).root!.format.string
  end
end
