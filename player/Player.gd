extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(100, 10)
var GRAVITY = 10
var MAX_SPEED = 400
var img
var tilemap
var is_jumping = false
var pause_physics = false
var color_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	img = $tile
	tilemap = $"../TileMap"
	pass # Replace with function body.

func _physics_process(delta):
	if pause_physics :
		return
		
	if is_on_floor() :
		if Input.is_action_just_pressed("ui_select"):
			is_jumping = true
			$TrailFX.emitting = false
			
			velocity.y = -250
			if velocity.x > 0:
				$AnimationPlayer.play("spin_right")
			else:
				$AnimationPlayer.play("spin_left")
	else:
		is_jumping = true

	if is_on_wall():
		velocity.x *= -1
		$TrailFX.scale.x *= -1
#		if not $"../PlayerLand_0_SFX".is_playing() and not $"../PlayerLand_1_SFX".is_playing():
#			if randf() < 0.45:
#				$"../PlayerLand_0_SFX".play()
#			else:
#				$"../PlayerLand_1_SFX".play()
		
	if velocity.y < 0:
		velocity.y += GRAVITY
	else:
		velocity.y += GRAVITY * 4

	if velocity.y > MAX_SPEED:
		velocity.y = MAX_SPEED
		
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() or is_on_wall():
		if is_jumping:
			is_jumping = false
			$TrailFX.emitting = true
			if is_on_floor():
				$"../LandFX".position = position
				$"../LandFX".restart()
				$"../LandFX".emitting = true;
				$"../LandFX".one_shot = true;
				if randf() < 0.45:
					$"../PlayerLand_0_SFX".play()
				else:
					$"../PlayerLand_1_SFX".play()
				

			
	
	#check for coloring the tiles as the player moves. 
	color_tiles()
	
func set_pick_color(color):
#	$tile.self_modulate = color
	$Polygon2D/Polygon2D.self_modulate = color
	var i = 0
	for c in $"..".color_palette:
		if c == color:
			break
		i+= 1
	color_index = i
	
func color_tiles():
	var tile_pos = tilemap.world_to_map(position)
	var cell = tilemap.get_cellv(tile_pos)
#	var tile_coord = tilemap.get_cell_autotile_coord(tile_pos.x, tile_pos.y)
	if cell >= 0 and cell < 5 and color_index > 0:
		if is_on_floor() :
#			tilemap.set_cell(tile_pos.x, tile_pos.y, 1, false, false, false, tile_coord)
			tilemap.set_cell(tile_pos.x, tile_pos.y, cell+color_index * 5)
	
	#custom handling for the walls.
	if is_on_wall():
		if velocity.x > 0:
			tile_pos.x += 1
		else:
			tile_pos.x -= 1 
		cell = tilemap.get_cellv(tile_pos)
		if cell == 3 or cell == 4:
			tilemap.set_cell(tile_pos.x, tile_pos.y, cell+color_index * 5)
