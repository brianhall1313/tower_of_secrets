extends Node2D

@onready var save_data: VBoxContainer = $UI/load_ui/load_selection/save_data
@onready var save_data_2: VBoxContainer = $UI/load_ui/load_selection/save_data2
@onready var save_data_3: VBoxContainer = $UI/load_ui/load_selection/save_data3
@onready var new_game_screen: Control = $UI/new_game_screen
@onready var name_entry_field: TextEdit = $UI/new_game_screen/PanelContainer/VBoxContainer/name_entry_field

var new_save_slot:String

func _ready() -> void:
	save_data.setup()
	save_data_2.setup()
	save_data_3.setup()
	new_game_screen.hide()


func _on_go_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_screen.tscn")


func _on_save_data_new_game(new_slot: Variant) -> void:
	new_save_slot = new_slot
	new_game_screen.show()


func _on_cancel_new_game_button_up() -> void:
	name_entry_field.clear()
	new_game_screen.hide()


func _on_new_game_button_up() -> void:
	if name_entry_field.text != "":
		LevelDirectory.new_game()
		GlobalPlayer.new_game(new_save_slot,name_entry_field.text)
		LevelDirectory.level_change("entry1")
		LevelDirectory.process_level_change()
