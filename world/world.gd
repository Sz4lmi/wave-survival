extends Node2D

func _ready() -> void:
	%"game over".visible = false

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
