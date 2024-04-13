function debug_print(str){
	if(global.debug) show_debug_message(str);
}

function print(str){
	show_debug_message(str);	
}

function char_is_letter(char){
	return ((ord(char) >= ord("a") && ord(char) <= ord("z"))
		|| (ord(char) >= ord("A") && ord(char) <= ord("Z")))
}

function Grid_Node(_x, _y, val=infinity, prev=undefined) constructor{
	x = _x;
	y = _y;
	value = val;
	previous = prev;
}

function a_star(start_coords, end_coords, grid, ignore_collision=false){
	var open_set = [new Grid_Node(start_coords[0], start_coords[1])];
	var closed_set = [];
	
	while(array_length(open_set) > 0){		
		var node = open_set[0];
		if(node.x == end_coords[0] && node.y == end_coords[1]) return reconstruct_path(node);
		array_delete(open_set, 0, 1);
		array_push(closed_set, node);
		
		//left neighbor
		if(node.x > 0 && (ignore_collision || grid[node.x-1][node.y] !=1)){
			node_add_sorted(new Grid_Node(node.x-1, node.y, 
				node.value + score_node([node.x-1, node.y], start_coords, end_coords), node), open_set, closed_set);
		}
		//right neighbor
		if(node.x < array_length(grid[node.x])-1 && (ignore_collision || grid[node.x+1][node.y] !=1)){
			node_add_sorted(new Grid_Node(node.x+1, node.y,
				node.value + score_node([node.x+1, node.y], start_coords, end_coords), node), open_set, closed_set);
		}
		//up neighbor
		if(node.y > 0 && (ignore_collision || grid[node.x][node.y-1] !=1)){
			node_add_sorted(new Grid_Node(node.x, node.y-1, 
				node.value + score_node([node.x, node.y-1], start_coords, end_coords), node), open_set, closed_set);
		}
		//down neighbor
		if(node.y < array_length(grid)-1 && (ignore_collision || grid[node.x][node.y+1] !=1)){
			node_add_sorted(new Grid_Node(node.x, node.y+1, 
				node.value + score_node([node.x, node.y+1], start_coords, end_coords), node), open_set, closed_set);
		}
	}
	
	return [];
}

function score_node(node_coords, start_coords, end_coords){
	return abs(start_coords[0] - node_coords[0]) + abs(start_coords[1] - node_coords[1])
	+ abs(node_coords[0] - end_coords[0]) + abs(node_coords[1] - end_coords[1])
}

function distance_to_coord(start_coords, end_coords){
	return abs(start_coords[0] - end_coords[0]) + abs(start_coords[1] - end_coords[1]);
}

function node_add_sorted(node, open_set, closed_set){
	//don't add if already visited
	for(var i=0; i < array_length(closed_set); i++) if(node.x == closed_set[i].x && node.y == closed_set[i].y) return;
	
	for(var i=0; i < array_length(open_set); i++){
		if(node.x == open_set[i].x && node.y == open_set[i].y){
			if(node.value < open_set[i].value){
				open_set[i].previous = node.previous;
				open_set[i].value = node.value;
			}
			else return;			
		}
		
		if(node.value < open_set[i].value){			
			array_insert(open_set, i, node);
			return;
		}
	}
	
	array_push(open_set, node);
	return;
}

function reconstruct_path(node){
	var curr_node = node;
	var path = [];
	while(!is_undefined(curr_node.previous)){
		array_insert(path, 0, [curr_node.x, curr_node.y]);
		curr_node = curr_node.previous;
	}
	
	return path;
}

function Create_Maze(){
	var grid = array_create(17, -1);
	for(var col = 0; col < 17; col++) grid[col] = array_create(16, 1);
	
	var node;
	var stack = [[1,14]];
	var found = false;
	while(array_length(stack) > 0){ 
		node = array_pop(stack);
		var max_neighbors = 3;//must be > 2
		if(!Valid_Path_Coord(node[0], node[1], grid, max_neighbors)) continue;
		grid[node[0], node[1]] = 0;
				
		//check for goal
		if((node[0] == 14 && node[1] == 1)
		||(node[0] == 15 && node[1] == 2)){
			grid[15,1] = 0;
			found = true;
		}		
		
		//check 4 dirs
		var options = [];
		if(Valid_Path_Coord(node[0]+1, node[1], grid, max_neighbors)) array_push(options, [node[0]+1, node[1]]);
		if(Valid_Path_Coord(node[0]-1, node[1], grid, max_neighbors)) array_push(options, [node[0]-1, node[1]]);
		if(Valid_Path_Coord(node[0], node[1]+1, grid, max_neighbors)) array_push(options, [node[0], node[1]+1]);
		if(Valid_Path_Coord(node[0], node[1]-1, grid, max_neighbors)) array_push(options, [node[0], node[1]-1]);
		
		var num_opts = array_length(options);
		while(num_opts > 0){
			var choice = irandom(num_opts-1);
			array_push(stack, options[choice]);
			array_delete(options, choice, 1);
			num_opts--;
		}
	}
	 
	// catch edge case
	if(!found){
		var nearest = [];
		for(var step=1; step<16; step++){
			var options = [];
			for(var i=0; i<step; i++){			
				for(var j=0; j<step; j++){
					if(grid[15-i][1+j] == 0) array_push(options, [15-i,1+j]);
				}
			}
			
			if(array_length(options) > 0){		
				var dist = infinity;
				for(var i=0; i<array_length(options);i++){
					var curr_dist = abs(options[i][0] - 15) + abs(options[i][1] - 1);
					if(curr_dist < dist){
						dist = curr_dist;
						nearest = options[i];
					}
				}
				break;
			}			
		}
		
		if(array_length(nearest) == 2){
			var path = a_star([15,1], nearest, grid, true);
			grid[15,1] = 0;
			for(var i = 0; i < array_length(path); i++) grid[path[i][0]][path[i][1]] = 0;
		}
	}
		
	return grid;
}

function Valid_Path_Coord(_x, _y, grid, max_neighbors){
	//cannot be placed on boarder or beyond
	if(grid[_x,_y] == 0) return false;
	var w = array_length(grid)-1;
	var h = array_length(grid[_x])-1;
	if(_x <= 0 || _x >= w)
	||(_y <= 0 || _y >= h) return false;
	
	//make sure selected point wouldn't form 2x2 path square
	//top-left
	var top = grid[_x][_y-1];
	var top_left = grid[_x-1][_y-1];
	var left = grid[_x-1][_y];
	var bottom_left = grid[_x-1][_y+1];
	var bottom = grid[_x][_y+1];
	var bottom_right = grid[_x+1][_y+1];
	var right = grid[_x+1][_y];
	var top_right = grid[_x+1][_y-1];
	
	if(_x > 1 && _y > 1){
		if((top-left == 0)
		&&(left == 0 && top == 0)) return false;
	}
	
	//top-right
	if(_x < w-1 && _y > 1){
		if((top_right == 0)
		&&(right == 0 && top == 0)) return false;
	}
	
	//bottom-left
	if(_x > 1 && _y < h-1){
		if((bottom_left == 0)
		&&(left == 0 && bottom == 0)) return false;
	}
	
	//bottom-right
	if(_x < w-1 && _y < h-1){
		if((bottom_right == 0)
		&&(right == 0 && bottom == 0)) return false;
	}
	
	return ((8 - (top + top_left + top_right + left + right
	+ bottom + bottom_left + bottom_right)) < max_neighbors);
}