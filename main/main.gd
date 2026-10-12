extends Node2D

func _ready() -> void:
	GameState.enemies_folder = $Enemies
	RoundManager.start_round()
	%CompletionCircle.visible = false
	RoundManager.round_completed.connect(_completion_circle)

func _completion_circle():
	%CompletionCircle.visible = true
	%CompletionCircle.frame = 0
	%CompletionCircle.play("default")
