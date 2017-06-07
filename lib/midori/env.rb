module Midori
  def self.env
    ENV['MIDORI_ENV'] || 'development'
  end
end

class String
  def production?
    self == 'production'
  end

  def development?
    self == 'development'
  end
end
