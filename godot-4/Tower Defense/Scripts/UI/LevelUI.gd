extends Control

@onready var path = get_node("../LevelPath")
@onready var upgrades = $Upgrades
@onready var health_label = $Values/Health
@onready var money_label = $Values/Money
@onready var wave_label = $Values/Wave
@onready var tower_shop = $TowerShop
@onready var level = get_parent()

@onready var health = path.player_health
@onready var money = path.player_money
@onready var wave = path.wave
var hovering_empty = false
var clicked_tower = null

signal update_values
signal empty_clicked

func _ready():
	upgrades.visible = false
	health_label.text = "Health: " + str(health)
	money_label.text = "Money: " + str(money)
	wave_label.text = "Wave: " + str(wave)
	
	#signals
	connect("update_values", Callable(self, "_on_value_updated"))
	connect("empty_clicked", Callable(self, "_on_Empty_clicked"))
	
func _process(_delta):
	check_mouse()

func check_mouse():
		#close upgrade UI on empty space clicked
		if hovering_empty:
			if Input.is_action_just_pressed("click"):
				emit_signal("empty_clicked")

func open_upgrade_ui():
	upgrades.visible = true
	
func close_upgrade_ui():
	upgrades.visible = false
	
func _on_value_updated():
	health = path.player_health
	money = path.player_money
	wave = path.wave
	
	health_label.text = "Health: " + str(health)
	money_label.text = "Money: " + str(money)
	wave_label.text = "Wave: " + str(wave)
	
func _on_Empty_clicked():
	tower_shop.current_bought = null
	clicked_tower = null
	close_upgrade_ui()


