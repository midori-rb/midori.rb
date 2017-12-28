class TCPServer
  def tcp_fast_open
    # macOS devices option is DIFFERENT from Linux and FreeBSD
    opt = (/darwin/ =~ RUBY_PLATFORM) ? 1 : 5
    # Magic number 6 may refer to Socket::SOL_TCP or Socket::IPPROTO_TCP
    self.setsockopt(6, Socket::TCP_FASTOPEN, opt)
    true
  rescue => _e
    # @logger.warn 'Failed to use TCP Fast Open feature on your OS'.yellow
    false
  end
end
