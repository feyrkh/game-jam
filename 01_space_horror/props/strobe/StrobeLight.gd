extends Node2D

export var rotateSpeed = 1.0

func _ready():
	$AnimationPlayer.playback_speed = rotateSpeed
	$AnimationPlayer.play("rotate")

