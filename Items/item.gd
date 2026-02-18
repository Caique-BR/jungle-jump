class_name Items extends Area2D

signal picked_up

@onready var item_sprite : Sprite2D = $Sprite2D
var textures = {
	"cherry": "res://assest/sprites/cherry.png",
	"gem": "res://assest/sprites/gem.png"
}

func init(type, _position):
	item_sprite.texture = load(textures[type])
	position = _position

	## SIGNAL HANDLERS
	
func _on_body_entered(body: Node2D) -> void:
	picked_up.emit()
	queue_free()
