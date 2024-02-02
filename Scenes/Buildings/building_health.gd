extends Node2D


@onready var durability_bar = $DurabilityBar



var max_durability = 120
var old_durability = max_durability


var durability:
	set(value):
		durability = clamp(value, 0, max_durability)
		durability_bar.value = durability
		var difference = durability - old_durability


func _ready():
	durability = max_durability
	durability_bar.max_value = durability
	durability_bar.value = durability
	Signals.connect("enemy_died", Callable(self, "_on_enemy_died"))


func _on_area_2d_area_entered(area):
	durability -= Signals.enemy_super_dmg / 3
	print(str(Global.global_enemy_dmg), durability)

func _on_enemy_died(enemy_position, state):
	durability += 0





func _on_area_2d_body_entered(body):
	if Global.gold > 0 and durability < 95:
		for gold in Global.gold:
			durability += 5
			Global.gold -= 1
			if durability >= 120:
				print("Durabilty full")
				break
	elif Global.gold == 0:
		print("Not enough gold for repair")
	elif durability >= 120:
		print("Durability already full")
