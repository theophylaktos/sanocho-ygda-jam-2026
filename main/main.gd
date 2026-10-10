extends Node2D

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	GameState.rotateRing(1, $Rings/RingOne, 2, 2)
