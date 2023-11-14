extends ActivatedAbility

#
# exports
#

@export var speed_mod: float
@export var duration: float

#
# nodes
#

@onready var end_timer_node: Timer = %EndTimer

#
# methods
#

func _ready():
	end_timer_node.wait_time = duration

func start_ability():
	super.start_ability()
	# TODO bad, can't use with AI, think of something different
	(parent as Player).speed += speed_mod
	end_timer_node.start()
	
func end_ability():
	super.end_ability()
	(parent as Player).speed -= speed_mod
	
#
# signal connections
#

func _on_end_timer_timeout():
	end_ability()
