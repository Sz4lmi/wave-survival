extends Node2D

@onready var player = get_node("/root/world/Player")
var damage
var onfire = false
var fireduration = 2.5
var poisoned = false
var poisonduration = 5.0

func _ready() -> void:
	%flame.visible = false
	%poison.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("gethit"):
		body.gethit(damage)
		player.lifesteal(damage)
		print(damage)
		if onfire == true:
			body.setonfire(fireduration)
		if poisoned == true:
			body.getpoisoned(poisonduration)

func addflame():
	%flame.visible = true
	onfire = true
	fireduration += 0.5
	
func addpoison():
	%poison.visible = true
	poisoned = true
	poisonduration += 0.5
