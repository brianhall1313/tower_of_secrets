extends Control

@onready var health_bar: ProgressBar = $player_stats/health_bar

func setup(max_health,current_health) -> void:
	update_health(max_health,current_health)
	#update weapon and ability sprites when we actually add them

func update_health(max_health,current_health) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
