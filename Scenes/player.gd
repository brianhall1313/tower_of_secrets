class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $coyote_timer
@onready var wall_jump_timer: Timer = $wall_jump_timer
@onready var attack_timer: Timer = $attack_timer
@onready var player_sprite: AnimatedSprite2D = $player_sprite
@onready var health: Health = $Health

#attack base
@onready var melee_box = preload("res://Resources/attack_hit_area.tscn")

@export var movement_data: PlayerMovementData

var sprite_height:float = 16
var is_jumping:bool = false
var is_falling:bool = false
var wall_jump_available:bool = false
var floor_offset:float = sprite_height/2
var air_jumps:bool = true
var last_direction:float = 1
var to_transition:bool = false




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	update_ui()
#	animated_sprite.play("idle")


func connect_signals() -> void:
	GlobalSignalBus.connect("update_ui",update_ui)

func _physics_process(delta):
	if (is_jumping or is_falling) and is_on_floor():
		is_jumping = false
		is_falling = false
		air_jumps = true
		#landing_animation()
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		last_direction = direction
	if attack_timer.is_stopped():
		handle_wall_jump()
		handle_jump()
		handle_gravity(delta)
		handle_acceleration(direction,delta)
		handle_air_acceleration(direction,delta)
		handle_friction(direction,delta)
		handle_air_resistance(direction,delta)
	else:
		velocity = Vector2.ZERO
	handle_attack()
	handle_animation(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	wall_jump_available = is_on_wall_only()
	if wall_jump_available: 
		wall_jump_timer.start()
	if was_on_floor and not is_on_floor() and not is_jumping:
		print("is falling")
		is_falling = true
		coyote_timer.start()


func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_wall_jump():
	var wall_normal = get_wall_normal()
	#wall normal points away from the wall,this is the direction you want to go
	if is_on_wall_only() or wall_jump_available:
		if Input.is_action_just_pressed("move_left") and wall_normal == Vector2.LEFT:
			velocity.x = wall_normal.x * movement_data.speed
			velocity.y = movement_data.jump_velocity
			is_jumping = true
			#AudioController.jump.play()
			#wall_animation("left")
		if Input.is_action_just_pressed("move_right") and wall_normal == Vector2.RIGHT:
			velocity.x = wall_normal.x * movement_data.speed
			velocity.y = movement_data.jump_velocity
			is_jumping = true
			#AudioController.jump.play()
			#wall_animation("right")


func handle_jump():
	if  is_on_floor() or coyote_timer.time_left > 0:
		if Input.is_action_just_pressed("jump") and not is_jumping:
			is_jumping = true
			velocity.y = movement_data.jump_velocity
			#AudioController.jump.play()
			return
	elif not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			if air_jumps:
				print("air jump")
				air_jumps = false
				velocity.y = movement_data.air_jump_velocity
				#AudioController.jump.play()
				return
		#shorten jump
		if Input.is_action_just_released("jump"):
			if velocity.y < movement_data.jump_velocity/2:
				velocity.y = movement_data.jump_velocity/2


func handle_acceleration(direction,delta):
	if direction != 0 and is_on_floor():
		velocity.x = move_toward(velocity.x,direction * movement_data.speed,movement_data.acceleration*delta)

func handle_air_acceleration(direction,delta):
	if direction != 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x,direction * movement_data.speed,movement_data.air_acceleration*delta)

func handle_friction(direction,delta):
	if direction==0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction*delta)

func handle_air_resistance(direction,delta):
	if direction==0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance*delta)

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
		new.global_position = global_position
		new.setup(Vector2(100,8),1,self,10)
		print("attack_launched")
		


func handle_animation(_direction):
	pass

func take_damage(damage:int) -> void:
	health.take_damage(damage)
	update_ui()
	if health.current_health <= 0:
		death()
	#TODO play damage taken animation

func update_ui()->void:
	GlobalSignalBus.update_ui.emit(health.max_health,health.current_health)

func death() -> void:
	#play death animation
	print("player death")
	#TODO don't do this after we make a death screen lol
	get_tree().quit()
