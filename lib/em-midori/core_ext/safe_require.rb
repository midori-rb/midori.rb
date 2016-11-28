module Kernel
  def safe_require(file, prompt)
    begin
      require file
    rescue LoadError => _e
      raise prompt
    end
  end
end