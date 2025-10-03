extends Control


@onready var animation_player = $AnimationPlayer

var current_slide = 0

@onready var text0 = $Label0
@onready var text1 = $Label1
@onready var text2 = $Label2
@onready var text3 = $Label3
@onready var text4 = $Label4
@onready var text5 = $Label5
@onready var text6 = $Label6
@onready var text7 = $Label7
@onready var text8 = $Label8
@onready var text9 = $Label9
@onready var text10 = $Label10
@onready var text11 = $Label11
@onready var illustration1 = $Intro1
@onready var illustration2 = $Intro2
@onready var illustration3 = $Intro3
@onready var illustration4 = $Intro4



func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
	#if event.is_action_pressed("dialogic_default_action"):
		next_slide()


func next_slide():
	current_slide += 1
	
	match(current_slide):
		0:
			text0.show()
		1:
			text0.hide()
			text1.show()
			print("slide = 1")
			print("text 1 being displayed")
		2:
			illustration1.show()
			text2.show()
		3:
			text1.hide()
			text2.hide()
			illustration2.show()
			text3.show()
		4:
			illustration3.show()
			text4.show()
		5:
			illustration1.hide()
			illustration2.hide()
			illustration3.hide()
			text3.hide()
			text4.hide()
			text5.show()
		6:
			text5.hide()
			text6.show()
		7:
			text6.hide()
			illustration4.show()
			text7.show()
		8:
			text8.show()
		9:
			illustration4.hide()
			text7.hide()
			text8.hide()
			text9.show()
		10:
			text9.hide()
			text10.show()
		11:
			text10.hide()
			text11.show()
		12:
			get_tree().change_scene_to_file("res://Scenes/LittleMainGameScene.tscn")
		
