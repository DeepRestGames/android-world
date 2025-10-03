extends Control


@onready var currentBombsAmount = $HBoxContainer/CurrentAmount


func _ready() -> void:
	EventBus.connect("update_current_bombs_count", update_current_bombs_count)


func update_current_bombs_count(value) -> void:
	currentBombsAmount.text = str(value)
