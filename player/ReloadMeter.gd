extends Control
class_name ReloadMeter

enum ReloadType { NONE, NORMAL, HOT, FAILED_HOT }

#
# signals
#
signal ejected
signal reloaded(reload_type: ReloadType)

#
# exports
#

@export var bg_color: Color
@export var fg_color: Color
@export var hot_reload_color: Color
@export var failed_hot_reload_color: Color

#
# nodes
#

@onready var main_bar: ColorRect = %Main
@onready var progress_bar: ColorRect = %Progress
@onready var hot_bar: ColorRect = %Hot

#
# vars
#

var gun: Gun :
	get:
		return gun
	set(value):
		gun = value
#		hotBar.rectTransform.offsetMax.x, -mbHeight * (_current.reloadTime - _current.hotReloadIntervalEnd) / _current.reloadTime);
		
#
# private vars
#

var _rtype: ReloadType = ReloadType.NONE
var _reload_tween: Tween
@onready var _mb_height: float = main_bar.size.y

#
# methods
#

func _ready():
	_set_bars(false)

func _set_bars(visible: bool):
	_set_main_bars(visible)
	hot_bar.visible = visible
	
func _set_main_bars(visible: bool):
	main_bar.visible = visible
	progress_bar.visible = visible
	
func _reset_colors():
	main_bar.color = bg_color
	progress_bar.color = fg_color
	hot_bar.color = hot_reload_color
	
func eject():
	_reset_colors()
	
	_set_main_bars(true)
	progress_bar.position.y = 0
	create_tween().tween_property(progress_bar, 'position', Vector2(0, _mb_height), gun.eject_time).finished.connect(_ejected)

func _ejected():
	_set_bars(false)
	ejected.emit()

func reload():
	if _rtype != ReloadType.NONE:
		if _rtype == ReloadType.FAILED_HOT:
			return
		# TODO
		var v = progress_bar.position.y
		var low = hot_bar.position.y
		var high = low + hot_bar.size.y
		if low < v and v < high:
			_rtype = ReloadType.HOT
			_reload_tween.stop()
			_reloaded()
			return
		_rtype = ReloadType.FAILED_HOT
		hot_bar.hide()
		progress_bar.color = failed_hot_reload_color
		return
	
	_reset_colors()
	_set_main_bars(true)
	_rtype = ReloadType.NORMAL
	progress_bar.position.y = 0
	hot_bar.size.y = _mb_height * (gun.hot_reload_interval_end - gun.hot_reload_interval_start) / gun.reload_time
	hot_bar.position.y = _mb_height * (gun.reload_time - gun.hot_reload_interval_end) / gun.reload_time
	hot_bar.visible = true
	progress_bar.position.y = _mb_height
#		
	_reload_tween = create_tween()
	_reload_tween.tween_property(progress_bar, 'position', Vector2(0, 0), gun.reload_time).finished.connect(_reloaded)
	
func _reloaded():
	_set_bars(false)
	reloaded.emit(_rtype)
	_rtype = ReloadType.NONE
