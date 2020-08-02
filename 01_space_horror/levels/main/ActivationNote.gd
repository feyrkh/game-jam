extends PanelContainer

onready var EventBus = $"/root/EventBus"
var lastOwner = null

func _ready():
	self.visible = false
	EventBus.connect("showControlNote", self, "showNote")
	EventBus.connect("hideControlNote", self, "hideNote")
	$AnimationPlayer.play("pulse")

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("pulse")

func showNote(msg:String, owner:Node):
	self.visible = true
	$Label.text = msg
	lastOwner = owner
	
func hideNote(owner:Node):
	if lastOwner == owner:
		self.visible = false
