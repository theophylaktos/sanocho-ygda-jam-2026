extends Node2D

class_name Player

@export var ring: int = 1

@export var degree: int = 2:
	set(new_value):
		if new_value < 0:
			new_value = 8 + new_value
		degree = new_value % 8

@export var local: Node2D

const SPEED = 0.5

var selected_direction: String = "W":
	set(new_value):
		selected_direction = new_value
		print("selected direction: ", new_value)

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
		selected_direction = "A"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
		
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
		selected_direction = "D"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
		
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
		selected_direction = "W"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
		
		if abs(degree) % 8 < 4:
			_move_in()
		else:
			_move_out()

	
	if Input.is_action_just_pressed("move_down"):
		selected_direction = "S"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
		
		if abs(degree) % 8 < 4:
			_move_out()
		else:
			_move_in()

			
	if Input.is_action_just_pressed("toggle"):
		toggle()
		
func toggle():
	GameState.clear_all_attack_segments()
	
	for i in AttackPatterns.attack_patterns["attack"].size():
		var x = AttackPatterns.attack_patterns["attack"][i].x
		var y = AttackPatterns.attack_patterns["attack"][i].y
		print("Base direction of segment to be changed: ", x, " ", y)
		print("Coordinates of player: ", Vector2i(ring, degree))
		print("Current selected direction: ", selected_direction)
		
		var faces: Dictionary[String, Vector2] = {
			"Forward": Vector2i(ring, degree) + Vector2i(x, y),
			"Backward": Vector2i(ring, degree) + Vector2i(-x, -y),
			"Leftward": Vector2i(ring, degree) + Vector2i(y, x),
			"Rightward": Vector2i(ring, degree) + Vector2i(-y, -x),
		}
		
		var segment: Vector2i = Vector2i(0,0)
		var direction = ""
		
		if degree == 0 or degree == 7:
			direction = "Right"
		if degree == 1 or degree == 2:
			direction = "Down"
		if degree == 3 or degree == 4:
			direction = "Left"
		if degree == 5 or degree == 6:
			direction = "Up"
		
		if selected_direction == "W":
			if direction == "Right":
				segment = faces["Rightward"]
			if direction == "Down":
				segment = faces["Forward"]
			if direction == "Left":
				segment = faces["Leftward"]
			if direction == "Up":
				segment = faces["Backward"]
		
		if selected_direction == "S":
			if direction == "Right":
				segment = faces["Leftward"]
			if direction == "Down":
				segment = faces["Backward"]
			if direction == "Left":
				segment = faces["Rightward"]
			if direction == "Up":
				segment = faces["Forward"]
				
		if selected_direction == "A":
			if direction == "Right":
				segment = faces["Forward"]
			if direction == "Down":
				segment = faces["Leftward"]
			if direction == "Left":
				segment = faces["Backward"]
			if direction == "Up":
				segment = faces["Rightward"]
				
		if selected_direction == "D":
			if direction == "Right":
				segment = faces["Backward"]
			if direction == "Down":
				segment = faces["Rightward"]
			if direction == "Left":
				segment = faces["Forward"]
			if direction == "Up":
				segment = faces["Leftward"]
				
		print("Coordinates of the segment to attempt to change: ", segment)
		
		if segment.x >= 0 and segment.x <= 2:
			if segment.y < 0:
				segment.y = 8 + segment.y
			segment.y = segment.y % 8
			GameState.toggle_attack_segment(segment.x, segment.y)

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
