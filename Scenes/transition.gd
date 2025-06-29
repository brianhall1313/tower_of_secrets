extends Area2D

@export var destination:String 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		LevelDirectory.level_change(destination)
