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

module Utils
  def self.heredoc(string)
    indent = string.scan(/^[ \t]*(?=\S)/).min.size rescue 0

    string.gsub(/^[ \t]{#{indent}}/, '')
  end
end

end
