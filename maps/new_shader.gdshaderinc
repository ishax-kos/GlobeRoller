


uniform vec3 rotation;
uniform vec2 ratio = vec2(1);
uniform vec2 center_offset = vec2(0);
uniform float scale = 1.0;
uniform float image_rotation;
uniform bool selected = false;
uniform float highlight = 0.0;

const vec3 center_color = vec3(1, 0, 0);
const vec3 highlight_color = vec3(1, 1, 1);

mat3 rotation_matrix_3d(vec3 euler_rotation) {
    vec3 r = euler_rotation * TAU;
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

mat2 rotation_matrix_2d(float euler_rotation) {
    float r = euler_rotation * TAU;
    return mat2(
        vec2(cos(r),-sin(r)),
        vec2(sin(r), cos(r))
    );
}
//
//#if !defined(project)
//vec2 project(vec3 n) {return vec2(0);}
//#endif

vec3 sphere_uv_to_cartesian(vec2 uv) {
    float lat = (uv.y - 0.5) * PI;
    float lon = (uv.x + 0.5) * TAU;
    float r_lat = cos(lat);
    
    // Get the sphere's uv coordinates as 3d points in space
    vec3 cartesian = vec3(
        sin(lon) * r_lat,
        sin(lat),
        cos(lon) * r_lat
    );
    // apply the inverse rotation matrix
    return rotation_matrix_3d(rotation) * cartesian;
}

vec4 colorize(vec2 uv, sampler2D tex) {
    
    float center = clamp(
        (0.01 - length(uv)) * float(selected)
    *1000.0, 0.0, 1.0);
    //float center2 = clamp(
        //(0.02 - length(uv)) * float(selected)
    //*1000.0, 0.0, 1.0);
    
    uv = rotation_matrix_2d(image_rotation) * uv;
    uv = uv/scale/ratio + center_offset*2.0;
    float mask = clamp(
        (1.0-max(abs(uv.x),abs(uv.y)))
    *1000.0, 0.0, 1.0);
    uv = uv*0.5+0.5;
    vec4 col = texture(tex, uv);
    
    float h = highlight + float(selected)*0.25;
    vec4 hcol = vec4(highlight_color, h);
    hcol *= clamp(sin(uv.x*100.0)*sin(uv.y*100.0), -0.1, 0.1) + 1.0;
    col.a = clamp((col.a + h) * mask + center, 0.0, 1.0);
    col.rgb = mix(hcol.rgb, col.rgb, col.a);
    col.rgb = mix(col.rgb, hcol.rgb, hcol.a*0.25);
    col.rgb = mix(col.rgb, center_color, center*0.5);
    return col;
}