extends CharacterBody2D

@export var deceleration_rate: float = 0.07
@export var max_movement_speed: float = 1500
@export var acceleration: float = 300
@export var momentum_rate: float = 0.05

var movement_direction: Vector2
var current_moving_speed: float = 0


func _ready() -> void:
	# Input Events
	EventBus.connect("player_movement", update_movement_direction)


func update_movement_direction(new_movement_direction: Vector2) -> void:
	movement_direction = new_movement_direction


func _physics_process(_delta: float) -> void:
	if movement_direction == Vector2.ZERO:
		# Stop slowly
		velocity = lerp(velocity, Vector2.ZERO, deceleration_rate)
	else:
		current_moving_speed = min(current_moving_speed + acceleration, max_movement_speed)
		
		# Momentum
		velocity = lerp(velocity, current_moving_speed * movement_direction, momentum_rate)
		current_moving_speed = velocity.length()
	
	move_and_slide()
