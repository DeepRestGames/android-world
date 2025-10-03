extends Control


@onready var currentPotionsAmount = $HBoxContainer/CurrentAmount


func _ready() -> void:
	EventBus.connect("update_current_potions_count", update_current_potions_count)


func update_current_potions_count(value) -> void:
	currentPotionsAmount.text = str(value)
