extends Node2D


@onready var weapon_sprite = $WeaponSprite


func _ready() -> void:
	EventBus.connect("is_reloading", change_weapon_sprite_on_reload)


func change_weapon_sprite_on_reload(is_reloading: bool) -> void:
	if is_reloading:
		weapon_sprite.frame = 1
	else:
		weapon_sprite.frame = 0
