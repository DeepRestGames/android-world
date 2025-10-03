extends Control


class ArrowHintElement:
	var arrow_hint_instance
	var node_name


var arrow_hint_powerup_scene = preload("res://Scenes/UI/ArrowHintPowerup.tscn")
@onready var arrow_hint_powerups_parent = $ArrowHintPowerups

var arrow_hints_list : Array[ArrowHintElement]


func _ready() -> void:
	EventBus.connect("send_powerup_global_position", add_powerup_arrow_hint)
	EventBus.connect("clear_powerup_positions", clear_powerup_positions)
	EventBus.connect("powerup_picked_up", on_powerup_picked_up)
	

func add_powerup_arrow_hint(powerup_global_position, powerup_node_name) -> void:
	var arrow_hint_instance = arrow_hint_powerup_scene.instantiate() as ArrowHintPowerupChip
	arrow_hint_instance.powerup_position = powerup_global_position
	add_child(arrow_hint_instance)
	
	var arrow_hint_element = ArrowHintElement.new()
	arrow_hint_element.arrow_hint_instance = arrow_hint_instance
	arrow_hint_element.node_name = powerup_node_name
	arrow_hints_list.append(arrow_hint_element)


func on_powerup_picked_up(node_name) -> void:
	for arrow_hint_element in arrow_hints_list:
		if arrow_hint_element.node_name == node_name:
			arrow_hint_element.arrow_hint_instance.queue_free()
			arrow_hints_list.erase(arrow_hint_element)


func clear_powerup_positions() -> void:
	for arrow_hint_element in arrow_hints_list:
		arrow_hint_element.arrow_hint_instance.queue_free()
		
	arrow_hints_list.clear()
