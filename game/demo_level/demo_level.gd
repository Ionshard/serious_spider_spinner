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

func _on_player_web_blast(blast: WebBlast) -> void:
	web_blasts.add_child(blast)
	shot_counter.set_shot(player.shots)
	blast.connect('body_entered', _on_blast_body_entered)
	
func _on_blast_body_entered(body: Node2D) -> void:
	if body == %LightSwitch:
		%LightBulb.play('default')
		%LightBulb2.play('default')
		var sprite = %LightSwitch.get_child(0) as Sprite2D
		sprite.texture = load("res://resources/light_on.tres")

func _on_light_bulb_animation_finished() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("uid://keljgahxq46q")
