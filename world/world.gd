extends Node2D

var elapsed_time = 0.0
var difficulty_level = 1

func _ready() -> void:
	%"game over".visible = false
	%paused.visible = false

func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > 20:
		difficulty_level += 1
		elapsed_time = 0.0
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	if get_tree().paused == true:
		%paused.visible = true
	else:
		%paused.visible = false

func spawn_enemy():
	const ENEMY = preload("res://enemy/pawn_enemy.tscn")
	var new_enemy = ENEMY.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()

func _on_player_ded() -> void:
	%"game over".visible = true
	get_tree().paused = true

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().quit()
