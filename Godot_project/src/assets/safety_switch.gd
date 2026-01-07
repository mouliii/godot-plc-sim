extends MeshInstance3D

@onready var interactable: Interactable = $Interactable
@onready var tag: PLCTag = $PLCTag
@onready var animPlayer: AnimationPlayer = $AnimationPlayer


var state := false

func _ready() -> void:
	interactable.onRelease = Pressed
	if state:
		animPlayer.play("TurnOn")
	else:
		animPlayer.play("TurnOff")

func Pressed():
	state = !state
	tag.Write(state)
	if state:
		animPlayer.play("TurnOn")
	else:
		animPlayer.play("TurnOff")
