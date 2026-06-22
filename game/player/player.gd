extends Area2D
class_name Player

@export var shots = 3

@onready var ray_cast_2d: RayCast2D = $RayCast2D
const WEB = preload("uid://c8l4u2mvfe2jq")
signal web_shot(web: Web)

var new_point: Vector2
var is_moving = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	ray_cast_2d.target_position = global_position.direction_to(get_global_mouse_position()) * 5000
	
	if shots != 0 and not is_moving and Input.is_action_just_pressed('spin_web'):
		if(ray_cast_2d.is_colliding()):
			new_point = ray_cast_2d.get_collision_point() - ray_cast_2d.get_collision_normal()
			is_moving = true
			var new_web: Line2D = WEB.instantiate()
			new_web.add_point(global_position)
			new_web.add_point(new_point)
			web_shot.emit(new_web)
			shots -= 1
	
	if((global_position - new_point).length_squared() < 1):
		is_moving = false
			
	if(is_moving):
		global_position = global_position.move_toward(new_point, 500 * delta)
