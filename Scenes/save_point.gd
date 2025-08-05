extends Node2D

@export var location:String

var player_in_range:bool = false

func _process(_delta: float) -> void:
	if player_in_range:
		if Input.is_action_just_released("interact"):
			save()

func save() -> void:
	print("save called")
	print(MetSys.get_save_data())
	var data = {
		"map":MetSys.get_save_data()
	}
	SaveAndLoad.save_game(data)
	#MetSys.get_save_data() will get you a dict to save from
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
