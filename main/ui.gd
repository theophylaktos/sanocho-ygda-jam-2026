extends Control

const move_icon = preload("uid://ba3p4xkleu16q")
const move_icon_used = preload("uid://bq1rbfcvjbdwa")

const attack_icon = preload("uid://68rolvwokb64")
const attack_icon_used = preload("uid://wsslysm1iufd")

func _ready() -> void:
	GameState.moves_left_changed.connect(_change_moves_left)
	GameState.max_moves_changed.connect(_change_max_moves)

	GameState.attacks_left_changed.connect(_change_attacks_left)
	GameState.max_attacks_changed.connect(_change_max_attacks)


func _change_moves_left():
	if GameState.attacks_left == GameState.max_attacks:
		for child in %Attacks.get_children():
			child.texture = attack_icon
	if GameState.moves_left < GameState.max_moves:
		%Moves.get_child(GameState.max_moves - GameState.moves_left - 1).texture = move_icon_used
	if GameState.moves_left == 0:
		RoundManager.start_attack_phase()
	
func _change_max_moves():
	pass

func _change_attacks_left():
	print(GameState.attacks_left)
	if GameState.attacks_left == GameState.max_attacks:
		for child in %Attacks.get_children():
			child.texture = attack_icon
	if GameState.attacks_left < GameState.max_attacks:
		%Attacks.get_child(GameState.max_attacks - GameState.attacks_left - 1).texture = attack_icon_used
	if GameState.attacks_left == 0:
		RoundManager.start_enemy_attack_phase()
	
func _change_max_attacks():
	pass


func _on_button_pressed() -> void:
	GameState.attacks_left -= 1
