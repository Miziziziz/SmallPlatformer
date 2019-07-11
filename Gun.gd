extends Sprite

var player = null

var rot_speed = 0.1
var fire_rate = 1.0
var fire_time = 0.0
var rang = 500

var bullet = preload("res://Bullet.tscn")

func _physics_process(delta):
	if player == null:
		return
	var dir_to_player = player.global_position - global_position
	rotation = dir_to_player.angle()
	fire_time += delta
	if fire_time > fire_rate:
		fire_time = 0
		fire()

func fire():
	if global_position.distance_to(player.global_position) > rang:
		return
	var bullet_inst = bullet.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = global_position
	var dir_to_player = (player.global_position - global_position).normalized()
	bullet_inst.move_dir = dir_to_player

func set_player(p):
	player = p