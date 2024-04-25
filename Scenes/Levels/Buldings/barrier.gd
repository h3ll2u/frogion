extends StaticBody2D


@onready var building_health = $BuildingHealth


func _ready():
	pass


func _process(delta):
	if building_health.durability <= 0:
		queue_free()
