extends CharacterBody2D

var elapsed_time = 0.0
var speed = 500
var maxhealth = 100.0
var health = 100.0
var damage = 5.0
var xp = 0
var xp_to_level_up = 15
var currentlevel = 1
var attackdamage = 1.0

#SWORD
const SWORD = preload("res://player/sword.tscn")
var firstsword = SWORD.instantiate()
var sword_rotation_speed = 150
var swords = []
var lifesteal_scale = 0.0
var swordcount = 0
var onfire = false
var poisoned = false

#BOW AND ARROW
const BOW = preload("res://player/bow.tscn")
var attackspeed = 1
var arrowcount = 1
var attackrange = 1
var bows = []
var arrowrange = 1200
var max_pierce = 0

var selected_weapon = ""
var current_weapon_upgrades = []
var weapons = {
	"sword": {
		"name": "Sword",
		"upgrades": [
			{"name": "Sword Count", "level": 0, "max_level": 5, "locked": false},
			{"name": "Rotation Speed", "level": 0, "max_level": 5, "locked": false},
			{"name": "Sword Damage", "level": 0, "max_level": 5, "locked": false},
			{"name": "Lifesteal", "level": 0, "max_level": 5, "locked": false},
			{"name": "Flame Sword", "level": 0, "max_level": 5, "locked": false},
			{"name": "Poison Sword", "level": 0, "max_level": 5, "locked": false},
			{"name": "Movement Speed", "level": 0, "max_level": 10, "locked": false},
			{"name": "Max Health", "level": 0, "max_level": 10, "locked": false},
			{"name": "Collection Radius", "level": 0, "max_level": 10, "locked": false}
		]
	},
	"bow": {
		"name": "Bow & Arrow",
		"upgrades": [
			{"name": "Arrow Damage", "level": 0, "max_level": 5, "locked": false},
			{"name": "Arrow Range", "level": 0, "max_level": 5, "locked": false},
			{"name": "Attack Speed", "level": 0, "max_level": 5, "locked": false},
			{"name": "Projectile Count", "level": 0, "max_level": 5, "locked": false},
			{"name": "Piercing Arrows", "level": 0, "max_level": 5, "locked": false},
			{"name": "Flaming Arrows", "level": 0, "max_level": 5, "locked": false},
			{"name": "Movement Speed", "level": 0, "max_level": 10, "locked": false},
			{"name": "Max Health", "level": 0, "max_level": 10, "locked": false},
			{"name": "Collection Radius", "level": 0, "max_level": 10, "locked": false}
		]
	},
	"shield": {
		"name": "Shield",
		"upgrades": [
			{"name": "Defense", "level": 0, "max_level": 5, "locked": false},
			{"name": "Area", "level": 0, "max_level": 5, "locked": false},
			{"name": "Damage", "level": 0, "max_level": 5, "locked": false},
			{"name": "Ice Aura", "level": 0, "max_level": 5, "locked": false},
			{"name": "Fire Aura", "level": 0, "max_level": 5, "locked": false},
			{"name": "Health Regeneration", "level": 0, "max_level": 5, "locked": false},
			{"name": "Movement Speed", "level": 0, "max_level": 10, "locked": false},
			{"name": "Max Health", "level": 0, "max_level": 10, "locked": false},
			{"name": "Collection Radius", "level": 0, "max_level": 10, "locked": false}
		]
	}
}

signal ded
func player():
	pass

func _ready() -> void:
	get_tree().paused = true
	%XPLabel.text = str(currentlevel)
	%XPBar.max_value = xp_to_level_up
	%choose_skill.visible = false
	%choose_weapon.visible = true
	%HP_XP.visible = true
	%Weapon.visible = false
	%Upgrade1.visible = false
	%Upgrade2.visible = false
	%Upgrade3.visible = false
	%Upgrade4.visible = false
	%Upgrade5.visible = false
	%Upgrade6.visible = false

func _on_weapon1_pressed():
	selected_weapon = "sword"
	current_weapon_upgrades = weapons[selected_weapon]["upgrades"]
	swordcount += 1
	resetswords(swordcount)
	start_game()

func _on_weapon2_pressed():
	selected_weapon = "bow"
	current_weapon_upgrades = weapons[selected_weapon]["upgrades"]
	resetbow()
	start_game()

func _on_weapon3_pressed():
	selected_weapon = "shield"
	current_weapon_upgrades = weapons[selected_weapon]["upgrades"]
	%AnimatedSprite2D.play("pawn_with_shield")
	start_game()

