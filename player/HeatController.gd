extends Node
class_name HeatController

#
# signals
#

signal heat_changed(value: float)
signal thresh_changed(value: float)

#
# exports
#

@export var health_node: ClampedValue
@export var implants_node: ImplantsController
@export var overheat_damage: int = 1
@export var heat_reduction: float
@export var thresh: float
@export var max_heat: float

#
# private vars
#

var _heat: float :
	get:
		return _heat
	set(value):
		_heat = value
		if _heat < 0: _heat = 0
		if _heat > _max: _heat = _max
		heat_changed.emit(_heat)
		
var _thresh: float :
	get:
		return _thresh
	set(value):
		_thresh = value
		thresh_changed.emit(_thresh)
		
var _max: float

#
# methods
#

func _ready():
	_thresh = thresh
	_heat = thresh
	_max = max_heat

func _physics_process(delta):
	_heat -= delta * heat_reduction

#
# signal connections
#

func _on_implants_ability_added(ability: Ability):
	if not ability is ActivatedAbility: return
	var aa = ability as ActivatedAbility
	aa.started.connect(func _ah(): _add_heat(aa.use_heat))

func _add_heat(heat: float):
	if _heat > _thresh:
		health_node.value -= overheat_damage
	_heat += heat 

#
# singal connections
#
