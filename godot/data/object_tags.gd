class_name ObjectTags extends Resource

@export_flags(
	"CARNE",
	"CHORIZO",
	"PAN",
	"MAYO",
	"CHIMI",
	"CRUDO",
	"COCIDO") var value : int
	
func equals(other: ObjectTags) -> bool:
	return value == other.value
	
func includes(other: ObjectTags) -> bool:
	return (value & other.value) == other.value
