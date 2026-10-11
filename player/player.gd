extends Node2D

@export var ring: int = 1

@export var degree: int = 2

@export var local: Node2D

const SPEED = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.player = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		RoundManager.start_round()
	
	if Input.is_action_just_pressed("location"):
		print(GameState.object_locations)
	
	if GameState.rotating == true:
		return
	
	if Input.is_action_just_pressed("ring_left"):
		if GameState.moves_left <= 0:
			return
	
		GameState.moves_left -= 1
		match ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, -1, SPEED)
			1:
				GameState.rotate_ring(1, %Level.ring_one, -1, SPEED)
			2:
				GameState.rotate_ring(2, %Level.ring_two, -1, SPEED)
		
	if Input.is_action_just_pressed("ring_right"):
		if GameState.moves_left <= 0:
			return
	
		GameState.moves_left -= 1
		match ring:
			0:
				GameState.rotate_ring(0, %Level.ring_zero, 1, SPEED)
			1:
				GameState.rotate_ring(1, %Level.ring_one, 1, SPEED)
			2:
				GameState.rotate_ring(2, %Level.ring_two, 1, SPEED)
		
	if Input.is_action_just_pressed("move_up"):
		if sign(degree) == 1 or sign(degree) == 0:
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
		if sign(degree) == 1 or sign(degree) == 0:
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
	if ring >= 2:
		return
	if GameState.object_locations[ring + 1][degree] != null:
		return
	if GameState.moves_left <= 0:
		return
	
	GameState.moves_left -= 1
	GameState.clear_select_ring(ring)
	GameState.toggle_select_ring(ring + 1)
	GameState.update_position(ring, degree, ring + 1, degree, self)
	GameState.position_node(self, ring + 1, degree, SPEED)
		
func _move_out():
	if ring <= 0:
		return
	if GameState.object_locations[ring - 1][degree] != null:
		return
	if GameState.moves_left <= 0:
		return
	
	GameState.moves_left -= 1
	GameState.clear_select_ring(ring)
	GameState.toggle_select_ring(ring - 1)
	GameState.update_position(ring, degree, ring - 1, degree, self)
	GameState.position_node(self, ring - 1, degree, SPEED)
