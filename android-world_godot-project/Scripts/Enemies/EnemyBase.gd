class_name EnemyBase
extends CharacterBody2D


var player: Player

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D

@export var hp: int = 1

@export var drop_rate := 1
var fabricatorMaterialScene = preload("res://Scenes/Consumables/FabricatorMaterial.tscn")

var enemy_blood_scene = preload("res://Scenes/Enemies/EnemyBlood.tscn")
var blood_marks_parent


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	#EventBus.connect("player_death", stop_chasing_player)
	blood_marks_parent = get_tree().get_first_node_in_group("BloodMarks")


func stop_chasing_player():
	pass


func take_damage(value):
	#EventBus.emit_signal("spawn_blood_particles", global_position)
	#EventBus.emit_signal("spawn_spark_particles", global_position)
	#EventBus.emit_signal("play_thunder_sfx")
	#EventBus.emit_signal("play_lightning_sfx", -5)
	#EventBus.emit_signal("screen_shake")
	
	var blinking_player_tween = get_tree().create_tween().set_parallel(false)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	
	var enemy_blood_instance = enemy_blood_scene.instantiate()
	enemy_blood_instance.global_position = global_position
	blood_marks_parent.add_child(enemy_blood_instance)
	
	hp -= value
	if hp <= 0:
		if randf_range(0, 1) <= drop_rate:
			drop_material()
		
		queue_free()
	
	


func drop_material() -> void:
	var dropInstance = fabricatorMaterialScene.instantiate()
	dropInstance.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", dropInstance)
