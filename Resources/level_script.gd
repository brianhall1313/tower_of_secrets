extends Node2D

@onready var player: Player = $player

func _ready() -> void:
	place_player(GlobalPlayer.player_spawn)


func place_player(from) -> void:
	print("data from ",from)
	if from == "entry":
		return
	if from == "save":
		print("loading from save")
		for child in get_children():
			if child.is_in_group("SavePoint"):
				player.position = child.global_position
				return
	for child in get_children():
		print("loading from room ", from)
		if child.is_in_group("Transition"):
			if child.destination == from:#needs to be destination here, otherwise it will not work
				player.position = child.spawn.global_position
			else:
				print("no destination from ", child.name)
