class_name SprintingPlayerState
extends State

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIMATION_SPEED : float = 5.0

func enter():
	ANIMATION.play("Sprinting")
	Global.player._speed = Global.player.SPEED_SPRINTING
	print("speed changed")

func _process(delta: float) -> void:
	pass

func update(delta):
	if Global.player:
		set_animation_speed(Global.player.velocity.length())

func set_animation_speed(spd) -> void:
	if Global.player:
		var alpha = remap(spd, 0.0, Global.player.SPEED_SPRINTING, 0.0, 1.0)
		ANIMATION.speed_scale = lerp(0.0, TOP_ANIMATION_SPEED, alpha)

func _input(event) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")  # Corrected signal emission
		print("SprintingPlayerState")
		
