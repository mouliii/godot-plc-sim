extends StaticBody3D

@onready var startBtn: Interactable = $StartButton
@onready var stopBtn: Area3D = $StopButton
@onready var start_tag: PLCData = $StartButton/PLCTag
@onready var stop_tag: PLCData = $StopButton/PLCTag


func _ready() -> void:
	startBtn.onPress = StartPressed
	startBtn.onRelease = StartReleased
	stopBtn.onPress = StopPressed
	stopBtn.onRelease = StopReleased

func StartPressed():
	#S7Wrapper.WriteInput(PlcDataTypes.DATA_TYPE.BOOL, start_tag.DB_num, start_tag.offset, start_tag.bit, true)
	S7Wrapper.WriteBool(2,0,0,true)
func StartReleased():
	#S7Wrapper.WriteInput(PlcDataTypes.DATA_TYPE.BOOL, start_tag.DB_num, start_tag.offset, start_tag.bit, false)
	S7Wrapper.WriteBool(2,0,0,false)

func StopPressed():
	#S7Wrapper.WriteInput(PlcDataTypes.DATA_TYPE.BOOL, start_tag.DB_num, start_tag.offset, start_tag.bit, true)
	S7Wrapper.WriteBool(2,0,1,true)
func StopReleased():
	#S7Wrapper.WriteInput(PlcDataTypes.DATA_TYPE.BOOL, start_tag.DB_num, start_tag.offset, start_tag.bit, false)
	S7Wrapper.WriteBool(2,0,1,false)
