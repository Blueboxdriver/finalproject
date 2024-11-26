extends Control

# Method that is called when the scene is loaded.
func _ready() -> void:
	# Object that references the listScore label node.
	var queue_score = $listScore
	# Object that references the total_score label node.
	var total_score = $listScore/TotalScore
	
	# Clear previous text.
	queue_score.text = "" 

	# Loops for every element in the scorekeeping array.
	# And prints out the value to the screen while removing it from the array.
	for i in range(GameManager.scorekeeping.size()):
		var text = GameManager.scorekeeping.pop_front()
		# The score that is pulled is added to the local score variable.
		GameManager.local_score += GameManager.score_dict[text]
		queue_score.text += text + ": " + str(GameManager.score_dict[text]) + "\n"
		await get_tree().create_timer(.5).timeout
	# Shows the calculated total score on the total score label.
	total_score.text = "Total score: " + str(GameManager.local_score)
	
	# If the highscores array size is less than 10 or our local score is
	# greater than the smallest score, show that we're adding the user's score
	# to the leaderboard
	if (GameManager.highscores.size() < 10) or (GameManager.local_score > GameManager.findMin()):
		total_score.text += "\n Score added to leaderboard!"
	# If the above isn't true, inform the user we're not adding their score to the leaderboard.
	else:
		total_score.text += "\n Score to low for leaderboard, try again next time!"
	
	# The local score is then saved to the score file.
	GameManager.save_score()

# Method that restarts the game by resetting game values and sending the player
# Back to the main menu.
func _on_restart_pressed() -> void:
	GameManager.enemyCount = 0
	GameManager.scorekeeping.clear()
	get_tree().change_scene_to_file("res://control.tscn")

# Method that exits the game.
func _on_exit_pressed() -> void:
	get_tree().quit()
