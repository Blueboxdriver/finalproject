extends Node

# Integer that stores the score acquired from a save file.
var saved_score = 0
# Integer that stores the score acquired in the current play session.
var local_score = 0
# An array that is used as a queue data struction to store scorekeeping strings.
var scorekeeping = []
# An array that stores every saved score integer. Starts as empty.
var highscores = []
# Constant string that holds the relative path to the save file.
const SAVE_FILE: String = "res://score.txt"
# Integer that stores the amount of enemies in a level.
var enemyCount: int = 0

# Dictionary that assigns a number [1-10] to a string.
var string_dict = {
	1: "Mop-up",
	2: "Cleanup",
	3: "Sanitized",
	4: "Killtubular",
	5: "Helltastic",
	6: "Psychotic",
	7: "Profiteer",
	8: "Warcriminal",
	9: "Wing Slave",
	10: "Rat-Sweeper"
}
# Dictionary that assigns a string to a integer representing the score value of the string.
var score_dict = {
	"Mop-up": 200,
	"Cleanup": 200,
	"Sanitized": 250,
	"Killtubular": 250,
	"Helltastic": 300,
	"Psychotic": 300,
	"Profiteer": 350,
	"Warcriminal": 350,
	"Wing Slave": 400,
	"Rat-Sweeper": 400
}

# Method that is called by an enemy dying. Decreases the enemy count by one.
# If the enemy count is equal or less than 0, the game ends and the player
# is sent to the score scene.
func decrease_enemy_amount():
	enemyCount -= 1
	if enemyCount <= 0:
		get_tree().change_scene_to_file("res://score.tscn")

# Method that when called, opens the save file and writes every element from
# highscores into it, separating each value with a comma as the delimiter.
func save_score():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	# If the size of highscores is 10, we need to see if we can replace
	# The lowest score with the current score.
	if (highscores.size() == 10):
		if (local_score > findMin()):
			highscores[highscores.size() - 1] = str(local_score)
	# If our highscores array has a size of less than 10, add it anyways.
	else:
		highscores.append(str(local_score))
	if file:
		# Create a single comma-separated string from the highscores array.
		var scores_line = ",".join(highscores)
		file.store_string(scores_line)
		local_score = 0
		file.close()

# Method that when called, calls on bubbleSort() to sort the highscores and then
# grabs the last value in the highscores array.
func findMin() -> int:
	bubbleSort()
	return int(highscores[highscores.size() - 1])
	
# Method that when called, uses the bubblesort algorithm to sort the highscores array.
# It's limited to highscores because that's the only array that needs to be sorted.
func bubbleSort():
	var tempArray = []
	
	for score in highscores:
		tempArray.append(int(score))
	var tempSize = tempArray.size()
	
	for i in range(tempSize):
		for j in range(tempSize - 1 - i):
			if tempArray[j] < tempArray[j + 1]:
				var temp = tempArray[j]
				tempArray[j] = tempArray[j + 1]
				tempArray[j + 1] = temp
	highscores.clear()
	
	for score in tempArray:
		highscores.append(str(score))

# Method that when called, opens the save file and takes the data from the first line
# and separates each value using the comma as a delimiter.
# Each value is pushed into the highscores array.
func load_score():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var line = file.get_line().strip_edges()
		highscores = line.split(",")
		file.close()
	else:
		print("Error: Could not open save file for reading.")
	bubbleSort()

# Method that when called, opens the save file with the intention to write to it.
# Then closes it, wiping all the data.
func clear_save():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.close()

# Helper function that returns whether or not the save file exists.
func save_file_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE)
