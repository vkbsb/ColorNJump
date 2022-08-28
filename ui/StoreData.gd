extends Node

var store_data: Dictionary = {
	"items":[
		{
		"id": 0,
		"price": 20,
		"name": "Jacket",
		"asset": "res://player/OGCharacter.tscn",
		"audio": "res://audio/running.wav",
		"speed": 100,
		},
		{
		"id": 1,
		"price": 30,
		"name": "Scarf",
		"asset": "res://player/ScarfGuy.tscn",
		"speed": 100,
		}, 
		{
		"id": 2,
		"price": 60,
		"name": "Surf",
		"asset": "res://player/SurfGuy.tscn",
		"speed": 125,
		},
		{
		"id": 3,
		"price": 120,
		"name": "Bike",
		"asset": "res://player/BikeGuy.tscn",
		"speed": 150,
		}
	]
}

func get_item_data(item_id):
	for item in store_data.items:
		if item.id == item_id:
			return item
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
