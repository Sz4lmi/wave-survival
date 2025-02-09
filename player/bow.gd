extends Area2D

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const ARROW = preload("res://player/arrow.tscn")
	var new_arrow = ARROW.instantiate()
	new_arrow.global_position = %arrow_spawn.global_position
	new_arrow.global_rotation = %pivot.global_rotation
	%arrow_spawn.add_child(new_arrow)


func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()
