extends Node

var levels = [
	"res://game/levels/level_1.tscn",
	"res://game/levels/level_2.tscn",
	"res://game/levels/multi_shot.tscn",
	"res://game/levels/trick_shot.tscn",
]
var currentLevel = 0

func next_level() -> void:
	if currentLevel >= levels.size():
		get_tree().change_scene_to_file("uid://keljgahxq46q") # End Screen
		return
	
	var next_scene = levels[currentLevel]
	get_tree().change_scene_to_file(next_scene)
	
	currentLevel += 1

func reset() -> void:
	currentLevel = 0
	next_level()
