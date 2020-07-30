extends Room

signal approachFinished
signal attackFinished

export(float) var approachMinutes = 1

func _ready():
	startApproach()

func _process(delta):
	if $AnimationPlayer.is_playing() && $AnimationPlayer.current_animation == "approach":
		$"/root/BackgroundMusic".updateMusicVolume($AnimationPlayer.current_animation_position/$AnimationPlayer.current_animation_length)
	elif $AnimationPlayer.is_playing() && $AnimationPlayer.current_animation == "attack":
		$"/root/BackgroundMusic".updateMusicVolume(1-($AnimationPlayer.current_animation_position/$AnimationPlayer.current_animation_length))

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
		approachMinutes *= 0.9
		startAttack()
	if anim_name == "attack":
		emit_signal("attackFinished")
		startApproach()
