extends Control

@export var icon_rotation_speed: float = 0.25

@onready var icon: TextureRect = $Icon

func _process(delta) -> void:
	_rotate_logo(delta)

## Hace girar el logo de la portada
func _rotate_logo(delta: float) -> void:
	icon.rotation -= icon_rotation_speed * TAU * delta
	if icon.rotation >= TAU: icon.rotation -= TAU

func _on_start_button_pressed() -> void:
	SceneManager.change_to_scene("simulator_selector")

func _on_credits_button_pressed() -> void:
	SceneManager.change_to_scene("credits")

func _on_quit_button_pressed() -> void:
	_set_quit_panel(true)

## Salir del juego
func _set_quit_panel(value: bool):
	$Quit.visible = value

func _on_yes_button_pressed() -> void:
	get_tree().quit()

func _on_no_button_pressed() -> void:
	_set_quit_panel(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_set_quit_panel(false if $Quit.visible else true)