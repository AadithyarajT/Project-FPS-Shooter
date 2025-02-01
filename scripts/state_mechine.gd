class_name StateMachine
extends Node

@export var CURRENT_STATE: State  
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("StateMachine contains incompatible child node: " + child.name)

	if CURRENT_STATE:
		CURRENT_STATE.enter()
	else:
		push_error("StateMachine has no initial state assigned!")

func _process(delta):
	if CURRENT_STATE:
		CURRENT_STATE.update(delta)
		Global.debug.add_property("State", CURRENT_STATE.name,1)

func _physics_process(delta):
	if CURRENT_STATE:
		CURRENT_STATE.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)

	if new_state:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE = new_state
	else:
		push_warning("State does not exist: " + new_state_name)
