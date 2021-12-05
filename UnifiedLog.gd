extends Control

const TimeEntryResource = preload("res://TimeEntry.tscn")
onready var LogContainer = $LogContainer
export var MaxEntries : int = 10
var ENTRY_SAVE_DATA_PATH = "user://savefile.save"

func _ready():
	readJournalFromFile()


func readJournalFromFile() -> void:
	var save_file = File.new()
	if not save_file.file_exists(ENTRY_SAVE_DATA_PATH):
		return
	save_file.open(ENTRY_SAVE_DATA_PATH, File.READ)
	var lines = getSaveFileLength(ENTRY_SAVE_DATA_PATH)
	if lines <= 0:
		return
	while lines > 0:
		var newName = str2var(save_file.get_line())
		var newAmount = str2var(save_file.get_line())
		var newTime = str2var(save_file.get_line())
		var newEntry = TimeEntryResource.instance()
		LogContainer.add_child(newEntry)
		newEntry.setData(newName, newAmount, newTime)
		lines -= 3
	save_file.close()

func load_entries():
	var save_file = File.new()
	if not save_file.file_exists("user://savefile.save"):
		return
	save_file.open("user://savefile.save", File.READ)
	var loadedData = JSON.parse(save_file.get_line())
	for entry in loadedData:
		create_entry(entry.name, entry.amount)
	save_file.close()

func create_entry(name: String, amount: int):
	var timeEntries = LogContainer.get_children()
	var newTime = TimeEntryResource.instance()
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
	var save_file = File.new()
	save_file.open("user://savefile.save", File.WRITE)
	for val in entries:
		val.saveToFile(save_file)
	#save_file.store_line(JSON.print(entries))
	save_file.close()
	pass

func getSaveFileLength(filePath : String) -> int:
	var save_file = File.new()
	if not save_file.file_exists(filePath):
		return 0
	save_file.open(filePath, File.READ)
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
