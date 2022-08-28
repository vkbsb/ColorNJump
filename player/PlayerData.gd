extends Node
const USER_DATA_FILE = "user_data_v3"

var best = 0
var data 
var inventory = {
	"coins": 0,
	"equipped":0,
	"bought": [0],
}

func equip_item(item_data:Dictionary):
	if item_data.has("id"):
		inventory.equipped = item_data.id

func buy_item(item_data:Dictionary):
	if not item_data.has("id"):
		print("Invalid item data", item_data)
		
	#TODO pick the item data from store data? 
	if inventory.coins >= item_data.price:
		inventory.coins -= item_data.price
		inventory.bought.push_back(item_data.id)
		return true
	return false
	
func unlock_all(store_data):
	inventory.bought = []
	for item in store_data.items:
		inventory.bought.push_back(item.id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	data = load_data(USER_DATA_FILE)
	
	if data == null:
		best = 0
	else:
		best = data.best
		if data.has("inventory"):
			inventory = data.inventory
#		inventory = data.inventory
	print("Player Data: Ready")
	pass # Replace with function body.

func remove_save_data():
	var dir = Directory.new()
	dir.remove("user://"+USER_DATA_FILE + '.json')
	
func save_data(file_data, file, path = "user"):

	## Create and open your file.
	var SAVE_PATH = path+'://'+file+'.json'
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# Convert your data to a useable string-format.
	save_file.store_line(to_json(file_data))

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
	var file_data = parse_json(save_file.get_as_text())

	# Close file 
	save_file.close()
	
	# Return data
	return file_data
	
func save_score(score):
	var new_best = false
	if best < score:
		best = score
		new_best = true
	
	#TODO: change to actual coin gains.
	inventory.coins += score
	
	var dict = { "score": score, "best": best, "new_best": new_best, "inventory": inventory}
	data = dict
	save_data(dict, USER_DATA_FILE)
