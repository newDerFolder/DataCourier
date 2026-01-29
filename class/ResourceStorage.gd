## DataCourier 资源存储器
## 直接将整个对象持久化为 Godot 原生资源格式 (.tres 或 .res)
extends BaseStorage
class_name ResourceStorage

## 保存数据为 .tres 或 .res 格式
func save_data() -> void:
	# ResourceSaver.save 直接将当前对象实例持久化
	# 这会自动包含所有标记为 @export 的变量
	var error = ResourceSaver.save(self, storage_path)
	
	if error == OK:
		print("DataCourier: 资源成功保存至 ", storage_path)
	else:
		push_error("DataCourier: 资源保存失败，错误代码: ", error)


## 加载数据
func load_data() -> void:
	if not FileAccess.file_exists(storage_path):
		print("DataCourier: 找不到资源文件，跳过读取。")
		return

	# 注意：ResourceLoader 会返回一个新的对象实例
	var loaded_resource = ResourceLoader.load(storage_path)
	
	if loaded_resource:
		_transfer_data(loaded_resource)
		print("DataCourier: 资源已从 ", storage_path, " 加载并同步")
	else:
		push_error("DataCourier: 无法加载资源文件: ", storage_path)


## 内部方法：将加载的对象属性拷贝到当前实例
func _transfer_data(source: Resource) -> void:
	var properties = get_property_list()
	for prop in properties:
		# 同样只针对脚本定义的变量进行同步
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = prop["name"]
			if prop_name in source:
				set(prop_name, source.get(prop_name))
