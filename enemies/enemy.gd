extends Node2D

class_name Enemy

@export var attacks: Dictionary[String, Array] = {}

@export var max_health: int = 0

@export var health: int = 0:
	set(new_value):
		health = new_value
		if health_bar != null:
			health_bar.value = health * 1.0 / max_health

@export var ring: int

@export var degree: int:
	set(new_value):
		if new_value < 0:
			new_value = 8 + new_value
		degree = new_value % 8
		
@export var health_bar: ProgressBar

func highlight_attack():
	for attack in attacks["attack"]:
		var v= (Vector2i)(attack)
		if ring + v.x >= 0 and ring + v.x <= 2:
			var new_y: int = degree + v.y
			if new_y < 0:
				new_y = 8 + new_y
			new_y = new_y % 8
			GameState.enable_enemy_attack_segment(ring+v.x, new_y)
	return

func attack():
	for attack in attacks["attack"]:
		var v = attack
		if ring + v.x >= 0 and ring + v.x <= 2:
			var new_y: int = degree + v.y
			if new_y < 0:
				new_y = 8 + new_y
			new_y = new_y % 8
			if GameState.object_locations[ring + v.x][new_y] == GameState.player:
				GameState.health_left -= 1
	return

func take_damage(damage: int):
	health -= damage
	if(health <= 0):
		die()
	return

func die():
	GameState.object_locations[ring][degree] = null
	self.queue_free()
