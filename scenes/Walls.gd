extends Polygon2D

var xt = 0
var yt = 0
var et = 0

var x_speed = rand_range(1, 10)
var y_speed = rand_range(1, 10)
var flash_speed = rand_range(1, 10)

func _ready():
	$StaticBody2D/CollisionPolygon2D.polygon = polygon

func _physics_process(delta):
	xt += x_speed * delta
	yt += y_speed * delta
	et += flash_speed * delta
	$Light2D.position = Vector2(cos(xt) * 400, sin(yt) * 400)
	$Light2D.energy = sin(et) / 2 + 0.5

func enabled(b):
	visible = b
	$StaticBody2D/CollisionPolygon2D.call_deferred("set_disabled", !b)
