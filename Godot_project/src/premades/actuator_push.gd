extends StaticBody3D

enum TYPE {DIGITAL, ANALOG}
@onready var tagExtend: PLCTag = $PLCTagExtend
@onready var tagLimitMax: PLCTag = $PLCTagLimitMax
@onready var tagLimitMin: PLCTag = $PLCTagLimitMin
@onready var animBody: AnimatableBody3D = $AnimatableBody3D

@export var speed := 1.0
@export var minPos := 0
@export var maxPos := 1.0
@export_category("Setup")
@export var type:TYPE
@export_category("Analog")
@export var analogIn := 0
@export var analogOut := 0

var currentPosition:float = 0.0 # z-axis
var previousState := false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# ON
	if tagExtend.Read():
		if type == TYPE.DIGITAL:
			if !tagLimitMax.Read():
				animBody.position.z = move_toward(animBody.position.z, maxPos, speed * delta)
				if is_equal_approx(animBody.position.z, maxPos):
					tagLimitMax.Write(true)
		elif type == TYPE.ANALOG:
			pass
	# OFF
	else:
		if type == TYPE.DIGITAL:
			animBody.position.z = move_toward(animBody.position.z, minPos, speed * delta)
			if is_equal_approx(animBody.position.z, minPos):
					tagLimitMin.Write(true)
	# N_TRIG
	if not tagExtend.Read() and previousState:
		tagLimitMax.Write(false)
	# P_TRIG
	if tagExtend.Read() and not previousState:
		tagLimitMin.Write(false)
	previousState = tagExtend.value
