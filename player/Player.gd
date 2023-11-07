extends CharacterBody2D
class_name Player

#
# signals
#

signal credits_changed(value: int)
signal died

#
# exports
#

@export var speed: float
@export var initial_credits: int

#
# nodes
#

@onready var sprite_node: Sprite2D = %Sprite
@onready var implants_node: ImplantsController = %Implants

#
# vars
#

var credits: int :
	get:
		return credits
	set(value):
		credits = value
		if credits < 0:
			credits = 0
		credits_changed.emit(credits)

#
# methods
#

func _ready():
	credits = initial_credits

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

#
# signal connections
#

func _on_health_reached_zero():
	get_tree().create_tween().tween_property(Engine, 'time_scale', 0, .3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	died.emit()
