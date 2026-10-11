shader_type canvas_item;

uniform bool select_enabled = false;
uniform bool player_attack_enabled = false;
uniform bool enemy_attack_enabled = false;

uniform float max_red = 1.0;
uniform float max_green = 1.0;

void fragment() {
	//COLOR.g += 1.0 * float(select_enabled);
	
	float initial_green = COLOR.g;
	
	vec2 warning_color_rg = vec2(((sin(TIME * 4.0) * 0.5) + 0.5));
	
	COLOR.rg += float(enemy_attack_enabled) * warning_color_rg;
	
	COLOR.r += float(player_attack_enabled);
	COLOR.g -= float(player_attack_enabled) * warning_color_rg.g * 0.5;
	
	COLOR.r = clamp(COLOR.r, 0.0, max_red);
	COLOR.g = clamp(COLOR.g, initial_green, max_green);
}