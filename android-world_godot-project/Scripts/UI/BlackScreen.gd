extends TextureRect


const player_starting_position = Vector2(0, 200)


func _ready() -> void:
	EventBus.connect("player_death", player_death)
	EventBus.connect("fade_to_black", fade_to_black)
	EventBus.connect("fade_to_normal", fade_to_normal)


func player_death() -> void:
	var fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0), .5)
	
	await fade_out_tween.finished
	get_tree().get_first_node_in_group("Player").global_position = player_starting_position
	EventBus.emit_signal("clear_map_from_enemies")
	
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), .5)
	
	EventBus.emit_signal("player_respawned")


func fade_to_black() -> void:
	var fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0), .5)
	
	await fade_out_tween.finished
	return


func fade_to_normal() -> void:
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), .5)
	
	await fade_in_tween.finished
	return
