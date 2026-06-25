extends Control

@export var new_game_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CuteMode.set_pressed_no_signal(Config.cuteMode) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	LevelSwitcher.reset()


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_cute_mode_toggled(toggled_on: bool) -> void:
	Config.cuteMode = toggled_on
