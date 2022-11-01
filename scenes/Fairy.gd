extends Node2D

const RANGE = 40
const MAX_SPEED = 80

var velocity = Vector2()
var timer = 0

var rot_vel = 0

func _physics_process(delta):
	position += velocity * delta
	timer -= delta
	rot_vel = clamp(lerp(rot_vel, rand_range(-200, 200), 0.1), -0.1, 0.1)
	rotation += rot_vel
	if timer <= 0:
		timer = rand_range(0.02, 0.1)
		position += Vector2(rand_range(-RANGE, RANGE), rand_range(-RANGE, RANGE))

func reset(player):
	var theta = rand_range(0, PI * 2)
	global_position = player + Vector2(cos(theta) * 1400, sin(theta) * 1400)
	velocity = global_position.direction_to(player + Vector2(rand_range(-MAX_SPEED, MAX_SPEED), rand_range(-MAX_SPEED, MAX_SPEED))) * rand_range(500, 1000)
	$Light2D.color = Color(rand_range(0.5, 1), rand_range(0.5, 1), rand_range(0.5, 1))
