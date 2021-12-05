extends Control

onready var TimeDateLabel : Label = $HBoxContainer/TimeDateText
onready var NameLabel : Label = $HBoxContainer/NameLabel
var AttachedTime : Dictionary
var Time : Dictionary
var Name : String
var Taken : int = 1

func setData(name:String, taken:int, time:String) -> void:
	Name = name
	Taken = taken
	Time = parse_json(time)
	setupFromDateTimeObject(Time)
	setNameLabel()

func saveToFile(file: File) -> void:
	file.store_line(var2str(Name))
	file.store_line(var2str(Taken))
	file.store_line(to_json(var2str(Time)))

func setupCurrentTime():
	Time = OS.get_datetime()
	TimeDateLabel.text = getFormattedDateTimeString(OS.get_datetime())

func setupCurrentTimeWithTaken(taken: int):
	Taken = taken
	Time = OS.get_datetime()
	TimeDateLabel.text = getFormattedDateTimeString(OS.get_datetime())

func setupCurrentTimeWithTakenAndName(taken: int, name: String):
	Taken = taken
	Time = OS.get_datetime()
	Name = name
	setNameLabel()
	TimeDateLabel.text = getFormattedDateTimeString(OS.get_datetime())

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
