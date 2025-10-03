extends Control


@export var move_ship_cost = 30
@onready var move_ship_button = $HBoxContainer/MoveShipButton
@onready var move_ship_cost_label = $HBoxContainer/VBoxContainer/MoveShipCost


func _ready() -> void:
	move_ship_cost_label.text = str(move_ship_cost)
	
	var player = get_tree().get_first_node_in_group("Player")
	if player.fabricator_material_quantity < move_ship_cost:
		move_ship_button.disabled = true
	else:
		move_ship_button.disabled = false
	
	EventBus.connect("update_current_fabricator_material_count", check_move_ship_cost)


func check_move_ship_cost(current_material_quantity) -> void:
	if current_material_quantity < move_ship_cost:
		move_ship_button.disabled = true
	else:
		move_ship_button.disabled = false


func _on_move_ship_button_pressed() -> void:
	EventBus.emit_signal("remove_fabricator_material", move_ship_cost)
	EventBus.emit_signal("move_ship")
