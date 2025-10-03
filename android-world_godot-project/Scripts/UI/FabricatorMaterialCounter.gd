extends Control


@onready var currentMaterialAmount = $HBoxContainer/CurrentAmount


func _ready() -> void:
	EventBus.connect("update_current_fabricator_material_count", update_current_fabricator_material_count)


func update_current_fabricator_material_count(value) -> void:
	currentMaterialAmount.text = str(value)
