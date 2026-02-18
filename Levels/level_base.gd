class_name Levels extends Node2D

@onready var items : TileMap = $Items
@onready var player: Player = $Player
@onready var spawn_point: Marker2D = $SpawnPoint


 ## BUILT-IN
func _ready():
	items.hide()
	player.reset(spawn_point.position)
