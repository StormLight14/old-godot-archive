extends TextureButton

@onready var tower_shop = get_node("../../")
@onready var mouse_tower = get_node("../../../MouseTower")
@onready var price_label = $PriceLabel

@export var type: String = ""

func _ready():
	price_label.text = "$" + str(tower_shop.shop_prices[type])

func _on_TowerButton_pressed():
	tower_shop.current_bought = type
	tower_shop.emit_signal("tower_bought", type)
