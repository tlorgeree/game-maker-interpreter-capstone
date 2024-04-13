function Player_State_Idle(){
	if(array_length(actions)>0){
		if(actions[0].complete) array_delete(actions, 0, 1);
		else actions[0].Execute();
	}
	if(Get_X() == obj_Goal.Get_X() && Get_Y() == obj_Goal.Get_Y()){
		obj_Main.win = true;
		global.output_window.Set_Mode(STATUS.SUCCESS);
		global.output_window.text = "YOU WIN!\n\n use crtl + R to restart with a new maze";
		global.output_window.Format_Text();
	}
}

function Player_State_Move(){
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
	}
	
	if(abs(x_to-x) < spd/2) x = x_to;
	if(abs(y_to-y) < spd/2) y = y_to;
	
	if(x == x_to && y == y_to) state = Player_State_Idle;
}