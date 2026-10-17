extends Node

@export var rounds: Dictionary[int, Array] = {}

@export var current_round = 0

@export var current_phase = ""

@export var starting_position: Vector2i = Vector2i(2, 6)

var random_enemy_points: int = 0

signal round_completed

signal move_phase_started
signal attack_phase_started
signal enemy_attack_phase_started

func change_scene_to_menu():
	get_tree().change_scene_to_file("uid://clc5dgdphsk57")

func change_scene_to_main():
	get_tree().change_scene_to_file("uid://j0l0agjlk84b")

func do_not_change_scene_to_shop():
	round_completed.emit()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("uid://j0l0agjlk84b")
	
func change_scene_to_shop():
	round_completed.emit()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("uid://iy5jea5tf8ka")
	
func start_round():
	start_move_phase()
	var spawned_positions: Array[Array] = []
	spawned_positions.resize(3)
	for i in spawned_positions.size():
		spawned_positions[i].resize(8)
		for j in spawned_positions[i].size():
			spawned_positions[i][j] = false
			
	GameState.add_node(GameState.player, starting_position.x, starting_position.y)
	GameState.toggle_select_ring(starting_position.x)
	spawned_positions[2][6] = true
	if(current_round<11):
		for node in rounds[current_round]:
			randomly_spawn_enemy(node, spawned_positions)
	else:
		var i: int=0
		while((int)(i<current_round*1.5)):
			var current: PackedScene=random_enemy()
			randomly_spawn_enemy(current, spawned_positions)
			i+=random_enemy_points+1
	
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
	move_phase_started.emit()
	current_phase = "Move"
	GameState.moves_left = GameState.max_moves
	GameState.attacks_left = GameState.max_attacks

func start_attack_phase():
	attack_phase_started.emit()
	current_phase = "PlayerAttack"
	GameState.clear_select_ring(0)
	GameState.clear_select_ring(1)
	GameState.clear_select_ring(2)
	
func start_enemy_attack_phase():
	enemy_attack_phase_started.emit()
	current_phase = "EnemyAttack"
	GameState.clear_all_player_attack_segments()
	
	for ring in GameState.segments.size():
		for degree in GameState.segments[0].size():
			var material: ShaderMaterial = GameState.segments[ring][degree].get_material()
			if material.get_shader_parameter("enemy_attack_enabled") == true:
				if GameState.object_locations[ring][degree] != null:
					if GameState.object_locations[ring][degree] is Player:
						GameState.object_locations[ring][degree].take_damage(1)
			if GameState.object_locations[ring][degree] !=null:
				if GameState.object_locations[ring][degree] is Enemy:
					GameState.object_locations[ring][degree].attack()
					GameState.object_locations[ring][degree].play_attack_sound()
					await get_tree().create_timer(1.5).timeout

	start_enemy_move_phase()
	
func start_enemy_move_phase():
	for ring in GameState.segments.size():
		for degree in GameState.segments[0].size():
			if GameState.object_locations[ring][degree] != null:
				if(GameState.object_locations[ring][degree] is Enemy):
					GameState.object_locations[ring][degree].can_move = true;
	
	for ring in GameState.segments.size():
		for degree in GameState.segments[0].size():
			var node = GameState.object_locations[ring][degree]
			if(node != null and node is Enemy and node.can_move):
				GameState.object_locations[ring][degree].can_move = false
				var mover : int=randi_range(0,3)
				match mover:
					0:
						if(ring<2 and GameState.object_locations[ring+1][degree]==null):
							GameState.position_node(GameState.object_locations[ring][degree], ring+1, degree, 0.5)
							GameState.update_position(ring,degree,ring+1,degree,GameState.object_locations[ring][degree])
							GameState.object_locations[ring][degree].play_move
					1:
						if(ring>0 and GameState.object_locations[ring-1][degree]==null):
							GameState.position_node(GameState.object_locations[ring][degree], ring-1, degree, 0.5)
							GameState.update_position(ring,degree,ring-1,degree,GameState.object_locations[ring][degree])
					2:
						if(GameState.object_locations[ring][(degree+1)%8]==null):
							GameState.position_node(GameState.object_locations[ring][degree], ring, (degree+1)%8, 0.5)
							GameState.update_position(ring,degree,ring,(degree+1)%8,GameState.object_locations[ring][degree])
					3:
						var new_degree: int = (degree-1) % 8
						if(new_degree < 0):
							new_degree = 8 - abs(new_degree)
						if(GameState.object_locations[ring][new_degree]==null):
							GameState.position_node(GameState.object_locations[ring][degree], ring, new_degree, 0.5)
							GameState.update_position(ring,degree,ring,new_degree,GameState.object_locations[ring][degree])
	GameState.refresh_enemy_highlights()
	start_move_phase()
func random_enemy() -> PackedScene:
	var choice: int=randi_range(1,5)
	if(choice==1):
		random_enemy_points=2
		return preload("uid://by52rlb2ob5qc")
	elif(choice==2):
		random_enemy_points=1
		return preload("uid://2d6hvyas8v7c")
	elif(choice==3):
		random_enemy_points=1
		return preload("uid://b7mh580xxik10")
	elif(choice==4):
		random_enemy_points=2
		return preload("uid://dktx6iodn45ko")
	else:
		random_enemy_points=2
		return preload("uid://57ce4qqyp5pq")
