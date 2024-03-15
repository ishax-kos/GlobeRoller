shader_type canvas_item;
render_mode unshaded;

#include "projection.gdshaderinc"

void fragment() {
    vec3 cartesian = sphere_uv_to_cartesian(UV);
    vec2 uv = atan(cartesian.xy, vec2(cartesian.z))/(TAU/4.0);
    //float angle = atan(cartesian.y, cartesian.x);
    ////
    //vec2 c = 1.0/normalize(cartesian.xy);
    //float rad = acos(cartesian.z)/(TAU/4.0);
    //float square = sqrt(0.5*(rad*rad+min(
        //pow(tan(angle), 2),
        //pow(tan(angle+TAU/4.0), 2)
    //)));
    ////square = mix(1.0, square, rad);
    //vec2 uv = rad*rad*rad*vec2(cos(angle), sin(angle))*square;
    ////COLOR = vec4(vec3(rad), 1.0);
    COLOR = colorize(uv, TEXTURE);
}
