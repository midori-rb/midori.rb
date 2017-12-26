##
# Case Insensitive Hash
# Designed for HTTP Headers due to RFC 2.6 Chapter 4.2
# https://www.ietf.org/rfc/rfc2616.txt
class HTTPHeader < Hash
  def [](key)
    super _insensitive(key)
  end

  def []=(key, value)
    super _insensitive(key), value
  end

  def key?(key)
    super _insensitive(key)
  end

  protected def _insensitive(key)
    key.downcase
  end
end
