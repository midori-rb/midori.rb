##
# Module for store Midori Const
module Midori::Const
  # Hash table for converting numbers to HTTP/1.1 status code line
  STATUS_CODE = {
    100 => '100 Continue',
    101 => '101 Switching Protocols',
    102 => '102 Processing', # RFC 2518
    200 => '200 OK',
    201 => '201 Created',
    202 => '202 Accepted',
    203 => '203 Non-Authoritative Information',
    204 => '204 No Content',
    205 => '205 Reset Content',
    206 => '206 Partial Content', # RFC 7233
    207 => '207 Multi-Status', # RFC 4918
    208 => '208 Already Reported', # RFC 5842
    226 => '226 IM Used', # RFC 3229
    300 => '300 Multiple Choices',
    301 => '301 Moved Permanently',
    302 => '302 Found',
    303 => '303 See Other',
    304 => '304 Not Modified', # RFC 7232
    305 => '305 Use Proxy',
    307 => '307 Temporary Redirect',
    308 => '308 Permanent Redirect', # RFC 7538
    400 => '400 Bad Request',
    401 => '401 Unauthorized', # RFC 7235
    402 => '402 Payment Required',
    403 => '403 Forbidden',
    404 => '404 Not Found',
    405 => '405 Method Not Allowed',
    406 => '406 Not Acceptable',
    407 => '407 Proxy Authentication Required', # RFC 7235
    408 => '408 Request Time-out',
    409 => '409 Conflict',
    410 => '410 Gone',
    411 => '411 Length Required',
    412 => '412 Precondition Failed', # RFC 7232
    413 => '413 Payload Too Large', # RFC 7231
    414 => '414 URI Too Long', # RFC 7231
    415 => '415 Unsupported Media Type',
    416 => '416 Range Not Satisfiable',
    417 => '417 Expectation Failed', # RFC 2324
    418 => '418 I\'m a teaport', # RFC 2324
    421 => '421 Misdirected Request', # RFC 7540
    422 => '422 Unprocessable Entity', # RFC 4918
    423 => '423 Locked', # RFC 4918
    424 => '424 Failed Dependency', # RFC 4918
    426 => '426 Upgrade Required',
    428 => '428 Precondition Required', # RFC 6585
    429 => '429 Too Many Requests', # RFC 6585
    431 => '431 Request Header Fields Too Large', # RFC 6585
    451 => '451 Unavailable For Legal Reasons',
    500 => '500 Internal Server Error',
    501 => '501 Not Implemented',
    502 => '502 Bad Gateway',
    503 => '503 Service Unavailable',
    504 => '504 Gateway Time-out',
    505 => '505 HTTP Version not supported',
    506 => '506 Variant Also Negotiates', # RFC 2295
    507 => '507 Insufficient Storage', # RFC 4918
    508 => '508 Loop Detected', # RFC 5842
    510 => '510 Not Extended', # RFC 2774
    511 => '511 Network Authentication Required', # RFC 6585
  }
  STATUS_CODE.default = '500 Internal Server Error'
  STATUS_CODE.freeze

  # Default header for Basic HTTP response
  DEFAULT_HEADER = {
    'Server' => "Midori/#{Midori::VERSION}"
  }

  # Default header for EventSource response
  EVENTSOURCE_HEADER = {
    'Content-Type' => 'text-event-stream',
    'Cache-Control' => 'no-cache',
    'Connection' => 'keep-alive'
  }

  # Default header for WebSocket response
  WEBSOCKET_HEADER = {
    'Upgrade' => 'websocket',
    'Connection' => 'Upgrade'
  }

  ROUTE_METHODS = %i(
    DELETE
    GET
    HEAD
    POST
    PUT
    CONNECT
    OPTIONS
    TRACE
    COPY
    LOCK
    MKCOL
    MOVE
    PROPFIND
    PROPPATCH
    UNLOCK
    REPORT
    MKACTIVITY
    CHECKOUT
    MERGE
    M-SEARCH
    NOTIFY
    SUBSCRIBE
    UNSUBSCRIBE
    PATCH
    PURGE
    WEBSOCKET
    EVENTSOURCE
  )
end
