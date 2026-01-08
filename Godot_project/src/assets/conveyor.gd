extends StaticBody3D

@export var beltSpeed:float
@onready var tag := $PLCTag
var beltDir := Vector3.ZERO
var fod :ForceObjectData
var productsInside := []
var prevState := false

func _ready() -> void:
	$Belt.material_override.set_shader_parameter("speed", 0.0)
	beltDir = -transform.basis.z
	beltSpeed = 5.0
	fod = ForceObjectData.new()
	fod.dataSetterID = get_instance_id()
	fod.direction = beltDir
	fod.speed = beltSpeed

func _process(_delta: float) -> void:
	var readCached:bool = tag.Read()
	if readCached == true:
		$Belt.material_override.set_shader_parameter("speed", 3.0)
	else:
		$Belt.material_override.set_shader_parameter("speed", 0.0)
	# p_trig
	if readCached and not prevState:
		for obj in productsInside:
			AddForceToObj(obj)
	# n_trig
	if not readCached and prevState:
		for obj in productsInside:
			RemoveForceToObj(obj)
	prevState = readCached

func _on_area_3d_body_entered(body: RigidBody3D) -> void:
	productsInside.append(body)
	if tag.Read():
		AddForceToObj(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	RemoveForceToObj(body)
	productsInside.erase(body)

func AddForceToObj(body: RigidBody3D)->void:
	body.AddForceObject(fod)
func RemoveForceToObj(body: RigidBody3D)->void:
	body.RemoveForceObject(get_instance_id())
