##
# Meta-programming String for Syntactic Sugars
class String
  # @param [Integer] color_code ANSI color code
  # @return [String] colored string
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  # color the string with red color
  def red
    colorize(31)
  end

  # color the string with green color
  def green
    colorize(32)
  end
  
  # color the string with yellow color
  def yellow
    colorize(33)
  end

  # color the string with blue color
  def blue
    colorize(34)
  end
end
