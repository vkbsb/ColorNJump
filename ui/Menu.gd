extends Control

var best_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting the httpRequest")
	var headers = ["auth_token:aFpkWlZtN0Y4TWZ2M1BZZzJrRHF1aVBROWVZU2FCSXdrRUNsb0czVGFLbU9wOUU1aHR8eGlzZGJqakdpQ2VyODhzY0pEczBpcFhuNUhDOFhtenRUR09tdGhzaHpKd2RlN1NMcEk="]
	#https://play.idevgames.co.uk
	var url = "https://play.idevgames.co.uk/request/check/W0ajBLmcWNt3jYON9gxReA79C299wBKvZLksaM5ftiHFh03gIM"
	var http_request = $HTTPRequest
	http_request.connect("request_completed", self, "_on_request_completed")
	http_request.request(url, headers)
	print("End of http request")
	
	var data = PlayerData.data
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
	
func _on_request_completed(result, response_code, headers, body):
	if body.get_string_from_utf8() == "true":
		print("Unlocking all items")
		PlayerData.unlock_all(StoreData.store_data)
	
func _input(event):
	if Input.is_action_just_released("ui_select"):
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			if event.position.y < 100:
				$MarginContainer/MainMenu/Music.pressed = !$MarginContainer/MainMenu/Music.pressed
				_on_Music_toggled($MarginContainer/MainMenu/Music.pressed)
			else:
				_on_Button_pressed()
	
	
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


func _on_ShopButton_pressed():
	if not SceneManager.is_transitioning:
		SceneManager.change_scene("res://ui/StoreScreen.tscn")
#	get_tree().change_scene("res://ui/StoreScreen.tscn")
	pass # Replace with function body.
