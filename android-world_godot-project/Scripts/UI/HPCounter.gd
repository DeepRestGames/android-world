extends Control


@onready var currentHP = $HBoxContainer/CurrentAmount


func _ready() -> void:
	EventBus.connect("update_current_hp_HUD", update_current_hp_HUD)


func update_current_hp_HUD(value) -> void:
	currentHP.text = str(value)
