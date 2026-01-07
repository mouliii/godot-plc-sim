extends StaticBody3D

@onready var startBtn: Interactable = $StartButton
@onready var stopBtn: Area3D = $StopButton
@onready var startPLCTag:PLCTag = $StartButton/PLCTag
@onready var stopPLCTag: PLCTag = $StopButton/PLCTag

func _ready() -> void:
	startBtn.onPress = StartPressed
	startBtn.onRelease = StartReleased
	stopBtn.onPress = StopPressed
	stopBtn.onRelease = StopReleased

func StartPressed():
	startPLCTag.Write(true)
func StartReleased():
	startPLCTag.Write(false)

func StopPressed():
	stopPLCTag.Write(true)
func StopReleased():
	stopPLCTag.Write(false)
