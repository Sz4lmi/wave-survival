extends Node2D

var speed = -0.05

func _physics_process(delta: float) -> void:
	$".".rotate(speed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit()

func addspeed(scale):
	speed = speed * scale
