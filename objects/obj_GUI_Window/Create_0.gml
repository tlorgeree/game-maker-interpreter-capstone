active = true;
if(output){ sprite_index = spr_Window_Output;
	window_w = room_width-x;
	window_h = room_height*(1/4);
}else {
	window_w = room_width-x;
	window_h = room_height*(3/4);
}

text = [""];

cursor_timer_max = 40;
cursor_timer = cursor_timer_max;
cursor_visible = true;

cursor_coords = [0,0];
if(output) sprite_index = spr_Window_Output;

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

Format_Text = function(){
	//Text formatting to keep it within the window
	//New line on width exceeded
	var line = 0;
	while(line<array_length(text)){
		if(string_width(text[line]) > window_w-18){
			var last_space = 0;
			var first_space = -1;
			while((string_char_at(text[line], string_length(text[line])-last_space) == " " || first_space ==-1) 
				&& (last_space < string_length(text[line]))){
				last_space++;
				if(first_space == -1 && string_char_at(text[line], string_length(text[line])-last_space) == " "){
					first_space = last_space;
				}
			}
			
			if(last_space < string_length(text[line])){
				var ind = string_length(text[line])-last_space;
				var new_str = string_delete(text[line], ind+1, last_space);
				var next_str = string_delete(text[line], 1, string_length(text[line])-first_space);
				
				text[line] = new_str;
				array_insert(text, line+1, next_str);
			}
		}
		line++;
	}
}

Get_Full_Text = function(){
	var str = "";
	for(var i=0; i<array_length(text); i++){
		str += text[i];	
	}
	return str;
}

Cursor_Up = function(){
	if(cursor_coords[1] == 0) return;
	
	cursor_coords[1]--;
	Cursor_X_Adj();
}

Cursor_Down = function(){
	if(cursor_coords[1]>=(array_length(text)-1)) return;
	
	cursor_coords[1]++;
	Cursor_X_Adj();
}

Cursor_Left = function(){
	if(cursor_coords[0] == 0){
		if(cursor_coords[1] == 0) return;
		cursor_coords[1]--;
		cursor_coords[0] = string_length(text[cursor_coords[1]]);
		return;
	}
	
	cursor_coords[0]--;
}

Cursor_Right = function(){
	if(cursor_coords[0] == string_length(text[cursor_coords[1]])){
		if(cursor_coords[1] == array_length(text)-1) return;
		cursor_coords[1]++;
		cursor_coords[0] = 0;
		return;
	}
	
	cursor_coords[0]++;
}

Cursor_X_Adj = function(){
	var len = string_length(text[cursor_coords[1]]);
	if(cursor_coords[0] > len){
		cursor_coords[0] = len;
		return true;
	}
	
	return false;
}