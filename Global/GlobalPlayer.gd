extends Node

@export var max_health:int 
@export var current_health:int

var player_name:String = "Defaulty Defaulterson"
var current_slot:String = "slot 1" #by default
var inventory:Array = []
var player_spawn:String

func _ready() -> void:
	GlobalSignalBus.connect("transition",set_player_spawn)

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

func get_stats() -> Dictionary:
	var data = {}
	data["current_health"] = current_health
	data["max_health"] = max_health
	return data

func load_data(slot:String)->void:
	current_slot = slot
	var data:Dictionary = SaveAndLoad.load_game()[slot]
	setup(data["stats"]["max_health"],data["stats"]["current_health"])
	LevelDirectory.level_change(data["save_location"],"save")
	print("loading")
	LevelDirectory.process_level_change()
	
func save_data(location:String)->void:
	full_heal()
	print("saving...")
	var data = SaveAndLoad.load_game()
	data[current_slot]["map"] = LevelDirectory.save_map()
	data[current_slot]["inventory"] = inventory
	data[current_slot]["player"] = player_name
	data[current_slot]["stats"] = get_stats()
	data[current_slot]["last_save"] = Time.get_datetime_string_from_system()
	data[current_slot]["save_location"] = location
	SaveAndLoad.save_game(data)
	print("saved")
	
func new_game(slot,new_name:String) -> void:
	current_slot = slot
	player_name = new_name
	inventory = []
	setup(100,100)

func set_player_spawn(from) -> void:
	player_spawn = from
