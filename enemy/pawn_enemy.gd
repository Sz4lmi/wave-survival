extends CharacterBody2D

const SPEED = 150
var health = 1

@onready var player = get_node("/root/world/Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()

func gethit():
	%AnimationPlayer.play("gethit")
	%AnimationPlayer.queue("walk")
	health -= 1
	if health == 0:
		queue_free()
		const XP = preload("res://random_stuff/xporb.tscn")
		var xp = XP.instantiate()
		get_parent().add_child(xp)
		xp.global_position = global_position
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

func enemy():
	pass
