extends RigidBody3D

var forceObjects:Array[ForceObjectData] = []

func _ready() -> void:
	add_to_group("Products")

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# FREEZE MODE OFF TAI JOTAI JOTAI PITÄÄ CLEARAA MUUTAKI KI FREEZE = OFF ????!?!?!?!??
	var size := forceObjects.size()
	if size > 0:
		var dir:Vector3 = Vector3.ZERO
		var speed:float = 0.0
		for obj in forceObjects:
			dir += obj.direction
			speed += obj.speed
		dir /= size
		speed /= size
		state.linear_velocity = dir * speed

func AddForceObject(obj:ForceObjectData)->void:
	forceObjects.append(obj)
	freeze = false

func RemoveForceObject(id:int)->void:
	# TODO: can be optimized
	for obj in forceObjects:
		if obj.dataSetterID == id:
			forceObjects.erase(obj)
			break
