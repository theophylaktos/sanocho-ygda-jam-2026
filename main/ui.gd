extends Control

const move_icon_used = preload("uid://bq1rbfcvjbdwa")

func _ready() -> void:
	GameState.moves_left_changed.connect(_change_moves_left)
	GameState.max_moves_changed.connect(_change_max_moves)

func _change_moves_left():
	if GameState.moves_left < GameState.max_moves:
		%Moves.get_child(GameState.max_moves - GameState.moves_left - 1).texture = move_icon_used
	if GameState.moves_left == 0:
		RoundManager.start_attack_phase()
	
func _change_max_moves():
	if GameState.moves_left < GameState.max_moves:
		%Moves.get_child(GameState.max_moves - GameState.moves_left - 1).texture = move_icon_used
	if GameState.moves_left == 0:
		RoundManager.start_attack_phase()
