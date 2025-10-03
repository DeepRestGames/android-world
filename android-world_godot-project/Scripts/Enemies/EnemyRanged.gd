class_name EnemyRanged
extends EnemyBase


@onready var path_calculation_timer = $PathCalculationTimer as Timer
@onready var line_of_sight = $RayCast2D as RayCast2D

@export var projectile_scene = preload("res://Scenes/Enemies/EnemyProjectile.tscn")

@export var MOVEMENT_SPEED: float = 150
@export var ROTATION_SPEED: float = 3

@export var shooting_cooldown: float = 2.5
var current_shooting_cooldown = 0

@onready var enemy_sprite = $AnimatedSprite2D as AnimatedSprite2D


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	current_shooting_cooldown -= delta
	handle_line_of_sight(delta)
	move_and_slide()


func handle_line_of_sight(delta):
	line_of_sight.target_position = to_local(player.global_position)
	
	if line_of_sight.is_colliding():
		var line_of_sight_collider = line_of_sight.get_collider()
		if line_of_sight_collider == null:
			return
		elif line_of_sight_collider.is_in_group("Player"):
			var rotation_direction = (player.global_position - global_position).normalized()
			if rotation_direction.x >= 0:
				enemy_sprite.flip_h = false
			else:
				enemy_sprite.flip_h = true
			
			velocity = Vector2.ZERO
			if current_shooting_cooldown <= 0:
				shoot()
				current_shooting_cooldown = shooting_cooldown
			return
		else:
			move_to_next_path_position(delta)


func move_to_next_path_position(delta):
	var next_point = navigation_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	if direction.x >= 0:
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true
	
	velocity = direction * MOVEMENT_SPEED


func shoot():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.global_position = position
	get_tree().root.add_child(projectile_instance)


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
