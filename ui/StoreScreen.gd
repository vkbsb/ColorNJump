extends Control

var STORE_ITEM = preload("res://ui/StoreItem.tscn")

onready var store_container = $ColorRect/GridContainer
var store_data

# Called when the node enters the scene tree for the first time.
func _ready():
	store_data = StoreData.store_data
	$ColorRect/coins.text = str(PlayerData.inventory.coins)
	for item in store_data.items:
		var store_item = STORE_ITEM.instance()
		store_item.item_data = item
		store_container.add_child(store_item)
		store_item.connect("item_button_clicked", self, "on_item_button_clicked")
	
	#hide the unlock button if the player has already unlocked everything.
	if PlayerData.inventory.bought.size() >= 4:
		$ColorRect/UnlockAll.visible = false
		
	pass # Replace with function body.

func _get_store_item(item_id):
	for store_item in store_container.get_children():
		if store_item.item_data.id == item_id:
			return store_item
	
	return null
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_item_button_clicked(store_item):
	var item_data = store_item.item_data
	if store_item.item_state == store_item.ItemState.UNLOCKED:
		#update store item of un-equipped item. 
		var equipped_store_item = _get_store_item(PlayerData.inventory.equipped)
		if equipped_store_item != null:
			equipped_store_item.item_state = store_item.ItemState.UNLOCKED 
		PlayerData.equip_item(item_data)
		store_item.item_state = store_item.ItemState.EQUIPPED
	elif store_item.item_state == store_item.ItemState.LOCKED:
		if PlayerData.buy_item(item_data):
			store_item.item_state = store_item.ItemState.UNLOCKED
			$ColorRect/coins.text = str(PlayerData.inventory.coins)
		
	print(item_data)

func _on_HomeButton_pressed():
	if not SceneManager.is_transitioning:
		SceneManager.change_scene("res://tiles/Node2D.tscn")
	pass # Replace with function body.


func _on_UnlockAll_pressed():
	JavaScript.eval("window.parent.openShop()")
#	JavaScript.eval("window.top.document.getElementById('embededGame').contentWindow.openShop()")
	pass # Replace with function body.
