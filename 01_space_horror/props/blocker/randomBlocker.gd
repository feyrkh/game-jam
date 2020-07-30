extends Node2D

func _ready():
	if randf() > 0.2: queue_free()
	else:
		if randf() >= 0.5: $tilebarrier.queue_free()
		else: $tilehole.queue_free()
