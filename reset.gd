extends Node

func reset():
	GameState.object_locations = []
	GameState.segments = []
	GameState.rotating = false
	GameState.player = null
	GameState.enemies_folder = null
	GameState.settings_open = false
	GameState.attacks = ["attack","attack2",""]
	GameState.selected_attack = "attack"
	GameState.damage = 1
	GameState.max_health = 5
	GameState.health_left = 5
	GameState.max_moves = 3
	GameState.moves_left = 3
	GameState.max_attacks = 1
	GameState.attacks_left = 1
	RoundManager.current_round = 0
	RoundManager.current_phase = ""
