extends MetSysGame
@onready var minimap: Control = $player/player_pov/Minimap


func _ready() -> void:
	game_start()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("map"):
		if minimap.visible:
			minimap.hide()
		else:
			minimap.show()


func game_start():
	MetSys.reset_state()
	var data = SaveAndLoad.load_game()
	if data:
		MetSys.set_save_data(data["map"])#pass in save data to save?
	else :
		MetSys.set_save_data()
	set_player($player)
	load_room("res://Scenes/levels/entry1.tscn")
	add_module("RoomTransitions.gd")
	player.position = Vector2(50,50)
	player.update_ui()
	print(MetSys.get_save_data())
