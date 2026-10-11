extends Node2D
@export var attacks: Dictionary[String, Array] = {}

@export var health: int = 0

@export var ring: int

@export var degree: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func attack():
	for attack in attacks["attack"].size():
		pass
