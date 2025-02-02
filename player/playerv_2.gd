extends CharacterBody3D
#3.25 e8
@export var ACCELERATION : float = 0.1
@export var DECELERACTION : float = 0.2
@export var ANIMATIONPLAYER: AnimationPlayer
@export var CROUCH_SHAPECAST: Node3D
@export var SPEED_DEFAULT: float = 5.0
@export var SPEED_CROUCH: float = 2.0
@export var SPEED_SPRINTING : float = 20.0

@export_range(5, 10, 0.1) var CROUCH_SPEED: float = 7.0

var _speed: float = 0.0
var mouse_sensitivity := 0.005
var twist_input := 0.0
var pitch_input := 0.0

var _is_crouching: bool = false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 5.5

func _ready() -> void:
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	_speed = SPEED_DEFAULT
	# Ensure CROUCH_SHAPECAST is assigned before calling add_exception()
	if CROUCH_SHAPECAST:
		CROUCH_SHAPECAST.add_exception(self)
	else:
		print("Warning: CROUCH_SHAPECAST is not assigned in the Inspector.")

func _physics_process(delta: float) -> void:
	Global.debug.add_property("MSpeed", _speed, 2)
	Global.debug.add_property("MRTwist",twist_input, 3)
	Global.debug.add_property("MRPitch",pitch_input, 4)
	# Add gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta  # Default Godot gravity

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not _is_crouching:
		velocity.y = JUMP_VELOCITY

	# Camera movement
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0

	# movement control
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var direction: Vector3 = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction.length() > 0:
		velocity.x = lerp(velocity.x,direction.x * _speed, ACCELERATION)
		velocity.z = lerp(velocity.z,direction.z * _speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERACTION)
		velocity.z = move_toward(velocity.z, 0, DECELERACTION)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Mouse movement tracking
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("crouch") and is_on_floor():
		toggle_crouch()

func toggle_crouch():
	# Prevent crouch if  an obstacle above
	if _is_crouching and CROUCH_SHAPECAST and CROUCH_SHAPECAST.is_colliding():
		return

	# Toggle crouch state
	_is_crouching = not _is_crouching
	crouching(_is_crouching)

func crouching(state: bool):
	if state:
		ANIMATIONPLAYER.play("crouch", -1, CROUCH_SPEED)
		set_movement_speed("crouching")
		print("crouching")
	else:
		ANIMATIONPLAYER.play("crouch", -1, -CROUCH_SPEED)
		set_movement_speed("default")
		print("uncrouching")

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		_is_crouching = not _is_crouching

func  set_movement_speed(state : String):
	match state:
		"default":
			_speed = SPEED_DEFAULT
		"crouching":
			_speed = SPEED_CROUCH
