extends Node

var object_locations: Array[Array] = []

var segments: Array[Array] = []

var distance: Array[int] = [57, 39, 25]

var rotating = false

var player: Node2D

var enemies_folder: Node

var center: Vector2 = Vector2(-55, 0)

signal attacks_changed

var settings_open = false

var master_volume: float = 0.5
var music_volume: float = 0.7
var sfx_volume: float = 0.4
var ambience_volume:float = 0.4

var attacks: Array[String]=["attack","",""]:
	set(new_value):
		attacks = new_value
		attacks_changed.emit()

var damage: int=1

signal max_health_changed
@export var max_health = 5:
	set(new_value):
		max_health = new_value
		max_health_changed.emit()
		
signal health_left_changed
@export var health_left = 5:
	set(new_value):
		health_left = new_value
		health_left_changed.emit()

signal max_moves_changed
@export var max_moves = 3:
	set(new_value):
		max_moves = new_value
		max_moves_changed.emit()

signal moves_left_changed
@export var moves_left: int = 3:
	set(new_value):
		moves_left = new_value
		moves_left_changed.emit()

signal max_attacks_changed
@export var max_attacks = 1:
	set(new_value):
		max_attacks = new_value
		max_attacks_changed.emit()

signal attacks_left_changed
@export var attacks_left = 1:
	set(new_value):
		attacks_left = new_value
		attacks_left_changed.emit()

func _init() -> void:
	object_locations.resize(3)
	for array in object_locations:
		array.resize(8)
	
	segments.resize(3)
	for array in segments:
		array.resize(8)

## This adds node to Vector2(ring, degree)
func add_node(node: Node2D, ring: int, degree: int):
	node.ring = ring
	node.degree = degree
	node.position = center
	node.local.position.x = distance[ring]
	object_locations[ring][degree] = node
	node.rotation = (PI / 8) + degree * (PI / 4)
	node.local.rotation = -1 * ((PI / 8) + degree * (PI / 4))

## This creates a new node from the packedscene and adds said node to Vector2(ring, degree)
func create_and_add_node(node: PackedScene, ring: int, degree: int):
	var temp = node.instantiate()
	temp.name = str(Time.get_ticks_msec()) + "enemy"
	enemies_folder.add_child(temp)
	temp.ring = ring
	temp.degree = degree
	temp.local.position.x = distance[ring]
	temp.position = center
	object_locations[ring][degree] = temp
	temp.rotation = (PI / 8) + degree * (PI / 4)
	temp.local.rotation = -1 * ((PI / 8) + degree * (PI / 4))

## This clears the old position and puts node in the new position
func update_position(old_ring: int, old_degree: int, new_ring: int, new_degree: int, node: Node2D):
	object_locations[new_ring][new_degree] = node
	object_locations[old_ring][old_degree] = null
	
## This moves node to Vector2(ring, degree)
func position_node(node: Node2D, ring: int, degree: int, time: float):
	rotating = true
	#object_locations[ring][degree] = global
	#object_locations[global.ring][global.degree] = null
	node.ring = ring
	node.degree = degree
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var global_rotation: float = node.rotation
	var local_rotation: float = node.local.rotation
	
	tween.tween_method(
		func(value: float) -> void:
			if node != null:
				node.rotation = lerp_angle(global_rotation, (PI / 8) + degree * (PI / 4), value), 0.0, 1.0, time
	)
	
	tween.parallel().tween_method(
		func(value: float) -> void:
			if node != null:
				node.local.rotation = lerp_angle(local_rotation, -1 * ((PI / 8) + degree * (PI / 4)), value), 0.0, 1.0, time
	)
	if node != null:
		tween.parallel().tween_property(node.local, "position", Vector2(distance[ring], 0), time)
	
	await tween.finished
	rotating = false
	
