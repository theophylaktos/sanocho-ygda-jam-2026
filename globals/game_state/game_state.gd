extends Node

var object_positions: Array[Array] = []

var angle: Array[float] = [22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]
var distance: Array[int] = [0, 90, 180, 270]

func positionNode(global: Node2D, local: Node2D, degree: int, ring: int, time: float):
	object_positions[degree][ring] = global
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
