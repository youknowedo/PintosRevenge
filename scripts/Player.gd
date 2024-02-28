extends CharacterBody2D
class_name Player

signal health_changed(new_health: int)

const bean = preload ("res://prefabs/Bean.tscn")

@onready var main = get_node("/root/Main/Beans")

@onready var sprite = $Sprite2D
@onready var animation: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var max_health = 100
@export var speed = 75

@export_group("Attack")
@export var attack_damage = 10
@export var attack_cooldown = 0.1
@export var attack_self_damage = 2

var health = max_health
var can_attack = true

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
