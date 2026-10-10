extends Node

var object_locations: Array[Array] = []

var segments: Array[Array] = []

var distance: Array[int] = [25, 41, 57]

func _init() -> void:
	object_locations.resize(3)
	for array in object_locations:
		array.resize(8)
	
	segments.resize(3)
	for array in segments:
		array.resize(8)
	
func addNode(node: Node2D, ring: int, degree: int):
	object_locations[ring][degree] = node
	node.rotation = (PI / 8) + degree * (PI / 4)
	node.local.rotation = -1 * ((PI / 8) + degree * (PI / 4))

func update_position(old_ring: int, old_degree: int, new_ring: int, new_degree: int, node: Node2D):
	object_locations[new_ring][new_degree] = node
	object_locations[old_ring][old_degree] = null
	
func position_node(node: Node2D, ring: int, degree: int, time: float):
	#object_locations[ring][degree] = global
	#object_locations[global.ring][global.degree] = null
	node.ring = ring
	node.degree = degree
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var global_rotation: float = node.rotation
	var local_rotation: float = node.local.rotation
	
	tween.tween_method(
		func(value: float) -> void:
			node.rotation = lerp_angle(global_rotation, (PI / 8) + degree * (PI / 4), value), 0.0, 1.0, time
	)
	
	tween.parallel().tween_method(
		func(value: float) -> void:
			node.local.rotation = lerp_angle(local_rotation, -1 * ((PI / 8) + degree * (PI / 4)), value), 0.0, 1.0, time
	)
	
	tween.parallel().tween_property(node.local, "position", Vector2(distance[ring], 0), time)
	
func rotate_ring(ring: int, ring_parent: Node, degree: int, time: float):
	var tween: Tween = get_tree().create_tween()
	for node in ring_parent.get_children():
		tween.parallel().tween_property(node, "rotation", node.rotation + (degree * (PI / 4)), time)
	
	for i in object_locations[ring].size():
		var node: Node2D = object_locations[ring][i]
		if node != null:# and $node.rotateable == true:
			GameState.position_node(node, node.ring, (degree + node.degree) % 8, time)
			#node.rotateable = false
	_rotate_nodes(ring, degree)
	
func _rotate_nodes(ring: int, degree: int):
	print("this is how much the nodes are getting rotated by: ", degree)
	for degrees in abs(degree):
		if degree > 0:
			var temp: Node = object_locations[ring][-1]
			for i in range(1, object_locations[0].size() - 1):
				object_locations[ring][-i] = object_locations[ring][-i - 1]
			object_locations[ring][0] = temp
		if degree < 0:
			var temp: Node = object_locations[ring][0]
			for i in range(0, object_locations[0].size() - 1):
				object_locations[ring][i] = object_locations[ring][i + 1]
			object_locations[ring][-1] = temp

func toggle_segment(ring: int, degree: int):
	var material: ShaderMaterial = segments[ring][degree].get_material()
	var is_enabled: bool = material.get_shader_parameter("enabled")
	material.set_shader_parameter("enabled", not is_enabled)
