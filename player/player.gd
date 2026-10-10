extends Node2D

@export var location: Vector2 = Vector2(0,0)
@export var local: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	GameState.positionNode(self, $Local, 2, 1, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout
	#GameState.positionNode(self, $Local, 5, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout

func _process(_delta: float) -> void:
	pass
