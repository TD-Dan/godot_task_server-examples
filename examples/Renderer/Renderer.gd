extends Control

var x_count = 20
var y_count = 12

enum R_STATE {
	NONE,
	INIT,
	RENDER_INIT,
	RENDERING,
	PAUSE,
	READY
}

var render_state = R_STATE.NONE: set = _set_render_state
var render_chunk_scene = preload("res://examples/Renderer/RenderChunk.tscn")
@onready var render_container = $HSplitContainer/RenderChunkContainer

func _set_render_state(val):
	render_state = val
	if render_state < R_STATE.INIT:
		# clear old render chunks
		for n in render_container.get_children():
			n.queue_free()
		
		# Create RenderChunks
		render_container.columns = x_count
		
		for x in range(0,x_count*y_count):
			render_container.add_child(render_chunk_scene.instantiate())
		
		render_state = R_STATE.INIT
	
	if render_state == R_STATE.RENDER_INIT:
		for chunk in render_container.get_children():
			chunk.render(100)
		render_state = R_STATE.RENDERING


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_render_state(R_STATE.NONE)
	


func _on_XSpinBox_value_changed(value):
	x_count = value
	_set_render_state(R_STATE.NONE)


func _on_YSpinBox2_value_changed(value):
	y_count = value
	_set_render_state(R_STATE.NONE)

func _on_StartButton_pressed():
	if render_state != R_STATE.INIT:
		_set_render_state(R_STATE.NONE)
	if render_state == R_STATE.INIT:
		_set_render_state(R_STATE.RENDER_INIT)


func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_ClearButton_pressed():
	_set_render_state(R_STATE.NONE)
