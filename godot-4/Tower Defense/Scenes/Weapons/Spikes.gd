extends Area2D

@export var damage = 1
@export var spike_count = 20

@onready var animated_sprite = $AnimatedSprite2D
@onready var pop_cooldown = $PopCooldown

func _ready():
	pop_cooldown.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Spikes_area_entered(area):
	spike_count -= 1
	
	set_deferred("monitoring", false)
	pop_cooldown.start()
	
	area.get_parent().health -= 1
	
	match spike_count:
		15:
			animated_sprite.frame = 0
		14:
			animated_sprite.frame = 0
		13:
			animated_sprite.frame = 0
		12:
			animated_sprite.frame = 1
		11:
			animated_sprite.frame = 1
		10:
			animated_sprite.frame = 2
		9:
			animated_sprite.frame = 2
		8:
			animated_sprite.frame = 3
		7:
			animated_sprite.frame = 3
		6:
			animated_sprite.frame = 4
		5:
			animated_sprite.frame = 4
		4:
			animated_sprite.frame = 5
		3:
			animated_sprite.frame = 5
		2:
			animated_sprite.frame = 6
		1:
			animated_sprite.frame = 6
		0:
			queue_free()

func _on_Timer_timeout():
	pop_cooldown.stop()
	set_deferred("monitoring", true)
