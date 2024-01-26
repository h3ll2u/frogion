extends Node2D


@onready var menu_animation = $MenuAnimation
@onready var lightning_timer = $LightningTimer


func _ready():
	pass
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/First Level/first_level.tscn")

	

func _on_quit_pressed():
	get_tree().quit()


func _on_lightning_timer_timeout():
	var rng = randi_range(10, 20)
	menu_animation.play("Lightning")
	lightning_timer.wait_time = rng
