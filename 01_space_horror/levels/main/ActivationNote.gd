extends PanelContainer

onready var EventBus = $"/root/EventBus"

func _ready():
	self.visible = false
	EventBus.connect("showControlNote", self, "showNote")
	EventBus.connect("hideControlNote", self, "hideNote")

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("pulse")

func showNote(msg:String):
	self.visible = true
	$Label.text = msg
	$AnimationPlayer.play("pulse")
	
func hideNote():
	self.visible = false
	$AnimationPlayer.stop()
