##DataCourier中最基本的存储基类,继承此类的存储器能够轻易读写各种格式的数据
@abstract
extends Resource
class_name BaseDataStorage

var storage_path:String
var object:Object

func _init(_storage_path:String,_object:Object=self,_load_data_now:bool=true) -> void:
	self.storage_path=_storage_path
	self.object=_object
	if _load_data_now:
		load_data()

@abstract func save_data()->void
@abstract func load_data()->void
