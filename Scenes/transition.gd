extends Area2D

@export var destination:String 


func _on_body_entered(body: Node2D) -> void:
	GlobalSignalBus.emit_level_transition(destination)
