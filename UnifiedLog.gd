extends Control

const TimeEntryResource = preload("res://TimeEntry.tscn")
@onready var LogContainer = $LogContainer
@export var MaxEntries : int = 10
var ENTRY_SAVE_DATA_PATH = "user://savefile.save"

func _ready():
	readJournalFromFile()


func readJournalFromFile() -> void:
	if not FileAccess.file_exists(ENTRY_SAVE_DATA_PATH):
		return
	var openedFile = FileAccess.open(ENTRY_SAVE_DATA_PATH, FileAccess.READ)
	var lines = getSaveFileLength(ENTRY_SAVE_DATA_PATH)
	if lines <= 0:
		return
	while lines > 0:
		var newName = str_to_var(openedFile.get_line())
		var newAmount = str_to_var(openedFile.get_line())
		var newTime = str_to_var(openedFile.get_line())
		var newEntry = TimeEntryResource.instantiate()
		LogContainer.add_child(newEntry)
		newEntry.setData(newName, newAmount, newTime)
		lines -= 3
	openedFile.close()

func load_entries():
	if not FileAccess.file_exists("user://savefile.save"):
		return
	var openFile = FileAccess.open("user://savefile.save", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(openFile.get_line())
	var loadedData = test_json_conv.get_data()
	for entry in loadedData:
		create_entry(entry.name, entry.amount)
	openFile.close()

func create_entry(name: String, amount: int):
	var timeEntries = LogContainer.get_children()
	var newTime = TimeEntryResource.instantiate()
	LogContainer.add_child(newTime)
	newTime.setupCurrentTimeWithTakenAndName(amount, name)
	LogContainer.move_child(newTime,0)
	trimExtraEntries()
	saveEntries()

func trimExtraEntries():
	var entryCount = LogContainer.get_child_count()
	if (entryCount > MaxEntries):
		var count = 1
		for entry in LogContainer.get_children():
			if count > MaxEntries:
				entry.queue_free()
			count = count + 1

func saveEntries():
	var entries = LogContainer.get_children()
	var save_file = FileAccess.open("user://savefile.save", FileAccess.WRITE)
	for val in entries:
		val.saveToFile(save_file)
	#save_file.store_line(JSON.print(entries))
	save_file.close()
	pass

func getSaveFileLength(filePath : String) -> int:
	if not FileAccess.file_exists(filePath):
		return 0
	var save_file = FileAccess.open(filePath, FileAccess.READ)
	var lines = 0
	while !save_file.eof_reached():
		lines += 1
		save_file.get_line()
	# Remove one extra empty line that is written
	return lines - 1

func _on_Ibuprofen1_pressed():
	create_entry("Ibuprofen", 1)

func _on_Ibuprofen2_pressed():
	create_entry("Ibuprofen", 2)

func _on_Acetaminophen1_pressed():
	create_entry("Acetaminophen", 1)

func _on_Acetaminophen2_pressed():
	create_entry("Acetaminophen", 2)
