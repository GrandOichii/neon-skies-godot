extends Node2D

#
# exports
#

@export var damage: int = 1
@export var speed: float
@export var dissapear_after: float

#
# private vars
#

@onready var _left: float = dissapear_after

#
# methods
#

func _physics_process(delta: float):
	position += transform.x * speed * delta

func _process(delta):
	_left -= delta
	if _left < 0:
		queue_free()

#
# signal connections
#

func _on_body_entered(body: Node2D):
	var health = body.get_node_or_null('Health') as ClampedValue
	if health != null:
		health.value -= damage
	var is_solid = body.is_in_group('solid')
	if is_solid:
		queue_free()
	if body is TileMap:
		# TODO sometimes tile is null for some reason
#		var tile_map = body as TileMap
#		var coords = tile_map.local_to_map(tile_map.to_local(global_position))
#		var tile: TileData = tile_map.get_cell_tile_data(1, coords)
#		print(coords, ' ', tile)
#		var l = tile.get_custom_data('life')
#		print(l)
#		var tile = tile_map.get_cellv(tile_map.world_to_map(global_position))
		# TODO for now will do, however need a way to interact with custom layers for more options when hitting tiles
		queue_free()
