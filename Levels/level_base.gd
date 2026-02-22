class_name Levels extends Node2D

@onready var world: TileMap = $World
@onready var items: TileMap = $Items
@onready var player: Player = $Player
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var camera: Camera2D = $Player/Camera2D

 ## BUILT-IN
func _ready():
	items.hide()
	player.reset(spawn_point.position)
	set_camera_limits()
	
func set_camera_limits():
	var map_size = world.get_used_rect()
	var cell_size = world.tile_set.tile_size
	camera.limit_left = (map_size.position.x - 5) * cell_size.x
	camera.limit_right = (map_size.end.x + 5) * cell_size.x
