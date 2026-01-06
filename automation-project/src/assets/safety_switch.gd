extends MeshInstance3D

@onready var interactable: Interactable = $Interactable
@onready var tag: PLCData = $PLCTag
@onready var animPlayer: AnimationPlayer = $AnimationPlayer


var state := false

func _ready() -> void:
	interactable.onRelease = Pressed
	var state = S7Wrapper.ReadBool(tag.DB_num, tag.offset, tag.bit)
	if state:
		animPlayer.play("TurnOn")
	else:
		animPlayer.play("TurnOff")

func Pressed():
	state = !state
	#S7Wrapper.WriteInput(PlcDataTypes.DATA_TYPE.BOOL, tag.DB_num, tag.offset, tag.bit, state)
	S7Wrapper.WriteBool(tag.DB_num, tag.offset, tag.bit, state)
	if state:
		animPlayer.play("TurnOn")
	else:
		animPlayer.play("TurnOff")
