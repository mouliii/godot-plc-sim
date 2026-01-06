extends CharacterBody3D

@onready var camPivot := $CamPivot
@onready var rayCast: RayCast3D = $CamPivot/Camera3D/RayCast3D
@export var mouseSens := 0.004

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var rayCastHitPrev := false
var interactPressed := false
var rayCastLastObj = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mov = event.relative * mouseSens
		rotate_y(-mov.x)
		camPivot.rotate_x(-mov.y)

func _physics_process(delta: float) -> void:
	HandleInteraction()
	HandleMovement(delta)

func HandleInteraction()->void:
	var hit = rayCast.is_colliding()
	if hit:
		var interactable = rayCast.get_collider() as Interactable
		rayCastLastObj = interactable
		if Input.is_action_just_pressed("interact"):
			interactable.onPress.call()
			interactPressed = true
		if Input.is_action_just_released("interact") and interactPressed:
			interactable.onRelease.call()
			interactPressed = false
	if not hit and rayCastHitPrev and interactPressed:
		if rayCastLastObj != null:
			rayCastLastObj.onRelease.call()
			interactPressed = false
	rayCastHitPrev = hit

func HandleMovement(delta:float)->void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forw", "move_backw")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_physics_interaction_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var dir:Vector3 = global_position.direction_to(body.global_position)
		dir.y = 0.5
		body.apply_central_impulse(dir * 4.0)
