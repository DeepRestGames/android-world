extends Node


var player: Player

# Enemy spawning
@onready var enemies_parent = $"../../Enemies"
@onready var enemy_spawning_path = $EnemySpawningPath/EnemyPathFollow2D
@export var enemy_scenes : Array[PackedScene]
@export var enemy_spawn_tick: float = 5
var current_enemy_spawn_tick: float = 0.0

var current_difficulty_counter: int = 0
const origin = Vector2.ZERO


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if current_enemy_spawn_tick > 0:
		current_enemy_spawn_tick -= delta
		return
	
	var player_distance = player.global_position.distance_to(origin)
	current_difficulty_counter = int(player_distance / 1000)
	
	for i in current_difficulty_counter:
		spawn_enemy()


func spawn_enemy() -> void:
	enemy_spawning_path.progress_ratio = randf_range(0.0, 1.0)
	
	var enemy_instance = enemy_scenes.pick_random().instantiate()
	enemy_instance.global_position = enemy_spawning_path.global_position
	enemies_parent.add_child(enemy_instance)
	
	current_enemy_spawn_tick = enemy_spawn_tick
