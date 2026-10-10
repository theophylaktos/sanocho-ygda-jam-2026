extends Node2D

@export var ring_zero: Node
@export var ring_one: Node
@export var ring_two: Node

func _ready() -> void:
	pass
	var ring_count = 0
	for ring in $Rings.get_children():
		var node_count = 0
		for node in ring.get_children():
			GameState.segments[ring_count][node_count] = node
			node_count += 1
		ring_count += 1
