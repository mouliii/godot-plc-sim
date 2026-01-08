extends StaticBody3D

@onready var startBtn: Interactable = $StartButton
@onready var stopBtn: Interactable = $StopButton
@onready var actButton: Interactable = $ActButton
@onready var startPLCTag:PLCTag = $StartButton/PLCTag
@onready var stopPLCTag: PLCTag = $StopButton/PLCTag
@onready var actPLCTag: PLCTag = $ActButton/PLCTag


func _ready() -> void:
	startBtn.onPress = StartPressed
	startBtn.onRelease = StartReleased
	stopBtn.onPress = StopPressed
	stopBtn.onRelease = StopReleased
	actButton.onPress = ActPressed
	actButton.onRelease = ActReleased

func StartPressed():
	startPLCTag.Write(true)
func StartReleased():
	startPLCTag.Write(false)

func StopPressed():
	stopPLCTag.Write(true)
func StopReleased():
	stopPLCTag.Write(false)
	
func ActPressed():
	actPLCTag.Write(true)
func ActReleased():
	actPLCTag.Write(false)
