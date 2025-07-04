extends Area2D

@export var destination:String 
@export var from:String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_transition()
		if destination:
			LevelDirectory.level_change(destination,from)
		else:
			print("error, no destination set in ",name)
