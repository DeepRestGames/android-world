extends Control


func _ready() -> void:
	EventBus.connect("show_ship_interaction_prompt", show_ship_interaction_prompt)


func show_ship_interaction_prompt(value) -> void:
	if value:
		show()
	else:
		hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_visible_in_tree():
		EventBus.emit_signal("show_ship_menu", true)
