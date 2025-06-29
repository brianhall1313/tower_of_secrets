extends Node

@export var max_health:int 
@export var current_health:int

func _ready() -> void:
	#TODO delete this later
	load_data()

func setup(new_max_health:int,new_current_health:int)-> void:
	max_health = new_max_health
	current_health = new_current_health

func take_damage(damage:int) -> void:
	if damage >= current_health:
		current_health = 0
		return
	current_health = current_health - damage

func load_data()->void:
	#TODO actually add loading and saving
	setup(100,10)
func save_data()->void:
	#TODO actually add loading and saving
	pass
