extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var USER_DATA_FILE = "user_data"
var best_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = load_data(USER_DATA_FILE)
	if not (data == null):
		print(data)
		best_score = data.best
		$MarginContainer/MainMenu/BestScore/BestScore.text = str(data.best)
		$MarginContainer/MainMenu/Score/Score2.text = str(data.score)
		if data.new_best :
			$MarginContainer/MainMenu/Score/Score2.self_modulate = $MarginContainer/MainMenu/BestScore/BestScore.self_modulate
	else:
		$MarginContainer/MainMenu/Score.visible = false
		best_score = 0
	
	$MarginContainer/OverLay.self_modulate = $MarginContainer/MainMenu.color
	$AnimationPlayer.play("show")
	pass # Replace with function body.

func save_data(data, file, path = "user"):

	## Create and open your file.
	var SAVE_PATH = path+'://'+file+'.json'
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# Convert your data to a useable string-format.
	save_file.store_line(to_json(data))

	# Close file.
	save_file.close()


func load_data(file, empty = null, path = "user"):

	# Create your file
	var SAVE_PATH = path+"://"+file+".json"
	var save_file = File.new()

	# Return 'empty' if file doesn't exist
	if not save_file.file_exists(SAVE_PATH):
		print("ERROR: file does not exist ("+path+"://"+file+".json)")
		return empty

	# Open your file
	save_file.open(SAVE_PATH, File.READ)

	# Save data from file.
	var data = parse_json(save_file.get_as_text())

	# Close file 
	save_file.close()

	# Return data
	return data
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save_score(score):
	var new_best = false
	if best_score < score:
		best_score = score
		new_best = true
		
	var dict = { "score": score, "best": best_score, "new_best": new_best}
	save_data(dict, USER_DATA_FILE)
	
	
func on_hide_finished():
	self.visible = false
	$"../Player/Camera2D".current = true
	$"../Player".pause_physics = false
	pass

func on_show_finished():
	$MarginContainer/OverLay.visible = false
	pass
	
func _on_Button_pressed():
	$MarginContainer/OverLay.self_modulate = $"..".color_palette[0]
	$MarginContainer/OverLay.visible = true
	$AnimationPlayer.play("hide")
	pass # Replace with function body.


func _on_Music_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)   
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)   
	pass # Replace with function body.
