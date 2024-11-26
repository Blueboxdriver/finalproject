class_name HitBox
extends Area2D

# Integer representing the universal damage value for both enemy and player.
@export var damage: int = 10

# Method that is called when the node is initialized. It sets collision_layer and mask
# to interact with the hurtbox node.
func _init() -> void:
	collision_layer = 2
	collision_mask = 0
