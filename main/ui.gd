extends Control

const health_icon = preload("uid://b5m36i1cyrvs8")
const health_icon_used = preload("uid://c32p5tt3tijbu")

const move_icon_used = preload("uid://bs07rvx8acl1r")

const attack_icon_used = preload("uid://dhsnyd16t61qp")

var attack_icons: Dictionary = {
	"diagonal": preload("uid://d30hood7b3jia"),
	"attack2": preload("uid://bwn8ypto7o7jl"),
	"attack4": preload("uid://ddlottmvshgpf"),
	"knight": preload("uid://c2hshq4wc3crf"),
	"all_diagonals": preload("uid://b4fj23dssqgx4"),
	"all_horizontals": preload("uid://b4fj23dssqgx4"),
	"attack": preload("uid://b4fj23dssqgx4"),
}

var health_icon_animated = preload("uid://cn65pyff78c3n")
var attack_icon_animated = preload("uid://dvem5fcvpnvuh")
var move_icon_animated = preload("uid://bh4jbss3p34a4")

var heart_loss_frame_length = 1.0 / 12.0
var attack_idle_frame_length = 1.0 / 5.0
var moves_idle_frame_length = 1.0 / 5.0


func _ready() -> void:
	GameState.health_left_changed.connect(_change_health_left)
	GameState.max_health_changed.connect(_change_max_health)
	
	GameState.moves_left_changed.connect(_change_moves_left)
	GameState.max_moves_changed.connect(_change_max_moves)

	GameState.attacks_left_changed.connect(_change_attacks_left)
	GameState.max_attacks_changed.connect(_change_max_attacks)
	
	GameState.attacks_changed.connect(_attacks_changed)
	GameState.attacks_changed.emit()
	
	GameState.max_health = GameState.max_health
	GameState.health_left = GameState.health_left
	
	GameState.max_moves = GameState.max_moves
	GameState.moves_left = GameState.moves_left

	GameState.max_attacks = GameState.max_attacks
	GameState.attacks_left = GameState.attacks_left
	
	animate_attack_icon(0)
	animate_move_icon(0)
	
func _change_moves_left():
	if GameState.moves_left == GameState.max_moves:
		for child in %Moves.get_children():
			child.texture = AtlasTexture.new()
			child.texture.atlas = move_icon_animated
			child.texture.region = Rect2(0,0,16,16)
	if GameState.moves_left < GameState.max_moves:
		if %Moves.get_child(GameState.max_moves - GameState.moves_left - 1) != null:
			%Moves.get_child(GameState.max_moves - GameState.moves_left - 1).texture = move_icon_used
	if GameState.moves_left == 0:
		RoundManager.start_attack_phase()
		
func animate_move_icon(frame: int):
	frame = frame % 3
	for node in %Moves.get_children():
		node.texture.region = Rect2(frame * 16, 0, 16, 16)
	await get_tree().create_timer(moves_idle_frame_length).timeout
	animate_move_icon(frame + 1)
	
func _change_max_moves():
	for node in %Moves.get_children():
		node.queue_free()
	for count in GameState.max_moves:
		var move = TextureRect.new()
		var texture = AtlasTexture.new()
		texture.atlas = attack_icon_animated
		move.texture = move
		%Moves.add_child(move)

func _change_attacks_left():
	if GameState.attacks_left == GameState.max_attacks:
		for child in %Attacks.get_children():
			child.texture = AtlasTexture.new()
			child.texture.atlas = attack_icon_animated
			child.texture.region = Rect2(0,0,16,16)
	if GameState.attacks_left < GameState.max_attacks:
		GameState.damage_enemies()
		if %Attacks.get_child(GameState.max_attacks - GameState.attacks_left - 1) != null:
			%Attacks.get_child(GameState.max_attacks - GameState.attacks_left - 1).texture = attack_icon_used
	if GameState.attacks_left == 0:
		RoundManager.start_enemy_attack_phase()
	
func animate_attack_icon(frame: int):
	frame = frame % 8
	for node in %Attacks.get_children():
		node.texture.region = Rect2(frame * 16, 0, 16, 16)
	await get_tree().create_timer(attack_idle_frame_length).timeout
	animate_attack_icon(frame + 1)
	
func _change_max_attacks():
	for node in %Attacks.get_children():
		node.queue_free()
	for count in GameState.max_attacks:
		var attack = TextureRect.new()
		var texture = AtlasTexture.new()
		texture.atlas = attack_icon_animated
		attack.texture = texture
		%Attacks.add_child(attack)
	
func _change_health_left():
	if GameState.health_left == GameState.max_health:
		for child in %Health.get_children():
			child.texture = health_icon
	if GameState.health_left < GameState.max_health:
		if %Health.get_child(GameState.max_health - GameState.health_left - 1) != null:
			play_health_loss_animation(%Health.get_child(GameState.max_health - GameState.health_left - 1))
	if GameState.health_left == 0:
		RoundManager.change_scene_to_menu()
	
func play_health_loss_animation(node: Node):
	for row in 4:
		for col in 3:
			var texture = AtlasTexture.new()
			texture.atlas = health_icon_animated
			texture.region = Rect2(16 * col, 16 * row, 16, 16)
			node.texture = texture
			await get_tree().create_timer(heart_loss_frame_length).timeout
	
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


func _on_weapon_1_button_pressed() -> void:
	GameState.selected_attack = GameState.attacks[0]

func _on_weapon_2_button_pressed() -> void:
	GameState.selected_attack = GameState.attacks[1]

func _on_weapon_3_button_pressed() -> void:
	GameState.selected_attack = GameState.attacks[2]
	
func _attacks_changed() -> void:
	if attack_icons.get(GameState.attacks[0]) != null:
		%Weapon1Button.texture_normal = attack_icons[GameState.attacks[0]]
	if attack_icons.get(GameState.attacks[1]) != null:
		%Weapon2Button.texture_normal = attack_icons[GameState.attacks[1]]
	if attack_icons.get(GameState.attacks[2]) != null:
		%Weapon3Button.texture_normal = attack_icons[GameState.attacks[2]]


func _on_escape_pressed() -> void:
	%Settings.visible = true
	GameState.settings_open = true
