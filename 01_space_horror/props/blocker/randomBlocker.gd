extends Node2D

func _ready():
	if randf() > 0.2: hideBlocker()
	if randf() >= 0.5: $tilebarrier.queue_free()
	else: $tilehole.queue_free()

func hideBlocker():
	visible = false
	$StaticBody2D/CollisionShape2D.disabled = true
	
func showBlocker():
	if !isTileNearPlayer():
		visible = true
		$StaticBody2D/CollisionShape2D.disabled = false
		

func damage():
	if randf() < 0.1: showBlocker()

func isTileNearPlayer():
	var player = get_tree().get_nodes_in_group("player")[0]
	var tileGlobalX = global_position.x
	var tileGlobalY = global_position.y
	var xDist = abs(player.global_position.x - tileGlobalX)
	var yDist = abs(player.global_position.y - tileGlobalY)
	if xDist <= 100 and yDist <= 100:
		return true
