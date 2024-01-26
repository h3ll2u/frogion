extends Node2D


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}


@onready var sun = $GlobalLight/Sun
@onready var world_animation = $WorldAnimation
@onready var day_night_change = $GlobalLight/DayNightChange


var state = MORNING


func _ready():
	_on_day_night_change_timeout()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/UI/Main Menu/main_menu.tscn")

func _on_day_night_change_timeout():
	match state:
		MORNING:
			morning_state()
		DAY:
			day_state()
		EVENING:
			evening_state()
		NIGHT:
			night_state()
	if state == 0:
		state += 1
	elif state < 3:
		state += 1
	else:
		state = MORNING
		
	Signals.emit_signal("day_time", state)


func morning_state():
	world_animation.play("morning_anim")
	print("Morning - ", state)


func day_state():
	world_animation.play("day_anim")
	print("Day - ", state)


func evening_state():
	world_animation.play("evening_anim")
	print("Evening - ", state)


func night_state():
	world_animation.play("night_anim")
	print("Night - ", state)

