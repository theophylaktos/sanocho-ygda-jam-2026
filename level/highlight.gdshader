shader_type canvas_item;

uniform bool select_enabled = false;
uniform bool attack_enabled = false;

void fragment() {
	COLOR.r += 1.0 * float(attack_enabled);
	COLOR.g += 1.0 * float(select_enabled);
}