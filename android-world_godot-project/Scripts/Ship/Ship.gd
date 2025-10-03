extends Node2D


@onready var animation_player = $AnimationPlayer
@onready var ship_visible_area = $ShipVisibleArea
@onready var ship_camera = $Camera2D


func _ready() -> void:
	EventBus.connect("move_ship", play_move_ship_animation)


func _on_ship_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		EventBus.emit_signal("show_ship_interaction_prompt", true)


func _on_ship_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		EventBus.emit_signal("show_ship_interaction_prompt", false)


func _on_ship_visible_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("Appear")
		
		await animation_player.animation_finished
		play_idle_visible_animation()


func play_idle_visible_animation() -> void:
	for body in ship_visible_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			animation_player.play("IdleVisible")


func _on_ship_visible_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.play_backwards("Appear")
		
		await animation_player.animation_finished
		play_idle_invisible_animation()


func play_idle_invisible_animation() -> void:
	for body in ship_visible_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			return
	
	animation_player.play("IdleInvisible")


func play_move_ship_animation() -> void:
	ship_camera.enabled = true
	ship_camera.make_current()
	EventBus.emit_signal("hide_player", true)
	EventBus.emit_signal("show_ship_menu", false)
	EventBus.emit_signal("show_ship_interaction_prompt", false)
	
	animation_player.play("Liftoff")
	await get_tree().create_timer(.6).timeout
	EventBus.emit_signal("screen_shake", 10, .5)
	
	await get_tree().create_timer(3.5).timeout
	EventBus.emit_signal("fade_to_black")
	
	await get_tree().create_timer(1).timeout
	EventBus.emit_signal("move_ship_end")
	
	await get_tree().create_timer(2).timeout
	EventBus.emit_signal("fade_to_normal")
	animation_player.play_backwards("Liftoff")
	EventBus.emit_signal("screen_shake", 20, 2)
	
	await animation_player.animation_finished
	ship_camera.enabled = false
	EventBus.emit_signal("hide_player", false)
	EventBus.emit_signal("show_ship_interaction_prompt", true)
