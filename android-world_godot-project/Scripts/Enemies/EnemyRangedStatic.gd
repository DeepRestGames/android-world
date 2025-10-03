class_name EnemyRangedStatic
extends Area2D


var player: Player

@onready var line_of_sight = $RayCast2D as RayCast2D

@export var projectile_scene = preload("res://Scenes/Enemies/EnemyProjectile.tscn")

@export var shooting_cooldown: float = 2.5
var current_shooting_cooldown = 0

@export var hp: int = 5

@export var drop_rate := 1
var fabricatorMaterialScene = preload("res://Scenes/Consumables/FabricatorMaterial.tscn")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta: float) -> void:
	current_shooting_cooldown -= delta
	handle_line_of_sight()


func handle_line_of_sight():
	line_of_sight.target_position = to_local(player.global_position)
	
	#if line_of_sight.is_colliding():
		#if line_of_sight.get_collider().is_in_group("MainCharacter"):
	if current_shooting_cooldown <= 0:
		shoot()
		current_shooting_cooldown = shooting_cooldown


func shoot():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.global_position = position
	get_parent().add_child(projectile_instance)


func take_damage(value) -> void:
	hp -= value
	if hp <= 0:
		if randf_range(0, 1) <= drop_rate:
			drop_material()
		
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerProjectile"):
		take_damage(1)


func drop_material() -> void:
	var dropInstance = fabricatorMaterialScene.instantiate()
	dropInstance.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", dropInstance)
