class_name HitArea
extends Area2D

@onready var hitbox: CollisionShape2D = $hitbox
@onready var lifespan: Timer = $lifespan
var power:int
var hit_targets:Array=[]

func _ready() -> void:
	pass


func setup(new_size:Vector2,time:float,parent:CharacterBody2D,damage:int) -> void:
	hitbox.shape.size = new_size
	lifespan.start(time)
	hit_targets.append(parent)
	power = damage
	print("setup")

func finish() -> void:
	print("attack finished")
	self.queue_free()



func _on_lifespan_timeout() -> void:
	finish()


func _on_body_entered(body: Node2D) -> void:
	if !hit_targets.has(body):
		hit_targets.append(body)#so when one attack hits it doesn't re register the hits
		print(body," entered")
		if body.get_parent().has_method("take_damage"):
			if power:
				body.get_parent().take_damage(power)
