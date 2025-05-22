class_name HitArea
extends Area2D

@onready var hitbox: CollisionShape2D = $hitbox
@onready var lifespan: Timer = $lifespan


func _ready() -> void:
	pass


func setup(new_size:Vector2,time:float) -> void:
	hitbox.shape.size = new_size
	lifespan.start(time)
	print("setup")

func finish() -> void:
	print("attack finished")
	self.queue_free()



func _on_lifespan_timeout() -> void:
	finish()
