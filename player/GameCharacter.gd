extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var color_parts = $ColorParts

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true
	color_parts.playing = true
	pass # Replace with function body.

func apply_color(color):
	color_parts.self_modulate = color
	
func play_animation(anim_name):
	.play(anim_name)
	color_parts.play(anim_name)
	color_parts.frame = 0
	frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
