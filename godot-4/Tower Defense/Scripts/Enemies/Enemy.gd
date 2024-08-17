extends PathFollow2D

const SLOW = 75
const MEDIUM = 100
const FAST = 130

var move_speed = 100
var enemy_type = 0
var enemy_delay = .5
var health = 1
var can_move = false
var path_offset = 0
var damage = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var normal_hitbox = $Hitboxes/NormalHitbox
@onready var large_hitbox = $Hitboxes/LargeHitbox
@onready var hitboxes = $Hitboxes
@onready var timer = Timer.new()
@onready var path = get_parent()
@onready var level_ui = get_node("../../LevelUI")


func _process(delta):
	#start moving after enemy delay ends
	if can_move == true:
		set_offset(get_offset() + move_speed * delta)
		if Input.is_action_just_pressed("ui_right"):
			_on_hit(1)
		path_offset = get_offset()
		
func _ready():
	#CHANGE AFTER BIG HITBOX IS USED
	normal_hitbox.disabled = false
	
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	if enemy_delay > 0:
		timer.wait_time = enemy_delay
		timer.start()
	else:
		_on_Timer_timeout()
	set_type()

func set_type():
	#set the properties of every enemy
	match enemy_type:
		100:
			#Invis
			pass
		0:
			#Red
			#large_hitbox.disabled = true
			#normal_hitbox.disabled = false
			animated_sprite.frame = 0
			move_speed = SLOW
			health = 1
			damage = 1
		1:
			#Blue
			#large_hitbox.disabled = true
			#normal_hitbox.disabled = false
			animated_sprite.frame = 1
			move_speed = SLOW
			health = 1
			damage = 2
		2:
			#Green
			#large_hitbox.disabled = true
			#normal_hitbox.disabled = false
			animated_sprite.frame = 2
			move_speed = SLOW
			health = 1
			damage = 3
		3:
			#Yellow
			#large_hitbox.disabled = true
			#normal_hitbox.disabled = false
			animated_sprite.frame = 3
			move_speed = MEDIUM + 10
			health = 1
			damage = 4
			
		4:
			#Pink
			#large_hitbox.disabled = true
			#normal_hitbox.disabled = false
			animated_sprite.frame = 4
			move_speed = FAST + 30
			health = 1
			damage = 5

func _on_Timer_timeout():
	can_move = true
	timer.queue_free()

func _on_hit(hit_damage):
	health -= hit_damage
	level_ui._on_value_updated()
	if health <= 0:
		if enemy_type == 0:
			path.wait_for_wave()
			queue_free()
			path.player_money += 1
		else:
			enemy_type -= 1
			path.player_money += hit_damage
			set_type()

func kill_enemy(hit_damage):
	health -= hit_damage
	level_ui._on_value_updated()
	queue_free()
