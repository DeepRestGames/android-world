class_name ArrowHintPowerupChip
extends Control


const screen_margin = 30

var starting_position: Vector2

var player: Player
@onready var arrow_texture = $ArrowTexture
@onready var distance_label = $DistanceLabel

var powerup_position: Vector2


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	starting_position = position


func set_powerup_position(powerup_global_position: Vector2):
	powerup_position = powerup_global_position
	show()


func update_distance_label() -> void:
	var distance_to_powerup = int(player.global_position.distance_to(powerup_position) / 100)
	
	if distance_to_powerup < 5:
		hide()
		return
	
	show()
	distance_label.text = ("%d" % distance_to_powerup) + "m"


func update_arrow_position() -> void:
	var powerup_direction = player.global_position.direction_to(powerup_position)
	
	position = starting_position + (powerup_direction * starting_position) - (powerup_direction * Vector2(screen_margin, screen_margin))
	arrow_texture.rotation = powerup_direction.angle()


func _process(_delta: float) -> void:
	update_arrow_position()
	update_distance_label()
