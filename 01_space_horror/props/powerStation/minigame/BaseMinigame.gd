extends Node
class_name BaseMinigame

var isSetup = false
var difficultyLevel:int
var controlPanel:PowerStationControlPanel

func _ready():
	setupGame()

func setupGame():
	randomize()
	if controlPanel == null:
		controlPanel = find_parent("PowerStationControlPanel")
	difficultyLevel = controlPanel.powerLevel
	isSetup = true
	
