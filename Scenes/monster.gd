extends Node2D

@export var health: Health

func _ready() -> void:
	health.setup(1,1)

func take_damage(damage:int)-> void:
	health.take_damage(damage)
