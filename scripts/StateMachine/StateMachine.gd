extends Node2D
class_name StateMachine

var states: Dictionary
var animation_player: AnimationPlayer
var state: State

@onready var player = get_node("/root/Main/Player")

func _init(_owner: Node2D, _states: Dictionary, _animation_player: AnimationPlayer):
    name = "StateMachine"
    states = _states
    animation_player = _animation_player

func _ready():
    player.connect("reveal_position", _on_player_reveal_position)

func change_state(new_state: State):
    if state != null:
        state.queue_free()

    state = new_state
    state.animation_player = animation_player
    add_child(state)

func _on_player_reveal_position(_position: Vector2):
    var distance = _position.distance_to(global_position)

    state.player_nearby = true

    if (distance < 10):
        state.player_nearby = false
        state.player_close = false
        state.player_next_to = false
        return

    state.player_close = true

    if (distance < 5):
        state.player_close = false
        return

    state.player_next_to = true

    if (distance < 2):
        state.player_next_to = false
        return

    state.on_player_reveal_position(_position)
