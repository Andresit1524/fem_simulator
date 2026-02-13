extends CharacterBody2D

enum Signs {
	POSITIVE = 1,
	NEGATIVE = -1
}

@export_group("Particle")
@export var charge_sign: Signs = Signs.NEGATIVE ## Signo de la carga
@export var value: int = 1 ## Intensidad de la carga

@export_group("Behaviour")
@export var unmovable: bool = false ## Fija el objeto en el mundo
@export var point_to_mouse: bool = false ## Apunta las cargas al mouse
@export var apply_friction: bool = false ## Aplica fricción al desplazamiento

var force: Vector2

func _ready():
	$Value.text = str(value)

	# Configura la carga y el color
	value *= charge_sign
	$Sprite.modulate = Color.RED if charge_sign == Signs.POSITIVE else Color.BLUE

func _physics_process(delta: float) -> void:
	if unmovable: return

	force = Algorithms.net_electric_force(self , position, value)

	if point_to_mouse:
		var direction := (get_global_mouse_position() - global_position).normalized()
		force += direction * 1000 # Fuerza de atracción arbitraria

	velocity += force * delta
	if apply_friction: velocity *= Constants.FRICTION
	move_and_slide()
