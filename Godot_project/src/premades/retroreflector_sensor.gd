extends MeshInstance3D

@onready var beam := $RayCast3D as RayCast3D
@onready var reflectorRID:RID
@onready var tag := $PLCTag

var prevState: bool = false
var prevHit:RID

func _ready() -> void:
	reflectorRID = $Reflector.get_rid()

func _physics_process(_delta: float) -> void:
	var hit = beam.is_colliding()
	if hit:
		var colRID = beam.get_collider_rid()
		# did not hit reflector
		if colRID != reflectorRID:
			# hit new target
			if colRID != prevHit:
				if S7Wrapper.IsConnected():
					tag.Write(false)
		# hit reflector
		else:
			# sensor sees reflector again
			if prevHit != reflectorRID:
				if S7Wrapper.IsConnected():
					tag.Write(true)
		prevHit = colRID
	prevState = hit
