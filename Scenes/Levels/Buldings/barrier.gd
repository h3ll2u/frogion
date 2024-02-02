extends StaticBody2D


@onready var building_health = $BuildingHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if building_health.durability <= 0:
		queue_free()
