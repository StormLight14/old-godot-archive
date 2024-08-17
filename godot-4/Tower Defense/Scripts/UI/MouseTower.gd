extends TextureButton

var can_place = true

func set_type(type):
	match type:
		"dart_monkey":
			texture_normal.set_current_frame(0)
		"wizard_monkey":
			texture_normal.set_current_frame(1)

func _on_Area2D_area_entered(area):
	can_place = false

func _on_Area2D_area_exited(area):
	can_place = true
