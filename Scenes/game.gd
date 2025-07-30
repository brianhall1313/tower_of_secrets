extends MetSysGame


func _ready() -> void:
	game_start()

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		print(MetSys.get_save_data())

func game_start():
	MetSys.reset_state()
	MetSys.set_save_data()#pass in save data to save?
	set_player($player)
	load_room("res://Scenes/levels/entry1.tscn")
	add_module("RoomTransitions.gd")
	player.position = Vector2(50,50)
	player.update_ui()
