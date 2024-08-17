extends Area2D

@export var damage = 0

@onready var pop_cooldown = $PopCooldown
@onready var path = get_node("../LevelPath")
@onready var level_ui = get_node("../LevelUI")

func _on_PathEnd_area_entered(area):
	pop_cooldown.start()
	area.get_parent().kill_enemy(damage)
	path.player_health -= area.get_parent().damage
	level_ui._on_value_updated()
	
	set_deferred("monitoring", false)

func _on_PopCooldown_timeout():
	pop_cooldown.stop()
	set_deferred("monitoring", true)
