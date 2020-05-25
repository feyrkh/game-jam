extends Node2D

signal approachFinished
signal attackFinished

export(float) var approachMinutes = 1

func _ready():
	$AnimationPlayer.playback_speed = 1/approachMinutes
	$AnimationPlayer.play("approach")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "approach":
		emit_signal("approachFinished")
		$AnimationPlayer.play("attack")
	if anim_name == "attack":
		emit_signal("attackFinished")
		$AnimationPlayer.play("approach")
