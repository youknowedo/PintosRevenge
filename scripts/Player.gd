extends CharacterBody2D

const bean = preload ("res://prefabs/Bean.tscn")

const SPEED = 75

@export var animation: AnimationPlayer
@export var top_tile_collider: CollisionShape2D
@export var top_detector_collider: CollisionShape2D
@export var bottom_tile_collider: CollisionShape2D
@export var bottom_detector_collider: CollisionShape2D

@onready var sprite = $Sprite2D
@onready var main = get_node("/root/Main/Beans")

var tile_on_top = false
var tile_on_bottom = false

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

func _on_bottom_tile_detector_body_entered(body: Node2D):
	if body is TileMap&&!tile_on_top:
		tile_on_bottom = true
		bottom_tile_collider.set_deferred("disabled", true)
		top_detector_collider.set_deferred("disabled", true)
		z_index = 3

func _on_bottom_tile_detector_body_exited(body: Node2D):
	if body is TileMap:
		tile_on_bottom = false
		bottom_tile_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		z_index = 5

func _on_top_tile_detector_body_entered(body: Node2D):
	if body is TileMap&&!tile_on_bottom:
		tile_on_top = true
		top_tile_collider.set_deferred("disabled", true)
		bottom_detector_collider.set_deferred("disabled", true)

func _on_top_tile_detector_body_exited(body: Node2D):
	if body is TileMap:
		tile_on_top = false
		top_tile_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)
