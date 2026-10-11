extends Control

const health_icon = preload("uid://dcq2kl2rd745w")
const health_icon_used = preload("uid://d3d2wdudp08kk")

const move_icon = preload("uid://ba3p4xkleu16q")
const move_icon_used = preload("uid://bq1rbfcvjbdwa")

const attack_icon = preload("uid://68rolvwokb64")
const attack_icon_used = preload("uid://wsslysm1iufd")

func _ready() -> void:
	GameState.health_left_changed.connect(_change_health_left)
	GameState.max_health_changed.connect(_change_max_health)
	
	GameState.moves_left_changed.connect(_change_moves_left)
	GameState.max_moves_changed.connect(_change_max_moves)

	GameState.attacks_left_changed.connect(_change_attacks_left)
	GameState.max_attacks_changed.connect(_change_max_attacks)


func _change_moves_left():
	if GameState.moves_left == GameState.max_moves:
		for child in %Moves.get_children():
			child.texture = move_icon
	if GameState.moves_left < GameState.max_moves:
		%Moves.get_child(GameState.max_moves - GameState.moves_left - 1).texture = move_icon_used
	if GameState.moves_left == 0:
		RoundManager.start_attack_phase()
	
func _change_max_moves():
	for node in %Moves.get_children():
		node.queue_free()
	for count in GameState.max_attacks:
		var moves = TextureRect.new()
		moves.texture = move_icon
		%Moves.add_child(moves)

func _change_attacks_left():
	if GameState.attacks_left == GameState.max_attacks:
		for child in %Attacks.get_children():
			child.texture = attack_icon
	if GameState.attacks_left < GameState.max_attacks:
		GameState.damage_enemies()
		%Attacks.get_child(GameState.max_attacks - GameState.attacks_left - 1).texture = attack_icon_used
	if GameState.attacks_left == 0:
		GameState.damage_enemies()
		RoundManager.start_enemy_attack_phase()
	
func _change_max_attacks():
	for node in %Attacks.get_children():
		node.queue_free()
	for count in GameState.max_attacks:
		var attack = TextureRect.new()
		attack.texture = attack_icon
		%Attacks.add_child(attack)
	
func _change_health_left():
	if GameState.health_left == GameState.max_health:
		for child in %Health.get_children():
			child.texture = health_icon
	if GameState.health_left < GameState.max_health:
		%Health.get_child(GameState.max_health - GameState.health_left - 1).texture = health_icon_used
	if GameState.health_left == 0:
		RoundManager.change_scene_to_menu()
	
func _change_max_health():
	for node in %Health.get_children():
		node.queue_free()
	for health in GameState.max_health:
		var heart = TextureRect.new()
		heart.texture = health_icon
		%Health.add_child(heart)


func _on_button_pressed() -> void:
	GameState.attacks_left -= 1


func _on_skip_button_pressed() -> void:
	if GameState.moves_left > 0:
		GameState.moves_left -= 1
