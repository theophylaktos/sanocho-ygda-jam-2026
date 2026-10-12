extends Control
var shop: Array[String]
## array of strings that corrospond to upgrades
var items_had: Array[bool]
var replaced: int=2
var choice: int=0
var choices: Array[int]
var textures: Dictionary = {
	"Heal 2": preload("uid://c822q0w7pcwgj"),
	"Add Heart": preload("uid://bhut60woybcnx"),
	"Add Attack": preload("uid://c822q0w7pcwgj"),
	"More Damage": preload("uid://b04xm6fdq5o5l"),
	"Add Movement": preload("uid://bga5uw67eyhr1"),
	"diagonal": preload("uid://d30hood7b3jia"),
	"attack2": preload("uid://bwn8ypto7o7jl"),
	"attack4": preload("uid://ddlottmvshgpf"),
	"knight": preload("uid://c2hshq4wc3crf"),
	"all_diagonals": preload("uid://cskr21f181ur"),
	"all_horizontals": preload("uid://cop404wtgqx3h"),
	"attack": preload("uid://b7ptnpwn3k0ni"),
}

## array of valid items to sell in a shop: valid=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.resize(12)
	items_had.resize(12)
	shop[0]="Heal 2"
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
	
	choices = pick_three_valid()
	
	if GameState.attacks[0] != "":
		%FirstSlot.texture_normal = textures[GameState.attacks[0]]
	else:
		%FirstSlot.texture_normal = null
	if GameState.attacks[1] != "":
		%SecondSlot.texture_normal = textures[GameState.attacks[1]]
	else:
		%SecondSlot.texture_normal = null
	if GameState.attacks[2] != "":
		%ThirdSlot.texture_normal = textures[GameState.attacks[2]]
	else:
		%ThirdSlot.texture_normal = null
	var options: Array[int] = [0,1,2]
	print(options)
	if textures[shop[options[0]]] != null:
		%FirstOption.texture_normal = textures[shop[choices[0]]]
	if textures[shop[options[1]]] != null:
		%SecondOption.texture_normal = textures[shop[choices[1]]]
	if textures[shop[options[2]]] != null:
		%ThirdOption.texture_normal = textures[shop[choices[2]]]

func pick_three_valid() -> Array[int]:
	var options: Array[int]
	options.resize(3)
	var possibility: int=0
	var position: int = 0
	var already_sold: Array[bool]
	already_sold.resize(12)
	if(GameState.health_left<GameState.max_health):
		options[0]=0
		possibility+=1
		position+=1
	for value in items_had:
		if(value==false):
			possibility+=1
	if(possibility<4):
		print("Out of stock!")
		return options
	var current: int
	while position<3:
		current = randi_range(0,11)
		if(items_had[current]==false and (current!=0 or GameState.health_left!=GameState.max_health) and already_sold[current]==false):
				options[position]=current
				position+=1
				already_sold[current]=true
	return options

func give_item():
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
		if(GameState.attacks[replaced]!=""):
			for attack in shop.size():
				if(shop[attack]==GameState.attacks[replaced]):
					items_had[attack]=false
					
	match choices[choice]:
		0:
			GameState.health_left+=2
			if(GameState.health_left>GameState.max_health):
				GameState.health_left=GameState.max_health
		1:
			GameState.max_health+=1
		2:
			GameState.max_attacks += 1
		3:
			GameState.damage*=2
		4:
			GameState.max_moves+=1
		5:
			GameState.attacks[replaced] = shop[choices[choice]]
		6:
			GameState.attacks[replaced] = shop[choices[choice]]
		7:
			GameState.attacks[replaced] = shop[choices[choice]]
		8:
			GameState.attacks[replaced] = shop[choices[choice]]
		9:
			GameState.attacks[replaced] = shop[choices[choice]]
		10:
			GameState.attacks[replaced] = shop[choices[choice]]
		11:
			print("hi")
			GameState.attacks[replaced] = shop[choices[choice]]


func _on_texture_button_pressed() -> void:
	give_item()
	RoundManager.change_scene_to_main()


func _on_first_slot_pressed() -> void:
	replaced=0

func _on_second_slot_pressed() -> void:
	replaced=1

func _on_third_slot_pressed() -> void:
	replaced=2


func _on_first_option_pressed() -> void:
	choice = 0
	%FirstOption.material.set_shader_parameter("is_outlined", true)
	%SecondOption.material.set_shader_parameter("is_outlined", false)
	%ThirdOption.material.set_shader_parameter("is_outlined", false)


func _on_second_option_pressed() -> void:
	choice=1
	%FirstOption.material.set_shader_parameter("is_outlined", false)
	%SecondOption.material.set_shader_parameter("is_outlined", true)
	%ThirdOption.material.set_shader_parameter("is_outlined", false)

func _on_third_option_pressed() -> void:
	choice=2
	%FirstOption.material.set_shader_parameter("is_outlined", false)
	%SecondOption.material.set_shader_parameter("is_outlined", false)
	%ThirdOption.material.set_shader_parameter("is_outlined", true)
