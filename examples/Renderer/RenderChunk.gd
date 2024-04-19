extends ColorRect

var my_work_item : TaskServerWorkItem
var my_color_data : Color = Color(): set = _set_my_color

var rendering = false

func _set_my_color(val):
	my_color_data=val
	color=val # Set color of this ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$TaskServerClient.connect("work_progress", Callable(self, "_on_work_progress"))
	$TaskServerClient.connect("work_ready", Callable(self, "_on_work_ready"))
	_set_my_color(Color(0.1, 0.1, 0.1, 1))

# Updates the RenderChunk
func render(priority):
	rendering = true
	_set_my_color(Color(0, 0.5, 0, 1))
	
	my_work_item = TaskServerWorkItem.new()
	my_work_item.data = Color(1,0,0,1) # data to manipulate with function
	my_work_item.function = Callable(self, "render_task")
	my_work_item.priority = priority
	$TaskServerClient.post_work(my_work_item)

# called inside a TaskWorker thread
func render_task(data):
	randomize()
	var random_number = randf() #get a random number between 0 and 1
	
	#Simulate some render delay
	OS.delay_msec(100 + random_number*200)	# Wait for 0.5 - 2 seconds
	
	#Calculate data
	var color_value = 0.5+random_number*0.5
	data = Color(color_value, color_value, color_value, 1)
	
	return data

func _on_work_progress(work_item, progress):
	if work_item == my_work_item:
		_set_my_color(Color(0.4, 1, 0, 1))
	
func _on_work_ready(ready_work):
	# work_item should be same as my_work_item
	if ready_work == my_work_item:
		print("Chunk render done in %s seconds" % my_work_item.metadata.time_s_execute)
		# set our data to the "rendered" data
		_set_my_color(ready_work.data)
		rendering = false


func _on_RenderChunk_mouse_entered():
	if !rendering:
		render(10)
