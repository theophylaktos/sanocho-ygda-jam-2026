extends Node

var object_locations: Array[Array] = []

var distance: Array[int] = [25, 41, 57]

func _init() -> void:
	object_locations.resize(3)
	for array in object_locations:
		array.resize(8)

func positionNode(global: Node2D, local: Node2D, degree: int, ring: int, time: float):
	object_locations[ring][degree] = global
	object_locations[global.location.x][global.location.y] = null
	global.location = Vector2(ring, degree)
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var global_rotation: float = global.rotation
	var local_rotation: float = local.rotation
	
	tween.tween_method(
		func(value: float) -> void:
			global.rotation = lerp_angle(global_rotation, (PI / 8) + degree * (PI / 4), value), 0.0, 1.0, time
	)
	
	tween.parallel().tween_method(
		func(value: float) -> void:
			local.rotation = lerp_angle(local_rotation, -1 * ((PI / 8) + degree * (PI / 4)), value), 0.0, 1.0, time
	)
	
	tween.parallel().tween_property(local, "position", Vector2(distance[ring], 0), time)

func rotateRing(ring: int, ring_parent: Node, degree: int, time: float):
	var tween: Tween = get_tree().create_tween()
	for node in ring_parent.get_children():
		tween.parallel().tween_property(node, "rotation", node.rotation + (degree * (PI / 4)), time)
	
	print(object_locations[ring])
	for i in object_locations[ring].size():
		var node: Node2D = object_locations[ring][i]
		print(node)
		if node != null:
			GameState.positionNode(node, node.local, degree + node.location.x, node.location.y, time)
	
	for i in abs(degree):
		rotateOnce(ring, degree)
		
func rotateOnce(ring: int, degree: int):
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
