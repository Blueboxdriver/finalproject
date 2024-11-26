extends Control

# Method that is called when the game starts.
# It loads previously saved data.
func _ready() -> void:
	GameManager.load_score()

# Method that reacts to the 'play' button being pressed
# Changing the scene to the 'level1' scene.
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level1.tscn")

# Method that checks if there's a save file, if there it isn't it throws an error.
# If there is a save file, it call's GameManager's load_score method and prints
# the output to the screen.
func _on_view_score_pressed() -> void:
	GameManager.load_score()
	var score_label = $Label
	var left_high = $HBoxContainer/highscore1
	var right_high =$HBoxContainer/highscore2
	var score_split_index = max(0, GameManager.highscores.size() - 5)

	# Clear previous text
	left_high.text = ""
	right_high.text = ""
	# If the lowest score in the highscores array isn't 0, display highscore.
	if (int(GameManager.highscores[0]) != 0):
		# Populate the left_high text with the first part of highscores
		for i in range(score_split_index):
			left_high.text += "Score: " + str(GameManager.highscores[i]) + "  |  \n"

		# Populate the right_high text with the remaining part of highscores
		for i in range(score_split_index, GameManager.highscores.size()):
			right_high.text += " Score: " + str(GameManager.highscores[i]) + "\n"
			
			# If the save file doesn't exist, throw an assertion.
			# This is godot's version of exception handling.
			assert(GameManager.save_file_exists(), "Save file does not exist!")
			
			GameManager.load_score()
			score_label.text = "Score: " + str(GameManager.saved_score)
	# If there's nothing in the highscore array, display nothing.
	else:
			left_high.text = ""
			right_high.text = ""

# Method that exits the game.
func _on_exit_pressed() -> void:
	get_tree().quit()

# Method that deletes the score saved in the save file.
func _on_delete_score_pressed() -> void:
	GameManager.clear_save()
	_on_view_score_pressed()
