extends KinematicBody2D

var speed = 250
var velocity = Vector2()
var direction := "right"
var state := "idle"
onready var rayUR : RayCast2D = $EdgeSmootherUpRight
onready var rayUL : RayCast2D = $EdgeSmootherUpLeft
onready var rayDR : RayCast2D = $EdgeSmootherDownRight
onready var rayDL : RayCast2D = $EdgeSmootherDownLeft
onready var debugger : Label = $Debugger

onready var sprite : AnimatedSprite = $AnimatedSprite

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction = "right"
		state = "run"
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		direction = "left"
		state = "run"
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		direction = "down"
		state = "run"
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		direction = "up"
		state = "run"
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	var start_position = position
	get_input()
	move_and_collide(velocity * delta)
	if (position == start_position && velocity.length() > 0):
		velocity = apply_movement_smoothing()
		move_and_collide(velocity * delta)
	
	sprite.play(direction + "_" + state)
	state = "idle"

func apply_movement_smoothing() -> Vector2:
	var new_velocity = Vector2.ZERO
	if direction == "left" and rayDL.is_colliding():
		new_velocity.y -= 1
		print("Sliding:" + String(new_velocity))
	if direction == "left" and rayUL.is_colliding():
		new_velocity.y += 1
		print("Sliding:" + String(new_velocity))
	if direction == "right" and rayDR.is_colliding():
		new_velocity.y -= 1
		print("Sliding:" + String(new_velocity))
	if direction == "right" and rayUR.is_colliding():
		new_velocity.y += 1
		print("Sliding:" + String(new_velocity))
	if direction == "up" and rayUL.is_colliding():
		new_velocity.x += 1
		print("Sliding:" + String(new_velocity))
	if direction == "up" and rayUR.is_colliding():
		new_velocity.x -= 1
		print("Sliding:" + String(new_velocity))
	if direction == "down" and rayDL.is_colliding():
		new_velocity.x += 1
		print("Sliding:" + String(new_velocity))
	if direction == "down" and rayDR.is_colliding():
		new_velocity.x -= 1
		print("Sliding:" + String(new_velocity))

	return new_velocity.normalized() * speed
	
