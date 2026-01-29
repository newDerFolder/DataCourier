## DataCourier 配置存储器
## 基于 ConfigFile 实现，支持 Godot 原生变量类型并支持分节存储
extends BaseDataStorage
class_name ConfigStorage

## 默认使用的配置节名称
const DEFAULT_SECTION = "Settings"

## 内部使用的 ConfigFile 实例
var _config := ConfigFile.new()


## 实现父类保存方法
func save_data() -> void:
	var properties = object.get_property_list()
	
	for prop in properties:
		# 仅处理脚本定义的变量
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = prop["name"]
			var value = object.get(prop_name)
			# 将变量保存到默认节下
			_config.set_value(DEFAULT_SECTION, prop_name, value)
	
	var err = _config.save(storage_path)
	if err == OK:
		print("DataCourier: Config 已保存至 ", storage_path)
	else:
		push_error("DataCourier: Config 保存失败，错误码: ", err)

## 实现父类加载方法
func load_data() -> void:
	var err = _config.load(storage_path)
	
	# 如果文件不存在，ConfigFile.load 会返回 ERR_FILE_NOT_FOUND
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			print("DataCourier: 未找到 Config 文件，将使用默认值。")
		else:
			push_error("DataCourier: Config 加载出错: ", err)
		return

	var properties = object.get_property_list()
	var loaded_count = 0
	
	for prop in properties:
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = prop["name"]
			# 如果配置文件中有这个键，则读取并赋值
			if _config.has_section_key(DEFAULT_SECTION, prop_name):
				var value = _config.get_value(DEFAULT_SECTION, prop_name)
				object.set(prop_name, value)
				loaded_count += 1
				
	print("DataCourier: Config 已加载 ", loaded_count, " 个属性")
