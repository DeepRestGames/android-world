extends Node


var prevent_inputs = false
var mouse_inputs = false

var looking_direction: Vector2

func _ready() -> void:
	EventBus.connect("set_prevent_inputs", set_prevent_inputs)


func set_prevent_inputs(value: bool) -> void:
	prevent_inputs = value


func _unhandled_input(event: InputEvent) -> void:
	if prevent_inputs:
		return
	
	if event.is_action_pressed("shoot"):
		EventBus.emit_signal("shoot_button_pressed")
	
	if event.is_action_pressed("drink_potion"):
		EventBus.emit_signal("drink_potion_button_pressed")
	
	if event.is_action_pressed("place_bomb"):
		EventBus.emit_signal("place_bomb_button_pressed")
	
	if event.is_action_pressed("reload"):
		EventBus.emit_signal("reload_button_pressed")
	
	if event.is_action_pressed("look_left") or event.is_action_pressed("look_right") or event.is_action_pressed("look_up") or event.is_action_pressed("look_down"):
		var temp_looking_direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		# Discard all "ghost" inputs
		if not temp_looking_direction.is_normalized():
			return
		looking_direction = temp_looking_direction
		EventBus.emit_signal("looking_direction_changed", looking_direction)
	
	# Always check for player movement
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	EventBus.emit_signal("player_movement", movement_direction)
