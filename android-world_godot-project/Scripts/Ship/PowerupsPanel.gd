extends Control


enum PowerupID {
	hp,
	speed,
	ammo
}


const max_powerup_level = 5

# HP
@onready var hp_powerup_slots = [ 
	$VBoxContainer/HP/PowerupSlots/PowerupSlot1, 
	$VBoxContainer/HP/PowerupSlots/PowerupSlot2, 
	$VBoxContainer/HP/PowerupSlots/PowerupSlot3, 
	$VBoxContainer/HP/PowerupSlots/PowerupSlot4, 
	$VBoxContainer/HP/PowerupSlots/PowerupSlot5 
]
@onready var hp_cost_label = $VBoxContainer/HP/HBoxContainer/HPCostLabel
@onready var hp_level_up_button = $VBoxContainer/HP/PowerupSlots/HPLevelUpButton
var powerup_hp_level = 0
var powerup_hp_cost = [2, 3, 5, 8, 13]

# Speed
@onready var speed_powerup_slots = [ 
	$VBoxContainer/Speed/PowerupSlots/PowerupSlot1, 
	$VBoxContainer/Speed/PowerupSlots/PowerupSlot2, 
	$VBoxContainer/Speed/PowerupSlots/PowerupSlot3, 
	$VBoxContainer/Speed/PowerupSlots/PowerupSlot4, 
	$VBoxContainer/Speed/PowerupSlots/PowerupSlot5 
]
@onready var speed_cost_label = $VBoxContainer/Speed/HBoxContainer/SpeedCostLabel
@onready var speed_level_up_button = $VBoxContainer/Speed/PowerupSlots/SpeedLevelUpButton
var powerup_speed_level = 0
var powerup_speed_cost = [2, 3, 5, 8, 15]

# Ammo
@onready var ammo_powerup_slots = [ 
	$VBoxContainer/Ammo/PowerupSlots/PowerupSlot1, 
	$VBoxContainer/Ammo/PowerupSlots/PowerupSlot2, 
	$VBoxContainer/Ammo/PowerupSlots/PowerupSlot3, 
	$VBoxContainer/Ammo/PowerupSlots/PowerupSlot4, 
	$VBoxContainer/Ammo/PowerupSlots/PowerupSlot5 
]
@onready var ammo_cost_label = $VBoxContainer/Ammo/HBoxContainer/AmmoCostLabel
@onready var ammo_level_up_button = $VBoxContainer/Ammo/PowerupSlots/AmmoLevelUpButton
var powerup_ammo_level = 0
var powerup_ammo_cost = [2, 3, 5, 8, 13]


func _ready() -> void:
	hp_cost_label.text = str(powerup_hp_cost[powerup_hp_level])
	speed_cost_label.text = str(powerup_speed_cost[powerup_speed_level])
	ammo_cost_label.text = str(powerup_ammo_cost[powerup_ammo_level])
	
	hp_level_up_button.disabled = true
	speed_level_up_button.disabled = true
	ammo_level_up_button.disabled = true
	
	visibility_changed.connect(focus_on_button)
	
	EventBus.connect("level_up_powerup_completed", level_up_powerup_completed)
	EventBus.connect("update_current_powerup_chips_count", check_powerups_cost)


func focus_on_button() -> void:
	if is_visible_in_tree():
		hp_level_up_button.grab_focus.call_deferred()


func _on_hp_level_up_button_pressed() -> void:
	EventBus.emit_signal("level_up_powerup", PowerupID.hp, powerup_hp_cost[powerup_hp_level])


func _on_speed_level_up_button_pressed() -> void:
	EventBus.emit_signal("level_up_powerup", PowerupID.speed, powerup_speed_cost[powerup_speed_level])


func _on_ammo_level_up_button_pressed() -> void:
	EventBus.emit_signal("level_up_powerup", PowerupID.ammo, powerup_ammo_cost[powerup_ammo_level])


func level_up_powerup_completed(powerup_ID: PowerupID, level):
	match powerup_ID:
		PowerupID.hp:
			for i in level:
				hp_powerup_slots[i].modulate = Color(0.208, 1.0, 0.208)
			powerup_hp_level += 1
			
			if powerup_hp_level == max_powerup_level:
				hp_cost_label.text = "MAX"
				hp_level_up_button.disabled = true
			else:
				hp_cost_label.text = str(powerup_hp_cost[powerup_hp_level])
		
		PowerupID.speed:
			for i in level:
				speed_powerup_slots[i].modulate = Color(0.208, 1.0, 0.208)
			powerup_speed_level += 1
			
			if powerup_speed_level == max_powerup_level:
				speed_cost_label.text = "MAX"
				speed_level_up_button.disabled = true
			else:
				speed_cost_label.text = str(powerup_speed_cost[powerup_speed_level])
		
		PowerupID.ammo:
			for i in level:
				ammo_powerup_slots[i].modulate = Color(0.208, 1.0, 0.208)
			powerup_ammo_level += 1
			
			if powerup_ammo_level == max_powerup_level:
				ammo_cost_label.text = "MAX"
				ammo_level_up_button.disabled = true
			else:
				ammo_cost_label.text = str(powerup_ammo_cost[powerup_ammo_level])


func check_powerups_cost(current_powerups) -> void:
	if current_powerups < powerup_hp_cost[powerup_hp_level]:
		hp_level_up_button.disabled = true
	else:
		hp_level_up_button.disabled = false
	
	if current_powerups < powerup_speed_cost[powerup_speed_level]:
		speed_level_up_button.disabled = true
	else:
		speed_level_up_button.disabled = false
	
	if current_powerups < powerup_ammo_cost[powerup_ammo_level]:
		ammo_level_up_button.disabled = true
	else:
		ammo_level_up_button.disabled = false
	
