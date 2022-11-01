tool
extends StaticBody2D

export var max_hits = 3
export var size = 1.0 setget set_size
export var light_time = 0.2
export var color = Color(1, 1, 1)
export (Texture)var texture setget set_texture

var hits = 0

var first = true

var light_timer = 0

var rot_vel = rand_range(-0.1, 0.1)

var shrinking = false

var free_timer = 3.0

func set_texture(t):
	texture = t
	$Sprite.texture = t

func set_size(s):
	size = s
	scale = Vector2(1, 1) * size

func activate(force):
	get_parent().activate()
	var bell_force = clamp(force, -10, -5)
	$AudioStreamPlayer1.volume_db = bell_force
	$AudioStreamPlayer2.volume_db = bell_force
	$AudioStreamPlayer3.volume_db = bell_force
	$AudioStreamPlayer4.volume_db = bell_force
	$AudioStreamPlayer5.volume_db = bell_force
	$AudioStreamPlayer6.volume_db = bell_force
	get_node("AudioStreamPlayer" + str(randi() % 6 + 1)).play()
	if max_hits > -1:
		hits += 1
		
		if hits >= max_hits:
			shrinking = true
			$CollisionShape2D.queue_free()
	
	light_timer = light_time
	

func _physics_process(delta):
	if light_timer >= 0:
		$Light2D.energy = (light_timer / light_time) * 0.8 + 0.2
		light_timer -= delta
	else:
		$Light2D.energy = 0.2
	
	rotation += rot_vel
	
	if shrinking:
		$Sprite.scale -= Vector2(1, 1) * delta
		free_timer -= delta
		if $Sprite.scale.x <= 0:
			$Sprite.visible = false
	if free_timer <= 0:
		get_parent().queue_free()
#	else:
#		$CollisionShape2D.scale = Vector2(lerp($CollisionShape2D.scale.x, size, delta), lerp($CollisionShape2D.scale.y, size, delta))
#		$Sprite.scale = Vector2(lerp($Sprite.scale.x, size, delta), lerp($Sprite.scale.y, size, delta))
