extends Interactable

export(int) var powerLevel = 0 setget setPowerLevel

func setPowerLevel(var amt):
	powerLevel = max(0, min(4, amt));
	match powerLevel:
		0: $AnimatedSprite.play("noPower")
		1: $AnimatedSprite.play("lowPower")
		2: $AnimatedSprite.play("medPower")
		3: $AnimatedSprite.play("hiPower")
		_: 
			powerLevel = 0
			$AnimatedSprite.play("noPower")

func interact():
	.interact()
	setPowerLevel(powerLevel+1)
