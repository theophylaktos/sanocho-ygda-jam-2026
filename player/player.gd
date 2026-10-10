extends Node2D

@export var ring: int = 1

@export var degree: int = 2

#@export var rotateable: bool = false

@export var local: Node2D

@export var selected_ring = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.addNode(self, ring, degree)
	GameState.toggle_select_ring(selected_ring)
	#GameState.positionNode(self, $Local, 1, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout
	#GameState.positionNode(self, $Local, 5, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("location"):
		print(GameState.object_locations)
		
	if Input.is_action_just_pressed("ring_left"):
		match selected_ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, -1, 1)
			1:
				GameState.rotate_ring(1, %Level.ring_one, -1, 1)
			2:
				GameState.rotate_ring(2, %Level.ring_two, -1, 1)
		print("degree: ", degree)
		
	if Input.is_action_just_pressed("ring_right"):
		match selected_ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, 1, 1)
			1:
				GameState.rotate_ring(1, %Level.ring_one, 1, 1)
			2:
				GameState.rotate_ring(2, %Level.ring_two, 1, 1)
		print("degree: ", degree)
		
	if Input.is_action_just_pressed("ring_up"):
		if selected_ring > 0:
			GameState.toggle_select_ring(selected_ring)
			GameState.toggle_select_ring(selected_ring - 1)
			selected_ring -= 1
			
	if Input.is_action_just_pressed("ring_down"):
		if selected_ring < 2:
			GameState.toggle_select_ring(selected_ring)
			GameState.toggle_select_ring(selected_ring + 1)
			selected_ring += 1
		
	if Input.is_action_just_pressed("move_out"):
		if ring > 0:
			GameState.update_position(ring, degree, ring - 1, degree, self)
			GameState.position_node(self, ring - 1, degree, 1)
			print("ring: ", ring)
			
	if Input.is_action_just_pressed("move_in"):
		if ring < 2:
			GameState.update_position(ring, degree, ring + 1, degree, self)
			GameState.position_node(self, ring + 1, degree, 1)
			print("ring: ", ring)
