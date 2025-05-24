extends CharacterBody2D

@export var health: Health
@onready var aggro_range: Area2D = $aggro_range
@onready var aggro_timer: Timer = $aggro_timer
@onready var sight_line: RayCast2D = $sight_line

var target:Node2D

func _ready() -> void:
	health.setup(1,1)
	health.connect("death",death)

func _process(delta: float) -> void:
	if target:
		#move toward player
		process_move(delta)
	elif aggro_timer.time_left > 0.0:
		velocity = Vector2.ZERO
	else:
		patrol()
func process_move(delta:float) -> void:
	pass
func patrol() -> void:
	pass

func take_damage(damage:int)-> void:
	health.take_damage(damage)

func death() -> void:
	#death animation stuff
	queue_free()


func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sight_line.target_position = body.position
		print("I see you~")
		target = body


func _on_aggro_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Where did you go~")
		target = null
		aggro_timer.start(3)
