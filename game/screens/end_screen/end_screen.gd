extends Control

func _ready() -> void:
	%PinkBow.visible = Config.cuteMode

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("uid://c1a4pudcw0drg")
