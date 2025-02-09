extends Area2D

var projectile_count = 1

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
		match projectile_count:
			1:
				shoot()
			2:
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
			3:
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
			4:
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
			5:
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()
				await get_tree().create_timer(0.2).timeout
				shoot()

func increase_range():
	%shoot_range.shape.radius += 75
