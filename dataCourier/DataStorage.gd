#extends Node
class_name DataStorage
var storage_path
func _init(_storage_path) -> void:
	self.storage_path=_storage_path
	load_data()
func save_data(save_path:String=storage_path):
	var path=save_path
	var data = {}
	# 获取所有属性列表，并筛选出脚本定义的变量
	var properties = get_property_list()
	for prop in properties:
		# 检查属性是否来自脚本（usage标志包含512，即PROPERTY_USAGE_SCRIPT_VARIABLE）
		if prop["usage"] & 4096:
			var prop_name = prop["name"]
			data[prop_name] = get(prop_name)
	print(data)
	var json = JSON.new()
	var json_string = json.stringify(data)# 将字典序列化为 JSON 字符串
	var file = FileAccess.open(path, FileAccess.WRITE)  # 打开文件以写入
	file.store_line(json_string)  # 写入 JSON 数据
	file.close()  # 关闭文件
	print("DataCourier :Storage file saved to: ", path)

func load_data(load_path:String=storage_path):
	var path = load_path
	if not FileAccess.file_exists(path):
		print("DataCourier :Storage file not found.")
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("DataCourier :Failed to open file for reading.")
		return false
	
	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		print("DataCourier :JSON parse error: ", error)
		return false
	
	var data = json.get_data()
	
	# 获取所有脚本定义的属性
	var properties = get_property_list()
	var loaded_count = 0
	
	for prop in properties:
		if prop["usage"] & 4096:  # PROPERTY_USAGE_SCRIPT_VARIABLE
			var prop_name = prop["name"]
			if data.has(prop_name):
				set(prop_name, data[prop_name])
				loaded_count += 1
	
	print("DataCourier :Loaded ", loaded_count, " properties from: ", path)
	return true
