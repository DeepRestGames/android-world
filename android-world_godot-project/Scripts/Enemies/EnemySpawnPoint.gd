extends RigidBody2D


@onready var enemies_parent_node = $EnemiesParentNode
@onready var enemies_spawn_timer = $EnemiesSpawnTimer as Timer
@onready var spawn_animation = $SpawnPointSprite
#@onready var enemy_spawn_buildup_particles = $EnemySpawnBuildup_GPUParticles2D as GPUParticles2D
#@onready var enemy_spawn_flare_particles = $EnemySpawnFlare_GPUParticles2D as GPUParticles2D

@export var enemy_scenes: Array[PackedScene]
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var spawn_cooldown: float = 3

@export var hp: int = 5

@export var drop_rate := 1
const min_material_drop_quantity = 2
const max_material_drop_quantity = 5
var drop_quantity
var fabricatorMaterialScene = preload("res://Scenes/Consumables/FabricatorMaterial.tscn")


func _ready() -> void:
	enemies_spawn_timer.wait_time = spawn_cooldown
	spawn_animation.play("spawn")
	drop_quantity = randi_range(min_material_drop_quantity, max_material_drop_quantity)


func _on_enemies_spawn_timer_timeout() -> void:
	var enemy_instance = enemy_scenes.pick_random().instantiate()
	enemies_parent_node.add_child(enemy_instance)
	EventBus.emit_signal("play_enemy_spawn_sound")
	spawn_animation.play("spawn")
	#enemy_spawn_flare_particles.restart()
	
	#if not enemies_spawn_timer.is_stopped():
		#enemy_spawn_buildup_particles.restart()


func take_damage(value) -> void:
	var blinking_player_tween = get_tree().create_tween().set_parallel(false)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	
	hp -= value
	if hp <= 0:
		if randf_range(0, 1) <= drop_rate:
			drop_material()
		
		queue_free()


func drop_material() -> void:
	for i in drop_quantity:
		var dropInstance = fabricatorMaterialScene.instantiate()
		dropInstance.global_position = global_position + Vector2(randf_range(-35, 35), randf_range(-35, 35))
		get_tree().current_scene.call_deferred("add_child", dropInstance)


func _on_aggro_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemies_spawn_timer.start()


func _on_aggro_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemies_spawn_timer.stop()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerProjectile"):
		if body.has_method("on_impact"):
			body.on_impact()
		take_damage(1)
