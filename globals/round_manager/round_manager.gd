extends Node

@export var rounds: Dictionary[int, Array] = {}

@export var current_round = 0

@export var current_phase = ""

@export var starting_position: Vector2i = Vector2i(2, 6)

func change_scene_to_menu():
	get_tree().change_scene_to_file("uid://clc5dgdphsk57")

func change_scene_to_main():
	get_tree().change_scene_to_file("uid://j0l0agjlk84b")
	
func change_scene_to_shop():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("uid://iy5jea5tf8ka")
	
func start_round():
	current_phase = "Move"
	GameState.moves_left = GameState.max_moves
	GameState.attacks_left = GameState.max_attacks
	var spawned_positions: Array[Array] = []
	spawned_positions.resize(3)
	for i in spawned_positions.size():
		spawned_positions[i].resize(8)
		for j in spawned_positions[i].size():
			spawned_positions[i][j] = false
			
	GameState.add_node(GameState.player, starting_position.x, starting_position.y)
	GameState.toggle_select_ring(starting_position.x)
	spawned_positions[2][6] = true
	
	for node in rounds[current_round]:
		randomly_spawn_enemy(node, spawned_positions)
	
	for ring in GameState.object_locations.size():
		for degree in GameState.object_locations[0].size():
			if GameState.object_locations[ring][degree] != null:
				if GameState.object_locations[ring][degree] is Enemy:
					GameState.object_locations[ring][degree].highlight_attack()

func randomly_spawn_enemy(node: PackedScene, spawned_positions: Array[Array]):
	var random_ring: int = randi_range(0,2)
	var random_degree: int = randi_range(0,7)
	if spawned_positions[random_ring][random_degree] == false:
		GameState.create_and_add_node(node, random_ring, random_degree)
		spawned_positions[random_ring][random_degree] = true
	else:
		randomly_spawn_enemy(node, spawned_positions)

func start_move_phase():
	current_phase = "Move"
	GameState.moves_left = GameState.max_moves
	GameState.attacks_left = GameState.max_attacks

func start_attack_phase():
	current_phase = "PlayerAttack"
	GameState.clear_select_ring(0)
	GameState.clear_select_ring(1)
	GameState.clear_select_ring(2)
	
func start_enemy_attack_phase():
	current_phase = "EnemyAttack"
	GameState.clear_all_player_attack_segments()
	
	for ring in GameState.segments.size():
		for degree in GameState.segments[0].size():
			var material: ShaderMaterial = GameState.segments[ring][degree].get_material()
			if material.get_shader_parameter("enemy_attack_enabled") == true:
				if GameState.object_locations[ring][degree] is Player:
					GameState.object_locations[ring][degree].take_damage(1)
	
	start_move_phase()
