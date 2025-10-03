extends AnimatedSprite2D

func _ready():
	play("fire")

func _on_animation_finished():
	queue_free()
