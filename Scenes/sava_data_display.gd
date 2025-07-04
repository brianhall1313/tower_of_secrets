extends VBoxContainer

@onready var save_slot: Label = $save_name
@onready var percent: Label = $percent
@onready var player_name: Label = $player_name
@onready var last_save_time: Label = $last_save_time
@onready var misc: Label = $misc
@onready var load_button: Button = $buttons/load_button
@onready var delete_save: Button = $buttons/delete_save

@export var slot:String = "slot 1"
@export var is_load:bool = false

signal new_game(new_slot)

func setup() -> void:
	var data:Dictionary = SaveAndLoad.load_game()[slot]
	if data:
		save_slot.text = slot
		percent.text = LevelDirectory.get_percent(slot)
		player_name.text = data["player"]
		last_save_time.text = data["last_save"]
	if data["last_save"] == "None" and is_load:
		load_button.disabled = true
		delete_save.disabled = true
	if is_load == false:
		delete_save.hide()
		load_button.text = "New Game"
		


func _on_load_button_button_up() -> void:
	if is_load:
		GlobalPlayer.load_data(slot)
	else:
		#do newgame stuff
		new_game.emit(slot)


func _on_delete_save_button_up() -> void:
	pass # Replace with function body.
