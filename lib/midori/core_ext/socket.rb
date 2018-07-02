class Socket
  def tcp_fast_open
    # macOS devices option is DIFFERENT from Linux and FreeBSD
    opt = (/darwin/ =~ RUBY_PLATFORM) ? 1 : 5
    # Magic number 6 may refer to Socket::SOL_TCP or Socket::IPPROTO_TCP
    setsockopt(6, Socket::TCP_FASTOPEN, opt)
    true
  rescue => _e
    false
  end

  def reuse_port
    setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEPORT, 1)
    true
  rescue => _e
    false
  end
end
