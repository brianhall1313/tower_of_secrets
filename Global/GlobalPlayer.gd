extends Node

@export var max_health:int 
@export var current_health:int

var player_name:String = "Defaulty Defaulterson"
var current_slot:String = "slot1"
var inventory:Array = []

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

func heal(amount:int)->void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	GlobalSignalBus.update_ui.emit()

func full_heal() -> void:
	#add status clearing info here when we do it
	heal(max_health)

func load_data()->void:
	#TODO actually add loading and saving
	setup(100,10)
	
func save_data()->void:
	full_heal()
	print("saving...")
	var data = SaveAndLoad.load_game()
	data[current_slot]["map"] = LevelDirectory.save_map()
	data[current_slot]["inventory"] = inventory
	data[current_slot]["player"] = player_name
	data[current_slot]["last_save"] = Time.get_datetime_string_from_system()
	SaveAndLoad.save_game(data)
	print("saved")
	
func new_game() -> void:
	inventory = []
	setup(100,100)
