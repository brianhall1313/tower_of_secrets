extends Node

#levels are rooms in the tower, each will have a name 
#(I figure that will be easier to keep from getting mixed around than just an array index)
#**each will have an entered state
#**each will have a list of pickups,eventually a sprite name,
#their starting position, and their status as picked up or not
#this will be used to populate the items in game

var entry_pos:int = 0
var new_destination:String = ""
var from:String = ""

var level_list:Dictionary = {
	"entry1":{
		"visited":false,
		"scene":load("res://Resources/entry1.tscn"),
		"pickups":[
			{
				"id":"potion",
				"pos":Vector2(0,0),
				"obtained":false
			},
		],
	},
	"entry2":{
		"visited":false,
		"scene":load("res://Resources/entry2.tscn"),
		"pickups":[
			{
				"id":"potion",
				"pos":Vector2(0,0),
				"obtained":false
			},
		],
	},
	"tower1":{
		"visited":false,
		"scene":load("res://Resources/tower1.tscn"),
		"pickups":[
			{
				"id":"potion",
				"pos":Vector2(0,0),
				"obtained":false
			},
		],
	},
	"towerSave":{
		"visited":false,
		"scene":load("res://Resources/towerSave.tscn"),
		"pickups":[],
	},
}


func level_change(destination:String,recieved_from:String)->void:
	if destination in level_list.keys():
		#update player information
		if not level_list[destination]["visited"]:
			level_list[destination]["visited"] = true
			from = recieved_from
			new_destination = destination

func process_level_change() -> void:
	if new_destination != "":
		get_tree().change_scene_to_packed(level_list[new_destination]["scene"])
		GlobalSignalBus.transition.emit(from)
		print("loading to ", new_destination, " from ",from)
		from = ""
		new_destination = ""
	else :
		print("error: no destination")

func save_map() -> Dictionary:
	return level_list

#for resetting data in the local map
func new_game() -> void:
	print("resetting")
	for level in level_list:
		level_list[level]["visited"] = false
		for item in level_list[level]["pickups"]:
			item["obtained"] = false
	print("reset")

func get_percent(slot:String) -> String:
	var temp_list = SaveAndLoad.load_game()[slot]["map"]
	var count:float = 0
	for item in level_list:
		if temp_list[item]["visited"] == true:
			count += 1
	if count == 0:
		return "0.0%"
	return str((count/len(level_list.keys()))*100)+"%" 
