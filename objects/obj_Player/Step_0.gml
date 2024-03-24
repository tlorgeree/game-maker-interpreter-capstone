if((x_to != x) && (y_to == y)){
	var dist;
	if(abs(x-x_to) < spd) dist = abs(x-x_to);
	else dist = spd;
	x += ((x_to < x) ? -1 : 1) * dist;
} else if((y_to != y) && (x_to == x)){
	var dist;
	if(abs(y-y_to) < spd) dist = abs(y-y_to);
	else dist = spd;
	y += ((y_to < y) ? -1 : 1) * dist;
} else if((x_to != x) && (y_to != y)){
	var dir = point_direction(x,y,x_to, y_to);
	x += lengthdir_x(spd, dir);
	y += lengthdir_y(spd, dir);
	
	if(abs(x_to-x)< spd/10) x = x_to;
	if(abs(y_to-y)< spd/10) y = y_to;
}