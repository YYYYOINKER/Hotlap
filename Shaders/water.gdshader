shader_type spatial;

// Neccesary basics
uniform vec3 water_color: source_color;
uniform float uv_scale: hint_range(0.0, 10.0, 0.25) = 1.0;
uniform float time_scale: hint_range(0.0, 10.0, 0.25) = 1.0;
uniform sampler2D water_normal_noise;

// Extras
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;

void fragment() {
	
	vec2 _uv = UV * uv_scale;
	vec2 _suv = SCREEN_UV;
	
	// Me when trig functions
	_uv.x += sin(TIME * time_scale + (_uv.x + _uv.y) * 25.0) * 0.01;
	_uv.y += cos(TIME * time_scale - (_uv.x + _uv.y) * 25.0) * 0.01;
	
	_suv.x += sin(TIME * time_scale + (_suv.x + _suv.y) * 25.0) * 0.01;
	_suv.y += cos(TIME * time_scale - (_suv.x + _suv.y) * 25.0) * 0.01;
	
	vec3 screen_texture_color = texture(screen_texture, _suv).rgb;
	ALBEDO = screen_texture_color * water_color;
	NORMAL_MAP = texture(water_normal_noise, _uv).rgb;
	NORMAL *= 0.8;
	ROUGHNESS = 0.09;
}
