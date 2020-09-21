#tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_save_clicked(tilemap):
	var block_design = []
	for row in range(1, 11):
		var y = -10 + row -1
		block_design.append("'")
		for x in range(0,20):
			var cell = tilemap.get_cell(x,y)
			var val  = " "
			
			if cell == 0:
				val = "["
			elif cell == -1:
				val = " "
			elif cell == 1:
				val = "_"
			elif cell == 2:
				val = ']'
			elif cell == 6:
				val = 'e'
			elif cell == 11:
				val = 'c'
			elif cell == 13 or cell == 14:
				val = 'l'
				
			block_design[row-1] += val
		block_design[row-1] += "',"
#		print(block_design[row-1])
	
	return block_design
	
func get_blocks():
	var blocks = []
	var maps = get_children()
	for map in maps:
		var block = on_save_clicked(map)
		blocks.append(block)
	return blocks
	
func get_difficulty_spread():
	var dict = {}
	dict['s'] = [0, 2]
	dict['e'] = [3, 9]
	dict['m'] = [10, 20]
	dict['h'] = [21, 25]
	
	return dict
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		pass
	
