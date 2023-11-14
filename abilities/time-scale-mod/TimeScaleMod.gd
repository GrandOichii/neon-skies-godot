extends ActivatedAbility

#
# exports
#

@export var set_time_scale_to: float
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
	Engine.time_scale = set_time_scale_to
	
	# TODO could be the last level of upgrade - everyone is slowed down, except the player's speed
#	(parent as Player).speed = (parent as Player).speed / set_time_scale_to
	
	end_timer_node.start()
	
func end_ability():
	super.end_ability()
	Engine.time_scale = 1
	
#	(parent as Player).speed = (parent as Player).speed * set_time_scale_to
	
#
# signal connections
#

func _on_end_timer_timeout():
	end_ability()
