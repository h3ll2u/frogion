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



func _on_area_2d_area_entered(area):
	durability -= Signals.enemy_super_dmg
	print(str(Global.global_enemy_dmg), durability)
