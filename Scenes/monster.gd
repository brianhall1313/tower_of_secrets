extends CharacterBody2D

@export var health: Health
@onready var aggro_range: Area2D = $aggro_range
@onready var aggro_timer: Timer = $aggro_timer
@onready var sight_line: RayCast2D = $sight_line


@export var movement_data: PlayerMovementData
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target:Node2D
var direction:float = -1.0

func _ready() -> void:
	health.setup(1,1)
	health.connect("death",death)

func _process(delta: float) -> void:
	if target:
		#move toward player
		sight_line.target_position = target.position - position#points at player
		#if the player is the thing struk, move towards them laterally, attacking if able
		if sight_line.get_collider() == target:
			print("I see you!")
			if position.y-target.position.y > 0:
				direction = -1.0
			else:
				direction = 1.0
			process_move(delta)
	elif aggro_timer.time_left > 0.0:
		velocity = Vector2.ZERO
	else:
		patrol()
	move_and_slide()

func process_move(delta:float) -> void:
	handle_gravity(delta)
	handle_acceleration(delta)
	handle_air_acceleration(delta)
	handle_friction(delta)
	handle_air_resistance(delta)
	
	

func patrol() -> void:
	pass


func handle_gravity(delta:float)->void:
	if not is_on_floor():
		velocity.y += gravity * delta
func handle_acceleration(delta:float) -> void:
	if direction != 0 and is_on_floor():
		velocity.x = move_toward(velocity.x,direction * movement_data.speed,movement_data.acceleration*delta)

func handle_air_acceleration(delta:float) -> void:
	if direction != 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x,direction * movement_data.speed,movement_data.air_acceleration*delta)

func handle_friction(delta:float) -> void:
	if direction==0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction*delta)

func handle_air_resistance(delta:float) -> void:
	if direction==0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance*delta)

func take_damage(damage:int)-> void:
	health.take_damage(damage)

func death() -> void:
	#death animation stuff
	queue_free()


func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sight_line.target_position = body.global_position
		print("I see you~")
		target = body


func _on_aggro_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Where did you go~")
		target = null
		aggro_timer.start(3)
