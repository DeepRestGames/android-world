extends Control


const screen_margin = 30

var starting_position: Vector2

var player: Player
@onready var arrow_texture = $ArrowTexture
@onready var distance_label = $DistanceLabel

var ship_position = Vector2.ZERO


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	starting_position = position


func update_distance_label() -> void:
	var distance_to_ship = int(player.global_position.distance_to(ship_position) / 100)
	
	if distance_to_ship < 5:
		hide()
		return
	
	show()
	distance_label.text = ("%d" % distance_to_ship) + "m"


func update_arrow_position() -> void:
	var ship_direction = player.global_position.direction_to(ship_position)
	
	position = starting_position + (ship_direction * starting_position) - (ship_direction * Vector2(screen_margin, screen_margin))
	arrow_texture.rotation = ship_direction.angle()


func _process(_delta: float) -> void:
	update_arrow_position()
	update_distance_label()
