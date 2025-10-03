extends Control


@onready var currentAmmoLabel = $HBoxContainer/CurrentAmmo
@onready var maxAmmoLabel = $HBoxContainer/MaxAmmo


func _ready() -> void:
	EventBus.connect("update_current_ammo", update_current_ammo)
	EventBus.connect("update_max_ammo", update_max_ammo)


func update_current_ammo(currentAmmoValue) -> void:
	currentAmmoLabel.text = str(currentAmmoValue)


func update_max_ammo(maxAmmoValue) -> void:
	maxAmmoLabel.text = str(maxAmmoValue)
