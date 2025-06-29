extends Node

signal level_transition(destination:String)

func emit_level_transition(destination:String)->void:
	level_transition.emit(destination)
