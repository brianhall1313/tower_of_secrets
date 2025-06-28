extends Node

const CONSUME:String = "consumable"

var items = {
	"potion":{
		"sprite":preload("res://Sprites/potion.png"),
		"type": CONSUME,
		"effect":{
			"heal":100
		}
		},
	"error":{
		"sprite":preload("res://Sprites/error.png"),
		"type": "error",
		}
}

func get_sprite(item_name:String) -> Texture2D:
	if item_name in items.keys():
		if items[item_name]["sprite"]:
			return items[item_name]
	return items["error"]["sprite"]

func get_type(item_name) -> String:
	if item_name in items.keys():
		if items[item_name]["type"]:
			return items[item_name]
	return items["error"]["type"]
	
