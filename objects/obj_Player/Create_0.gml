actions = []; // action queue
path = [];
x_to = x;
y_to = y;
spd = 3;

state = Player_State_Idle;

Get_X = function(){
	return coords[0];
}

Get_Y = function(){
	return coords[1];	
}

Move_Up = function(){
	coords[1]--;
	y_to = coords[1]*TILE_SIZE;
	state = Player_State_Move;
}

Move_Down = function(){
	coords[1]++;
	y_to = coords[1]*TILE_SIZE;
	state = Player_State_Move;
}

Move_Left = function(){
	coords[0]--;
	x_to = coords[0]*TILE_SIZE;
	state = Player_State_Move;
}

Move_Right = function(){
	coords[0]++;
	x_to = coords[0]*TILE_SIZE;
	state = Player_State_Move;
}

Set_Path = function(path_arr){
	path = path_arr;	
}

Execute_Path = function(){
	if(state != Player_State_Idle) return;
	actions = [];
	var prev = coords;
	for(var i=0; i<array_length(path); i++){
		var curr = path[i];
		if((prev[0] == curr[0] && prev[1] == curr[1])
		|| (prev[0] != curr[0] && prev[1] != curr[1])) return;
		
		if(prev[0] != curr[0]){
			if(curr[0] - prev[0] < 0) array_push(actions, new Action(Move_Left));	
			else array_push(actions, new Action(Move_Right));
		}else if(prev[1] != curr[1]){
			if(curr[1] - prev[1] < 0) array_push(actions, new Action(Move_Up));	
			else array_push(actions, new Action(Move_Down));	
		}
		prev = path[i];
	}
}

Reset_Position = function(){
	x_to = TILE_SIZE;
	y_to = 14 * TILE_SIZE;
	coords = [1,14];
	
	state = Player_State_Move;
}

At_Destination = function(){
	return (x_to == x && y_to == y);	
}