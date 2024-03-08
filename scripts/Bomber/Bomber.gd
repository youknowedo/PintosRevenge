extends CharacterBody2D
class_name Bomber

var states = {
	"IDLE": BomberSearchState,
}

@onready var animation_player = $AnimationPlayer
@onready var state_machine = StateMachine.new(self, states, animation_player)

func _ready():
	add_child(state_machine)
	state_machine.change_state(BomberSearchState.new())
