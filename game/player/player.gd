extends Area2D
class_name Player

@export var shots = 3
@export var speed = 200
@export var blast_speed = 500

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var shot_indicator: Sprite2D = %ShotIndicator
@onready var shot_spawn: Marker2D = %ShotSpawn

@onready var web_shot_sound: AudioStreamPlayer2D = $WebShotSound
@onready var no_shoot_sound: AudioStreamPlayer2D = $NoShootSound
@onready var sleep_sound: AudioStreamPlayer2D = $SleepSound
@onready var web_blast_sound: AudioStreamPlayer2D = $WebBlastSound


const WEB = preload("uid://c8l4u2mvfe2jq")
const WEB_BLAST = preload("uid://c1yfs6w0107j3")

signal web_shot(web: Web)
signal web_blast(blast: WebBlast)

@onready var pink_bow: Sprite2D = %PinkBow

var prev_collision_point: Vector2
var new_point: Vector2
var new_rotation: float
var is_moving = false
var is_dead = false
var is_winning = false

func _show_bow(visible: bool) -> void:
	if not Config.cuteMode:
		return
	pink_bow.visible = visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prev_collision_point = global_position
	_show_bow(true)
	if Config.cuteMode:
		%CuteSound.play()

func _physics_process(delta: float) -> void:
	ray_cast_2d.target_position = global_position.direction_to(get_global_mouse_position()) * 5000
	
	if ray_cast_2d.is_colliding():
		shot_indicator.modulate = Color(1, 1, 1, 0.7)
	else:
		shot_indicator.modulate = Color(0.3, 0.3, 0.3, 0.5)
	
	if shots != 0 and Input.is_action_just_pressed("web_blast"):
		web_blast_sound.play()
		var new_blast: WebBlast = WEB_BLAST.instantiate()
		new_blast.global_position = shot_spawn.global_position
		new_blast.linear_velocity = new_blast.global_position.direction_to(get_global_mouse_position()).normalized() * blast_speed
		shots -= 1
		web_blast.emit(new_blast)
	
	#if shots != 0 and not is_moving and Input.is_action_just_pressed('spin_web'):
	if shots != 0 and Input.is_action_just_pressed('spin_web'):
		if not ray_cast_2d.is_colliding():
			no_shoot_sound.play()
		else:
			var collision_point = ray_cast_2d.get_collision_point()
			var collision_normal = ray_cast_2d.get_collision_normal()
			new_point = collision_point + (collision_normal*3)
			new_rotation = collision_normal.angle() + PI/2
			is_moving = true
			var new_web: Line2D = WEB.instantiate()
			if is_moving:
				new_web.add_point(global_position)
			else:
				new_web.add_point(prev_collision_point)
			new_web.add_point(collision_point)
			prev_collision_point = collision_point
			shots -= 1
			web_shot.emit(new_web)
			animated_sprite_2d.play("zoom")
			_show_bow(false)
			animated_sprite_2d.rotation = animated_sprite_2d.get_angle_to(new_point) - PI/2
			web_shot_sound.play()
	
	if is_moving and (global_position - new_point).length_squared() < 5:
		is_moving = false
		animated_sprite_2d.play("move")
		_show_bow(true)
		animated_sprite_2d.rotation = new_rotation
		print("landeded with shots: ", str(shots))
		if shots == 0 and not get_parent().has_blasts():
			die()
			
	if(is_moving):
		global_position = global_position.move_toward(new_point, speed * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		shot_indicator.rotation = get_angle_to(event.position) + PI/2

func die() -> void:
	if is_winning: return
	is_dead = true
	if not is_moving:
		_be_dead()
		
func _be_dead() -> void:
	sleep_sound.play()
	animated_sprite_2d.play('die')
	animated_sprite_2d.connect('animation_finished', _after_dead)
	pink_bow.position.y += 5

func _after_dead() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()
