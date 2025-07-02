extends Node2D

var data:Dictionary
func _ready() -> void:
	data = SaveAndLoad.load_game()


func _on_go_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_screen.tscn")
