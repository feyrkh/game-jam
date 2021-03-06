extends Node2D

var powerPercent = 0
export var acceptablePowerPercent = 90
export var powerConsoleGroupName = "shieldConsole"

# Called when the node enters the scene tree for the first time.
func _ready():
	var acceptableLineRotation = max(0, min(180, 180 * acceptablePowerPercent/100.0))
	$AcceptableLine.rotation_degrees = acceptableLineRotation
	calculatePowerLevel()
	
func calculatePowerLevel():
	var powerSuppliers = get_tree().get_nodes_in_group(powerConsoleGroupName)
	var maxPowerLevel:float = 0
	var curPowerLevel:float = 0
	for supplier in powerSuppliers:
		maxPowerLevel += supplier.getMaxPowerLevel()
		curPowerLevel += supplier.getPowerLevel()
	powerPercent = curPowerLevel/maxPowerLevel * 100
	var needleRotation = max(0, min(180, 180 * powerPercent / 100.0))
	$Tween.interpolate_property($PowerLine, "rotation_degrees",
		$PowerLine.rotation_degrees, needleRotation, 1,
		Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_completed")
	if powerPercent >= acceptablePowerPercent:
		$PowerLine.default_color = Color(0, 1, 0, 1)
	else:
		$PowerLine.default_color = Color(1, 0, 0, 1)

func damage():
	print_debug("Are we dead? ", powerPercent, " < ", acceptablePowerPercent)
	if powerPercent < acceptablePowerPercent:
		get_tree().call_group("gameOver", "gameOver")