func rotate_ring(ring: int, ring_parent: Node, degree: int, time: float):
	rotating = true
	var tween: Tween = get_tree().create_tween()
	
	for node in ring_parent.get_children():
		tween.parallel().tween_property(node, "rotation", node.rotation + (degree * (PI / 4)), time)
	
	for i in object_locations[ring].size():
		var node: Node2D = object_locations[ring][i]
		if node != null:# and $node.rotateable == true:
			GameState.position_node(node, node.ring, (degree + node.degree) % 8, time)
			#node.rotateable = false
	_rotate_nodes(ring, degree)
	_rotate_segments(ring, degree)
	
	refresh_enemy_highlights()
	
	await tween.finished
	rotating = false
	
func _rotate_nodes(ring: int, degree: int):
	for degrees in abs(degree):
		if degree > 0:
			var temp: Node = object_locations[ring][-1]
			for i in range(1, object_locations[0].size()):
				object_locations[ring][-i] = object_locations[ring][-i - 1]
			object_locations[ring][0] = temp
		if degree < 0:
			var temp: Node = object_locations[ring][0]
			for i in range(0, object_locations[0].size() - 1):
				object_locations[ring][i] = object_locations[ring][i + 1]
			object_locations[ring][-1] = temp

func _rotate_segments(ring: int, degree: int):
	for degrees in abs(degree):
		if degree > 0:
			var temp: Node = segments[ring][-1]
			for i in range(1, segments[0].size()):
				segments[ring][-i] = segments[ring][-i - 1]
			segments[ring][0] = temp
		if degree < 0:
			var temp: Node = segments[ring][0]
			for i in range(0, segments[0].size() - 1):
				segments[ring][i] = segments[ring][i + 1]
			segments[ring][-1] = temp

func toggle_player_attack_segment(ring: int, degree: int):
	var material: ShaderMaterial = segments[ring][degree].get_material()
	var is_enabled: bool = material.get_shader_parameter("player_attack_enabled")
	material.set_shader_parameter("player_attack_enabled", not is_enabled)
	
func toggle_select_ring(ring: int):
	for i in 8:
		var material: ShaderMaterial = segments[ring][i].get_material()
		material.set_shader_parameter("select_enabled", true)
		
func clear_select_ring(ring: int):
		for i in 8:
			var material: ShaderMaterial = segments[ring][i].get_material()
			material.set_shader_parameter("select_enabled", false)
	
func clear_player_attack_segment(ring: int, degree: int):
	var material: ShaderMaterial = segments[ring][degree].get_material()
	material.set_shader_parameter("player_attack_enabled", false)

func clear_all_player_attack_segments():
	for ring in segments.size():
		for degree in segments[0].size():
			clear_player_attack_segment(ring, degree)

func enable_enemy_attack_segment(ring: int, degree: int):
	var material: ShaderMaterial = segments[ring][degree].get_material()
	material.set_shader_parameter("enemy_attack_enabled", true)

func clear_enemy_attack_segment(ring: int, degree: int):
	var material: ShaderMaterial = segments[ring][degree].get_material()
	material.set_shader_parameter("enemy_attack_enabled", false)

func clear_all_enemy_attack_segments(): 
	for ring in segments.size():
		for degree in segments[0].size():
			clear_enemy_attack_segment(ring, degree)

func damage_enemies():
	for ring in segments.size():
		for degree in segments[0].size():
			var material: ShaderMaterial = segments[ring][degree].get_material()
			if material.get_shader_parameter("player_attack_enabled") == true:
				if object_locations[ring][degree] is Enemy:
					object_locations[ring][degree].take_damage(damage)
	refresh_enemy_highlights()
	
	if count_enemies() == 0:
		RoundManager.change_scene_to_shop()

func count_enemies() -> int:
	var count: int = 0
	for ring in object_locations.size():
		for degree in object_locations[0].size():
			if object_locations[ring][degree] is Enemy:
				count += 1
	return count

func refresh_enemy_highlights():
	clear_all_enemy_attack_segments()
	for r in object_locations.size():
		for d in object_locations[0].size():
			if object_locations[r][d] is Enemy:
				object_locations[r][d].highlight_attack()
