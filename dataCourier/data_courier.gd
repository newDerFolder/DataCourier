@icon("res://vcder/dataCourier/DataCourier_nolbg.png")
extends Node
#DataCourier​ 0.1|godot 4.5

var tempData_val:Dictionary
var tempData_letterName:String

func put_tempData(letterName,newData:Variant):
	tempData_letterName=letterName
	tempData_val=newData

func get_tempData(letterName):
	if tempData_letterName!=letterName:
		print("DataCourier​/temp:no this letter")
		return null
	var data=tempData_val.duplicate()
	tempData_val.clear()
	print("DataCourier​/temp:get and return letter now")
	return data

func keep_tempData(letterName):
	if tempData_letterName!=letterName:
		print("DataCourier​/temp:no this letter")
		return null
	var data=tempData_val.duplicate()
	print("DataCourier​/temp:keep and return letter now")
	return data
