extends Area2D
class_name Player

@export var shots = 3
@export var speed = 200
@export var blast_speed = 500

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var shot_indicator: Sprite2D = %ShotIndicator
@onready var shot_spawn: Marker2D = %ShotSpawn
const WEB = preload("uid://c8l4u2mvfe2jq")
const WEB_BLAST = preload("uid://c1yfs6w0107j3")

signal web_shot(web: Web)
signal web_blast(blast: WebBlast)

var new_point: Vector2
var is_moving = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	ray_cast_2d.target_position = global_position.direction_to(get_global_mouse_position()) * 5000
	
	if shots != 0 and Input.is_action_just_pressed("web_blast"):
		var new_blast: WebBlast = WEB_BLAST.instantiate()
		new_blast.global_position = shot_spawn.global_position
		new_blast.linear_velocity = new_blast.global_position.direction_to(get_global_mouse_position()).normalized() * blast_speed
		shots -= 1
		web_blast.emit(new_blast)
		
	
	if shots != 0 and not is_moving and Input.is_action_just_pressed('spin_web'):
		if(ray_cast_2d.is_colliding()):
			new_point = ray_cast_2d.get_collision_point() - ray_cast_2d.get_collision_normal()
			is_moving = true
			var new_web: Line2D = WEB.instantiate()
			new_web.add_point(global_position)
			new_web.add_point(new_point)
			shots -= 1
			web_shot.emit(new_web)
			animated_sprite_2d.play("zoom")
			animated_sprite_2d.rotation = animated_sprite_2d.get_angle_to(new_point) - PI/2
	
	if((global_position - new_point).length_squared() < 5):
		is_moving = false
		animated_sprite_2d.play("move")
		animated_sprite_2d.rotation = 0
			
	if(is_moving):
		global_position = global_position.move_toward(new_point, speed * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		shot_indicator.rotation = get_angle_to(event.position) + PI/2
