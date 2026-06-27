extends RigidBody2D
class_name WebBlast

@onready var collision_sound: AudioStreamPlayer2D = $CollisionSound


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	call_deferred('queue_free')
