extends Control

@onready var level_ui = get_parent()

func _on_Upgrades_mouse_entered():
	level_ui.hovering_empty = false

func _on_Upgrades_mouse_exited():
	level_ui.hovering_empty = true
