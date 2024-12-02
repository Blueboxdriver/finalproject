# Thank you to 'GDQuest' for this code: https://www.youtube.com/watch?v=JWjzSn95bM0
class_name HurtBox
extends Area2D

# Method that is called when the node is initialized. It sets collision_layer and mask
# to interact with the hurtbox node.
func _init() -> void:
	collision_layer = 0
	collision_mask = 2

# Method that is called when the game starts. Connects the "area_entered" event
# to the _on_area_entered method.
func _ready() -> void:
	connect("area_entered", _on_area_entered)

# Method that is called whenever the myhurtbox collision area is entered.
# If the owner of the object entering the area has a method 'take_damage'
# the owner calls that method.
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
	
