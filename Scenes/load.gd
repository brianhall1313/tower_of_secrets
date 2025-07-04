extends Node2D

@onready var save_data_1: VBoxContainer = $UI/load_ui/load_selection/save_data
@onready var save_data_2: VBoxContainer = $UI/load_ui/load_selection/save_data2
@onready var save_data_3: VBoxContainer = $UI/load_ui/load_selection/save_data3


func _ready() -> void:
	save_data_1.setup()
	save_data_2.setup()
	save_data_3.setup()

func _on_go_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_screen.tscn")
