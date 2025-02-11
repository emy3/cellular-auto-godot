extends Node2D

@export var cell_scene : PackedScene
var row_count : int = 45
var column_count : int = 80
var cell_width : int = 15
var cell_matrix : Array = []
var previous_cell_states : Array = []

func _ready():
	var rng = RandomNumberGenerator.new() # setup rand num gen
	for column in range(column_count):
		# create empty array to hold cells for this column
		cell_matrix.push_back([])
		previous_cell_states.push_back([])
		for row in range(row_count):
			var cell = cell_scene.instantiate() #instantiate the cell
			self.add_child(cell) # add it to the scene
			# set its position based on what column and row it is
			cell.position = Vector2(column * cell_width, row * cell_width)
			if(rng.randi_range(0,1) or is_edge(column, row)):
				cell.visible = false # make some invisible
				previous_cell_states[column].push_back(false)
			else:
				previous_cell_states[column].push_back(true)
			cell_matrix[column].push_back(cell) # adds cell to appropriate column array
	print(previous_cell_states)		
	pass
	
func get_next_state(column, row):
	var current = previous_cell_states[column][row]
	var neighbours_alive = get_count_of_alive_neighbours(column, row)
	
	# dead
	if current:
		if neighbours_alive > 3:
			return false
		elif neighbours_alive < 2:
			return false
	
	# birth
	else: 
		if neighbours_alive == 3:
			return true
			
	# statis
	return current

# detect edges of grid
# returns true if the position is along the top, left, bottom or right edges of the grid
func is_edge(column, row):
	return row == 0 or column == 0 or row == row_count - 1 or column == column_count - 1
	
# use two for loops to iterate over a 3x3 grid around our cell. Here x will go -1, 0, 1 and so will y. 
# If x and y are both 0 at the same time, then we skip the cell, as it shouldn't include the cell itself.
func get_count_of_alive_neighbours(column, row):
	var count = 0
	for x in range(-1, 2):
		for y in range(-1, 2):
			if not (x == 0 and y == 0):
				if previous_cell_states[column + x][row + y]:
					count += 1
	return count

func _process(delta):
	# save each cell state to old state array
	for column in range(column_count):
		for row in range(row_count):
			previous_cell_states[column][row] = cell_matrix[column][row].visible
			
	# update current state
	for column in range(column_count):
		for row in range(row_count):
			if !is_edge(column, row):
				cell_matrix[column][row].visible = get_next_state(column, row)
	pass
	
	
	
	
	
	
