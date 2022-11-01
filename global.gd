extends Node

var score = 0 setget set_score
var true_score = 0
var timer = 60.0
var dir = true if randi() % 2 == 0 else false
var speed = 0.3
var just_updated_score = false

func set_score(s):
	score = s
	just_updated_score = true

func reset_combo():
	score = 0
