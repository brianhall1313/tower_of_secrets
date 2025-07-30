extends Node
@export var save_dictionary: Dictionary = {}
@export var data_path="user://save_data.save"

var default_data = {
			"player":"None",
			"inventory":[],
			"last_save":"None"
		}


func save_game(data):
	var full_path = data_path
	var save_file=FileAccess.open(full_path,FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)


func load_game():
	var data = load_json()
	if data:
		print('data loaded')
		return data
	else:
		print("Data failed to load")
		return data


func load_json():
	var full_path = data_path
	if FileAccess.file_exists(full_path):
		var data_file=FileAccess.open(full_path,FileAccess.READ)
		var parsed_data=JSON.parse_string(data_file.get_as_text())
		if parsed_data is Dictionary:
			#print(parsed_data)
			return parsed_data
		else:
			print('parsed data is not a dictionary')
			return false
	else:
		print('Json parse error:file does not exist')
		return false

func create_default(slot) -> void:
	var temp = SaveAndLoad.load_game()
	temp[slot] = default_data.duplicate(true)
	save_game(temp)

func initialize() -> void:
	var temp:Dictionary = {}
	temp["slot 1"] = default_data.duplicate(true)
	temp["slot 2"] = default_data.duplicate(true)
	temp["slot 3"] = default_data.duplicate(true)
	save_game(temp)
