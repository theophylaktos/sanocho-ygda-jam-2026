shader_type canvas_item;

uniform bool select_enabled = false;
uniform bool player_attack_enabled = false;
uniform bool enemy_attack_enabled = false;

void fragment() {
	COLOR.b += 1.0 * float(player_attack_enabled);
	COLOR.g += 1.0 * float(select_enabled);
	COLOR.r += 1.0 * float(enemy_attack_enabled) * abs(sin(TIME));
}