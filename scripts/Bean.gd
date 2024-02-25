extends Sprite2D

const SPEED = 100

@export var playerSpeed: int
@export var timeAlive = 5

@onready var animation = $AnimationPlayer
@onready var mousePosition = get_global_mouse_position()
@onready var direction = (mousePosition - global_position).normalized()
@onready var playerMovement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _ready():
	await get_tree().create_timer(timeAlive).timeout
	queue_free()
	
func _physics_process(_delta):
	animation.play("ROTATE")
		
	position += (direction * SPEED) * _delta
