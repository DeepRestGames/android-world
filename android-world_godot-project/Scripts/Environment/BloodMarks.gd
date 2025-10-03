extends Node2D


func _ready() -> void:
	EventBus.connect("move_ship_end", on_ship_moved)


func on_ship_moved() -> void:
	var blood_marks = get_children()
	
	for blood_mark in blood_marks:
		blood_mark.queue_free()
	
	blood_marks.clear()
