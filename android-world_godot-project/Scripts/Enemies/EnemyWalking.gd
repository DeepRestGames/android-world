class_name EnemyWalking
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer

@export var MOVEMENT_SPEED: float = 300
@export var ROTATION_SPEED: float = 3

@onready var enemy_sprite = $RunningSprite as AnimatedSprite2D

func _ready() -> void:
	super._ready()
	make_path()


func _physics_process(delta: float) -> void:
	var next_point = navigation_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	if direction.x >= 0:
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true
	
	velocity = direction * MOVEMENT_SPEED
	move_and_slide()


func stop_chasing_player():
	path_calculation_timer.stop()


func make_path() -> void:
	navigation_agent.target_position = player.global_position


func _on_path_calculation_timer_timeout() -> void:
	make_path()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerProjectile"):
		if body.has_method("on_impact"):
			body.on_impact()
		take_damage(1)
