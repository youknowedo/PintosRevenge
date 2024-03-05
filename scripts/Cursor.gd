extends Sprite2D

func _ready():
	set_process_input(true)

func _notification(blah):
	match blah:
		NOTIFICATION_WM_MOUSE_EXIT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NOTIFICATION_WM_MOUSE_ENTER:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
func _input(event):
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()