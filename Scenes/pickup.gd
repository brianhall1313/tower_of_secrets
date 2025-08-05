extends Node2D
@onready var pickup_sprite: Sprite2D = $pickup_sprite
@onready var pickup_hitbox: Area2D = $pickup_hitbox
@export var img: Texture2D

func _ready() -> void:
	if img:
		pickup_sprite.texture = img
	MetSys.register_storable_object(self)
	if MetSys.register_storable_object(self):
		return
	print("unregistered")

func pickup(body:Node2D) -> void:
	#body.add_item(self) #adds item to player inventory
	MetSys.store_object(self)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pickup(body)