func start_game():
	get_tree().paused = false
	%choose_weapon.visible = false
	%choose_skill.visible = false
	%Weapon.visible = true
	%Weapon.text = ("Weapon: " + weapons[selected_weapon]["name"])

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	elapsed_time += delta
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	%Time.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
	%HPBar.value = health
	%HPBar.max_value = maxhealth
	
	if velocity.length() > 0.0:
		%AnimationPlayer.play("walk")
	else:
		%AnimationPlayer.play("RESET")
	
	var mobs = %hurtbox.get_overlapping_bodies()
	if mobs.size() > 0:
		health -= damage * mobs.size() * delta
	if health <= 0.0:
		ded.emit()
	
	for sword in swords:
		sword.rotation_degrees += sword_rotation_speed * delta
		sword.damage = attackdamage
	
	for bow in bows:
		bow.damage = attackdamage
		bow.max_pierce = max_pierce

func collectxp():
	xp += randf_range(4.2, 6.9)
	%XPBar.value = xp
	if %XPBar.value == %XPBar.max_value:
		levelup()

func levelup():
	xp = 0
	xp_to_level_up = xp_to_level_up * 1.05
	%XPBar.value = 0
	%XPBar.max_value = xp_to_level_up
	currentlevel += 1
	%XPLabel.text = str(currentlevel)
	show_level_up_screen()
	health += ((maxhealth-health)/2.0)


var random_upgrades = []
func show_level_up_screen():
	random_upgrades = get_random_upgrades()
	
	get_tree().paused = true
	%choose_skill.visible = true
	
	# Assign upgrade names to buttons
	if random_upgrades.size() > 0:
		%button1.text = random_upgrades[0]["name"]
	else:
		%button1.text = ""

	if random_upgrades.size() > 1:
		%button2.text = random_upgrades[1]["name"]
	else:
		%button2.text = ""

	if random_upgrades.size() > 2:
		%button3.text = random_upgrades[2]["name"]
	else:
		%button3.text = ""

	%button1.visible = random_upgrades.size() > 0
	%button2.visible = random_upgrades.size() > 1
	%button3.visible = random_upgrades.size() > 2


func get_random_upgrades():
	var valid_upgrades = current_weapon_upgrades.filter(func(upgrade):
		return upgrade["level"] < upgrade["max_level"] and not upgrade["locked"]
	)
	valid_upgrades.shuffle()
	return valid_upgrades.slice(0, 3)

func handle_upgrade_selected(selected_upgrade_name: String):
	for upgrade in current_weapon_upgrades:
		if upgrade["name"] == selected_upgrade_name:
			# Only increase level if it's below the max level
			if upgrade["level"] < upgrade["max_level"]:
				upgrade["level"] += 1
				# Lock upgrade if it reaches max level
				if upgrade["level"] >= upgrade["max_level"]:
					upgrade["locked"] = true
			else:
				print(selected_upgrade_name, "is already at max level.")
			break


func _on_button_1_pressed() -> void:
	button_pressed(0)

func _on_button_2_pressed() -> void:
	button_pressed(1)

func _on_button_3_pressed() -> void:
	button_pressed(2)


func button_pressed(button_index):
	var selected_upgrade = random_upgrades[button_index]
	apply_upgrade(selected_upgrade)
	get_tree().paused = false
	%choose_skill.visible = false



func apply_upgrade(upgrade):
	if upgrade["level"] < upgrade["max_level"]:
		match upgrade["name"]:
			"Sword Count":
				increase_sword_count(upgrade)
			"Rotation Speed":
				increase_rotation_speed(upgrade)
			"Sword Damage":
				increase_attack_damage(upgrade)
			"Lifesteal":
				increase_lifesteal(upgrade)
			"Flame Sword":
				increase_flame(upgrade)
			"Poison Sword":
				increase_poison(upgrade)
			"Arrow Damage":
				increase_arrow_damage(upgrade)
			"Arrow Range":
				increase_arrow_range(upgrade)
			"Attack Speed":
				increase_attack_speed(upgrade)
			"Projectile Count":
				increase_projectile_count(upgrade)
			"Piercing Arrows":
				increase_piercing_arrows(upgrade)
			"Flaming Arrows":
				increase_flaming_arrows(upgrade)
			"Defense":
				increase_defense(upgrade)
			"Area Size":
				increase_area_size(upgrade)
			"Area Damage":
				increase_area_damage(upgrade)
			"Slow Area":
				increase_slow_area(upgrade)
			"Health Regeneration":
				increase_hp_regen(upgrade)
			"Movement Speed":
				increase_movement_speed(upgrade)
			"Max Health":
				increase_max_hp(upgrade)
			"Collection Radius":
				increase_coll_rad(upgrade)


