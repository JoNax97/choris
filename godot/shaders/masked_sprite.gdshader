// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx,unshaded,alpha_to_coverage_and_one;

uniform vec4 key_color : source_color = vec4(0,1,0,1);
uniform vec4 replacement_color : source_color;
uniform float similarity : hint_range(0.0,1.0) = 0.4;
uniform float smoothness : hint_range(0.00,1.0) = 0.08;
uniform float spill : hint_range(0.0,1.0) = 0.1;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float alpha_scissor_threshold;
uniform float alpha_antialiasing_edge;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// From https://github.com/libretro/glsl-shaders/blob/master/nnedi3/shaders/rgb-to-yuv.glsl
vec2 RGBtoUV(vec3 rgb) {
  return vec2(
    rgb.r * -0.169 + rgb.g * -0.331 + rgb.b *  0.5    + 0.5,
    rgb.r *  0.5   + rgb.g * -0.419 + rgb.b * -0.081  + 0.5
  );
}

vec4 ProcessChromaKey(vec4 rgba) {
  float chromaDist = distance(RGBtoUV(rgba.rgb), RGBtoUV(key_color.rgb));

  float baseMask = chromaDist - similarity;
  float fullMask = pow(clamp(baseMask / smoothness, 0., 1.), 1.5);
  rgba.a = fullMask;

  float spillVal = pow(clamp(baseMask / spill, 0., 1.), 1.5);
 // float desat = clamp(rgba.r * 0.2126 + rgba.g * 0.7152 + rgba.b * 0.0722, 0., 1.);
  rgba.rgb = mix(replacement_color.rgb, rgba.rgb, spillVal);

  return rgba;
}

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * ProcessChromaKey(albedo_tex).rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	ALPHA_ANTIALIASING_EDGE = alpha_antialiasing_edge;
	ALPHA_TEXTURE_COORDINATE = UV * vec2(albedo_texture_size);
}

