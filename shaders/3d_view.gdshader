shader_type spatial;
//render_mode unshaded;

uniform sampler2D tex: repeat_disable, filter_nearest_mipmap;
uniform vec4 regions[256];
//uniform float ratios[256];
uniform vec3 rotations[256];
uniform float scales[256];
uniform vec4 sea_color: source_color;
uniform int continent_count = 8;


mat3 inv_continent_transform(int index) {
    #define r -(rotations[index])
    return mat3(
        vec3( cos(r.y), 0, sin(r.y)), 
        vec3(0,1,0),
        vec3(-sin(r.y), 0, cos(r.y))
    ) * mat3(
        vec3(1,0,0),
        vec3(0,cos(r.x),-sin(r.x)),
        vec3(0,sin(r.x), cos(r.x))
    ) * mat3(
        vec3(cos(r.z),-sin(r.z),0),
        vec3(sin(r.z), cos(r.z),0),
        vec3(0,0,1)
    );
}


vec4 texture_atlas(sampler2D sampler, vec4 region, vec2 uv) {
    return texture(sampler, region.xy+uv*region.zw);
}


void fragment() {
    
    // convert the uvs into polar coordinates.
    float lat = (0.5-UV.y) * PI;
    float lon = UV.x * TAU;
    float r_lat = cos(lat);
    
    // Get the sphere's uv coordinates as 3d points in space and
    // apply the inverse rotation matrix
    vec3 sphere_coord = vec3(
        sin(lon) * r_lat,
        sin(lat),
        cos(lon) * r_lat
    );
    vec4 col = sea_color;
    
    for (int i = 0; i < continent_count; i += 1) {
        mat3 mat = inv_continent_transform(i); 
        vec3 coord = mat * sphere_coord;
        vec4 region = regions[i];
        vec2 uv_scale = scales[i] * vec2(region.z/region.w, 1.0);
        
        // /coord.z controls the style of projection
        vec2 uv = 0.5-coord.xy*0.5/uv_scale/coord.z;
        vec4 new_col = texture_atlas(tex, region, uv);
        // mask off repeating due to trig
        new_col.a *= float(coord.z > 0.0)
            * float(uv.x > 0.0 && uv.x < 1.0 && uv.y > 0.0 && uv.y < 1.0);
            
        col.rgb = mix(col.rgb, new_col.rgb, new_col.a);
        col.a = clamp(col.a + new_col.a, 0.0, 1.0);
    }
    
    ALBEDO = col.rgb;
    ALPHA = col.a;
}
