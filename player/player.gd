extends Node2D

@export var ring: int = 1

@export var degree: int = 2

@export var rotateable: bool = true

@export var local: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.addNode(self, ring, degree)
	#GameState.positionNode(self, $Local, 1, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout
	#GameState.positionNode(self, $Local, 5, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout

func _process(_delta: float) -> void:
	pass
