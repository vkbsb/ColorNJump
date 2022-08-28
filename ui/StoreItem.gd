extends NinePatchRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ItemState {
	UNAVAILABLE,
	LOCKED,
	UNLOCKED,
	EQUIPPED, 
}

var item_state setget set_item_state, get_item_state
var item_data setget set_item_data, get_item_data

#EQUIPPED -- USING
#LOCKED -- show price
#UNLOCKED -- EQUIP
#UNAVAILABLE -- show price, disable button

signal item_button_clicked(StoreItem)

func set_item_data(value:Dictionary):
	item_data = value
	self.item_state = ItemState.LOCKED
	
	var asset_data = load(value.asset)
	var asset_instance = asset_data.instance()
	asset_instance.scale = Vector2(6, 6)
	asset_instance.position = Vector2(rect_size)/2
	add_child(asset_instance)
	
	if item_data.id == PlayerData.inventory.equipped:
		self.item_state = ItemState.EQUIPPED
	else:
		#if the item was already bought, we have to keep it as equip.
		for bought_item in PlayerData.inventory.bought:
			if bought_item == item_data.id:
				self.item_state = ItemState.UNLOCKED
	
	if item_state == ItemState.LOCKED and PlayerData.inventory.coins < item_data.price:
		self.item_state = ItemState.UNAVAILABLE
	
func get_item_data():
	return item_data
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "on_button_pressed")
	pass # Replace with function body.

func on_button_pressed():
	print(ItemState.keys()[item_state])
	emit_signal("item_button_clicked", self)
	
	
func get_item_state():
	return item_state
	
func set_item_state(state):
	item_state = state
	
	if state == ItemState.UNLOCKED:
		$Button.text = "EQUIP"
		$Button.disabled = false
	elif state == ItemState.EQUIPPED:
		$Button.text = "USING"
		$Button.disabled = true
	elif state == ItemState.UNAVAILABLE:
		$Button.disabled = true
	elif state == ItemState.LOCKED:
		$Button.disabled = false
		$Button.text = str(item_data.price)
