extends Node2D

func _ready() -> void:
	await get_tree().create_timer(7).timeout
	#for i in range(0,3):
		#for j in range(0,8):
			#GameState.toggle_segment(i,j)
			#await get_tree().create_timer(0.5).timeout
			#GameState.toggle_segment(i,j)
	#GameState.rotate_ring(1, $Level.ring_one, 2, 2)
