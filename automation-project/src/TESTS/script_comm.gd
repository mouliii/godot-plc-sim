@tool
extends Node

# Export the JSON file path so you can change it in Inspector
@export var json_file: String = "res://DATA.txt"

# Exported dictionary to show loaded data in Inspector
@export var plc_data: Dictionary = {}

func _ready():
	# Load JSON both in editor and at runtime
	load_json()

# Function to load JSON
func load_json():
	if json_file == "":
		push_error("No JSON file specified!")
		return

	var file = FileAccess.open(json_file, FileAccess.READ)
	if not file:
		push_error("Cannot open JSON file: %s" % json_file)
		return

	var result = JSON.parse_string(file.get_as_text())
	if result.error != OK:
		push_error("JSON parse error: %s" % result.error_string)
		return

	plc_data = result.result
	print("PLC Data loaded:", plc_data)

	# Refresh Inspector in editor so exported dictionary updates
	if Engine.is_editor_hint():
		notify_property_list_changed()
