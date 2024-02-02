extends Enemy


func _on_mob_health_damage_received():
	state = IDLE
	state = DAMAGE


func _on_mob_health_no_health():
	Signals.emit_signal("enemy_died", position, state)
	state = DEATH
 
