extends Node2D

const REFRESH_FPS_TIME: float = 0.1

@export var arrow_scene: PackedScene
@export var x_step: float = 20.0
@export var y_step: float = 20.0

@onready var fps_label := $UILayer/UI/FPSLabel
@onready var field_node := $Field

var viewport: Viewport
var elapsed_time: float = 0.0
var last_camera_transform: Transform2D
var boundaries: Dictionary[String, Vector2] = {
	"top_left": Vector2.ZERO,
	"bottom_right": Vector2.ZERO,
}

func _ready():
	viewport = get_viewport()
	last_camera_transform = viewport.get_canvas_transform()
	_reinstantiate_field()

func _process(delta: float) -> void:
	# Verifica el movimiento del viewport y re-renderiza el campo
	var current_transform := viewport.get_canvas_transform()
	if current_transform != last_camera_transform:
		last_camera_transform = current_transform
		_reinstantiate_field()

	_refresh_fps(delta)

## Determina la posición del viewport en el mundo
func get_global_viewport_corners() -> void:
	var rect_visible = viewport.get_visible_rect()

	# Obtenemos la transformación inversa (Pantalla -> Mundo)
	var transform_inversa = viewport.get_canvas_transform().affine_inverse()

	# Calculamos las 4 esquinas multiplicando la transformación por los puntos
	boundaries.top_left = transform_inversa * rect_visible.position
	boundaries.bottom_right = transform_inversa * (rect_visible.position + rect_visible.size)

## Instancia las flechas del campo eléctrico a lo largo de una cuadrícula
func instantiate_field() -> void:
	var arrow_coordinates: Array[Vector2]
	var current_point := boundaries.top_left

	# Recorre todo el espacio de la camara
	while true:
		arrow_coordinates.append(current_point)

		current_point.x += x_step

		if current_point.x > boundaries.bottom_right.x:
			current_point.x = boundaries.top_left.x
			current_point.y += y_step

		if current_point.y > boundaries.bottom_right.y:
			break

	for point in arrow_coordinates:
		var arrow = arrow_scene.instantiate()
		arrow.position = point
		field_node.add_child(arrow)

## Refresca el campo eléctrico si se mueve la cámara
func _reinstantiate_field():
	print_debug("Refreshed field")
	for arrow in field_node.get_children():
		arrow.queue_free()

	get_global_viewport_corners()
	instantiate_field()

func _refresh_fps(delta: float):
	elapsed_time += delta

	if elapsed_time >= REFRESH_FPS_TIME:
		fps_label.text = "FPS: %d" % round(1 / delta)
		elapsed_time = 0
