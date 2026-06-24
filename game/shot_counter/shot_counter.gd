extends Control

@onready var amount_label: Label = %Amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_shot(amount: int) -> void:
	amount_label.text = str(amount)
