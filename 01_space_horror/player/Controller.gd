extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var processInput = true
# if you're in a room where you can only move up and down, disable this
var leftRightInput = true
# if you're in a room where you can only move left and right, disable this
var upDownInput = true

onready var fadeOutRect = $CanvasLayer/FadeOutRect

onready var animatedSprite:AnimatedSprite = $AnimatedSprite
onready var triggerZoneArea:Area2D = $InteractTriggerArea

func _ready():
	fadeOutRect.color = Color(0,0,0,1.0)
	yield(get_tree().create_timer(0.5), "timeout")
	$ScreenFadeAnimationPlayer.play("fadein")
	enableInput()
	$starfield.visible = true

func disableInput():
	processInput = false
	
func enableInput():
	processInput = true

func get_input():
	velocity = Vector2()
	if !processInput: return
	
	if Input.is_action_just_pressed("ui_accept"):
		var overlaps:Array = triggerZoneArea.get_overlapping_areas()
		if !overlaps.empty():
			var interactable = overlaps[0].get_parent()
			if interactable != null and (!interactable.has_method("canInteract") or interactable.canInteract($EquipmentMgr)):
				interactable.interact($EquipmentMgr)
	
	if leftRightInput:
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1

	if upDownInput:
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
		
	if velocity.x < 0:
		animatedSprite.flip_h = true
	elif velocity.x > 0:
		animatedSprite.flip_h = false
		
	var nextAnimation = "idle_right"
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

func teleport(newGlobalPosition:Vector2):
	if get_tree() == null:
		return
	disableInput()
	get_tree().paused = true
	fadeOutRect.set_global_position(global_position - fadeOutRect.rect_size/2)
	$ScreenFadeAnimationPlayer.play("fadeout")
	yield($ScreenFadeAnimationPlayer, "animation_finished")
	global_position = newGlobalPosition
	$ScreenFadeTimer.start()
	get_tree().paused = false
	yield($ScreenFadeTimer, "timeout")
	$ScreenFadeAnimationPlayer.play("fadein")
	yield($ScreenFadeAnimationPlayer, "animation_finished")
	enableInput()

func gameOver():
	disableInput()
	$ScreenFadeAnimationPlayer.play("gameOver")
	yield($ScreenFadeAnimationPlayer, "animation_finished")
	get_tree().change_scene("res://levels/gameOver/GameOver.tscn")
