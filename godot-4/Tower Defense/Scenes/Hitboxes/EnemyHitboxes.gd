extends Area2D

@onready var enemy = get_parent()

func _on_Hitboxes_area_entered(area):
	enemy._on_hit(area.damage)
