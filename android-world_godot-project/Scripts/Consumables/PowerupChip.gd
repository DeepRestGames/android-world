extends Area2D


@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.play("hover")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		EventBus.emit_signal("add_powerup_chip", 1)
		EventBus.emit_signal("powerup_picked_up", name)
		queue_free()
