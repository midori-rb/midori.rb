#include <ruby.h>
#include <ruby/encoding.h>

VALUE Midori = Qnil;
VALUE MidoriException = Qnil;
VALUE MidoriWebSocket = Qnil;

VALUE ContinousFrameException = Qnil;
VALUE OpCodeException = Qnil;
VALUE NotMaskedException = Qnil;

void Init_midori_ext();
VALUE method_midori_websocket_decode(VALUE self, VALUE data);

void Init_midori_ext()
{
  Midori = rb_define_module("Midori");
  MidoriWebSocket = rb_define_class_under(Midori, "WebSocket", rb_cObject);
  MidoriException = rb_define_module_under(Midori, "Exception");
  ContinousFrameException = rb_const_get(MidoriException, rb_intern("ContinuousFrame"));
  OpCodeException = rb_const_get(MidoriException, rb_intern("OpCodeError"));
  NotMaskedException = rb_const_get(MidoriException, rb_intern("NotMasked"));
  rb_define_method(MidoriWebSocket, "decode", method_midori_websocket_decode, 1);
}

VALUE method_midori_websocket_decode(VALUE self, VALUE data)
{
  int byte, opcode, i, fin;
  ID getbyte = rb_intern("getbyte");
  ID close = rb_intern("close");

  byte = NUM2INT(rb_funcall(data, getbyte, 0));
  fin = byte & 0x80;
  opcode = byte & 0x0f;

  if (fin != 0x80)
    rb_raise(ContinousFrameException, "");
  
  rb_iv_set(self, "@opcode", INT2NUM(opcode));
  if (opcode != 0x1 && opcode != 0x2 && opcode != 0x8 && opcode != 0x9 && opcode != 0xA)
    rb_raise(OpCodeException, "");

  if (opcode == 0x8)
  {
    rb_funcall(self, close, 0);
    return Qnil;
  }

  byte = NUM2INT(rb_funcall(data, getbyte, 0));
  if ((byte & 0x80) != 0x80)
  {
    rb_raise(NotMaskedException, "");
  }

  int n = byte & 0x7f;
  char result[n];

  int mask_array[] = {
      NUM2INT(rb_funcall(data, getbyte, 0)),
      NUM2INT(rb_funcall(data, getbyte, 0)),
      NUM2INT(rb_funcall(data, getbyte, 0)),
      NUM2INT(rb_funcall(data, getbyte, 0))};

  for (i = 0; i < n; i++)
  {
    result[i] = NUM2INT(rb_funcall(data, getbyte, 0)) ^ mask_array[i % 4];
  }

  if (opcode == 0x1 || opcode == 0x9 || opcode == 0xA) {
    rb_iv_set(self, "@msg", rb_enc_str_new(result, n, rb_utf8_encoding()));
  } else {
    VALUE result_arr = rb_ary_new2(n);
    for (i = 0; i < n; i++)
    {
      rb_ary_store(result_arr, i, INT2NUM(result[i]));
    }
    rb_iv_set(self, "@msg", result_arr);
  }
  return Qnil;
}
