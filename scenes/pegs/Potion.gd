extends Node2D

func _ready():
	$Peg.scale = Vector2(1, 1) * rand_range(0.3, 0.7)

func activate():
	$AudioStreamPlayer.play()
	$"/root/Global".timer += 5
