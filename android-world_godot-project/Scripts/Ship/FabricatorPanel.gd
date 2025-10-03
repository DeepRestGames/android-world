extends Control


var player: Player

# Potions
@onready var potion_material_cost_label = $VBoxContainer/PotionCrafting/VBoxContainer/HBoxContainer/FabricatorMaterialCost
@export var potion_material_cost = 5

# Bombs
@onready var bombs_material_cost_label = $VBoxContainer/BombsCrafting/VBoxContainer/HBoxContainer/FabricatorMaterialCost
@export var bombs_material_cost = 10


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	potion_material_cost_label.text = "x " + str(potion_material_cost)
	bombs_material_cost_label.text = "x " + str(bombs_material_cost)


func _on_craft_potion_button_pressed() -> void:
	if player.fabricator_material_quantity >= potion_material_cost:
		EventBus.emit_signal("remove_fabricator_material", potion_material_cost)
		EventBus.emit_signal("add_potion", 1)


func _on_craft_bomb_button_pressed() -> void:
	if player.fabricator_material_quantity >= bombs_material_cost:
		EventBus.emit_signal("remove_fabricator_material", bombs_material_cost)
		EventBus.emit_signal("add_bomb", 1)
