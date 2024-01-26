extends Node2D


@onready var animation_player = $AnimationPlayer
@onready var title = $Title
@onready var intro = $"."


func _ready():
	title.visible = true
	animation_player.play("label_fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu/main_menu.tscn")
