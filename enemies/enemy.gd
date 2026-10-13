extends Node2D

class_name Enemy

@export var attacks: Dictionary[String, Array] = {}

@export var max_health: int = 0

@export var health: int = 0:
	set(new_value):
		health = new_value
		if health_bar != null:
			health_bar.value = (health * 1.0) / max_health

@export var ring: int

@export var degree: int:
	set(new_value):
		if new_value < 0:
			new_value = 8 + new_value
		degree = new_value % 8
		
@export var health_bar: ProgressBar

@export var animated_sprite_2d: AnimatedSprite2D

@export var can_move = false

var is_attacking = false

var is_dying = false

func _process(delta: float) -> void:
	if animated_sprite_2d != null:
		if not is_attacking or is_dying:
			if degree == 7 or degree == 0:
				if animated_sprite_2d.animation != "idle_right":
					animated_sprite_2d.play("idle_right")
			if degree == 1 or degree == 2:
				if animated_sprite_2d.animation != "idle_back":
					animated_sprite_2d.play("idle_back")
			if degree == 3 or degree == 4:
				if animated_sprite_2d.animation != "idle_left":
					animated_sprite_2d.play("idle_left")
			if degree == 5 or degree == 6:
				if animated_sprite_2d.animation != "idle_front":
					animated_sprite_2d.play("idle_front")

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
	is_attacking = true
	print("grrr attck")
	if degree == 7 or degree == 0:
		animated_sprite_2d.play("attack_right")
	if degree == 1 or degree == 2:
		animated_sprite_2d.play("attack_back")
	if degree == 3 or degree == 4:
		animated_sprite_2d.play("attack_left")
	if degree == 5 or degree == 6:
		animated_sprite_2d.play("attack_front")
	await animated_sprite_2d.animation_finished
	is_attacking = false

func take_damage(damage: int):
	health -= damage
	if(health <= 0):
		die()
	return

func die():
	GameState.object_locations[ring][degree] = null
	self.queue_free()
	
func play_attack_sound():
	if self.type == "Ghost":
		SFX.play(SFX.Id.GHOST_ATTACK)
	elif self.type == "Golem":
		SFX.play(SFX.Id.GOLEM_ATTACK)
	elif self.type == "Mushroom":
		SFX.play(SFX.Id.MUSHROOM_ATTACK)
	elif self.type == "Goblin":
		SFX.play(SFX.Id.GOBLIN_ATTACK)
	elif self.type == "Snake":
		SFX.play(SFX.Id.SNAKE_ATTACK)
