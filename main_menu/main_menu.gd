extends Control

func _on_play_button_pressed() -> void:
	RoundManager.change_scene_to_main()

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_PRESS)


func _on_button_mouse_entered() -> void:
	SFX.play(SFX.Id.BUTTON_HOVER)
