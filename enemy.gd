extends CharacterBody2D
# Constant integer that represents the speed of the enemy.
const SPEED = 100
# AnimationPlayer object that references our AnimationPlayer node.
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Integer representing the health the enemy has
var health: int = 10 
# RandomNumberGenerator object used to generate a random number for scoring purposes
var rng = RandomNumberGenerator.new()
# Empty variable that's meant to hold a Node2D object.
var player = null
# Boolean used to represent whether an attack animation is ongoing.
var isAttacking: bool = false

# This method is called every frame to detect for a player in it's detection radius
# and move towards the player.
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if player:
		var direction = position.direction_to(player.position)
		rotation = direction.angle()
		velocity = position.direction_to(player.position) * SPEED
		
		if not isAttacking:
			animation_player.play("Walk")
	move_and_slide()

# Method is called on initialization, adding 1 to GameManager's enemyCount variable.
func _ready() -> void:
	GameManager.enemyCount += 1

# Method that is called whenever the enemy's hurtbox is collided with an hitbox.
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()

# method that is called when an enemy's health reaches 0. 
# Generates a random number that corresponds to a string and adds it to the GameManager's
# scorekeeping queue.
func die() -> void:
	var random_number = rng.randi_range(1, 10)
	# The random number corresponds with a string in the string_dict dictionary.
	GameManager.scorekeeping.push_back(GameManager.string_dict[random_number])
	GameManager.decrease_enemy_amount()
	self.queue_free()

# Method that is called whenever a Node2D object enters the enemy's detection radius
# collision shape. When called, it populates the empty player variable
# With data from the Node2D object entering the detection radius.
func _on_detection_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Use a group for the Player
		player = body

# Method that is called whenever an Node2D object leaves the enemy's detection radius.
# When called, if the object leaving the radius is a part of the player group, the previously
# populated player variable is made null.
func _on_detection_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null

# Method that when called activates the attacking animation and turns isAttacking to true.
func attack():
	isAttacking = true
	animation_player.play("Attack")

# Method that when the attacking animation is finished, the isAttacking boolean is changed
# to false.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		isAttacking = false

# Called when a 2D object enters the attack radius, waiting .35 seconds before
# calling the attack() method.
func _on_attack_radius_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(.35).timeout
	attack()
