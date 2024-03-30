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

function a_star(start_coords, end_coords, grid){
	var open_set = [new Grid_Node(start_coords[0], start_coords[1])];
	var closed_set = [];
	
	while(array_length(open_set) > 0){		
		var node = open_set[0];
		if(node.x == end_coords[0] && node.y == end_coords[1]) return reconstruct_path(node);
		array_delete(open_set, 0, 1);
		array_push(closed_set, node);
		
		//left neighbor
		if(node.x > 0 && grid[node.x-1][node.y] !=1){
			node_add_sorted(new Grid_Node(node.x-1, node.y, 
				node.value + score_node([node.x-1, node.y], start_coords, end_coords), node), open_set, closed_set);
		}
		//right neighbor
		if(node.x < array_length(grid[node.x])-1 && grid[node.x+1][node.y] !=1) {
			node_add_sorted(new Grid_Node(node.x+1, node.y,
				node.value + score_node([node.x+1, node.y], start_coords, end_coords), node), open_set, closed_set);
		}
		//up neighbor
		if(node.y > 0 && grid[node.x][node.y-1] !=1){
			node_add_sorted(new Grid_Node(node.x, node.y-1, 
				node.value + score_node([node.x, node.y-1], start_coords, end_coords), node), open_set, closed_set);
		}
		//down neighbor
		if(node.y < array_length(grid)-1 && grid[node.x][node.y+1] !=1){
			node_add_sorted(new Grid_Node(node.x, node.y+1, 
				node.value + score_node([node.x, node.y+1], start_coords, end_coords), node), open_set, closed_set);
		}
	}
	
	return undefined;
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