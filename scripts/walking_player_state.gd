class_name WalkingPlayerState
extends State 

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIMATION_SPEED : float = 0.2

func enter():
	print("Entered Walking State")
	ANIMATION.play("Walking", -1.0, 1.0)
	Global.player._speed = Global.player.SPEED_DEFAULT

func exit():
	print("Exiting Walking State")

func update(delta):
	set_animation_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")  # Transition back to idle

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, Global.player.SPEED_DEFAULT, 0.0, 10)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIMATION_SPEED, alpha)

func _input(event) -> void:
	if event.is_action_pressed("sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
