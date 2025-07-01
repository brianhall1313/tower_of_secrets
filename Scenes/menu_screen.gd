extends Node2D



#quits the game
func _on_exit_button_up() -> void:
	get_tree().quit()

#sets data to defaults
func _on_new_game_button_up() -> void:
	LevelDirectory.new_game()
	GlobalPlayer.new_game()
	LevelDirectory.level_change("entry1")


func _on_load_game_button_up() -> void:
	pass # Replace with function body.


func _on_options_button_up() -> void:
	pass # Replace with function body.
