extends Node

@export var rounds: Dictionary[int, Array] = {}

@export var current_round = 0

@export var starting_position: Vector2i = Vector2i(2, 6)

func change_scene_to_main():
	get_tree().change_scene_to_file("uid://j0l0agjlk84b")
	
func change_scene_to_shop():
	get_tree().change_scene_to_file("uid://iy5jea5tf8ka")
	
func start_round():
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
	
	for enemy in rounds[current_round]:
		randomly_spawn_enemy(enemy, spawned_positions)

func randomly_spawn_enemy(enemy: PackedScene, spawned_positions: Array[Array]):
	var random_ring: int = randi_range(0,2)
	var random_degree: int = randi_range(0,7)
	if spawned_positions[random_ring][random_degree] == false:
		GameState.create_and_add_node(enemy, random_ring, random_degree)
		spawned_positions[random_ring][random_degree] = true
	else:
		randomly_spawn_enemy(enemy, spawned_positions)
		
func start_attack_phase():
	GameState.clear_select_ring(0)
	GameState.clear_select_ring(1)
	GameState.clear_select_ring(2)
