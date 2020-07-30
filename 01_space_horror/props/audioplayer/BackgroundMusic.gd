extends AudioStreamPlayer

export var minVolume = -30
export var maxVolume = 0

func _ready():
	self.volume_db = minVolume

func updateMusicVolume(percentVolume):
	#self.volume_db = -90
	self.volume_db = lerp(minVolume, maxVolume, percentVolume)
