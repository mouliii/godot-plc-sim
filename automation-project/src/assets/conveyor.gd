extends StaticBody3D

@onready var tag := $PLCTag as PLCData

@export var beltSpeed:float
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
	if tag.value == true:
		$Belt.material_override.set_shader_parameter("speed", 3.0)
	else:
		$Belt.material_override.set_shader_parameter("speed", 0.0)
	# p_trig
	if tag.value and not prevState:
		for obj in productsInside:
			AddForceToObj(obj)
	# n_trig
	if not tag.value and prevState:
		for obj in productsInside:
			RemoveForceToObj(obj)
	prevState = tag.value

func _on_area_3d_body_entered(body: RigidBody3D) -> void:
	productsInside.append(body)
	if tag.value:
		AddForceToObj(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	RemoveForceToObj(body)
	productsInside.erase(body)

func AddForceToObj(body: RigidBody3D)->void:
	body.AddForceObject(fod)
func RemoveForceToObj(body: RigidBody3D)->void:
	body.RemoveForceObject(get_instance_id())
