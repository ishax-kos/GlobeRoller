shader_type canvas_item;
render_mode unshaded;

#include "projection.gdshaderinc"

void fragment() {
    vec3 cartesian = sphere_uv_to_cartesian(UV);
    float lon = atan(cartesian.x, cartesian.z);
    float lat = asin(cartesian.y);
    vec2 uv = vec2(lon, lat)*4.0/TAU;
    COLOR = colorize(uv, TEXTURE);
}