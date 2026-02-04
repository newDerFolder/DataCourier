##@deprecated
@icon("res://vcder/dataCourier/DataCourier_nolbg.png")
extends Node
#DataCourier​ 0.2|godot 4.5

#region DataCourier
var tempData_val:Variant
var tempData_key:String

func put_tempData(letterKey,newData:Variant):
	tempData_key=letterKey
	tempData_val=newData

func get_tempData(letterKey):
	if tempData_key!=letterKey:
		print("DataCourier​/temp:no this letter")
		return null
	var data=tempData_val.duplicate()
	tempData_val.clear()
	print("DataCourier​/temp:get and return letter now")
	return data

func keep_tempData(letterKey):
	if tempData_key!=letterKey:
		print("DataCourier​/temp:no this letter")
		return null
	var data=tempData_val.duplicate()
	print("DataCourier​/temp:keep and return letter now")
	return data
#endregion



class moneyC extends JSONStorage:
	var gold:int=0
	var apple:int=0

var money=moneyC.new("user://money.json")
