extends Control


@onready var currentPowerupsAmount = $HBoxContainer/CurrentAmount


func _ready() -> void:
	EventBus.connect("update_current_powerup_chips_count", update_current_powerup_chips_count)


func update_current_powerup_chips_count(value) -> void:
	currentPowerupsAmount.text = str(value)
