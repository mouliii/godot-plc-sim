extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_video_btn_pressed() -> void:
	OS.shell_open("https://www.youtube.com/watch?v=vNWSEvBKPj0&list=PL1rq2aiF4jozrMs9-kxwQHnVzFuRz58cr&index=19")


func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("uid://cc5ge4ut10bag")
