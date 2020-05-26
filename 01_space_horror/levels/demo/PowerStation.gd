extends AnimatedSprite

var originalLightMask

# Called when the node enters the scene tree for the first time.
func _ready():
	originalLightMask = self.light_mask

func _on_ActivationArea_area_entered(area):
	self.light_mask = 0

func _on_ActivationArea_area_exited(area):
	self.light_mask = originalLightMask
