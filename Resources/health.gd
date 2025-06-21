class_name Health
extends Node

@export var max_health:int 
@export var current_health:int

signal death

func setup(new_max_health:int,new_current_health:int)-> void:
	max_health = new_max_health
	current_health = new_current_health

func take_damage(damage:int) -> void:
	if damage >= current_health:
		current_health = 0
		death.emit()
		return
	current_health = current_health - damage
	#take damage animation/reactions go here