#SWORD
func increase_sword_count(upgrade):#WORKS 
	upgrade["level"] += 1
	swordcount += 1
	resetswords(swordcount)
	%Upgrade1.visible = true
	%Name1.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar1.visible = true
			%Bar2.visible = false
			%Bar3.visible = false
			%Bar4.visible = false
			%Bar5.visible = false
		2:
			%Bar2.visible = true
		3:
			%Bar3.visible = true
		4:
			%Bar4.visible = true
		5:
			%Bar5.visible = true

func increase_rotation_speed(upgrade):#WORKS
	upgrade["level"] += 1
	sword_rotation_speed += 25
	%Upgrade2.visible = true
	%Name2.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar6.visible = true
			%Bar7.visible = false
			%Bar8.visible = false
			%Bar9.visible = false
			%Bar10.visible = false
		2:
			%Bar7.visible = true
		3:
			%Bar8.visible = true
		4:
			%Bar9.visible = true
		5:
			%Bar10.visible = true

func increase_attack_damage(upgrade):#WORKS
	upgrade["level"] += 1
	attackdamage *= 1.38
	%Upgrade3.visible = true
	%Name3.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar11.visible = true
			%Bar12.visible = false
			%Bar13.visible = false
			%Bar14.visible = false
			%Bar15.visible = false
		2:
			%Bar12.visible = true
		3:
			%Bar13.visible = true
		4:
			%Bar14.visible = true
		5:
			%Bar15.visible = true

func increase_lifesteal(upgrade):#WORKS
	upgrade["level"] += 1
	lifesteal_scale += 0.1
	%Upgrade4.visible = true
	%Name4.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar16.visible = true
			%Bar17.visible = false
			%Bar18.visible = false
			%Bar19.visible = false
			%Bar20.visible = false
		2:
			%Bar17.visible = true
		3:
			%Bar18.visible = true
		4:
			%Bar19.visible = true
		5:
			%Bar20.visible = true

func increase_flame(upgrade): #WORKS
	upgrade["level"] += 1
	onfire = true
	for sword in swords:
		sword.addflame()
	%Upgrade5.visible = true
	%Name5.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar21.visible = true
			%Bar22.visible = false
			%Bar23.visible = false
			%Bar24.visible = false
			%Bar25.visible = false
		2:
			%Bar22.visible = true
		3:
			%Bar23.visible = true
		4:
			%Bar24.visible = true
		5:
			%Bar25.visible = true

func increase_poison(upgrade): #WORKS
	upgrade["level"] += 1
	poisoned = true
	for sword in swords:
		sword.addpoison()
	%Upgrade6.visible = true
	%Name6.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar26.visible = true
			%Bar27.visible = false
			%Bar28.visible = false
			%Bar29.visible = false
			%Bar30.visible = false
		2:
			%Bar27.visible = true
		3:
			%Bar28.visible = true
		4:
			%Bar29.visible = true
		5:
			%Bar30.visible = true


#BOWANDARROW
func increase_arrow_damage(upgrade):#WORKS
	upgrade["level"] += 1
	attackdamage = attackdamage * 1.33
	%Upgrade1.visible = true
	%Name1.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar1.visible = true
			%Bar2.visible = false
			%Bar3.visible = false
			%Bar4.visible = false
			%Bar5.visible = false
		2:
			%Bar2.visible = true
		3:
			%Bar3.visible = true
		4:
			%Bar4.visible = true
		5:
			%Bar5.visible = true

func increase_arrow_range(upgrade):#WORKS
	upgrade["level"] += 1
	for bow in bows:
		bow.increase_range()
	%Upgrade2.visible = true
	%Name2.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar6.visible = true
			%Bar7.visible = false
			%Bar8.visible = false
			%Bar9.visible = false
			%Bar10.visible = false
		2:
			%Bar7.visible = true
		3:
			%Bar8.visible = true
		4:
			%Bar9.visible = true
		5:
			%Bar10.visible = true

func increase_attack_speed(upgrade):#WORKS
	upgrade["level"] += 1
	attackspeed += 1
	var timer = get_node("/root/world/Player/bow/Timer")
	timer.wait_time -= 0.2
	%Upgrade3.visible = true
	%Name3.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar11.visible = true
			%Bar12.visible = false
			%Bar13.visible = false
			%Bar14.visible = false
			%Bar15.visible = false
		2:
			%Bar12.visible = true
		3:
			%Bar13.visible = true
		4:
			%Bar14.visible = true
		5:
			%Bar15.visible = true

