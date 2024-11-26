extends Control

# Method that is called when the restart button is pressed.
# When pressed, enemyCount and scorekeeping are cleared, the player is then sent to the main
# menu.
func _on_restart_pressed() -> void:
	GameManager.enemyCount = 0
	GameManager.scorekeeping.clear()
	get_tree().change_scene_to_file("res://control.tscn")

# Method that is called when the exit button is pressed. When pressed,
# the method quits the game.
func _on_exit_pressed() -> void:
	get_tree().quit()
	
