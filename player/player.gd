extends Node2D

@export var ring: int = 1

@export var degree: int = 2

#@export var rotateable: bool = false

@export var local: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.addNode(self, ring, degree)
	#GameState.positionNode(self, $Local, 1, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout
	#GameState.positionNode(self, $Local, 5, 2, 2)
	#print(GameState.object_locations)
	#await get_tree().create_timer(3).timeout

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("location"):
		print(GameState.object_locations)
		
	if Input.is_action_just_pressed("rotate_left"):
		GameState.rotate_ring(0, %Level.ring_zero, -1, 1)
		print("degree: ", degree)
		
	if Input.is_action_just_pressed("rotate_right"):
		GameState.rotate_ring(0, %Level.ring_zero, 1, 1)
		print("degree: ", degree)
		
	if Input.is_action_just_pressed("move_out"):
		if ring > 0:
			GameState.update_position(ring, degree, ring - 1, degree, self)
			GameState.position_node(self, ring - 1, degree, 1)
			print("ring: ", ring)
			
	if Input.is_action_just_pressed("move_in"):
		if ring < 2:
			GameState.update_position(ring, degree, ring - 1, degree, self)
			GameState.position_node(self, ring - 1, degree, 1)
			print("ring: ", ring)
