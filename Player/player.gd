class_name Player extends CharacterBody2D

signal life_changed
signal died

@export var gravity = 700
@export var run_speed = 150
@export var jump_speed = -300

@onready var player_animation : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $PlayerSprite2D

enum {IDLE, RUN, JUMP, HURT, DEAD}

var state = IDLE
var lives = 3: set = set_lives 

func set_lives(value):
	lives = value
	life_changed.emit(lives)
	if lives <= 0: change_state(DEAD)

func hurt():
	if state != HURT: change_state(HURT)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			player_animation.play("Idle")
		RUN:
			player_animation.play("Run")
		HURT:
			player_animation.play("hurt")
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			lives -= 1
			await get_tree().create_timer(.5).timeout
			change_state(IDLE)
		JUMP:
			player_animation.play("jump_up")
		DEAD:
			died.emit()
			hide()

func get_input(): # Handles the player input
	if state == HURT: return
	
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	
	velocity.x = 0
	
	# movement can occurs in all states
	if right:
		velocity.x += run_speed
		player_sprite.flip_h = false
	if left:
		velocity.x -= run_speed
		player_sprite.flip_h = true
	
	# can only jump if is on the floor
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	
	if state == IDLE and velocity.x != 0: change_state(RUN)
	
	if state == RUN and velocity.x == 0: change_state(IDLE)
	
	if state in [IDLE, RUN] and !is_on_floor(): change_state(JUMP)

func reset(_position): # spanw point yet to be defined
	position = _position
	show()
	change_state(IDLE)
	lives = 3

## BUILT-IN

func _ready() -> void:
	change_state(IDLE)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == JUMP and is_on_floor(): change_state(IDLE) # changes the animation to idle after reaching the ground from a jump
	if state == JUMP and velocity.y > 0: player_animation.play("jump_down") # changes the animaiton to jump down when it starts to fall after jumping
	
