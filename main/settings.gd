extends Control

func _ready():
	visible = false
	
	$MasterHSlider.value = GameState.master_volume
	$MusicHSlider.value = GameState.music_volume
	$SFXHSlider.value = GameState.sfx_volume
	
	change_bus_volume("Master", GameState.master_volume)
	change_bus_volume("Music", GameState.music_volume)
	change_bus_volume("SFX", GameState.sfx_volume)
	
func _on_master_h_slider_value_changed(value):
	change_bus_volume("Master", value)

func _on_music_h_slider_value_changed(value):
	change_bus_volume("Music", value)

func _on_sfx_h_slider_value_changed(value):
	change_bus_volume("SFX", value)

func change_bus_volume(bus, linear_value):
	if bus == "Master":
		GameState.master_volume = linear_value
	if bus == "Music":
		GameState.music_volume = linear_value
	if bus == "SFX":
		GameState.sfx_volume = linear_value
	if bus == "Ambience":
		GameState.ambience_volume = linear_value
	
	var db_value = linear_to_db(linear_value)
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db_value)


func _on_return_pressed() -> void:
	visible = false
	GameState.settings_open = true


func _on_exit_pressed() -> void:
	RoundManager.change_scene_to_menu()
