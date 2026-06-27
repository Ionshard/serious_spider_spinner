extends Node

@onready var bleeping_demo: AudioStreamPlayer = %BleepingDemo
@onready var happy_bee: AudioStreamPlayer = %HappyBee
@onready var lightless_dawn: AudioStreamPlayer = %LightlessDawn

func stop() -> void:
	bleeping_demo.stop()
	happy_bee.stop()
	lightless_dawn.stop()


func play_bleeping_demo() -> void:
	stop()
	bleeping_demo.play()

func play_happy_bee() -> void:
	stop()
	happy_bee.play()
	
func play_lightless_dawn() -> void:
	stop()
	lightless_dawn.play()
