extends Node2D


enum PowerupID {
	hp,
	speed,
	ammo
}

@onready var player = $".." as Player

# HP
var powerup_hp_level = 0
var powerup_hp_value = 1

# Speed
var powerup_speed_level = 0
var powerup_speed_value = 50

# Ammo
var powerup_ammo_level = 0
var powerup_ammo_value = 2


func _ready() -> void:
	EventBus.connect("level_up_powerup", level_up_powerup)


func level_up_powerup(powerup_id: PowerupID, powerup_cost) -> void:
	match powerup_id:
		PowerupID.hp:
			if player.remove_powerup_chip(powerup_cost):
				powerup_hp_level += 1
				player.maxHP += powerup_hp_value
				player.currentHP = player.maxHP
				EventBus.emit_signal("update_max_hp_HUD", player.maxHP)
				EventBus.emit_signal("update_current_hp_HUD", player.currentHP)
				
				EventBus.emit_signal("level_up_powerup_completed", PowerupID.hp, powerup_hp_level)
		
		PowerupID.speed:
			if player.remove_powerup_chip(powerup_cost):
				powerup_speed_level += 1
				player.movement_speed += powerup_speed_value
				
				EventBus.emit_signal("level_up_powerup_completed", PowerupID.speed, powerup_speed_level)
		
		PowerupID.ammo:
			if player.remove_powerup_chip(powerup_cost):
				powerup_ammo_level += 1
				player.maxAmmo += powerup_ammo_value
				player.currentAmmo = player.maxAmmo
				EventBus.emit_signal("update_max_ammo", player.maxAmmo)
				EventBus.emit_signal("update_current_ammo", player.currentAmmo)
				
				EventBus.emit_signal("level_up_powerup_completed", PowerupID.ammo, powerup_ammo_level)
