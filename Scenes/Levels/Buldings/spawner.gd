extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var mobs = $".."


var berserk_preload = preload("res://Scenes/Mobs/Berserk/berserk.tscn")
var soldier_preload = preload("res://Scenes/Mobs/Soldier/soldier_boy.tscn")
var spawn_count = 0


func _ready():
	Signals.connect("day_time", Callable(self, "_on_change_time"))


func _on_change_time(state, day_count):
	spawn_count = 0
	var rng = randi_range(0, 2)
	if state == 2:
		for i in (day_count + rng):
			animation_player.play("spawn")
			await animation_player.animation_finished
			spawn_count += 1
			print(spawn_count, " - spawn_count")
	if state == 3:
		animation_player.play("idle")
	
	if spawn_count == day_count + rng:
		animation_player.play("idle")
		
	
func enemy_spawn():
	var rng = randi_range(1, 2)
	if rng == 1:
		soldier_spawn()
	elif rng == 2:
		berserk_spawn()
	

func soldier_spawn():
	var soldier = soldier_preload.instantiate()
	soldier.position = Vector2(self.position.x, self.position.y)
	mobs.add_child(soldier)


func berserk_spawn():
	var berserk = berserk_preload.instantiate()
	berserk.position = Vector2(self.position.x, self.position.y)
	mobs.add_child(berserk)
