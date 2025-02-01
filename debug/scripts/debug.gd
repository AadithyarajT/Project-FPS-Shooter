extends PanelContainer

var properties = {}  # Dictionary to store debug properties

@onready var property_container = %VBoxContainer

func _ready() -> void:
	# Set default visibility to false
	visible = false
	
	# Add FPS as a debug property
	add_debug_property("FPS", "0")  # Initial placeholder value

func _process(delta: float) -> void:
	if visible:
		var fps = str(Engine.get_frames_per_second())

		# Update the FPS label if it exists
		if "FPS" in properties:
			properties["FPS"].text = "FPS: " + fps

func _input(event: InputEvent) -> void:
	# Toggle debug panel visibility
	if event.is_action_pressed("debug"):
		visible = !visible

func add_debug_property(title: String, value: String) -> void:
	var label = Label.new()  # Create a new label
	label.text = title + ": " + value  # Set initial text
	property_container.add_child(label)  # Add label to VBoxContainer
	
	# Store reference in dictionary
	properties[title] = label
