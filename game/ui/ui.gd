extends Control
class_name UI

@onready var shot_counter: Panel = %ShotCounter

func set_shots(amount: int) -> void:
	shot_counter.set_shots(amount)
