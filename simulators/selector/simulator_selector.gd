extends Control

const HOVER_COLOR := Color.BLUE_VIOLET

func _ready():
	# Conecta el mouse a los botones
	for button in get_tree().get_nodes_in_group("simulators_buttons"):
		button.mouse_entered.connect(hover_button.bind(button, true))
		button.mouse_exited.connect(hover_button.bind(button, false))

## Hace semitransparente a los botones cuando se mueve el mouse por encima de ellos
func hover_button(button: BaseButton, hover: bool):
	# Abrillanta cuando se le pasa el mouse, oscurece cuando no
	button.modulate *= 2.0 if hover else 0.5

func go_to_simulator(scene: String):
	SceneManager.change_to_scene(scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"): SceneManager.change_to_scene("start_menu")