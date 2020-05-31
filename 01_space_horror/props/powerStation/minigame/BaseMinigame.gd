extends Node
class_name BaseMinigame

var isSetup = false
var difficultyLevel:int = 0
var controlPanel:PowerStationControlPanel
var minigameConfig:Dictionary

func _ready():
	setupGame()

func setupGame():
	randomize()
	if controlPanel == null:
		controlPanel = find_parent("PowerStationControlPanel")
	if controlPanel != null:
		difficultyLevel = controlPanel.powerLevel
	isSetup = true
	
func getPowerText(powerLevel):
	match powerLevel:
		0: return "FUEL PUMP NOT PRIMED"
		1: return "FUEL PUMP OPERATING AT MINIMUM CAPACITY"
		2: return "FUEL PUMP OPERATING AT REDUCED CAPACITY"
		3: return "FUEL PUMP OPERATING AT FULL CAPACITY"

func setMinigameConfig(_config:Dictionary):
	minigameConfig = _config
	
func saveMinigameConfig():
	pass
