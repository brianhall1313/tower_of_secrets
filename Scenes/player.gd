extends Node2D

@onready var coyote_timer: Timer = $coyote_timer
@onready var wall_jump_timer: Timer = $wall_jump_timer
@onready var player_sprite: AnimatedSprite2D = $player_body/player_sprite
@onready var attack_timer: Timer = $attack_timer
@onready var player_body: CharacterBody2D = $player_body

#attack base
@onready var melee_box = preload("res://Resources/attack_hit_area.tscn")

@export var movement_data: PlayerMovementData
@export var health: Health

var sprite_height:float = 16
var is_jumping:bool = false
var is_falling:bool = false
var wall_jump_available:bool = false
var floor_offset:float = sprite_height/2
var air_jumps:bool = true
var last_direction:float = 1

const PUSH_FORCE = 20


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health
#	animated_sprite.play("idle")
func _physics_process(delta):
	if (is_jumping or is_falling) and player_body.is_on_floor():
		is_jumping = false
		is_falling = false
		air_jumps = true
		#landing_animation()
	handle_gravity(delta)
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		last_direction = direction
	if attack_timer.is_stopped():
		handle_wall_jump()
		handle_jump()
		handle_acceleration(direction,delta)
		handle_air_acceleration(direction,delta)
		handle_friction(direction,delta)
		handle_air_resistance(direction,delta)
	else:
		player_body.velocity = Vector2.ZERO
	handle_attack()
	handle_animation(direction)
	var was_on_floor = player_body.is_on_floor()
	player_body.move_and_slide()
	wall_jump_available = player_body.is_on_wall_only()
	if wall_jump_available: 
		wall_jump_timer.start()
	if was_on_floor and not player_body.is_on_floor() and not is_jumping:
		is_falling = true
		coyote_timer.start()


func handle_gravity(delta):
	if not player_body.is_on_floor():
		player_body.velocity.y += gravity * delta


func handle_wall_jump():
	var wall_normal = player_body.get_wall_normal()
	#wall normal points away from the wall,this is the direction you want to go
	if player_body.is_on_wall_only() or wall_jump_available:
		if Input.is_action_just_pressed("move_left") and wall_normal == Vector2.LEFT:
			player_body.velocity.x = wall_normal.x * movement_data.speed
			player_body.velocity.y = movement_data.jump_velocity
			is_jumping = true
			#AudioController.jump.play()
			#wall_animation("left")
		if Input.is_action_just_pressed("move_right") and wall_normal == Vector2.RIGHT:
			player_body.velocity.x = wall_normal.x * movement_data.speed
			player_body.velocity.y = movement_data.jump_velocity
			is_jumping = true
			#AudioController.jump.play()
			#wall_animation("right")


func handle_jump():
	if  player_body.is_on_floor() or coyote_timer.time_left > 0:
		if Input.is_action_just_pressed("jump"):
			is_jumping = true
			player_body.velocity.y = movement_data.jump_velocity
			#AudioController.jump.play()
			return
	elif not player_body.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			if air_jumps:
				air_jumps = false
				player_body.velocity.y = movement_data.air_jump_velocity
				#AudioController.jump.play()
				return
		#shorten jump
		if Input.is_action_just_released("jump"):
			if player_body.velocity.y < movement_data.jump_velocity/2:
				player_body.velocity.y = movement_data.jump_velocity/2


func handle_acceleration(direction,delta):
	if direction != 0 and player_body.is_on_floor():
		player_body.velocity.x = move_toward(player_body.velocity.x,direction * movement_data.speed,movement_data.acceleration*delta)

func handle_air_acceleration(direction,delta):
	if direction != 0 and not player_body.is_on_floor():
		player_body.velocity.x = move_toward(player_body.velocity.x,direction * movement_data.speed,movement_data.air_acceleration*delta)

func handle_friction(direction,delta):
	if direction==0 and player_body.is_on_floor():
		player_body.velocity.x = move_toward(player_body.velocity.x, 0, movement_data.friction*delta)

func handle_air_resistance(direction,delta):
	if direction==0 and not player_body.is_on_floor():
		player_body.velocity.x = move_toward(player_body.velocity.x, 0, movement_data.air_resistance*delta)

func handle_attack() -> void:
	#-1 == left
	#1 == right
	if Input.is_action_just_released("attack"):
		if attack_timer.time_left > 0:
			print(attack_timer.time_left)
			return
		attack_timer.start(1)
		print("attack time!")
		var new:HitArea= melee_box.instantiate()
		add_child(new)
		new.global_position = player_body.global_position
		new.setup(Vector2(100,8),1)
		print("attack_launched")
		
	

func handle_animation(_direction):
	pass
