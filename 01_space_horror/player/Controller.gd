extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

onready var animatedSprite:AnimatedSprite = $AnimatedSprite

func _ready():
	set_process_input(true)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		print_debug("moving right")
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		
	if velocity.x < 0:
		animatedSprite.flip_h = true
	elif velocity.x > 0:
		animatedSprite.flip_h = false
		
	var nextAnimation = "idle"
	if velocity.y < 0:
		nextAnimation = "walk_up"
	elif velocity.y > 0: 
		nextAnimation = "walk_down"
	elif velocity.x != 0:
		nextAnimation = "walk_right"
		
	if nextAnimation != animatedSprite.animation:
		animatedSprite.play(nextAnimation)
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
