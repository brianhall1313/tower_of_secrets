extends CharacterBody2D

@export var health: Health
@onready var aggro_range: Area2D = $aggro_range
@onready var aggro_timer: Timer = $aggro_timer
@onready var sight_line: RayCast2D = $sight_line
@onready var left_collision: RayCast2D = $left_collision
@onready var right_collision: RayCast2D = $right_collision
#cooldown is for how there should be inbetween attacks
@onready var attack_cooldown: Timer = $attack_cooldown
#how long it takes for an attack to take
@onready var attack_time: Timer = $attack_time

@export var movement_data: PlayerMovementData

#attack base
@onready var melee_box = preload("res://Resources/attack_hit_area.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target:Node2D
var direction:float = 0.0
@export var last_direction:float = -1.0#defaults to left, but export so that monsters can have a different default if necessary.
var patrolling:bool = true
#for testing purposes 50, will make this a check eventually with a set of attack objects
var attack_dir:Dictionary = {
	"range":50.0,
	"size":Vector2(100,100),
	"time":3
}


func _ready() -> void:
	health.setup(1,1)
	health.connect("death",death)

func _process(delta: float) -> void:
	if attack_time.is_stopped():
		if target:
			if target_in_range() and attack_cooldown.is_stopped():
				print("I should attack you!")
				attack()
			else:
				target_movement()
		if patrolling:
			patrol()
		process_move(delta)
		move_and_slide()

func process_move(delta:float) -> void:
	handle_gravity(delta)
	handle_acceleration(delta)
	handle_air_acceleration(delta)
	handle_friction(delta)
	handle_air_resistance(delta)
	
func target_movement() -> void:
	#move toward player
	sight_line.target_position = target.position - position#points at player
	#if the player is the thing struk, move towards them laterally, attacking if able
	if sight_line.get_collider() == target:
		#print("I see you!")
		#print(target.position-position)
		if position.x-target.position.x > 0:
			#print("left")
			direction = -1.0
			last_direction = direction
		else:
			#print("right")
			direction = 1.0
			last_direction = direction
		
	else:
		print("I don't see you")
		patrolling = true


func patrol() -> void:
	if direction == 0.0:
		direction = last_direction
	else:
		if is_on_wall():
			direction = direction * -1.0
			last_direction = direction
	if direction == 1.0:
		if not right_collision.get_collider():
			direction = -1.0
	else: 
		if not left_collision.get_collider():
			direction = 1.0


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

func target_in_range() -> bool:
	if target:
		if position.distance_to(target.position) <= attack_dir["range"]:
			return true
	return false

func attack() -> void:
		attack_cooldown.start(15)
		attack_time.start(attack_dir["time"])
		print("attack time!")
		var new:HitArea= melee_box.instantiate()
		add_child(new)
		new.global_position = global_position
		new.setup(attack_dir["size"],attack_dir["time"],self,10)#shape,time,origin,damage
		print("attack_launched")

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sight_line.target_position = body.global_position
		print("I see you~")
		target = body
		patrolling = false


func _on_aggro_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Where did you go~")
		target = null
		patrolling = true
