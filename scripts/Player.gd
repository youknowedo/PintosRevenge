extends CharacterBody2D
class_name Player

signal health_changed(new_health: int)

const bean = preload ("res://prefabs/Bean.tscn")

@onready var main = get_node("/root/Main/Beans")

@onready var sprite = $Sprite2D
@onready var animation: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var top_tile_collider: CollisionShape2D = $TopTileCollider
@onready var top_detector_collider: CollisionShape2D = $TopTileOuterDetector/CollisionShape2D
@onready var bottom_tile_collider: CollisionShape2D = $BottomTileCollider
@onready var bottom_detector_collider: CollisionShape2D = $BottomTileOuterDetector/CollisionShape2D

@export var max_health = 100
@export var speed = 75

@export_group("Attack")
@export var attack_damage = 10
@export var attack_cooldown = 0.1
@export var attack_self_damage = 2

var health = max_health

var can_attack = true
var tile_on_top = false
var tile_on_bottom = false

func _ready():
	health_changed.emit(health_changed)

func change_health(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	if health < 0:
		health = 0
	health_changed.emit(health)

func _process(_delta):
	if Input.is_action_just_pressed("fire")&&can_attack:
		var b = bean.instantiate()
		b.position = position
		b.playerSpeed = speed

		main.add_child(b)
		change_health( - attack_self_damage)
		can_attack = false
		get_tree().create_timer(attack_cooldown).timeout.connect(on_timer_timeout)

func on_timer_timeout():
	can_attack = true

func _physics_process(_delta):
	var movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = movement * speed

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
