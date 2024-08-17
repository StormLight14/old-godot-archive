extends Control

@onready var level_ui = get_parent()
@onready var path = get_node("../../LevelPath")
@onready var mouse_tower = get_node("../MouseTower")
@onready var level = get_node("../../")

@export var upgrade_prices: Resource

var dart_monkey_hovering = false
var current_bought = null
var shop_prices = {
	"dart_monkey": 200,
	"wizard_monkey": 350
}

signal tower_bought

func _ready():
	connect("tower_bought", Callable(self, "_on_tower_bought"))

func _process(_delta):
	check_shop_pressed()
	if current_bought:
		mouse_tower.visible = true
		mouse_tower.set_global_position(get_viewport().get_mouse_position() + Vector2(-16, -16))

func check_shop_pressed():
	if level_ui.clicked_tower:
		if level_ui.clicked_tower.left_upgradable and level_ui.left_path_hovering:
			if Input.is_action_just_pressed("click"):
				emit_signal("upgrade_left")
		if level_ui.clicked_tower.right_upgradable and level_ui.right_path_hovering:
			if Input.is_action_just_pressed("click"):
				emit_signal("upgrade_right")
		
func _on_tower_bought(type):
	# ON TOWER BUTTON CLICKED
	if path.player_money >= shop_prices[type]:
		path.player_money -= shop_prices[type]
		current_bought = type
		mouse_tower.visible = true
		mouse_tower.set_type(type)
		level_ui._on_value_updated()
	else:
		current_bought = null

func _on_MouseTower_button_down():
	mouse_tower.visible = false 
	if mouse_tower.can_place:
		if current_bought:
			#ON TOWER PLACED
			var tower_scene = preload("res://Scenes/Tower/Tower.tscn").instantiate()
			tower_scene.type = current_bought
			tower_scene.enabled = true
			tower_scene.global_position = get_global_mouse_position() + Vector2(1, .5)
			level.add_child(tower_scene)
			tower_scene.set_owner(level)
			current_bought = null
