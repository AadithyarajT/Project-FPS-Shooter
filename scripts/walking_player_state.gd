class_name WalkingPlayerState
extends State 

func enter():
	print("Entered Walking State")

func exit():
	print("Exiting Walking State")

func update(delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")  # Transition back to idle
