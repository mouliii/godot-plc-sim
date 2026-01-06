extends MeshInstance3D

@onready var beam := $RayCast3D as RayCast3D
@onready var tag := $PLCTag

var prevState: bool = false

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var hit = beam.is_colliding()
	if S7Wrapper.IsConnected():
		if hit and not prevState:
			S7Wrapper.WriteBool(tag.DB_num, tag.offset, tag.bit, true)
		if not hit and prevState:
			S7Wrapper.WriteBool(tag.DB_num, tag.offset, tag.bit, false)
	prevState = hit
