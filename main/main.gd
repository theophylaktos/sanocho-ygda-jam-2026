extends Node2D

func _ready() -> void:
	GameState.enemies_folder = $Enemies
	RoundManager.start_round()
