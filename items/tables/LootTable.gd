extends Resource
class_name LootTable

#
# exports
#

@export var chance_for_nothing: int
@export var rows: Array[LootTableRow]

#
# methods
#

func single() -> Item:
	var count = chance_for_nothing;
	for pair in rows:
		count += pair.chance
	var v = randi_range(1, count)
	if v <= chance_for_nothing:
		return null
	v -= chance_for_nothing
	for pair in rows:
		if v > pair.chance:
			v -= pair.chance
			continue
		return pair.item

	# TODO shouldn't happen, just in case
	return null
