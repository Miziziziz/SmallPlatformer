extends KinematicBody2D

var move_dir = Vector2()
var move_speed = 200

func _physics_process(_delta):
	var coll = move_and_collide(move_dir * move_speed * _delta)
	if coll:
		if coll.collider.name == "Player":
			coll.collider.die()
		queue_free()
