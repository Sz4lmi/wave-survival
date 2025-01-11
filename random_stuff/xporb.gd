extends CharacterBody2D

var speed = 0
@onready var player = get_node("/root/world/Player")

func _ready() -> void:
	%AnimationPlayer.play("drop")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		speed = 100

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		speed = 0

func _on_pickup_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.collectxp()
		queue_free()
