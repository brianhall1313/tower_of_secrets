extends Node

#levels are rooms in the tower, each will have a name 
#(I figure that will be easier to keep from getting mixed around than just an array index)
#**each will have an entered state
#**each will have a list of pickups,eventually a sprite name,
#their starting position, and their status as picked up or not
#this will be used to populate the items in game

var entry_pos:int = 0

var level_list:Dictionary = {
	"entry1":{
		"visited":false,
		"scene":preload("res://Resources/entry1.tscn"),
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
		"scene":preload("res://Resources/entry2.tscn"),
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
		"scene":preload("res://Resources/tower1.tscn"),
		"pickups":[
			{
				"id":"potion",
				"pos":Vector2(0,0),
				"obtained":false
			},
		],
	},
}


func level_change(destination:String)->void:
	if destination in level_list.keys():
		#update player information
		if not level_list[destination]["visited"]:
			level_list[destination]["visited"] = true
		get_tree().change_scene_to_packed(level_list[destination]["scene"])

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
