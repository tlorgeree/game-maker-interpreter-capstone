active = true;
if(output){ sprite_index = spr_Window_Output;
	window_w = room_width-x;
	window_h = room_height*(1/4);
}else {
	window_w = room_width-x;
	window_h = room_height*(3/4);
}

text = "";

if(output) sprite_index = spr_Window_Output;
state = {
	Active : function(){
		
	},
	
	Inactive : function(){
		id.state.Active();
	}
}

Resize = function(width, height){
	//Changes the size of the window
}

Close = function(){
	//Closes the window and destroys the object
}

Minimize = function(){
	//Minimizes the window to the bottom of the screen
}

repl = new Repl(text);

Set_Mode = function(status){
	if(!output) return;
	switch(status){
		case STATUS.SUCCESS:
			sprite_index = spr_Window_Output_Success;
			break;
		case STATUS.FAILURE:
			sprite_index = spr_Window_Output_Failure;
			break;
		default:
			sprite_index = spr_Window_Output;
			break;
	}
}