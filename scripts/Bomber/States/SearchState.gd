extends State
class_name BomberSearchState

var rays = PackedVector2Array()
var foundIndex = 0

func _ready():
	name = "IDLE"

func on_player_reveal_position(_player_position: Vector2):
	rays.clear()
	var directionPrime = (_player_position - global_position).normalized()

	rays.append_array([
		directionPrime,
		directionPrime.rotated(deg_to_rad(2)),
		directionPrime.rotated(deg_to_rad(4)),
		directionPrime.rotated(deg_to_rad( - 2)),
		directionPrime.rotated(deg_to_rad( - 4))
	])

	var space_state = get_world_2d().direct_space_state
	for i in range(rays.size()):
		var direction = rays[i]
		var query = PhysicsRayQueryParameters2D.create(global_position + direction * 96, global_position)
		var result = space_state.intersect_ray(query)
		print(result)
		foundIndex = i
		break

	queue_redraw()

func _draw():
	for i in range(rays.size()):
		var direction = rays[i]

		var color
		if i == foundIndex:
			color = Color(0, 1, 0)
		else:
			color = Color(1, 0, 0)

		draw_line(Vector2(), direction * 96, color, 1)
