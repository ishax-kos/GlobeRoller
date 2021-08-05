shader_type canvas_item;
render_mode blend_mix;

const float TAU = 6.28318530717958647692;
const float PI = 3.14159265358979323846;


const vec2 proportion = vec2(2.0, 1.0);
uniform int hemi_count : hint_range(1,2) = 2;


float pythag(vec2 p) {
    return sqrt(p.x * p.x + p.y * p.y);
}


vec2 lengthdir(float theta, float rad) {
    return vec2(
        cos(theta),
        sin(theta)
    ) * rad;
}


void fragment() {
    vec2 circumcenter = vec2(0.5) / proportion;
    vec2 uv2 = UV;  

    vec2 pos;
    
    
    if (UV.y <= 0.5) {
        pos = lengthdir((0.5 - uv2.x) * TAU, uv2.y);
        pos /= proportion;
        pos += circumcenter;
    }
    else {
        pos = lengthdir(uv2.x * TAU, 1.0 - uv2.y);
        pos /= proportion;
        pos += circumcenter + vec2(0.5, 0.0);
    }
    
    
        
    COLOR = texture(TEXTURE, pos);
    //*/
}