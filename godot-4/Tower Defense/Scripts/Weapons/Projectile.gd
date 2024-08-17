extends Area2D

@onready var sprite = $AnimatedSprite2D

var velocity = Vector2.ZERO
var damage = 1
var speed = 1
#health = pierce
var health = 2
var type = "dart"

func _ready():
	match type:
		"dart_monkey":
			sprite.frame = 0
		"wizard_monkey":
			sprite.frame = 1
			
	if velocity != Vector2.ZERO:
		if velocity:
			sprite.look_at(velocity)
		else:
			queue_free()

func _process(_delta):
	if velocity:
		global_position += velocity * speed

func _on_Projectile_area_entered(_area):
	health -= 1
	if health <= 0:
		queue_free()
