extends Node2D

func _ready():
	$Peg.rot_vel = 0.05

func activate():
	$AudioStreamPlayer.play()
	$"/root/Global".dir = !$"/root/Global".dir
	$"/root/Global".speed = 1
	$Peg.rot_vel = 1

func _physics_process(delta):
	if $Peg.rot_vel > 0.05:
		$Peg.rot_vel -= delta * 2
