extends RigidBody2D

var xt = 0
var yt = 0
var et = 0

var x_speed = rand_range(1, 10)
var y_speed = rand_range(1, 10)
var flash_speed = rand_range(1, 10)

var speed = 10

var normal_grav = 9.8
var heavy_grav = 40.0

var grav = normal_grav

const GRAV_TIME = 0.2
var grav_timer = 0

var rot = 0

var cam_zoom = Vector2(1, 1)

var playing = false

func _ready():
	$Area2D/CollisionShape2D.transform = $CollisionShape2D.transform

func _integrate_forces(state):
	if not playing:
		state.linear_velocity = Vector2(0, 0)
		return
	
	if (Input.is_action_pressed("right")):
		state.linear_velocity += Vector2(speed, 0).rotated(rot)
	
	if (Input.is_action_pressed("left")):
		state.linear_velocity += Vector2(-speed, 0).rotated(rot)
	
	state.linear_velocity += Vector2(0, grav).rotated(rot)

func _physics_process(delta):
	if not playing:
		if Input.is_action_just_pressed("heavy") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			playing = true
			return
	
	if $"/root/Global".dir:
		rot += delta * $"/root/Global".speed
	else:
		rot -= delta * $"/root/Global".speed
	
	if $"/root/Global".speed > 0.3:
		$"/root/Global".speed -= delta
	
	$Camera2D.rotation = rot - rotation
	
	grav_timer -= delta
	
	if (grav_timer <= 0 and Input.is_action_pressed("heavy")):
		grav = heavy_grav
	else:
		grav = normal_grav
	
	cam_zoom = lerp(cam_zoom, Vector2(1, 1) * (linear_velocity.length() / 2000 + 1), delta)
	$Camera2D.zoom = cam_zoom
	$Light2D.rotation = -rotation
	
	$Light2D.energy = lerp($Light2D.energy, clamp($Light2D.energy + rand_range(-0.1, 0.1), 0.7, 0.4), delta * 10)
	$Light2D.scale = Vector2(1 ,1) * $Light2D.energy * 0.5
	
	xt += x_speed * delta
	yt += y_speed * delta
	et += flash_speed * delta
	$WallLight.position = Vector2(cos(xt) * 400, sin(yt) * 400)
	$WallLight.energy = sin(et) / 2 + 0.5
	$WallLight.position = Vector2(-cos(xt) * 400, -sin(yt) * 400)
	$WallLight.energy = sin(et) / 2 + 0.5

func _on_Area2D_body_entered(body):
	var force = clamp((linear_velocity.length() / 1000.0) * 20 - 19, -20, 1)
	if body.has_method("activate"):
		body.activate(force)
	elif linear_velocity.length() > 100:
		$AudioStreamPlayer.volume_db = force
		$AudioStreamPlayer.play()
	grav_timer = GRAV_TIME

func _on_Area2D_area_entered(area):
	if area.has_method("activate"):
		if area.activate():
			get_parent().advance()
