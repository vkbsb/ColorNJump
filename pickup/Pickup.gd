extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("pulse")
	$AnimationPlayer.advance(randf())
	pass


func set_pick_color(color):
	$Sprite.modulate = color
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Pickup_body_entered(body):
	if body.name == "Player":
		body.set_pick_color($Sprite.modulate)
		$"..".on_color_pickup($Sprite.modulate)
		queue_free()
