#include <ruby.h>

VALUE Midori = Qnil;
VALUE MidoriWebSocket = Qnil;

void Init_midori();
VALUE method_midori_websocket_mask(VALUE self, VALUE payload, VALUE mask);

void Init_midori() {
  Midori = rb_define_module("Midori");
  MidoriWebSocket = rb_define_class_under(Midori, "WebSocket", rb_cObject);
  rb_define_protected_method(MidoriWebSocket, "mask", method_midori_websocket_mask, 2);
}

VALUE method_midori_websocket_mask(VALUE self, VALUE payload, VALUE mask) {
  long n = RARRAY_LEN(payload), i, p, m;
  VALUE unmasked = rb_ary_new2(n);

  int mask_array[] = {
    NUM2INT(rb_ary_entry(mask, 0)),
    NUM2INT(rb_ary_entry(mask, 1)),
    NUM2INT(rb_ary_entry(mask, 2)),
    NUM2INT(rb_ary_entry(mask, 3))
  };

  for (i = 0; i < n; i++) {
    p = NUM2INT(rb_ary_entry(payload, i));
    m = mask_array[i % 4];
    rb_ary_store(unmasked, i, INT2NUM(p ^ m));
  }
  return unmasked;
}
