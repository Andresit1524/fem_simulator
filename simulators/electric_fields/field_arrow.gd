extends Node2D

var force: Vector2

func _process(_delta):
	force = Algorithms.net_electric_force(self , position)