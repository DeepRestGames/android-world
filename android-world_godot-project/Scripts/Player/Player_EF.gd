extends CharacterBody2D

#Graphics
@onready var player_sprite = $PlayerSprite

# Shooting
var projectile = preload("res://Scenes/Player/PlayerProjectile.tscn")
var shooting_animation = preload("res://Scenes/Player/PlayerShootingAnimation.tscn")

# Movement
var movement_speed: float = 300
var movement_direction: Vector2
var facing_direction: Vector2

func _ready() -> void:
	# Input signals
	EventBus.connect("shoot_button_pressed", shoot)
	"""""
	EventBus.connect("drink_potion_button_pressed", heal_hp)
	EventBus.connect("place_bomb_button_pressed", place_bomb)
	EventBus.connect("reload_button_pressed", reload)
	EventBus.connect("looking_direction_changed", update_looking_direction)
	EventBus.connect("player_movement", update_movement_direction)

func update_movement_direction(new_movement_direction: Vector2) -> void:
	velocity = new_movement_direction * movement_speed
	"""
	

func _process(delta: float) -> void:
	pass
		
		
func _physics_process(_delta: float) -> void:
	
	#Detect directional movement
	movement_direction.x = Input.get_axis("move_left", "move_right")
	movement_direction.y = Input.get_axis("move_up", "move_down")
	movement_direction = movement_direction.normalized()
	
	#Movement
	if movement_direction:
		velocity = movement_direction * movement_speed
		facing_direction = movement_direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		
	
	#Update sprite direction manually (8D)
	#S
	if facing_direction.angle() > PI*3/8 and facing_direction.angle() < PI*5/8:
			player_sprite.frame = 0
	#SE
	if facing_direction.angle() > PI/8 and facing_direction.angle() < PI*3/8:
		player_sprite.frame = 1
	#E
	if facing_direction.angle() < PI/8 and facing_direction.angle() > -PI/8:
		player_sprite.frame = 2
	#NE
	if facing_direction.angle() < -PI/8 and facing_direction.angle() > -PI*3/8:
		player_sprite.frame = 3
	#N
	if facing_direction.angle() < -PI*3/8 and facing_direction.angle() > -PI*5/8:
		player_sprite.frame = 4
	#NW
	if facing_direction.angle() < -PI*5/8 and facing_direction.angle() > -PI*7/8:
		player_sprite.frame = 5
	#W
	if facing_direction.angle() < -PI*7/8 or facing_direction.angle() > PI*7/8:
		player_sprite.frame = 6
	#SW
	if facing_direction.angle() > PI*5/8 and facing_direction.angle() < PI*7/8:
		player_sprite.frame = 7
		

	move_and_slide()

func shoot() -> void:
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = player_sprite.global_position
	projectile_instance.direction = facing_direction
	get_parent().add_child(projectile_instance)
	EventBus.emit_signal("player_shoot")
	
