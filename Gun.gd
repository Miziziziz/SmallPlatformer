extends Sprite

var player = null

# commented ones are not used throughout the game.
# var rot_speed = 0.1
var fire_rate = 1.0
var fire_time = 0.0
var rang = 500

var bullet = preload("res://Bullet.tscn")

func _physics_process(_delta):
	if player == null:
		return
	var dir_to_player = player.global_position - global_position
	rotation = dir_to_player.angle()
	fire_time += _delta
	if fire_time > fire_rate:
		fire_time = 0
		fire()

func fire():
	if global_position.distance_to(player.global_position) > rang:
		return
	var bullet_inst = bullet.instance()
	#get_tree().get_root().add_child(bullet_inst)
	get_tree().get_root().get_node("World").get_node("bullets").add_child(bullet_inst)
	bullet_inst.global_position = global_position
	var dir_to_player = (player.global_position - global_position).normalized()
	bullet_inst.move_dir = dir_to_player

func set_player(p):
	player = p


func _on_VisibilityEnabler2D_screen_entered():
	pause_mode = false
	pass # Replace with function body.

func _on_VisibilityEnabler2D_screen_exited():
	pause_mode = true
	pass # Replace with function body.

