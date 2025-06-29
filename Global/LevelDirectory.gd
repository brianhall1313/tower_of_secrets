extends Node

#levels are rooms in the tower, each will have a name 
#(I figure that will be easier to keep from getting mixed around than just an array index)
#**each will have an entered state
#**each will have a list of pickups,eventually a sprite name,
#their starting position, and their status as picked up or not
#this will be used to populate the items in game

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
	}
}

func level_change(destination)->void:
	if destination in level_list.keys():
		#update player information
		get_tree().change_scene_to_packed(level_list[destination]["scene"])
