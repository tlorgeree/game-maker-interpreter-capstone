function debug_print(str){
	if(global.debug) show_debug_message(str);
}

function print(str){
	show_debug_message(str);	
}

function Grid_Node(_x, _y, val=infinity, prev=undefined) constructor{
	x = _x;
	y = _y;
	value = val;
	previous = prev;
}

function a_star(start_coords, end_coords, grid){
	var open_set = [new Grid_Node(start_coords[0], start_coords[1])];
	var closed_set = [];
	
	while(array_length(open_set) > 0){		
		var node = open_set[0];
		if(node.x == end_coords[0] && node.y == end_coords[1]) return reconstruct_path(node);
		array_delete(open_set, 0, 1);
		array_push(closed_set, node);
		
		//left neighbor
		if(node.x > 0 && grid[node.x-1][node.y] !=1 && distance_to_coord([node.x-1, node.y], end_coords) < node.value){
			node_add_sorted(new Grid_Node(node.x-1, node.y, 
				distance_to_coord([node.x-1, node.y], end_coords), node), open_set, closed_set);
		}
		//right neighbor
		if(node.x < array_length(grid[node.x])-1 && grid[node.x+1][node.y] !=1 && distance_to_coord([node.x+1, node.y], end_coords) < node.value) {
			node_add_sorted(new Grid_Node(node.x+1, node.y,
				distance_to_coord([node.x+1, node.y], end_coords), node), open_set, closed_set);
		}
		//up neighbor
		if(node.y > 0 && grid[node.x][node.y-1] !=1 && distance_to_coord([node.x, node.y-1], end_coords) < node.value){
			node_add_sorted(new Grid_Node(node.x, node.y-1, 
				distance_to_coord([node.x, node.y-1], end_coords), node), open_set, closed_set);
		}
		//down neighbor
		if(node.y < array_length(grid)-1 && grid[node.x][node.y+1] !=1 && distance_to_coord([node.x, node.y+1], end_coords) < node.value){
			node_add_sorted(new Grid_Node(node.x, node.y+1, 
				distance_to_coord([node.x, node.y+1], end_coords), node), open_set, closed_set);
		}
		
		debug_print("we tried");
	}
	
	return undefined;
}

function distance_to_coord(start_coords, end_coords){
	return sqrt(sqr(end_coords[0] - start_coords[0]) + sqr(end_coords[1] - start_coords[1]));
}

function node_add_sorted(node, open_set, closed_set){
	//don't add if already visited
	for(var i=0; i < array_length(closed_set); i++) if(node.x == closed_set[i].x && node.y == closed_set[i].y) return;
	
	for(var i=0; i < array_length(open_set); i++){
		if(node.x == open_set[i].x && node.y == open_set[i].y) return;
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
	while(!is_undefined(curr_node)){
		array_insert(path, 0, [curr_node.x, curr_node.y]);
		curr_node = curr_node.previous;
	}
	
	return path;
}