extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var debug = get_node("/root/Main/Debug")
@onready var player = get_node("/root/Main/Player")
@onready var space_state = get_world_2d().direct_space_state

@export var showDebug = false

func _ready():
	animation.play("IDLE")
	player.connect("reveal_position", _on_player_reveal_position)

func _on_player_reveal_position(new_position: Vector2):
	var query = PhysicsRayQueryParameters2D.create(new_position, global_position)
	var result = space_state.intersect_ray(query)

	if showDebug:
		print(result)

		var marker = ColorRect.new()
		marker.size = Vector2(2, 2)
		marker.position = new_position - Vector2(1, 1)
		if result.collider.name == "Player":
			marker.color = Color(0, 1, 0)
		else:
			marker.color = Color(1, 0, 0)

		debug.add_child(marker)

		# wait 10 seconds
		get_tree().create_timer(10).timeout.connect(func(): marker.queue_free())
