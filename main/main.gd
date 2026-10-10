extends Node2D

func _ready() -> void:
	GameState.rotateRing(1, $Rings/RingOne, 2, 1, 2)
