shader_type canvas_item;
render_mode unshaded;

//uniform sampler2D tex: repeat_disable, filter_nearest_mipmap;
uniform vec3 rotation;
// I guess its time for FULL SCREEN QUAD
uniform float ratio = 1.0;
uniform float scale = 1.0;
uniform float splat_amount: hint_range(0, 1) = 0.0;


mat3 rotation_matrix(vec3 euler_rotation) {
    vec3 r = -euler_rotation * TAU;
    return mat3(
        vec3(cos(r.z),-sin(r.z),0),
        vec3(sin(r.z), cos(r.z),0),
        vec3(0,0,1)
    ) * mat3(
        vec3(1,0,0),
        vec3(0,cos(r.x),-sin(r.x)),
        vec3(0,sin(r.x), cos(r.x))
    ) * mat3(
        vec3( cos(r.y), 0, sin(r.y)), 
        vec3(0,1,0),
        vec3(-sin(r.y), 0, cos(r.y))
    );
}



void fragment() {
    vec2 uv_scale = scale * vec2(ratio*1.0, 1.0);
    
    // convert the uvs into polar coordinates.
    float lat = -(UV.y - 0.5) * PI;
    float lon = -(UV.x + 0.5) * TAU;
    float r_lat = cos(lat);
    
    // Get the sphere's uv coordinates as 3d points in space and
    // apply the inverse rotation matrix
    vec3 coord = rotation_matrix(rotation) * vec3(
        sin(lon) * r_lat,
        sin(lat),
        cos(lon) * r_lat
    );
    
    // /coord.z controls the style of projection
    float splat = mix(coord.z, 1.0, splat_amount);
    vec2 uv = -coord.xy/uv_scale/splat;
    //uv = asin(uv);
    uv = uv*0.5+0.5;
    vec4 col = texture(TEXTURE, uv);
    
    // mask off repeating due to trig
    col.a *= float(coord.z > 0.0)
        * float(uv.x > 0.0 && uv.x < 1.0 && uv.y > 0.0 && uv.y < 1.0);
        
    COLOR.rgb = clamp(col.rgb, 0.0, 1.0);
    COLOR.a = col.a;
}
