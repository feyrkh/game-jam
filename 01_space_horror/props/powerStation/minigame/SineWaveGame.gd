extends BaseMinigame

var possibleCmds = ["ui_right", "ui_up", "ui_down", "ui_left"]
var periodCmd
var amplitudeCmd
var moveSpeedCmd

func _ready():
	periodCmd = possibleCmds[0]
	amplitudeCmd = possibleCmds[1]
	moveSpeedCmd = possibleCmds[2]
	
func setMinigameConfig(config):
	.setMinigameConfig(config)
	if !config.has("sineSetup"):
		config["sineSetup"] = true
		$ColorRect.generateRandomSetup()
		saveMinigameConfig()
	$ColorRect.amp = config["a"]
	$ColorRect.per = config["p"]
	$ColorRect.moveSpeed = config["s"]
	$ColorRect.playerAmp = config["pa"]
	$ColorRect.playerPer = config["pp"]
	$ColorRect.playerMoveSpeed = config["ps"]
	
func saveMinigameConfig():
	minigameConfig["a"] = $ColorRect.amp
	minigameConfig["p"] = $ColorRect.per
	minigameConfig["s"] = $ColorRect.moveSpeed
	minigameConfig["pa"] = $ColorRect.playerAmp
	minigameConfig["pp"] = $ColorRect.playerPer
	minigameConfig["ps"] = $ColorRect.playerMoveSpeed

func _process(_delta):
	if Input.is_action_just_pressed(periodCmd):
		$ColorRect.incrementPeriod()
		$ColorRect.checkSuccess()
		saveMinigameConfig()
	if Input.is_action_just_pressed(amplitudeCmd):
		$ColorRect.incrementAmplitude()
		$ColorRect.checkSuccess()
		saveMinigameConfig()
	if Input.is_action_just_pressed(moveSpeedCmd):
		$ColorRect.incrementMoveSpeed()
		$ColorRect.checkSuccess()
		saveMinigameConfig()

func getPowerText(powerLevel):
	match powerLevel:
		0: return "POWER SYSTEM OUT OF PHASE -   0% ALIGNMENT"
		1: return "POWER SYSTEM OUT OF PHASE -  30% ALIGNMENT"	
		2: return "POWER SYSTEM OUT OF PHASE -  60% ALIGNMENT"	
		3: return "POWER SYSTEM OUT OF PHASE - 100% ALIGNMENT"	
