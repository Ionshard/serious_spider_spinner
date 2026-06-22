extends Area2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var new_point: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	ray_cast_2d.target_position = global_position.direction_to(get_global_mouse_position()) * 5000
	
	if Input.is_action_just_pressed('spin_web'):
		if(ray_cast_2d.is_colliding()):
			global_position = ray_cast_2d.get_collision_point() - ray_cast_2d.get_collision_normal()
