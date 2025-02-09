extends Area2D

const SPEED = 1000
var range = 1200
var travelled_distance = 0
var damage = 5


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit(damage)
	queue_free()
	print(damage)
