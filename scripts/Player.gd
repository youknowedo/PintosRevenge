extends CharacterBody2D

const bean = preload ("res://prefabs/Bean.tscn")

const SPEED = 75

@export var animation: AnimationPlayer
@onready var sprite = $Sprite2D
@onready var main = get_node("/root/Main/Beans")

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		var b = bean.instantiate()
		b.position = position
		b.playerSpeed = SPEED

		main.add_child(b)

func _physics_process(_delta):
	var movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = movement * SPEED

	if movement:
		animation.play("WALK")
	else:
		animation.play("RESET")

	if movement.x < 0:
		sprite.flip_h = true
	elif movement.x > 0:
		sprite.flip_h = false

	move_and_slide()
