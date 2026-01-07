extends Node

func _ready() -> void:
	var status = S7Wrapper.ConnectToPLC("192.168.0.90",0,1)
	if status != 0:
		print("connection failed")
	else:
		print("connected to PLC!")

func _process(_delta: float) -> void:
	# read tags
	if Input.is_action_just_pressed("toggle_mouse"):
		var mm = Input.mouse_mode
		if mm == Input.MouseMode.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE

func _on_timer_timeout() -> void:
	if S7Wrapper.IsConnected():
		get_tree().call_group("PLC_TAGS", "ReadNewData")

func SpawnBox()->void:
	var pos := Vector3(-3.4, 2.8, -0.23)
	var b = load("res://src/assets/box.tscn")
	var box = b.instantiate()
	$World.add_child(box)
	box.global_position = pos

func _on_box_despawner_body_entered(body: Node3D) -> void:
	if body.is_in_group("Products"):
		body.queue_free()

func _on_box_spawner_body_exited(_body: Node3D) -> void:
	SpawnBox()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position = Vector3(-2.295,1.187,5.321)