func increase_projectile_count(upgrade):#WORKS
	upgrade["level"] += 1
	for bow in bows:
		bow.projectile_count_level += 1
		bow.upgrade_shooting()
	%Upgrade4.visible = true
	%Name4.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar16.visible = true
			%Bar17.visible = false
			%Bar18.visible = false
			%Bar19.visible = false
			%Bar20.visible = false
		2:
			%Bar17.visible = true
		3:
			%Bar18.visible = true
		4:
			%Bar19.visible = true
		5:
			%Bar20.visible = true

func increase_piercing_arrows(upgrade):#WORKS
	upgrade["level"] += 1
	max_pierce += 1
	%Upgrade5.visible = true
	%Name5.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar21.visible = true
			%Bar22.visible = false
			%Bar23.visible = false
			%Bar24.visible = false
			%Bar25.visible = false
		2:
			%Bar22.visible = true
		3:
			%Bar23.visible = true
		4:
			%Bar24.visible = true
		5:
			%Bar25.visible = true

func increase_flaming_arrows(upgrade):#WORKS
	upgrade["level"] += 1
	for bow in bows:
		bow.onfire = true
		bow.firelevel += 1
	%Upgrade6.visible = true
	%Name6.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar26.visible = true
			%Bar27.visible = false
			%Bar28.visible = false
			%Bar29.visible = false
			%Bar30.visible = false
		2:
			%Bar27.visible = true
		3:
			%Bar28.visible = true
		4:
			%Bar29.visible = true
		5:
			%Bar30.visible = true

#SHIELD
func increase_defense(upgrade):
	upgrade["level"] += 1
	%Upgrade1.visible = true
	%Name1.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar1.visible = true
			%Bar2.visible = false
			%Bar3.visible = false
			%Bar4.visible = false
			%Bar5.visible = false
		2:
			%Bar2.visible = true
		3:
			%Bar3.visible = true
		4:
			%Bar4.visible = true
		5:
			%Bar5.visible = true

func increase_area_size(upgrade):
	upgrade["level"] += 1
	%Upgrade2.visible = true
	%Name2.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar6.visible = true
			%Bar7.visible = false
			%Bar8.visible = false
			%Bar9.visible = false
			%Bar10.visible = false
		2:
			%Bar7.visible = true
		3:
			%Bar8.visible = true
		4:
			%Bar9.visible = true
		5:
			%Bar10.visible = true

func increase_area_damage(upgrade):#ROYAL AURA
	upgrade["level"] += 1
	%Upgrade3.visible = true
	%Name3.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar11.visible = true
			%Bar12.visible = false
			%Bar13.visible = false
			%Bar14.visible = false
			%Bar15.visible = false
		2:
			%Bar12.visible = true
		3:
			%Bar13.visible = true
		4:
			%Bar14.visible = true
		5:
			%Bar15.visible = true

func increase_slow_area(upgrade):#FROZEN FIELD
	upgrade["level"] += 1
	%Upgrade4.visible = true
	%Name4.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar16.visible = true
			%Bar17.visible = false
			%Bar18.visible = false
			%Bar19.visible = false
			%Bar20.visible = false
		2:
			%Bar17.visible = true
		3:
			%Bar18.visible = true
		4:
			%Bar19.visible = true
		5:
			%Bar20.visible = true

func increase_hp_regen(upgrade):
	upgrade["level"] += 1
	%Upgrade5.visible = true
	%Name5.text = upgrade["name"]
	match upgrade["level"]:
		1:
			%Bar21.visible = true
			%Bar22.visible = false
			%Bar23.visible = false
			%Bar24.visible = false
			%Bar25.visible = false
		2:
			%Bar22.visible = true
		3:
			%Bar23.visible = true
		4:
			%Bar24.visible = true
		5:
			%Bar25.visible = true

#UNIVERSAL
func increase_movement_speed(upgrade):#WORKS
	upgrade["level"] += 1
	speed *= 1.1

func increase_max_hp(upgrade):#WORKS
	upgrade["level"] += 1
	maxhealth *= 1.2

func increase_coll_rad(upgrade):
	print("radius increased")

#extras
func resetswords(n):#WORKS
	var newsword = SWORD.instantiate()
	add_child(newsword)
	swords.append(newsword)
	newsword.global_position = %Swordspawn.global_position
	
	if n > 1:
		for i in range(swordcount):
			var angle = 360.0/swordcount * i
			swords[i].set_rotation_degrees(angle)
	if onfire == true:
		for sword in swords:
			sword.addflame()
	if poisoned == true:
		for sword in swords:
			sword.addpoison()

func lifesteal(n):#WORKS
	health += n * lifesteal_scale

func resetbow():#WORKS
	var bow = BOW.instantiate()
	add_child(bow)
	bows.append(bow)
