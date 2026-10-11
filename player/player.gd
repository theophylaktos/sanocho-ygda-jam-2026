extends Node2D

@export var ring: int = 1

@export var degree: int = 2

@export var local: Node2D

const SPEED = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.addNode(self, ring, degree)
	GameState.toggle_select_ring(ring)
	#GameState.positionNode(self, $Local, 1, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout
	#GameState.positionNode(self, $Local, 5, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("location"):
		print(GameState.object_locations)
		
	if GameState.rotating == true:
		return
	
	if Input.is_action_just_pressed("ring_left"):
		match ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, -1, SPEED)
			1:
				GameState.rotate_ring(1, %Level.ring_one, -1, SPEED)
			2:
				GameState.rotate_ring(2, %Level.ring_two, -1, SPEED)
		print("degree: ", degree)
		
	if Input.is_action_just_pressed("ring_right"):
		match ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, 1, SPEED)
			1:
				GameState.rotate_ring(1, %Level.ring_one, 1, SPEED)
			2:
				GameState.rotate_ring(2, %Level.ring_two, 1, SPEED)
		print("degree: ", degree)
		
	#if Input.is_action_just_pressed("ring_up"):
		#if selected_ring > 0:
			#GameState.toggle_select_ring(selected_ring)
			#GameState.toggle_select_ring(selected_ring - 1)
			#selected_ring -= 1
			#
	#if Input.is_action_just_pressed("ring_down"):
		#if selected_ring < 2:
			#GameState.toggle_select_ring(selected_ring)
			#GameState.toggle_select_ring(selected_ring + 1)
			#selected_ring += 1
		
	if Input.is_action_just_pressed("move_up"):
		if sign(degree) == 1:
			if abs(degree) % 8 < 4:
				_move_in()
			else:
				_move_out()
		else:
			if abs(degree) % 8 > 4:
				_move_in()
			else:
				_move_out()
	
	if Input.is_action_just_pressed("move_down"):
		if sign(degree) == 1:
			if abs(degree) % 8 < 4:
				_move_out()
			else:
				_move_in()
		else:
			if abs(degree) % 8 > 4:
				_move_out()
			else:
				_move_in()
			
	if Input.is_action_just_pressed("toggle"):
		for i in AttackPatterns.attack_patterns["attack"].size():
			var segment: Vector2 = AttackPatterns.attack_patterns["attack"][i] + Vector2i(ring, degree)
			if segment.x >= 0 and segment.x <= 2:
				if sign(segment.y) == 1 or sign(segment.y) == 0:
					GameState.toggle_attack_segment(int(segment.x), int(segment.y) % 8)
				else:
					GameState.toggle_attack_segment(int(segment.x), 8 - (int(abs(segment.y)) % 8))

func _move_in():
	if ring < 2:
		GameState.clear_select_ring(ring)
		GameState.toggle_select_ring(ring + 1)
		GameState.update_position(ring, degree, ring + 1, degree, self)
		GameState.position_node(self, ring + 1, degree, SPEED)
		print("ring: ", ring)
		
func _move_out():
	if ring > 0:
		GameState.clear_select_ring(ring)
		GameState.toggle_select_ring(ring - 1)
		GameState.update_position(ring, degree, ring - 1, degree, self)
		GameState.position_node(self, ring - 1, degree, SPEED)
		print("ring: ", ring)
