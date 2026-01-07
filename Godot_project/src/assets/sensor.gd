extends MeshInstance3D

@onready var beam := $RayCast3D as RayCast3D
@onready var tag := $PLCTag

var prevState: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var hit = beam.is_colliding()
	if S7Wrapper.IsConnected():
		if hit and not prevState:
			tag.Write(true)
		if not hit and prevState:
			tag.Write(false)
	prevState = hit
