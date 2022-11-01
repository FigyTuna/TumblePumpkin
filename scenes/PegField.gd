tool
extends Node2D

#var Peg = preload("res://scenes/Peg.tscn")

export var radius = 200 setget set_radius

export var min_pegs = 6
export var max_pegs = 8

func _ready():
	if not Engine.editor_hint:
		$Polygon2D.visible = false
		var pegs = []
		for child in get_children():
			if child.has_method("activate"):
				pegs.append(child)
		var num_pegs = int(rand_range(min_pegs, max_pegs+1))
		while(num_pegs > 0):
			var peg = pegs[randi() % len(pegs)].duplicate()
			var theta = rand_range(0.0, PI * 2)
			var mag = rand_range(0.0, 1.0)
			mag = (1 - mag * mag) * radius
			peg.position = Vector2(cos(theta) * mag, sin(theta) * mag)
			add_child(peg)
			num_pegs -= 1
		for peg in pegs:
			peg.queue_free()

func set_radius(r):
	radius = r
	if Engine.editor_hint:
		var polygon = PoolVector2Array()
		for i in range(20):
			polygon.append(Vector2(cos(i / 20.0 * PI * 2) * radius, sin(i / 20.0 * PI * 2) * radius))
		$Polygon2D.polygon = polygon
