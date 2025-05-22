class_name Health
extends Node

@export var max_health:int 
@export var current_health:int

signal death

func setup(max:int,current:int)-> void:
	max_health = max
	current_health = current

func take_damage(damage:int) -> void:
	if damage >= current_health:
		current_health = 0
		death.emit()
		return
	current_health = current_health - damage
	#take damage animation/reactions go here
