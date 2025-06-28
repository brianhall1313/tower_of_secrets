extends Node2D
@onready var pickup_sprite: Sprite2D = $pickup_sprite
@onready var pickup_hitbox: Area2D = $pickup_hitbox




func setup(item_name:String,new_position:Vector2=Vector2(150,150)) -> void:
	position = new_position
	pickup_sprite.texture = ItemDirectory.get_sprite(item_name)
