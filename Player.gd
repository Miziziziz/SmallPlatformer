extends KinematicBody2D

export var move_speed = 200
export var gravity = 20
export var less_gravity = 10
export var jump_force = 400
var velo = Vector2()
var drag = 0.5

const jump_buffer = 0.08
var time_pressed_jump = 0.0
var time_left_ground = 0.0
var last_grounded = false

var facing_right = true

onready var anim_player = $AnimationPlayer

var dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("need_player_ref", "set_player", self)

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	if dead and Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	var move_vec = Vector2()
	if !dead:
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1
	
	velo += move_vec * move_speed - drag * Vector2(velo.x, 0)
	
	var cur_grounded = is_on_floor()
	if !cur_grounded and last_grounded:
		time_left_ground = get_cur_time()
	
	var will_jump = false
	var pressed_jump = Input.is_action_just_pressed("jump")
	
	if pressed_jump:
		time_pressed_jump = get_cur_time()
	
	if (pressed_jump and cur_grounded):
		jump()
	elif (!last_grounded and cur_grounded and get_cur_time() - time_pressed_jump < jump_buffer):
		jump()
	elif pressed_jump and get_cur_time() - time_left_ground < jump_buffer:
		jump()
	
	if Input.is_action_pressed("jump"):
		velo.y += less_gravity
	else:
		velo.y += gravity
	
	if cur_grounded and velo.y > 10:
		velo.y = 10
	
	move_and_slide(velo, Vector2.UP)
	
	if move_vec.x > 0.0 and !facing_right:
		flip()
	elif move_vec.x < 0.0 and facing_right:
		flip()
	
	if cur_grounded:
		if move_vec == Vector2():
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")
	
	
	last_grounded = cur_grounded

func jump():
	if dead:
		return
	velo.y = -jump_force

func get_cur_time():
	return OS.get_ticks_msec() / 1000.0

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func die():
	dead = true
	$CanvasLayer/RestartMessage.show()
	$Blood.emitting = true
