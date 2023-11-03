extends CharacterBody2D

#
# exports
#

@export var speed: float

#
# nodes
#

@onready var sprite: Sprite2D = %Sprite

#
# methods
#

func _physics_process(delta):
	sprite.look_at(get_global_mouse_position())
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()
