extends Node2D

@onready var player: Area2D = %Player
@onready var webs: Node = %Webs
@onready var shot_counter = %ShotCounter
@onready var web_blasts: Node2D = %WebBlasts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()


func _on_player_web_shot(web: Web) -> void:
	webs.add_child(web)
	shot_counter.set_shot(player.shots)

func _on_goal_area_entered(area: Area2D) -> void:
	print()
	if area is Player:
		get_tree().change_scene_to_file("res://game/end_screen/end_screen.tscn")


func _on_player_web_blast(blast: WebBlast) -> void:
	web_blasts.add_child(blast)
