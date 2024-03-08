extends Node2D
class_name State

var animation_player

var player_nearby = false
var player_close = false
var player_next_to = false

func _process(_delta):
    animation_player.play(name)

func on_player_reveal_position(_player_position: Vector2):
    pass