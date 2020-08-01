extends PanelContainer

var powerPercent = 0
export var acceptablePowerPercent = 90
export var powerConsoleGroupName = "shieldConsole"

# Called when the node enters the scene tree for the first time.
func _ready():
	var acceptableLineRotation = max(0, min(180, 180 * acceptablePowerPercent/100.0))
	
func calculatePowerLevel():
	var powerSuppliers = get_tree().get_nodes_in_group(powerConsoleGroupName)
	var maxPowerLevel:float = 0
	var curPowerLevel:float = 0
	for supplier in powerSuppliers:
		maxPowerLevel += supplier.getMaxPowerLevel()
		curPowerLevel += supplier.getPowerLevel()
	if maxPowerLevel == 0: maxPowerLevel = 1
	powerPercent = int(round(curPowerLevel/maxPowerLevel * 100))
	if powerPercent < acceptablePowerPercent:
		$Label.text = str(powerPercent)+"% DANGER"
	elif powerPercent != 100:
		$Label.text = str(powerPercent)+"% WARNING"
	else:
		$Label.text = str(powerPercent)+"% OK"

func damage():
	print_debug("Are we dead? ", powerPercent, " < ", acceptablePowerPercent)
	if powerPercent < acceptablePowerPercent:
		get_tree().call_group("gameOver", "gameOver")


func _on_Timer_timeout():
	calculatePowerLevel()
