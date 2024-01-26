extends CharacterBody2D


class_name Enemy


enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_enemy = $AnimationEnemy


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 20
var move_speed = 150

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recovery_state()


func _ready():
	chase_state()
	state = CHASE


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state == CHASE:
		chase_state()
	
	move_and_slide()
	
	player = Global.player_pos

func _on_attack_range_body_entered(_body):
	state = ATTACK


func idle_state():
	velocity.x = 0
	animation_enemy.play("idle")
	state = CHASE


func attack_state():
	velocity.x = 0
	animation_enemy.play("attack")
	await animation_enemy.animation_finished
	state = RECOVER


func chase_state():
	animation_enemy.play("run")
	direction = (player - self.position).normalized()
	print(direction.x)
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
		$AttackDirection.rotation_degrees = 0
	else:
		animated_sprite_2d.flip_h = true
		$AttackDirection.rotation_degrees = 180
		
	velocity.x = direction.x * move_speed


func damage_state():
	velocity.x = 0
	damage_anim()
	animation_enemy.play("taking_hit")
	await animation_enemy.animation_finished
	state = IDLE


func death_state():
	velocity.x = 0
	animation_enemy.play("death")
	await animation_enemy.animation_finished
	queue_free()


func recovery_state():
	velocity.x = 0
	animation_enemy.play("recover")
	await animation_enemy.animation_finished
	state = IDLE


func damage_anim():
	direction = (player - self.position).normalized()
	velocity.x = 0
	if direction.x < 0:
		velocity.x += 200
	elif direction.x > 0:
		velocity.x -= 200
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.1)


func _on_run_timeout():
	move_speed = move_toward(move_speed, randi_range(120, 170), 100)


func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)
