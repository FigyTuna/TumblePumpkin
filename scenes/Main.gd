extends Node2D

onready var last_hall = $Map/Start
onready var history = [[],[],[],[last_hall]]

var halls = {
	0: [preload("res://scenes/halls/Split.tscn"),preload("res://scenes/halls/Left.tscn"),preload("res://scenes/halls/Tri.tscn"),preload("res://scenes/halls/Tiny.tscn")],
	1: [preload("res://scenes/halls/Challenge.tscn"),preload("res://scenes/halls/Skulls.tscn"),preload("res://scenes/halls/Wide.tscn"),preload("res://scenes/halls/MoreMed.tscn")],
	2: [preload("res://scenes/halls/Vertical.tscn"),preload("res://scenes/halls/WithExtra.tscn"),preload("res://scenes/halls/Scatter.tscn")],
	3: [preload("res://scenes/halls/Pocket.tscn"),preload("res://scenes/halls/SmallB.tscn")],
	4: [preload("res://scenes/halls/Bonus.tscn"),preload("res://scenes/halls/SkullBonus.tscn")],
	5: [preload("res://scenes/halls/LargeBonus.tscn"),preload("res://scenes/halls/LargeB.tscn")]
}

var score_timer = 0
var combo = 0

func _ready():
	randomize()
	$GUI/AnimationPlayer2.play("title")
	advance()
	call_deferred("advance")

func advance():
	for area in history.pop_front():
		area.queue_free()
	var s = last_hall.get_exit().size
	var hall = halls[s][randi() % len(halls[s])].instance()
	hall.position = last_hall.get_exit().global_position
	hall.rotation = last_hall.get_exit().global_rotation - hall.get_enter().rotation
	$Map.call_deferred("add_child", hall)
	last_hall = hall
	history.append([hall])
	if len(history[0]):
		history[0][0].close()
	if hall.get_extra():
		call_deferred("add_extra")

func add_extra():
	var es = last_hall.get_extra().size + 3
	var extra = halls[es][randi() % len(halls[es])].instance()
	extra.position = last_hall.get_extra().global_position
	extra.rotation = last_hall.get_extra().global_rotation - extra.get_extra().rotation
	$Map.call_deferred("add_child", extra)
	history[-1].append(extra)

func _physics_process(delta):
	if Input.is_action_just_pressed("playagain") and $"/root/Global".timer <= 0:
		$"/root/Global".timer = 60.0
		$"/root/Global".true_score = 0
		$"/root/Global".dir = true if randi() % 2 == 0 else false
		get_tree().change_scene("res://scenes/Main.tscn")
	
	if $"/root/Global".just_updated_score:
		$"/root/Global".just_updated_score = false
		score_timer = 2.5
		combo += 1
	
	if $Player.playing:
		$"/root/Global".timer -= delta
		if $"/root/Global".timer < 0:
			$"/root/Global".timer = 0
	score_timer -= delta
	
	if score_timer > 0.0:
		$GUI/ProgressBar.value = (score_timer / 2.5) * 100
		$GUI/Score.text = "Score: " + str($"/root/Global".true_score) + " + " + str($"/root/Global".score) + " x" + str(combo / 5 + 1)
		if $GUI/ProgressBar.modulate.a == 0:
			$GUI/AnimationPlayer.play_backwards("combofade")
	else:
		$"/root/Global".true_score += $"/root/Global".score * combo
		$"/root/Global".reset_combo()
		combo = 0
		$GUI/Score.text = "Score: " + str($"/root/Global".true_score)
		if $GUI/ProgressBar.modulate.a == 1:
			$GUI/AnimationPlayer.play("combofade")
	
	$GUI/Timer.text = ("Time: %.2f" % $"/root/Global".timer).replace(".",":")
	
	for fairy in $Fairies.get_children():
		if fairy.global_position.distance_to($Player.global_position) > 1500:
			fairy.reset($Player.global_position)
	
	if $Player.playing and $GUI/Score.modulate.a == 0:
		$GUI/AnimationPlayer3.play("startfade")
		$GUI/Score.visible = true
		$GUI/Timer.visible = true
	elif not $Player.playing and $GUI/Score.modulate.a == 1:
		$GUI/AnimationPlayer3.play_backwards("startfade")
	
	if $"/root/Global".timer < 10.0 and $"/root/Global".timer > 0:
		$Map.modulate.a = $"/root/Global".timer / 10.0
		if not $AudioStreamPlayer2.playing:
			$AudioStreamPlayer.stop()
			$AudioStreamPlayer2.play()
	elif $Map and $"/root/Global".timer >= 10.0:
		$Map.modulate.a = 1
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer2.stop()
			$AudioStreamPlayer.play()
	elif $Map and $"/root/Global".timer <= 0:
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer2.stop()
		$AudioStreamPlayer3.play()
		$Map.queue_free()
		score_timer = 0
		$"/root/Global".true_score += $"/root/Global".score * combo
		$"/root/Global".reset_combo()
		combo = 0
		var overwrite = true
		var read = File.new()
		$GUI/HighScore.text = "New High Score!"
		if read.file_exists("user://savedata.json"):
			read.open("user://savedata.json", File.READ)
			var d = parse_json(read.get_as_text())
			print(d["score"])
			print($"/root/Global".true_score)
			if d["score"] > $"/root/Global".true_score:
				$GUI/HighScore.text = "High Score: " + str(d["score"])
				overwrite = false
			read.close()
		if overwrite:
			print("adsf")
			var save = File.new()
			save.open("user://savedata.json", File.WRITE)
			var data = {
				"score": $"/root/Global".true_score
			}
			save.store_line(to_json(data))
			save.close()
		$GUI/HighScore.text += "\nPress Enter to play again!"
		$GUI/HighScore.visible = true
		$GUI/AnimationPlayer4.play("hs")
