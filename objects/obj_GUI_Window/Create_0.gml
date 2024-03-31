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
    // Text formatting to keep it within the window
    // New line on width exceeded
	var line = 0;
	while(line < array_length(text)){
		if(string_width(text[line]) > window_w - 18){
			var new_line = "";
			var line_len = string_length(text[line]);
			for(var i=1; i<=line_len; i++){
				if(string_char_at(text[line], i) == " "){
					if((string_width(new_line) + string_width(" ")) < window_w - 18) new_line += " ";
					continue;
				}
				
				var word = string_char_at(text[line], i);
				var j=1;
				var next_char = string_char_at(text[line], i+j);
				while((next_char != " ") 
					&& ((i+j) <= string_length(text[line]))){
					word += next_char;
					j++;
					next_char = string_char_at(text[line], i+j);
				}
					
				i += j-1;
				if((string_width(new_line) + string_width(word)) >= window_w - 18) break;			
				
				new_line += word;
			}
			
			var new_len = string_length(new_line);
			var next_line = string_delete(text[line], 1, new_len);
			
			cursor_coords[1]++;
			cursor_coords[0] -= new_len;
			array_insert(text, line+1, next_line);
			text[line] = new_line;
			
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

Cursor_To_Position = function(_x, _y){
	// Get Y Position
	if(_y < y+24) cursor_coords[1] = 0;
	else{
		var y_coord = round((_y - (y + 24))/19);
		cursor_coords[1] = (y_coord < array_length(text)) ? y_coord : array_length(text)-1;
	}
	
	if(_x < x+5) cursor_coords[0] = 0;
	else{
		var x_coord	= round((_x - (x + 5))/9);
		cursor_coords[0] = (x_coord < string_length(text[cursor_coords[1]])) ? x_coord : string_length(text[cursor_coords[1]]);
	}
}