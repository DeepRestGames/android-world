extends RigidBody2D

@onready var sprite = $Sprite2D

@export var hp = 10
@export var drop_rate := 1
const min_material_drop_quantity = 3
const max_material_drop_quantity = 6
var drop_quantity
var fabricatorMaterialScene = preload("res://Scenes/Consumables/FabricatorMaterial.tscn")


func _ready() -> void:
	sprite.frame = randi() % sprite.hframes
	drop_quantity = randi_range(min_material_drop_quantity, max_material_drop_quantity)
	

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
		dropInstance.global_position = global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().current_scene.call_deferred("add_child", dropInstance)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerProjectile"):
		if body.has_method("on_impact"):
			body.on_impact()
		take_damage(1)
