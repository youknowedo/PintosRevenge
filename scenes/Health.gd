extends Control

@onready var text_label = $RichTextLabel
@onready var texture_progress = $TextureProgressBar

func _on_player_health_changed(new_health: int):
	text_label.text = "[center]" + str(new_health) + "[/center]"
	texture_progress.value = new_health
