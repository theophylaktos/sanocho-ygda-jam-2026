extends Control

func _ready() -> void:
	if GameState.first_time:
		GameState.first_time = false
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.visible = false
	else:
		$AnimatedSprite2D.visible = false

func _on_play_button_pressed() -> void:
	$Settings.visible = false
	RoundManager.change_scene_to_main()

func _on_settings_button_pressed() -> void:
	$Settings.visible = true


func _on_button_pressed() -> void:
	SFX.play(SFX.Id.BUTTON_PRESS)


func _on_button_mouse_entered() -> void:
	SFX.play(SFX.Id.BUTTON_HOVER)
