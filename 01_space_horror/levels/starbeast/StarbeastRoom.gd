extends Node2D

signal approachFinished
signal attackFinished

export(float) var approachMinutes = 1

func _ready():
	startApproach()

func startApproach():
	$AnimationPlayer.playback_speed = 1/approachMinutes
	$AnimationPlayer.play("approach")
	
func startAttack():
	$AnimationPlayer.playback_speed = 1
	$AnimationPlayer.play("attack")
	get_tree().call_group("damagable", "damage")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "approach":
		emit_signal("approachFinished")
		startAttack()
	if anim_name == "attack":
		emit_signal("attackFinished")
		startApproach()
