extends MetSysGame
@onready var minimap: Control = $player/player_pov/Minimap
const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")

func _ready() -> void:
	connect_to_global_signal_bus()
	game_start()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("map"):
		if minimap.visible:
			minimap.hide()
		else:
			minimap.show()

func connect_to_global_signal_bus()->void:
	GlobalSignalBus.connect("save",save_game)
	GlobalSignalBus.connect("load",load_game)

func game_start():
	MetSys.reset_state()
	var has_data = FileAccess.file_exists("user://save.sav")
	set_player($player)
	add_module("RoomTransitions.gd")
	if has_data:
		print("loading")
		load_game()
		print("loaded")
		for child in get_children(true):
			if child.name == "level":
				for subchild in child.get_children(true):
					if subchild.is_in_group("SavePoint"):
						print("save point sspawn")
						player.position = subchild.global_position
	else :
		print("no save data found, new game")
		MetSys.set_save_data()
		load_room("res://Scenes/levels/entry1.tscn")
		player.position = Vector2(50,50)
	player.update_ui()
	print(MetSys.get_save_data())

func save_game() -> void:
	print("saving")
	var saver := SaveManager.new()
	saver.set_value("current_room", MetSys.get_current_room_name())
	#saver.store_resource(player.stats, "player_stats") we aren't doing this yet
	saver.save_as_text("user://save.sav")
	print("saved")

func load_game() -> void:
	var loader := SaveManager.new()
	loader.load_from_text("user://save.sav")
	#loader.retrieve_resource(player.stats, "player_stats")
	change_map_to(loader.get_value("current_room"))

func change_map_to(val)->void:
	load_room(val)
