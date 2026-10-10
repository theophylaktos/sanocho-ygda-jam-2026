extends Node

var object_locations: Array[Array] = []

func _init() -> void:
	object_locations.resize(3)
	for array in object_locations:
		array.resize(8)

var angle: Array[float] = [22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]
var distance: Array[int] = [90, 180, 270]

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
