extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		SceneManager.change_to_scene("start_menu")