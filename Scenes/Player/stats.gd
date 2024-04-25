extends CanvasLayer


signal no_stamina ()


@onready var health_bar = $HealthBar
@onready var stamina_bar = $Stamina
@onready var health_text = $"../HealthText"
@onready var health_anim = $"../HealthAnim"
@onready var coin_counter = $CoinCounter


var stamina_cost
var attack_cost = 10
var block_cost = 0.5
var dodge_cost = 15
var max_health = 120
var old_health = max_health


var stamina = 50:
	set(value):
		stamina= value
		if stamina < 1:
			emit_signal("no_stamina")


var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		health_text.text = str(difference)
		old_health = health
		
		if difference < 0:
			health_anim.play("damage_received")
		if difference > 0:
			health_anim.play("health_received")


func _ready():
	health_text.modulate.a = 0
	health = max_health
	health_bar.max_value = health
	health_bar.value = health


func _process(delta):
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 10 * delta
	coin_counter.text = str(Global.gold)	


func stamina_consuption ():
	stamina -= stamina_cost


func _on_health_regen_timeout():
	health += 5

