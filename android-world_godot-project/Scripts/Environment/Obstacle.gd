extends RigidBody2D

@onready var sprite = $Sprite2D

@export var hp = 10

func _ready() -> void:
	sprite.frame = randi() % sprite.hframes
	

func take_damage(value) -> void:
	
	var blinking_player_tween = get_tree().create_tween().set_parallel(false)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), .05)
	blinking_player_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), .05)
	
	hp -= value

	if hp <= 0:
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerProjectile"):
		if body.has_method("on_impact"):
			body.on_impact()
		take_damage(1)
