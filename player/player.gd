extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.positionNode(self, $Local, 5, 3, 2)
	

func _process(_delta: float) -> void:
	pass
