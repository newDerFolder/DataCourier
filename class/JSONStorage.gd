## DataCourier 自动序列化存储器
## 自动扫描脚本中定义的变量并将其持久化为 JSON 格式
extends BaseDataStorage
class_name JSONStorage



## 保存数据为json格式
func save_data() -> void:
	var data = {}
	var properties = object.get_property_list()
	
	for prop in properties:
		# PROPERTY_USAGE_SCRIPT_VARIABLE (4096) 确保只保存开发者定义的变量
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = prop["name"]
			data[prop_name] = object.get(prop_name)
	
	var json_string = JSON.stringify(data, "\t") # 添加缩进方便阅读
	var file = FileAccess.open(storage_path, FileAccess.WRITE)
	
	if file:
		file.store_string(json_string)
		file.close()
		print("DataCourier: 成功保存至 ", storage_path)
	else:
		push_error("DataCourier: 无法打开路径进行写入: ", storage_path)


## 加载json格式数据
func load_data() -> void:
	if not FileAccess.file_exists(storage_path):
		print("DataCourier: 找不到存储文件，跳过读取。")
		return

	var file = FileAccess.open(storage_path, FileAccess.READ)
	if not file:
		return

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("DataCourier: JSON 解析失败: ", json.get_error_message())
		return

	var data = json.get_data()
	var properties = object.get_property_list()
	var loaded_count = 0
	
	for prop in properties:
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = prop["name"]
			if data.has(prop_name):
				object.set(prop_name, data[prop_name])
				loaded_count += 1
	
	print("DataCourier: 已从 ", storage_path, " 加载 ", loaded_count, " 个属性")
