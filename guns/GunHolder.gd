class_name GunHolder

#
# vars
#

var gun: Gun

var ammo_count: int :
	get:
		return ammo_count
	set(value):
		ammo_count = max(0, value)

var magazine_count: int :
	get:
		return magazine_count
	set(value):
		magazine_count = clampi(value, 0, gun.magazine_size)

#
# methods
#

func _init(g: Gun):
	gun = g
	magazine_count = gun.magazine_size
	ammo_count = gun.pickup_ammo
