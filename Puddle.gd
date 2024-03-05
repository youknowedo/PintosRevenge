extends Area2D

@onready var timer = $Timer
@onready var player: Player = get_node("/root/Main/Player")

func _on_body_shape_entered(_body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int):
	if body.name == "Player"&&body_shape_index == 0:
		timer.autostart = true
		timer.start()

func _on_body_exited(_body: Node):
	timer.stop()

func _on_timer_timeout():
	player.change_health(1)