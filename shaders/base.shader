shader_type canvas_item;
render_mode blend_mix;

vec2 lengthdir(float theta, float rad) {
    return vec2(
        cos(theta),
        sin(theta)
    ) * rad;
}


void fragment() {
    COLOR = texture(TEXTURE, UV);
}