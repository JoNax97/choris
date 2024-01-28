extends Node

var objects: Array[ObjectData] = []

func _ready():
	var path = "res://data/objects"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			var obj = load(path + "/" + file_name)
			if obj is ObjectData:
				objects.push_back(obj)
	dir.list_dir_end()
	

func get_data_for_tags(tags: ObjectTags) -> ObjectData:
	for obj in objects:
		if obj.tags.equals(tags):
			return obj
			
	printerr("No object found for tags %s" % tags)
	return null
