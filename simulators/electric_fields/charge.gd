extends CharacterBody2D

enum Signs {
	POSITIVE = 1,
	NEGATIVE = -1
}

@export_group("Particle")
@export var charge_sign: Signs = Signs.NEGATIVE ## Signo de la carga
@export var value: int = 1 ## Intensidad de la carga

@export_group("Behaviour")
@export var movable: bool = false ## Permite el objeto moverse
@export var attract_by_mouse: bool = false ## Las cargas se ven atraidas por el mouse
@export var apply_friction: bool = false ## Aplica fricción al desplazamiento

@export_group("Show")
@export var show_value: bool = true: ## Muestra el valor de la carga arriba de él
	set(value):
		show_value = value
		if value_label: value_label.visible = value
@export var show_force: bool = true: ## Muestra la fuerza neta de la carga como un segmento
	set(value):
		show_force = value
		if vector_display: vector_display.show_vectors = value
@export var show_axes: bool = false: ## Muestra los componentes en X y Y de la fuerza
	set(value):
		show_axes = value
		if vector_display: vector_display.show_axes = value

@onready var value_label := $Value
@onready var vector_display := $VectorDisplay2D

var force: Vector2
var is_dragging := false
var offset: Vector2

func _ready() -> void:
	if show_value:
		value_label.text = str(value)
	else:
		value_label.visible = false

	vector_display.show_vectors = show_force
	vector_display.show_axes = show_axes

	# Configura la carga y el color
	value *= charge_sign
	$Sprite.modulate = Color.RED if charge_sign == Signs.POSITIVE else Color.BLUE

func _process(delta: float) -> void:
	force = Algorithms.net_electric_force(self , position, value)

	if is_dragging:
		global_position = get_global_mouse_position() + offset
		return

	if attract_by_mouse:
		var direction := (get_global_mouse_position() - global_position).normalized()
		force += direction * 100 # Fuerza de atracción arbitraria

	if not movable: return

	velocity += force * delta
	if apply_friction: velocity *= Constants.FRICTION
	move_and_slide()

# Activa el arrastre con el mouse para el objeto actual
func _on_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	var is_drag_event: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	)

	if not is_drag_event: return

	is_dragging = true
	offset = global_position - get_global_mouse_position()
	modulate.a = 0.5

# Desactiva el arrastre de forma global para evitar bugs
func _input(event: InputEvent) -> void:
	var is_drop_event: bool = (
		is_dragging
		and event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and not event.pressed
	)

	if not is_drop_event: return

	is_dragging = false
	modulate.a = 1.0