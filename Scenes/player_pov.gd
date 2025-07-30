extends Camera2D

@onready var ui: Control = $UI


func update_ui(max_health:int,current_health:int) -> void:
	ui.update_health(max_health,current_health)
