extends Node2D


func _ready() -> void:
	#var temp = SaveAndLoad.load_game()
	#if not temp:
	#	print("no save data, creating defaults")
	#	SaveAndLoad.initialize()
	#else:
		pass
		#print(temp)
#quits the game
func _on_exit_button_up() -> void:
	get_tree().quit()

#sets data to defaults
func _on_new_game_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/new_game.tscn")


func _on_load_game_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/load.tscn")

func _on_options_button_up() -> void:
	#TODO replace this!
	#SaveAndLoad.initialize()
	pass
