class_name ObjectTags extends Resource

@export_flags(
	"CARNE",
	"CHORIZO",
	"PAN",
	"MAYO",
	"CHIMI",
	"CRUDO",
	"COCIDO") var value : int = 0
	
func equals(other: ObjectTags) -> bool:
	return value == other.value
	
func includes(other: ObjectTags) -> bool:
	return (value & other.value) == other.value
	
func combine(tags_to_add: ObjectTags, tags_to_remove: ObjectTags) -> ObjectTags:
	var tags = ObjectTags.new()
	var add = tags_to_add.value
	var remove = tags_to_remove.value
	tags.value = (value | add) & (! remove)
	return tags
