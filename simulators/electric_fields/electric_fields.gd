extends Node2D

@export var refresh_fps_time: float = 0.1

@onready var fps_label := $CanvasLayer/Control/FPS

var elapsed_time: float = 0

func _process(delta: float) -> void:
	elapsed_time += delta

	if elapsed_time >= refresh_fps_time:
		fps_label.text = "FPS: %d" % round(1 / delta)
		elapsed_time = 0
