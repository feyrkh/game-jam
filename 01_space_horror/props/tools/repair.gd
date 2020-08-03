extends Tool

var repairTime:float
var repairableItem:Node

func stopActivation():
	.stopActivation()
	$Particles2D.emitting = false
	
func startActivation():
	.startActivation()
	repairTime = 1
	$Particles2D.emitting = true

func _process(delta):
	._process(delta)
	if isActive:
		repairTime -= delta
		if repairTime <= 0:
			repairTime += 1
			if repairableItem: 
				if repairableItem.doRepair(): stopActivation()
				pulseEffects()

func pulseEffects():
	$PulseParticles.emitting = true
	yield(get_tree().create_timer(0.1), "timeout")
	$PulseParticles.emitting = false


func _on_Area2D_area_entered(area):
	var areaOwner = area.get_parent()
	print("Welder entered an area")
	if areaOwner.has_method("doRepair"):
		print("Welder has a target")
		repairableItem = areaOwner


func _on_Area2D_area_exited(area):
	if repairableItem == area.get_parent():
		print("Welder lost a target")
		repairableItem = null
