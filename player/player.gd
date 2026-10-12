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

var selected_direction: String = "W"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.player = self
	RoundManager.move_phase_started.connect(_move_phase_started)
	RoundManager.attack_phase_started.connect(_attack_phase_started)
	RoundManager.enemy_attack_phase_started.connect(_enemy_attack_phase_started)
	RoundManager.round_completed.connect(_round_completed)
	
	GameState.selected_attack_changed.connect(_selected_attack_changed)

func _process(_delta: float) -> void:
	
	var direction: String = ""
	
	if degree == 0 or degree == 7:
			direction = "Right"
	if degree == 1 or degree == 2:
		direction = "Down"
	if degree == 3 or degree == 4:
		direction = "Left"
	if degree == 5 or degree == 6:
		direction = "Up"
	
	if Input.is_action_just_pressed("location"):
		print(GameState.object_locations)
		print(GameState.attacks)
	
	if GameState.rotating == true:
		return
	
	if Input.is_action_just_pressed("left"):
		selected_direction = "A"
		
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
		
		if RoundManager.current_phase == "Move":
			if GameState.moves_left <= 0:
				return
			
			if direction == "Right":
				_move_in()
			if direction == "Down":
				_rotate_ring(1)
			if direction == "Left":
				_move_out()
			if direction == "Up":
				_rotate_ring(-1)
		
	if Input.is_action_just_pressed("right"):
		selected_direction = "D"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
			
		if RoundManager.current_phase == "Move":
			if GameState.moves_left <= 0:
				return
			
			if direction == "Right":
				_move_out()
			if direction == "Down":
				_rotate_ring(-1)
			if direction == "Left":
				_move_in()
			if direction == "Up":
				_rotate_ring(1)
		
	if Input.is_action_just_pressed("up"):
		selected_direction = "W"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
			
		if RoundManager.current_phase == "Move":
			if GameState.moves_left <= 0:
				return
			
			if direction == "Right":
				_rotate_ring(-1)
			if direction == "Down":
				_move_in()
			if direction == "Left":
				_rotate_ring(1)
			if direction == "Up":
				_move_out()
	
	if Input.is_action_just_pressed("down"):
		selected_direction = "S"
		if RoundManager.current_phase == "PlayerAttack":
			toggle()
			
		if RoundManager.current_phase == "Move":
			if GameState.moves_left <= 0:
				return
			
			if direction == "Right":
				_rotate_ring(1)
			if direction == "Down":
				_move_out()
			if direction == "Left":
				_rotate_ring(-1)
			if direction == "Up":
				_move_in()
	
func _move_phase_started():
	%AnimatedSprite2D.play("move_phase_start_front")
	await %AnimatedSprite2D.animation_finished
	%AnimatedSprite2D.play("move_phase_idle_front")
	
func _enemy_attack_phase_started():
	%AnimatedSprite2D.play("idle_front")

func _attack_phase_started():
	%AnimatedSprite2D.play("idle_front")
	
func _round_completed():
	%AnimatedSprite2D.play("idle_front")

func _rotate_ring(amount: int):
	GameState.moves_left -= 1
	match ring:
		0:
			GameState.rotate_ring(0, %Level.ring_zero, amount, SPEED)
		1:
			GameState.rotate_ring(1, %Level.ring_one, amount, SPEED)
		2:
			GameState.rotate_ring(2, %Level.ring_two, amount, SPEED)
	
func toggle():
	GameState.clear_all_player_attack_segments()
	
	for i in AttackPatterns.attack_patterns[GameState.selected_attack].size():
		var x = AttackPatterns.attack_patterns[GameState.selected_attack][i].x
		var y = AttackPatterns.attack_patterns[GameState.selected_attack][i].y
		
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
				
		if segment.x >= 0 and segment.x <= 2:
			if segment.y < 0:
				segment.y = 8 + segment.y
			segment.y = segment.y % 8
			GameState.toggle_player_attack_segment(segment.x, segment.y)

func _move_in():
	if ring >= 2:
		return
	if GameState.object_locations[ring + 1][degree] != null:
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
		
	GameState.moves_left -= 1
	GameState.clear_select_ring(ring)
	GameState.toggle_select_ring(ring - 1)
	GameState.update_position(ring, degree, ring - 1, degree, self)
	GameState.position_node(self, ring - 1, degree, SPEED)

func take_damage(damage: int):
	GameState.health_left -= damage
	
func _selected_attack_changed():
	if RoundManager.current_phase == "PlayerAttack":
		toggle()
