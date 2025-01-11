extends Node2D

var damage = 1
@onready var player = get_node("/root/world/Player")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit(damage)
		player.lifesteal(damage)
