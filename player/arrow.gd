extends Area2D

const SPEED = 1000
var range = 1200
var travelled_distance = 0
var damage
var piercecount = 0
var max_pierce
var onfire = false
var firelevel = 2


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > range:
		queue_free()
	if onfire == true:
		%flame.visible = true
	else:
		%flame.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit(damage)
		piercecount += 1
		
		if piercecount > max_pierce:
			queue_free()
			
		if onfire == true:
			body.setonfire(firelevel)
