shader_type canvas_item;
render_mode unshaded;

#include "projection.gdshaderinc"

void fragment() {
    vec3 cartesian = sphere_uv_to_cartesian(UV);
    float angle = atan(cartesian.y, cartesian.x);
    float rad = acos(cartesian.z)/(TAU/4.0);
    vec2 uv = rad*vec2(cos(angle), sin(angle));
    COLOR = colorize(uv, TEXTURE);
}