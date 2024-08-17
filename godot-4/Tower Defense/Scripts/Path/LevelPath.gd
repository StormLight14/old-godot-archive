extends Path2D

@onready var default_children = get_child_count()
@onready var wave_delay = $WaveDelay
@onready var music = $JumpAudio
@onready var jumpscare = $JumpScare
@onready var level_ui = get_node("../LevelUI")

@export var player_health = 200
@export var player_money = 400

var wave = 1
var enemy_type := 0
var enemy_delay = .5
var enemy_space = enemy_delay

func _ready():
	wave_delay.connect("timeout", Callable(self, "_on_wave_delay_finish"))
	#create_enemy(100)
	

func new_wave():
	wave_delay.stop()
	#reset enemy delay every wave
	enemy_delay = 0
	
	match wave:
		1:
			enemy_space = .5
			for _i in range(10):
				create_enemy(0)
			
		2:
			enemy_space = .4
			for _i in range(30):
				create_enemy(1)
			
		3:
			for _i in range(15):
				create_enemy(2)
			
		4:
			for _i in range(20):
				create_enemy(3)
		5:
			for _i in range(25):
				create_enemy(4)
		6:
			enemy_space = .2
			for _i in range(20):
				create_enemy(3)
	

func create_jumpscare():
	music.play()
	jumpscare.visible = true

func create_enemy(type):
	#set enemy type and add spacing to it
	enemy_type = type
	enemy_instance()
	enemy_delay += enemy_space
	
func enemy_instance():
	#create enemy
	var enemy_scene = preload("res://Scenes/Path3D/Enemy.tscn").instantiate()
	enemy_scene.enemy_type = enemy_type
	enemy_scene.enemy_delay = enemy_delay
	add_child(enemy_scene)
	
func wait_for_wave():
	#if the entire wave is dead, start the next one.
	if get_child_count() <= default_children + 1:
		wave += 1
		player_money += 100
		level_ui.emit_signal("update_values")
		wave_delay.start()
	
func _on_wave_delay_finish():
	new_wave()
	wave_delay.stop()
