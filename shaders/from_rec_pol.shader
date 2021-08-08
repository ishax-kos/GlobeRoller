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
    float angle;
    float rad;
    
//    angle = atan(uv2.y - 0.5, uv2.x - 0.5) / TAU;
//    rad = pythag(uv2);
    
    if (UV.x <= 0.5) {
        uv2 += -circumcenter;
        angle = 0.5 - atan(uv2.y, uv2.x) / TAU;
        rad = pythag(uv2);

    }
    else {
        uv2 += -circumcenter;
        uv2.x -= 1.0;
        angle = 0.5 - atan(uv2.y, -uv2.x) / TAU;
        rad = 1.0 - pythag(uv2);
    }
    float threshhold = ((0.5 + TEXTURE_PIXEL_SIZE.x) - pythag(uv2))/ TEXTURE_PIXEL_SIZE.x;
    pos = vec2(angle, rad);
    COLOR = texture(TEXTURE, vec2(angle, rad));
    COLOR.a *= clamp(threshhold, 0.0, 1.0);
    //clamp(COLOR.a * threshhold, 0.0, 1.0);
}