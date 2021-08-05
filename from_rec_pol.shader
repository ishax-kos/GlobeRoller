shader_type canvas_item;
render_mode blend_mix;


const float TAU = 6.28318530717958647692;
const vec2 proportion = vec2(2.0, 1.0);


float pythag(vec2 p) {
    return sqrt(p.x * p.x + p.y * p.y);
}


void fragment() {
    vec2 circumcenter = vec2(0.5);
    vec2 uv2 = UV * proportion;  

    vec2 pos;
    
    
    if (UV.x <= 0.5) {
        uv2 += -circumcenter;
        pos.x = 0.5 - atan(uv2.y, uv2.x) / TAU;
        pos.y = pythag(uv2);
    }
    else {
        uv2 += -circumcenter;
        uv2.x -= 1.0;
        pos.x = 0.5 - atan(uv2.y, -uv2.x) / TAU;
        pos.y = 1.0 - pythag(uv2);
    }
//    pos.x += 0.5;
    COLOR = texture(TEXTURE, pos);
//    COLOR.a *= max(1.0 * pos.y)
}