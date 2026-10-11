extends Control
var shop: Array[String]
## array of strings that corrospond to upgrades
var items_had: Array[bool]
## array of valid items to sell in a shop: valid=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop[0]="Heal"
	shop[1]="Add Heart"
	shop[2]="Add Attack"
	shop[3]="More Damage"
	shop[4]="Add Movement"
	shop[5]="Diagonal"
	shop[6]="Spear"
	shop[7]="Bow"
	shop[8]="Knight"
	shop[9]="Four Diagonals"
	shop[10]="Four Horizontals"
	shop[11]="Horizontal"
	items_had[11]=true
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func pick_three_valid() -> Array[int]:
	var options: Array[int]
	var possibility: int
	var position: int
	for bool in items_had:
		if(bool==false):
			possibility+=1
		if(possibility<4):
			print("Out of stock!")
			return options
	var current: int
	while position<3:
		current = randi_range(0,11)
		if(items_had[current]==false and (current!=0 or GameState.health_left!=GameState.max_health)):
				options[position]=current
				position+=1
	return options
