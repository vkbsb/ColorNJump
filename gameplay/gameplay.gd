extends Control

export(int) var kill_area_offset

var BLOCK_DESIGN = preload("res://level_design/design.tscn")
var player
var kill_area 
var tilemap
var blocks = []
var difficulty_spread
var num_blocks_added = 0
var top_offset = -10
var threshold_value = 10
export(Array, PoolColorArray) var ColorPalettes
var color_palette

var COLOR_PICKUP = preload("res://pickup/ColorPickup.tscn")
var ENEMY = preload("res://enemies/Enemy.tscn")
var LIFT = preload("res://pickup/SlidingBlock.tscn")

var game_score = 0
var random = RandomNumberGenerator.new()
var difficulty_curve = "seemeeseememmhmmem"
var flag_y = 0

func add_block(block_indx, x_offset, y_offset):
	var platform = blocks[block_indx]
	
	var left_offset = x_offset
	var top_offset = y_offset - platform.size()
	randomize()
	
	#keep track of how many blocks were added.
	num_blocks_added += 1
	
	for row in platform:
		var is_left = true
		for c in row:
			if c == '[':
				tilemap.set_cell(left_offset, top_offset, 0)
			elif c == ']':
				tilemap.set_cell(left_offset, top_offset, 2)
			if c == "|":
				if is_left:
					tilemap.set_cell(left_offset, top_offset, 4)
					is_left = false
				else:
					tilemap.set_cell(left_offset, top_offset, 3)
			elif c == "_":
				is_left = false
				tilemap.set_cell(left_offset, top_offset, 1)
			elif c == 'e':
				tilemap.set_cell(left_offset, top_offset, 1)
				var pos = tilemap.map_to_world(Vector2(left_offset, top_offset))
				var pu = ENEMY.instance()
				pos.y += 16
				pos.x += 16
				pu.position = pos
				add_child(pu)
			elif c == 'c':
				tilemap.set_cell(left_offset, top_offset, 1)
				var pos = tilemap.map_to_world(Vector2(left_offset, top_offset))
				var pu = COLOR_PICKUP.instance()
				add_child(pu)
				pu.set_pick_color(color_palette[random.randi_range(1, color_palette.size()-1)])
				pos.y += 16
				pos.x += 16
				pu.position = pos
			elif c == 'l':
				#TODO: add code for spawning the moving elevators using kinematic body.
				var pu = LIFT.instance()
				var pos = tilemap.map_to_world(Vector2(left_offset, top_offset))
				pos.y += 16
				pos.x += 16
				add_child(pu)
				pu.position = pos
			else:
#				is_left = false
				pass
			left_offset += 1
		left_offset = x_offset
		top_offset += 1
		
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	kill_area = $KillArea
	tilemap = $TileMap
	random.randomize()
	color_palette = ColorPalettes[random.randi_range(0, ColorPalettes.size()-1)]
	initialize_colors()
	initialize_blocks()
	
	var random_start_block = random.randi_range(difficulty_spread['s'][0], difficulty_spread['s'][1])
	add_block(random_start_block, 0, 0)
	$Player.pause_physics = true
	
func initialize_blocks():
	var design = BLOCK_DESIGN.instance()
	blocks = design.get_blocks()
	difficulty_spread = design.get_difficulty_spread()
	design.queue_free()
	
func initialize_colors():
	var tileset = tilemap.tile_set
	VisualServer.set_default_clear_color(color_palette[0])
	
	var index = 1
	while index < color_palette.size():
		for indx in range(0,5):
			tileset.tile_set_modulate(index * 5 + indx, color_palette[index])
		$LandmarkFlag.get_child(index-1).self_modulate = color_palette[index]
		index += 1

