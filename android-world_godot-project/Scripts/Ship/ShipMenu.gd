extends Control


@onready var arrow_hints = $"../ArrowHints"


func _ready() -> void:
	EventBus.connect("show_ship_menu", show_ship_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_visible_in_tree():
		show_ship_menu(false)


func show_ship_menu(value) -> void:
	if value:
		EventBus.emit_signal("show_ship_interaction_prompt", false)
		show()
		arrow_hints.hide()
		Engine.time_scale = 0
	else:
		EventBus.emit_signal("show_ship_interaction_prompt", true)
		hide()
		arrow_hints.show()
		Engine.time_scale = 1


func _on_exit_ship_button_pressed() -> void:
	show_ship_menu(false)
