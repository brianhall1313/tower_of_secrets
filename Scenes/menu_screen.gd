extends Node2D


func _ready() -> void:
	
	var temp = SaveAndLoad.load_game()
	if not temp:
		print("no save data, creating defaults")
		SaveAndLoad.create_default()
	else:
		#print(temp)
		print(OS.get_data_dir())
#quits the game
func _on_exit_button_up() -> void:
	get_tree().quit()

#sets data to defaults
func _on_new_game_button_up() -> void:
	LevelDirectory.new_game()
	GlobalPlayer.new_game()
	LevelDirectory.level_change("entry1")
	LevelDirectory.process_level_change()


func _on_load_game_button_up() -> void:
	pass # Replace with function body.


func _on_options_button_up() -> void:
	#TODO replace this!
	SaveAndLoad.create_default()
