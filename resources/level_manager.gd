extends Node2D
class_name LevelManager

const UI_SCENE = preload("uid://ds020ov238vb5")
const AUDIO_MANAGER = preload("uid://bdq036884f2de")


var player: Player
var ui: UI
var webs: Node2D
var web_blasts: Node2D
@onready var audio_manager = AUDIO_MANAGER.instantiate()

func has_blasts() -> bool:
	return web_blasts.get_child_count() > 0

func _ready() -> void:
	ui = UI_SCENE.instantiate()
	add_child(ui)
	webs = Node2D.new()
	add_child(webs)
	web_blasts = Node2D.new()
	add_child(web_blasts)
	
	player = get_node("Player")
	player.connect('web_shot', _on_player_web_shot)
	player.connect('web_blast', _on_player_web_blast)
	ui.set_shots(player.shots)
	
	add_child(audio_manager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('reset'):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("uid://c1a4pudcw0drg")

func _on_player_web_shot(web: Web) -> void:
	webs.add_child(web)
	ui.set_shots(player.shots)

func _on_player_web_blast(blast: WebBlast) -> void:
	web_blasts.add_child(blast)
	ui.set_shots(player.shots)
	blast.connect('body_entered', _on_blast_body_entered)
	blast.connect('tree_exited', _on_blast_tree_exited)
	
func _on_blast_body_entered(body: Node2D) -> void:
	if body is not LightSwitch:
		audio_manager.get_node("CollisionSound").play()
	else:
		audio_manager.get_node("LightSwitchClickSound").play()
		player.is_winning = true
		var sprite = body.get_node("%Sprite2D")
		sprite.texture = load("res://resources/light_on.tres")
		
		var light_bulbs: Array[LightBulb]
		for node in get_children():
			if node is LightBulb:
				light_bulbs.append(node)
				
		for light_bulb in light_bulbs:
			light_bulb.play('default')
		audio_manager.get_node("BunchOFlyBuzzesSound").play()
		if light_bulbs.size() > 0:
			light_bulbs[0].connect('animation_finished', _on_light_bulb_animation_finished)
			return
		_trigger_next_scene()

func _on_blast_tree_exited() -> void:
	if web_blasts.get_children().size() == 0 and player.shots == 0:
		player.die()

func _on_light_bulb_animation_finished() -> void:
	_trigger_next_scene()
	
func _trigger_next_scene() -> void:
	await get_tree().create_timer(2).timeout
	LevelSwitcher.next_level()
