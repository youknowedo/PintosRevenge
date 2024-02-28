extends Control

@onready var player = get_node("/root/Main/Player")
@onready var text_label = $RichTextLabel
@onready var texture_progress = $TextureProgressBar

func _ready():
	texture_progress.max_value = player.max_health
	_on_player_health_changed(player.health)

func _on_player_health_changed(new_health: int):
	text_label.text = "[center]" + str(new_health) + "[/center]"
	texture_progress.value = new_health
