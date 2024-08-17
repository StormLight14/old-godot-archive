extends Area2D

@onready var detection_zone = $TowerDetectionZone/DetectionZone
@onready var timer = $AttackCooldown
@onready var sprite = $AnimatedSprite2D
@onready var path = get_node("../LevelPath")
@onready var level_ui = get_node("../LevelUI")
@onready var tower_shop = get_node("../LevelUI/TowerShop")

@export var tower_damage = 1
@export var tower_piercing = 2
@export var tower_projectile_speed = 5
@export var detection_range = 10
@export var enabled = true

var enemies_in_range = []
var biggest_offset = 0
var offset = 0
var target = null
var furthest_enemy = null
var enemy_speed = 0
var direction = null
var time = 0
var left_upgradable = false
var right_upgradable = false
var mouse_hovering = false
var upgrade_tier_left = 0
var upgrade_tier_right = 0
var type = ""

signal tower_clicked

func _ready():
	if enabled:
		set_type()
		timer.start()
		timer.connect("timeout", Callable(self, "shoot_enemy"))
		detection_zone.scale *= detection_range
		visible = true
		
		#signals
		connect("tower_clicked", Callable(self, "_on_Tower_clicked"))
	else:
		visible = false

func _process(_delta):
	if enabled:
		check_for_enemy()
		check_pressed()
		if target:
			direction = global_position.direction_to(target)
			sprite.look_at(target)
		
func shoot_enemy():
	if enabled:
		timer.stop()
		if enemies_in_range:
			#create projectile
			var projectile_scene = preload("res://Scenes/Weapons/Projectile.tscn").instantiate()
			projectile_scene.health = tower_piercing
			projectile_scene.damage = tower_damage
			projectile_scene.speed = tower_projectile_speed
			projectile_scene.velocity = direction
			projectile_scene.type = type
			add_child(projectile_scene)
		timer.start()

func set_type():
	match type:
		"dart_monkey":
			tower_damage = 1
			tower_piercing = 2
			detection_range = 8
			sprite.frame = 0
			
		"wizard_monkey":
			tower_damage = 1
			tower_piercing = 3
			detection_range = 10
			sprite.frame = 1
		_:
			print("Type: " + type)
		
func check_for_enemy():
	if enabled:
		if enemies_in_range:
			for enemy in enemies_in_range:
				offset = enemy.get_parent().get_offset()
				if offset > biggest_offset:
					biggest_offset = offset
					enemy_speed = enemy.get_parent().move_speed
					#time = global_position.distance_to(enemy.global_position) / enemy_speed
					
					target = enemy.global_position
					#var prediction = path.curve.interpolate_baked(offset + direction * time)
		else:
			target = null
	
func check_pressed():
	#open upgrade UI on tower clicked
	if mouse_hovering:
		if Input.is_action_just_pressed("click"):
			emit_signal("tower_clicked")
		
func _on_TowerDetectionZone_area_entered(area):
	enemies_in_range.append(area)
	
func _on_TowerDetectionZone_area_exited(area):
	enemies_in_range.erase(area)
	biggest_offset = 0
	
func _on_Tower_clicked():
	level_ui.clicked_tower = self
	level_ui.open_upgrade_ui()

func _on_TowerClickRegion_mouse_entered():
	mouse_hovering = true
	level_ui.hovering_empty = false

func _on_TowerClickRegion_mouse_exited():
	mouse_hovering = false
	level_ui.hovering_empty = true
