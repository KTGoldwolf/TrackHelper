extends Control


@export var MedKey: String
@export var MaxEntries : int = 10
@onready var TimeContainer = $VBoxContainer/TimeContainer
const TimeEntryResource = preload("res://TimeEntry.tscn")


func _on_Button_pressed():
	var timeEntries = TimeContainer.get_children()
	var newTime = TimeEntryResource.instantiate()
	TimeContainer.add_child(newTime)
	newTime.setupCurrentTime()
	TimeContainer.move_child(newTime,0)
	trimExtraEntries()
	
func _on_Button2_pressed():
	var timeEntries = TimeContainer.get_children()
	var newTime = TimeEntryResource.instantiate()
	TimeContainer.add_child(newTime)
	newTime.setupCurrentTimeWithTaken(2)
	TimeContainer.move_child(newTime,0)
	trimExtraEntries()

func trimExtraEntries():
	var entryCount = TimeContainer.get_child_count()
	if (entryCount > MaxEntries):
		var count = 1
		for entry in TimeContainer.get_children():
			if count > MaxEntries:
				entry.queue_free()
			count = count + 1
