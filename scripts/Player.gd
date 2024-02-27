extends CharacterBody2D

signal health_changed(new_health: int)

const bean = preload ("res://prefabs/Bean.tscn")

const SPEED = 75

@export var animation: AnimationPlayer
@export var top_tile_collider: CollisionShape2D
@export var top_detector_collider: CollisionShape2D
@export var bottom_tile_collider: CollisionShape2D
@export var bottom_detector_collider: CollisionShape2D

@onready var sprite = $Sprite2D
@onready var main = get_node("/root/Main/Beans")

var health = 100
var tile_on_top = false
var tile_on_bottom = false

func _ready():
	health_changed.emit(health_changed)

func change_health(amount: int):
	health += amount
	health_changed.emit(health)

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
		print("entered bottom")
		tile_on_bottom = true
		bottom_tile_collider.set_deferred("disabled", true)
		top_detector_collider.set_deferred("disabled", true)
		z_index = 3

func _on_bottom_tile_inner_detector_body_entered(body: Node2D):
	if body is TileMap&&!tile_on_top:
		print("inner bottom")
		bottom_detector_collider.set_deferred("disabled", true)
	
func _on_bottom_tile_detector_body_exited(body: Node2D):
	if body is TileMap:
		print("exited bottom" + body.name)
		tile_on_bottom = false
		bottom_tile_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		z_index = 5
	
func _on_top_tile_detector_body_entered(body: Node2D):
	if body is TileMap&&!tile_on_bottom:
		print("entered top")
		tile_on_top = true
		top_tile_collider.set_deferred("disabled", true)
		bottom_detector_collider.set_deferred("disabled", true)

func _on_top_tile_inner_detector_body_entered(body: Node2D):
	if body is TileMap&&!tile_on_bottom:
		print("inner top")
		top_detector_collider.set_deferred("disabled", true)

func _on_top_tile_detector_body_exited(body: Node2D):
	if body is TileMap:
		print("exited top")
		tile_on_top = false
		top_tile_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)

func _on_tile_exit_detector_body_exited(body):
	if body is TileMap:
		print("exited exit")
		tile_on_top = false
		tile_on_bottom = false
		top_tile_collider.set_deferred("disabled", false)
		bottom_tile_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)
		z_index = 5
