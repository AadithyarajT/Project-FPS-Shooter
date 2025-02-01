extends PanelContainer

var properties = {}  # Dictionary to store debug properties

@onready var property_container = %VBoxContainer

func _ready() -> void:
	
	Global.debug = self
	# Set default visibility to false
	visible = false
	
	# Add FPS as a debug property
	#add_debug_property("FPS", "0")  # Initial placeholder value

func _process(delta: float) -> void:
	if visible:
		var frames_per_second = str(Engine.get_frames_per_second())
		add_property("FPS", frames_per_second, 1)
		# Update the FPS label if it exists
		#if "FPS" in properties:
			#properties["FPS"].text = "FPS: " + fps

func _input(event: InputEvent) -> void:
	# Toggle debug panel visibility
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title: String, value, order) -> void:
	var target  # Create a new label
	target = property_container.find_child(title,true,false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ":" + str(value)
	elif visible:
		target.text = title + ":" + str(value)
		property_container.move_child(target,order)
