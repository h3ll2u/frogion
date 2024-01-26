extends CharacterBody2D


enum {
	MOVE,
	ATTACK,
	BLOCK,
	DODGE,
	TAKING_HIT,
	DEATH
}


const speed = 150.0
const JUMP_VELOCITY = -400.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var stats = $Stats


var state = MOVE
var damage_basic = 10
var damage_multiplier = 1
var damage_current
var recovery = false

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	Global.player_damage = damage_basic * damage_multiplier
	
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		BLOCK:
			block_state()
		DODGE:
			dodge_state()
		TAKING_HIT:
			damage_state()
		DEATH:
			death_state()

		
	move_and_slide()
	
	Global.player_pos = self.position
	
	if Global.player_dead == true:
		get_tree().change_scene_to_file("res://Scenes/UI/Main Menu/main_menu.tscn")
		Global.player_dead = false
		
		
func move_state():
	var direction = Input.get_axis("move_left", "move_right")
	var mouse_direction = get_local_mouse_position().normalized()

	if direction:
		velocity.x = direction * speed
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.x == 0:
			animation_player.play("idle")
	
	if direction == -1:
		animated_sprite_2d.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif direction == 1:
		animated_sprite_2d.flip_h = false
		$AttackDirection.rotation_degrees = 0
		
	if Input.is_action_just_pressed("attack"):
		if mouse_direction.x <= -0.1:
			animated_sprite_2d.flip_h = true
		elif mouse_direction.x >= -0.1:
			animated_sprite_2d.flip_h = false
		state = ATTACK
		if not recovery:
			stats.stamina_cost = stats.attack_cost
			if stats.stamina > stats.stamina_cost:
				state = ATTACK
				
	if Input.is_action_pressed("block"):
		if not recovery:
			if velocity.x == 0:
				if stats.stamina > 1:
					state = BLOCK
			else:
				stats.stamina_cost = stats.dodge_cost
				if stats.stamina > stats.stamina_cost:
					state = DODGE


func block_state():
	stats.stamina -= stats.block_cost
	velocity.x = 0
	animation_player.play("block")
	if Input.is_action_just_released("block") or recovery:
		state = MOVE


func dodge_state():
	animation_player.play("dodge")
	await animation_player.animation_finished
	state = MOVE

	
func attack_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1
	velocity.x = 0
	animation_player.play("attack")
	await animation_player.animation_finished
	state = MOVE


func damage_state():
	animation_player.play("taking_hit")
	await animation_player.animation_finished
	state = MOVE


func death_state():
	velocity.x = 0
	animation_player.play("death")
	await animation_player.animation_finished
	Global.player_dead = true
	
func _on_damage_received(enemy_damage):
	if state == BLOCK:
		enemy_damage /= 2
	elif state == DODGE:
		enemy_damage = 0
	else:
		state = TAKING_HIT
		damage_anim()
	stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state = DEATH


func _on_stats_no_stamina():
	recovery = true
	await get_tree().create_timer(2).timeout
	recovery = false


func damage_anim():
	velocity.x = 0
	animated_sprite_2d.modulate = Color(1, 0, 0, 1)
	if animated_sprite_2d.flip_h == true:
		velocity.x += 200
	else:
		velocity.x -= 200
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.1)
	tween.parallel().tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1, 1), 0.1)
	
