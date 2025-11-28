extends CharacterBody2D

@export var deceleration_rate: float = 0.07
@export var max_movement_speed: float = 1500
@export var acceleration: float = 800
@export var momentum_rate: float = 0.01

var movement_direction: Vector2
var current_moving_speed: float = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var dust_particles: GPUParticles2D = $DustParticles


func _ready() -> void:
	# Input Events
	EventBus.connect("player_movement", update_movement_direction)


func update_movement_direction(new_movement_direction: Vector2) -> void:
	movement_direction = new_movement_direction


func _physics_process(_delta: float) -> void:
	if movement_direction == Vector2.ZERO:
		# Stop slowly
		velocity = lerp(velocity, Vector2.ZERO, deceleration_rate)
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		current_moving_speed = min(current_moving_speed + acceleration, max_movement_speed)
		# Momentum
		velocity = lerp(velocity, current_moving_speed * movement_direction, momentum_rate)
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	animation_tree["parameters/Move/blend_position"] = movement_direction
	
	move_and_slide()

	current_moving_speed = velocity.length()
	update_animation_speed()
	update_dust_particles_emission()
	
	EventBus.emit_signal("update_motorcycle_moving_speed", current_moving_speed / max_movement_speed)


func update_dust_particles_emission() -> void:
	if current_moving_speed < 100:
		dust_particles.emitting = false
		return
	
	dust_particles.emitting = true
	
	var dust_gravity = Vector3(-velocity.normalized().x * 20, -10, 0)
	
	dust_particles.process_material.set("gravity", dust_gravity)
	dust_particles.speed_scale = 1 + (current_moving_speed * 10) / max_movement_speed


func update_animation_speed() -> void:
	if current_moving_speed < 100:
		animation_player.speed_scale = 0
		return
	
	animation_player.speed_scale = 10 * (current_moving_speed / max_movement_speed)
	
	print(animation_player.speed_scale)
