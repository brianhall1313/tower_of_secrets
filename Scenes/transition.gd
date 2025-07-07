extends Area2D

@export var destination:String 
@export var from:String
@export var spawn:Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_transition()
		if destination:
			print("going from " , from, " to ", destination)
			LevelDirectory.level_change(destination,from)
		else:
			print("error, no destination set in ",name)
