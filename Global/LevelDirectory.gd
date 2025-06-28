extends Object

#levels are rooms in the tower, each will have a name 
#(I figure that will be easier to keep from getting mixed around than just an array index)
#**each will have an entered state
#**each will have a list of pickups,eventually a sprite name,
#their starting position, and their status as picked up or not
#this will be used to populate the items in game

var level_list:Dictionary = {
	"entry":{
		"visited":false,
		"pickups":[
			{
				"id":"potion",
				"pos":Vector2(0,0),
				"obtained":false
			},
		],
	}
}
