extends Control
var shop: Array[String]
## array of strings that corrospond to upgrades
var items_had: Array[bool]
var next_attack: int=0

var textures: Dictionary = {
	"Heal": preload("uid://o37gts8apes7"),
	"Add Heart": null,
	"Add Attack": null,
	"More Damage": null,
	"Add Movement": null,
	"diagonal": preload("uid://bwn8ypto7o7jl"),
	"attack2": "",
	"attack4": preload("uid://ddlottmvshgpf"),
	"knight": null,
	"all_diagonals": null,
	"all_horizontals": null,
	"attack": preload("uid://d30hood7b3jia"),
}

## array of valid items to sell in a shop: valid=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.resize(12)
	items_had.resize(12)
	shop[0]="Heal"
	shop[1]="Add Heart"
	shop[2]="Add Attack"
	shop[3]="More Damage"
	shop[4]="Add Movement"
	shop[5]="diagonal"
	shop[6]="attack2"
	shop[7]="attack4"
	shop[8]="knight"
	shop[9]="all_diagonals"
	shop[10]="all_horizontals"
	shop[11]="attack"
	items_had[11]=true
	pass
	
	if GameState.attacks[0] != "":
		%FirstSlot.texture = textures[GameState.attacks[0]]
	if GameState.attacks[1] != "":
		%FirstSlot.texture = textures[GameState.attacks[1]]
	if GameState.attacks[2] != "":
		%FirstSlot.texture = textures[GameState.attacks[2]]
	var options: Array[int] = [0,1,2]
	print(options)
	if textures[shop[options[0]]] != null:
		%FirstOption.texture_normal = textures[shop[options[0]]]
	if textures[shop[options[1]]] != null:
		%FirstOption.texture_normal = textures[shop[options[1]]]
	if textures[shop[options[2]]] != null:
		%FirstOption.texture_normal = textures[shop[options[2]]]

func pick_three_valid() -> Array[int]:
	var options: Array[int]
	var possibility: int
	var position: int
	if(GameState.health_left<GameState.max_health):
		options[0]=0
		possibility+=1
		position+=1
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

func give_item(choice: int):
	var is_removed: bool
	if(choice==0):
		is_removed=false
	elif(choice==1 && GameState.max_health<=7):
		is_removed=false
	elif(choice==2 && GameState.max_attacks<=3):
		is_removed=false
	elif(choice==4 && GameState.max_moves<=5):
		is_removed=false
	else:
		is_removed=true
	if(is_removed):
		items_had[choice]=true
	if(choice>=5):
		if(GameState.attacks[next_attack]!=""):
			for attack in shop.size():
				if(shop[attack]==GameState.attacks[next_attack]):
					items_had[attack]=false
		next_attack=(next_attack+1)%3 ##picks next slot, replaces last weapon
		
	match choice:
		0:
			GameState.health_left+=2
			if(GameState.health_left>GameState.max_health):
				GameState.health_left=GameState.max_health
		1:
			GameState.max_health+=1
		2:
			GameState.max_attacks+=1
		3:
			GameState.damage*=2
		4:
			GameState.max_moves+=1
		5:
			GameState.attack[next_attack]=shop[choice]
		6:
			GameState.attack[next_attack]=shop[choice]
		7:
			GameState.attack[next_attack]=shop[choice]
		8:
			GameState.attack[next_attack]=shop[choice]
		9:
			GameState.attack[next_attack]=shop[choice]
		10:
			GameState.attack[next_attack]=shop[choice]
		11:
			GameState.attack[next_attack]=shop[choice]


func _on_texture_button_pressed() -> void:
	RoundManager.change_scene_to_main()
