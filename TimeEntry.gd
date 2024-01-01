extends Control

@onready var TimeDateLabel : Label = $HBoxContainer/TimeDateText
@onready var NameLabel : Label = $HBoxContainer/NameLabel
var AttachedTime : Dictionary
var Times : Dictionary
var Name : String
var Taken : int = 1

func setData(name:String, taken:int, new_time_data:String) -> void:
	Name = name
	Taken = taken
	var test_json_conv = JSON.new()
	test_json_conv.parse(new_time_data)
	if not new_time_data.is_empty():
		Times = test_json_conv.get_data()
		setupFromDateTimeObject(Times)
	else:
		TimeDateLabel.text = "Time data corrupted"
	setNameLabel()

func saveToFile(file: FileAccess) -> void:
	file.store_line(var_to_str(Name))
	file.store_line(var_to_str(Taken))
	var time_demo = JSON.stringify(var_to_str(Times))
	file.store_line(JSON.stringify(var_to_str(Times)))

func setupCurrentTime():
	Times = Time.get_datetime_dict_from_system()
	TimeDateLabel.text = getFormattedDateTimeString(Time.get_datetime_dict_from_system())

func setupCurrentTimeWithTaken(taken: int):
	Taken = taken
	Times = Time.get_datetime_dict_from_system()
	TimeDateLabel.text = getFormattedDateTimeString(Time.get_datetime_dict_from_system())

func setupCurrentTimeWithTakenAndName(taken: int, name: String):
	Taken = taken
	Times = Time.get_datetime_dict_from_system()
	Name = name
	setNameLabel()
	TimeDateLabel.text = getFormattedDateTimeString(Time.get_datetime_dict_from_system())

func setNameLabel():
	NameLabel.text = Name

func setupFromDateTimeObject(dateTime: Dictionary):
	TimeDateLabel.text = getFormattedDateTimeString(dateTime)

func getFormattedDateTimeString(dateTime : Dictionary) -> String:
	var timestring = getDay(dateTime.get("weekday")) + " - " + getAmPmHour(dateTime.get("hour")) + ":" + getMinutes(dateTime.get("minute")) + " " + getAmPm(dateTime.get("hour")) + " x" + str(Taken)
	return timestring

func getAmPmHour(hour:int) -> String:
	if (hour == 0):
		return str(12)
	if (hour > 12):
		return str(hour - 12)
	return str(hour)

func getMinutes(minutes: int) -> String:
	if (minutes < 10):
		return "0" + str(minutes)
	return str(minutes)

func getAmPm(hour: int) -> String:
	if (hour >= 12):
		return "PM"
	return "AM"

func getDay(dayNumber: int) -> String:
	if (dayNumber == 1):
		return "Mon"
	if (dayNumber == 2):
		return "Tues"
	if (dayNumber == 3):
		return "Wed"
	if (dayNumber == 4):
		return "Thur"
	if (dayNumber == 5):
		return "Fri"
	if (dayNumber == 6):
		return "Sat"
	if (dayNumber == 7):
		return "Sun"
	return "Someday"
