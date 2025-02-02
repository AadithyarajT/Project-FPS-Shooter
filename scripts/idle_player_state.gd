class_name IdlePlayerState
extends State 

@export var ANIMATION : AnimationPlayer

func enter():
	print("Entered Idle State")
	ANIMATION.pause()

func exit():
	print("Exiting Idle State")

func update(delta):
	if Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")  # Transition to walking
