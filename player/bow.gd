extends Area2D

const ARROW = preload("res://player/arrow.tscn")
var projectile_count_level = 0
var spread_angle = 15
var arrow_count = 1
var piercing = false
var onfire = false
var firelevel = 0

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)


func shoot():
	for i in range(arrow_count):
		var new_arrow = ARROW.instantiate()
		var angle_offset = spread_angle * (i - (arrow_count / 2))
		new_arrow.global_position = %arrow_spawn.global_position
		new_arrow.global_rotation = %pivot.global_rotation + deg_to_rad(angle_offset)
		%arrow_spawn.add_child(new_arrow)

func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

func increase_range():
	%shoot_range.shape.radius += 75

func upgrade_shooting():
	match projectile_count_level:
		1:
			arrow_count = 2
		2:
			arrow_count = 3
		3:
			arrow_count = 5
		4:
			arrow_count = 7
		5:
			arrow_count = 10
