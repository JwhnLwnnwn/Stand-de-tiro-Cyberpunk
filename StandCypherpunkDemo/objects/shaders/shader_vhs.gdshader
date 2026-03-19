shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float distortion = 0.002;
uniform float scanline_intensity = 1.5;

void fragment() {

    vec2 uv = SCREEN_UV;

    // distorção horizontal tipo VHS
    uv.x += sin(uv.y * 2.0 + TIME * 3.0) * distortion;

    vec3 col = texture(SCREEN_TEXTURE, uv).rgb;

    // scanlines
    float scan = sin(uv.y * 1000.0) * scanline_intensity;
    col *= 1.0 - scan;

    COLOR = vec4(col,1);
}