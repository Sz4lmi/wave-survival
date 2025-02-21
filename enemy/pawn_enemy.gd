extends CharacterBody2D

const SPEED = 150
var health = 3
var maxhealth = 3

@onready var player = get_node("/root/world/Player")

func enemy():
	pass

func _ready() -> void:
	%flame.visible = false
	%poison.visible = false
	%HPBar.visible = false

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()
	%HPBar.value = health
	%HPBar.max_value = maxhealth
	if health < maxhealth:
		%HPBar.visible = true
	else:
		%HPBar.visible = false
	

	

func gethit(damage):
	%AnimationPlayer.play("gethit")
	%AnimationPlayer.queue("walk")
	health -= damage
	if health <= 0:
		queue_free()
		const XP = preload("res://random_stuff/xporb.tscn")
		var xp = XP.instantiate()
		get_parent().add_child(xp)
		xp.global_position = global_position
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

func setonfire(n):
	%flame.visible = true
	%fire_duration.start(n)
	%fire_dot.start(1)

func getpoisoned(n):
	%poison.visible = true
	%poison_duration.start(n)
	%poison_dot.start(2)

func _on_fire_duration_timeout() -> void:
	%flame.visible = false
	%fire_dot.stop()

func _on_fire_dot_timeout() -> void:
	gethit(0.5)

func _on_poison_duration_timeout() -> void:
	%poison.visible = false
	%poison_dot.stop()

func _on_poison_dot_timeout() -> void:
	gethit(0.2)
