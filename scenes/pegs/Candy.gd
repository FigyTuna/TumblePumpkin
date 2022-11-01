extends Node2D

export (int, "10", "100", "1000")var value = 0

export (Texture)var t10
export (Texture)var t100
export (Texture)var t1000

func _ready():
	if value == 0:
		$Peg.texture = t10
		$Peg.max_hits = 1
		$Peg.size = 0.4
	elif value == 1:
		$Peg.texture = t100
		$Peg.max_hits = 2
		$Peg.size = 0.6
	else:
		$Peg.texture = t1000
		$Peg.max_hits = 3
		$Peg.size = 0.8

func activate():
	$AudioStreamPlayer.play()
	if not $Peg.shrinking:
		if value == 0:
			$"/root/Global".score += 50
		elif value == 1:
			$"/root/Global".score += 100
			$Peg.texture = t10
			$Peg.size = 0.4
			value = 0
		else:
			$"/root/Global".score += 1000
			$Peg.texture = t100
			$Peg.size = 0.6
			value = 1
