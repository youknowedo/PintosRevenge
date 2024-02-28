extends Node2D

@onready var characterBody: CharacterBody2D = get_parent()
@onready var top_detector_collider: CollisionShape2D = $TopTileOuterDetector/CollisionShape2D
@onready var bottom_detector_collider: CollisionShape2D = $BottomTileOuterDetector/CollisionShape2D

@export var tilesOnly = true
@export var top_tile_collider: CollisionShape2D
@export var bottom_tile_collider: CollisionShape2D

var tile_on_top = false
var tile_on_bottom = false

func _ready():
	characterBody.z_index = 4
	
func _on_top_outer_body_entered(body: Node2D):
	print("body.name")
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name&&!tile_on_bottom:
		tile_on_top = true
		top_tile_collider.set_deferred("disabled", true)
		bottom_detector_collider.set_deferred("disabled", true)

func _on_top_inner_body_entered(body: Node2D):
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name&&!tile_on_bottom:
		top_detector_collider.set_deferred("disabled", true)

func _on_top_inner_body_exited(body: Node2D):
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name:
		tile_on_top = false
		top_tile_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)

func _on_bottom_outer_body_entered(body: Node2D):
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name&&!tile_on_top:
		tile_on_bottom = true
		bottom_tile_collider.set_deferred("disabled", true)
		top_detector_collider.set_deferred("disabled", true)
		characterBody.z_index = 3

func _on_bottom_inner_body_entered(body: Node2D):
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name&&!tile_on_top:
		bottom_detector_collider.set_deferred("disabled", true)
	
func _on_bottom_inner_body_exited(body: Node2D):
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name:
		tile_on_bottom = false
		bottom_tile_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)

func _on_exit_body_exited(body):
	print("body.name")
	if (!tilesOnly||(body is TileMap))&&body.name != characterBody.name:
		tile_on_top = false
		tile_on_bottom = false
		top_tile_collider.set_deferred("disabled", false)
		bottom_tile_collider.set_deferred("disabled", false)
		top_detector_collider.set_deferred("disabled", false)
		bottom_detector_collider.set_deferred("disabled", false)
		characterBody.z_index = 4