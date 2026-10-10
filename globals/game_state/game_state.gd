extends Node

var characterPositions: Array[Array] = []

var angle: Array[float] = [22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]
var distance: Array[int] = [0, 100, 200, 300]

func positionNode(global: Node2D, local: Node2D, degree: int, ring: int, time: float):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(global, "rotation_degrees", angle[degree], time)
	tween.parallel().tween_property(local, "rotation_degrees", -1 * angle[degree], time)
	local.position = Vector2(distance[ring], 0)
