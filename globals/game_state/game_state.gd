extends Node

var object_locations: Array[Array] = []

var distance: Array[int] = [25, 41, 57]

func _init() -> void:
	object_locations.resize(3)
	for array in object_locations:
		array.resize(8)

func addNode(node: Node2D, ring: int, degree: int):
	object_locations[ring][degree] = node
	node.rotation = (PI / 8) + degree * (PI / 4)
	node.local.rotation = -1 * ((PI / 8) + degree * (PI / 4))

func positionNode(node: Node2D, ring: int, degree: int, time: float):
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

func rotateRing(ring: int, ring_parent: Node, degree: int, time: float):
	var tween: Tween = get_tree().create_tween()
	for node in ring_parent.get_children():
		tween.parallel().tween_property(node, "rotation", node.rotation + (degree * (PI / 4)), time)
	
	print(object_locations[ring])
	for i in object_locations[ring].size():
		var node: Node2D = object_locations[ring][i]
		if node != null && node.rotateable == true:
			GameState.positionNode(node, node.ring, (degree + node.degree) % 8, time)
			print(degree, " ", node.degree)
			print(node.ring)
			node.rotateable = false
	rotateNodes(ring, degree)
	print(object_locations[ring])
	
func rotateNodes(ring: int, degree: int):
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
