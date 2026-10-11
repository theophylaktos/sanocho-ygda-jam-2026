extends Node2D
class_name enemy
@export var attacks: Dictionary[String, Array] = {}

@export var health: int = 0

@export var ring: int

@export var degree: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func highlight_attack():
	for attack in attacks["attack"]:
		var v= (Vector2i)(attack)
		GameState.toggle_enemy_attack_segment(ring+v.x,degree+v.y)
	return
func attack():
	for attack in attacks["attack"]:
		var v= (Vector2i)(attack)
		if(GameState.object_locations[ring+v.x][degree+v.y]==GameState.player):
			GameState.health_left-=1
	return
func damage(attack: int):
	health -= attack
	if(health<=0):
		die()
	return
func die():
	GameState.object_locations[ring][degree]=null
	self.queue_free()