func show_land_mark():
	var cell_pos = $TileMap.world_to_map($Player.position)
	#if int(cell_pos.y*-1) % 10 == 0 and flag_y != int(cell_pos.y):
	var start_cell = -1
	for x in range(0, 20):
		var cell = $TileMap.get_cell(x, cell_pos.y)
		if cell > -1:
			if start_cell == -1:
				start_cell = x
				$LandmarkFlag.position = $TileMap.map_to_world(Vector2(x, cell_pos.y))
				$LandmarkFlag/CPUParticles2D.restart()
				$LandmarkFlag/CPUParticles2D.emitting = true
				$LandmarkFlag/CPUParticles2D.one_shot = true
				$LandMark_SFX.play()
		elif cell == -1 and start_cell > -1:
			$Tween.interpolate_property($LandmarkFlag/NinePatchRect, "rect_size:x", 0, (x-start_cell)*32, random.randf_range(0.5, 0.75), Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween.interpolate_property($LandmarkFlag/NinePatchRect2, "rect_size:x", 0, (x-start_cell)*32, random.randf_range(0.5, 0.75), Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween.interpolate_property($LandmarkFlag/NinePatchRect3, "rect_size:x", 0, (x-start_cell)*32, random.randf_range(0.5, 0.75), Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween.start()
#			flag_y = int(cell_pos.y)
			break;
			#$TileMap.set_cell(x, cell_pos.y, cell+15)
			
func on_color_pickup(color):
	$PickupFX.restart()
	$PickupFX.emitting = true
	$PickupFX.one_shot = true
	$PickupFX.position = $Player.position
	$PickupFX.position.y -= 16
	$PickupFX.modulate = color
	
	$PickupFX2.restart()
	$PickupFX2.emitting = true
	$PickupFX2.one_shot = true
	$PickupFX2.position = $Player.position
	$PickupFX2.modulate = color
	
	var arr = [$Pop_0_SFX, $Pop_1_SFX, $Pop_2_SFX]
	arr[random.randi_range(0, arr.size()-1)].play()
	game_score += 1
	if game_score == 5 or game_score % 10 == 0:
		$LandmarkFlag/Label.text = str(game_score)
		show_land_mark()
	
func _physics_process(delta):
	if player.is_on_floor():
		kill_area.position.y = player.position.y + kill_area_offset
		
		var cell_pos = $TileMap.world_to_map(player.position)
		if abs(cell_pos.y - top_offset) < threshold_value:
			var rnd_indx = 0
			#if the player has crossed our pre-defined difficulty curve. We start throwing m and h at them. 
			if num_blocks_added > difficulty_curve.length() -1 :
				rnd_indx = random.randi_range(difficulty_spread['m'][0], difficulty_spread['h'][1])
			else:
				var cur_difficulty = difficulty_curve[num_blocks_added]
				rnd_indx = random.randi_range(difficulty_spread[cur_difficulty][0], difficulty_spread[cur_difficulty][1])
			add_block(rnd_indx, 0, top_offset)
			top_offset -= threshold_value
			
			#Clear all the nodes that were previously spawned. 
			var used_cells = $TileMap.get_used_cells()
			for cell in used_cells:
				if cell.y > cell_pos.y + threshold_value:
					$TileMap.set_cellv(cell, -1)


func _on_KillArea_body_entered(body):
	if body == $Player:
		#show the explosion particles
		$DeathFX.visible = true
		$DeathFX.position = $Player.position
		$DeathFX.restart()
		$DeathFX.emitting = true
		$DeathFX.one_shot = true
		
		#save the score details for the main menu to pick. 
		$Menu.save_score(game_score)
		
		#start a timer for the effect to finish and hide player node.
		$Timer.start()
		$Player.pause_physics = true
		$Player.visible = false
		
		$Dead_SFX.play()
		
	elif body.name.begins_with("@Enemy"):
		print("Cleaning Enemy")
		#cleanup the enemies as they hit the killzone.
		body.queue_free()
	elif body.name.begins_with("@Sliding"):
		print(body.name)
		pass
		
		
func _on_Timer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_KillArea_area_entered(area):
	if area.name.begins_with("Pickup"):
		#cleanup the pickups that were not picked.
		area.queue_free()
		
	pass # Replace with function body.
