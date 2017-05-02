module Kernel
  # Raise error if Load Failed
  # @param [String] file file to Load
  # @param [String] prompt To prompt what when load error
  # @return [Boolean] whether it has been required already
  def safe_require(file, prompt)
    begin
      require file
    rescue LoadError => _e
      raise prompt
    end
  end
end
