extends CharacterBody2D
class_name Player

#
# exports
#

@export var speed: float

#
# nodes
#

@onready var sprite_node: Sprite2D = %Sprite
@onready var implants_node: ImplantsController = %Implants

#
# methods
#

func _physics_process(delta):
	sprite_node.look_at(get_global_mouse_position())
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()

func _input(event):
	var activated = implants_node.get_activated_abilities()
	for ability in activated:
		if not event.is_action_pressed(ability.player_input):
			continue
		ability.do()
		return
