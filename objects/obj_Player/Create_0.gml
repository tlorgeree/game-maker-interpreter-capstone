spd = 3;
actions = [];

Get_X = function(){
	return coords[0];
}

Get_Y = function(){
	return coords[1];	
}

Move_Up = function(){
	coords[1]--;
	y = coords[1]*TILE_SIZE;
}

Move_Down = function(){
	coords[1]++;
	y = coords[1]*TILE_SIZE;
}

Move_Left = function(){
	coords[0]--;
	x = coords[0]*TILE_SIZE;
}

Move_Right = function(){
	coords[0]++;
	x = coords[0]*TILE_SIZE;
}