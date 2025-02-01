class_name State
extends Node

signal transition(new_state_name: StringName)

# Called when entering a state
func enter():
	pass

# Called when exiting a state
func exit():
	pass

# Called every frame
func update(delta):
	pass

# Called every physics frame
func physics_update(delta):
	pass
