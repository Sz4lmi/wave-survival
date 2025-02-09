extends Area2D

const SPEED = 1000
var range = 1200
var travelled_distance = 0
var damage = 1.5
var piercing = false
var onfire = false


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit(damage)
		if onfire == true:
			body.setonfire(3)
		if piercing == false:
			queue_free()
	print(damage)
