class_name Arrow extends Node2D


## Las cargas se ven atraidas por el mouse
@export var point_to_mouse: bool = false


@onready var vd2d: VectorDisplay2D = $VectorDisplay2D


var force: Vector2


func _process(_delta):
	force = Algorithms.net_electric_force(self, position)

	if not point_to_mouse: return

	var direction := (get_global_mouse_position() - global_position).normalized()
	force += direction * 100 # Fuerza de atracción arbitraria
