extends CharacterBody2D

# Constant integer representing the speed of the player.
const SPEED = 500.0
# Integer representing the health the player has.
var health = 10

# AnimationPlayer object that represents the AnimationPlayer node for the player.
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# A boolean that represents whether a player is attacking or not.
var isAttacking: bool = false

# Method that when called, sets isAttacking to true and plays the attack animation.
func attack():
	isAttacking = true
	animation_player.play("Attack")

# Method that when called, causes the player to take whatever damage is specified.
# If the player's health is less than 0, they call the die() method.
func take_damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		die()

# Method that when called, immediately changes the scene to the gameover scene.
func die():
	get_tree().change_scene_to_file("res://Gameover.tscn")

# Method that is called every frame. Detects for movement and attack button inputs
# and performs an action depending on the input.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not isAttacking:
		attack()

	# Get the input direction for both axes.
	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	# Normalize the direction so that diagonal movement isn't faster.
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * SPEED
		if not isAttacking:
			animation_player.play("Walk") 
	else:
		velocity = Vector2.ZERO
		if not isAttacking:
			animation_player.play("Idle")

	# Face the mouse position
	look_at(get_global_mouse_position())

	# Apply the movement
	move_and_slide()

# Method that is called whenever an animation is finished.
# If the animation that finished is the attack animation, change isAttacking to false.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		isAttacking = false
