active = true;
if(output){ sprite_index = spr_Window_Output;
	window_w = room_width-x;
	window_h = room_height*(1/4);
}else {
	window_w = room_width-x;
	window_h = room_height*(3/4);
}

text = [""];
viewable_text = [text[0]];
highlighted_text_range = []; //[[x1,y1], [x2, y2]]
view_start = 0;
num_lines = 1;

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
			
			if(string_length(new_line) == 0){
				line++;
				continue;
			}
			var new_len = string_length(new_line);
			var next_line = string_delete(text[line], 1, new_len);
						
			array_insert(text, line+1, next_line);
			text[line] = new_line;
			Adjust_Viewable_Text();
			Cursor_Down();
			cursor_coords[0] -= new_len;		
		}
		line++;
	}
	Adjust_Viewable_Text();
}


Get_Full_Text = function(){
	var str = "";
	for(var i=0; i<array_length(text); i++){
		str += (i == array_length(text) - 1) ? text[i] : text[i] + " ";
	}
	return str;
}

Cursor_Up = function(){
	if(cursor_coords[1] == 0){
		Scroll_Up();
		Cursor_X_Adj();
		return;
	}
	
	cursor_coords[1]--;
	Cursor_X_Adj();
}

Cursor_Down = function(){
	if(cursor_coords[1]==(array_length(viewable_text)-1)){
		Scroll_Down();
		Cursor_X_Adj();
		return;
	}
	
	cursor_coords[1]++;
	Cursor_X_Adj();
}

Cursor_Left = function(){
	if(cursor_coords[0] == 0){
		if(cursor_coords[1] == 0) return;
		Cursor_Up();
		cursor_coords[0] = string_length(viewable_text[cursor_coords[1]]);
		return;
	}
	
	cursor_coords[0]--;
}

Cursor_Right = function(){
	if(cursor_coords[0] == string_length(viewable_text[cursor_coords[1]])){
		if(cursor_coords[1] + view_start == array_length(text) -1) return;
		Cursor_Down();
		cursor_coords[0] = 0;
		return;
	}
	
	cursor_coords[0]++;
}

Cursor_X_Adj = function(){
	var len = string_length(viewable_text[cursor_coords[1]]);
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
		var y_coord = round((_y - (y + 30))/19);
		cursor_coords[1] = (y_coord < array_length(viewable_text)) ? y_coord : array_length(viewable_text)-1;
	}
	// Get X Position
	if(_x < x+5) cursor_coords[0] = 0;
	else{
		var x_coord	= round((_x - (x + 10))/9);
		cursor_coords[0] = (x_coord < string_length(viewable_text[cursor_coords[1]])) ? x_coord : string_length(viewable_text[cursor_coords[1]]);
	}
}

Cursor_To_Coords = function(_x, _y){
	cursor_coords[0] = _x;
	cursor_coords[1] = _y;
}

Click_Get_Position = function(){
	// Get Y Position
	var coords = [0,0];
	if(mouse_y < y+24) coords[1] = 0;
	else{
		var y_coord = round((mouse_y - (y + 30))/19);
		coords[1] = (y_coord < array_length(viewable_text)) ? y_coord : array_length(viewable_text)-1;
	}
	// Get X Position
	if(mouse_x < x+5) coords[0] = 0;
	else{
		var x_coord	= round((mouse_x - (x + 10))/9);
		coords[0] = (x_coord < string_length(viewable_text[coords[1]])) ? x_coord : string_length(viewable_text[coords[1]]);
	}
	
	return coords;
}

Scroll_Up = function(){
	if(view_start == 0) return;
	view_start--;
	Adjust_Viewable_Text();
}

Scroll_Down = function(){
	if(array_length(text) <= num_lines || view_start+num_lines == array_length(text)) return;
	view_start++;
	Adjust_Viewable_Text();
}

Calc_Num_Lines = function(){
	num_lines = min(array_length(text), floor(window_h/19)-1);	
}

Adjust_Viewable_Text = function(){
	Calc_Num_Lines();
	viewable_text = array_create(num_lines, -1);
	
	for(var i=0; i<num_lines; i++){
		viewable_text[i] = text[i + view_start];	
	}
	if(cursor_coords[1] > array_length(viewable_text)-1) cursor_coords[1] = array_length(viewable_text)-1;
	
	Cursor_X_Adj();	
}

Mouse_Is_In_Window = function(){
	return ((mouse_x >= x && mouse_x <= x + window_w)
		&& (mouse_y >= y && mouse_y <= y + window_h));
} 

Text_Delete_Range = function(x1, y1, x2, y2){
	if(y1 < 0) y1 = 0;
	if(y2 + view_start >= array_length(text)) y2 = array_length(text) - 1 - view_start;
	
	if(y1 == y2) text[view_start + y1] = string_delete(text[view_start + y1], x1+1, x2-x1);
	else{
		text[view_start + y2] = string_delete(text[view_start + y2], 1, x2);
		for(var i = y2-1; i>y1; i--) array_delete(text, view_start  + i, 1);
		text[view_start + y1] = string_delete(text[view_start + y1], x1+1, string_length(text[view_start+y1])-x1);
		
	}
	Cursor_To_Coords(x1, y1);
	Format_Text();
	Adjust_Viewable_Text();	
}

Text_Copy_Range = function(x1, y1, x2, y2){
	var str = "";
	if(y1 < 0) y1 = 0;
	if(y2 >= array_length(text)) y2 = array_length(text) - 1;
	
	if(y1 == y2) str = string_delete(Get_Text_Before_Coords(x2, y1), 1, x1);
	else{
		str += Get_Text_After_Coords(x1, y1);
		for(var i=y1+1; i<y2; i++) str += "\n" + string_copy(text[i + view_start], 1, string_length(text[i + view_start]));	
		str += "\n" + Get_Text_Before_Coords(x2, y2);		
	}
	clipboard_set_text(str);
}

Text_Cut_Range = function(x1, y1, x2, y2){
	if(!active) return;
	Text_Copy_Range(x1, y1, x2, y2);
	Text_Delete_Range(x1, y1, x2, y2);
}

Text_Paste = function(_x, _y){
	if(!clipboard_has_text()) return;
	var str = clipboard_get_text();
	if(string_length(str) == 0) return;
	
	var new_arr = [];
	
	var i=1;
	var curr_str = "";
	
	while(i <= string_length(str)){
		if(string_char_at(str,i) == "\n"){
			array_push(new_arr, string_copy(curr_str, 1, string_length(curr_str)));
			curr_str = "";
		}else if(string_char_at(str,i) == "\t"){
			curr_str += "   ";			
		}else curr_str += string_char_at(str, i);
	
		i++;
	}
	array_push(new_arr, string_copy(curr_str, 1, string_length(curr_str)));
	
	if(array_length(new_arr) > 0) text[_y + view_start] = string_insert(string_copy(new_arr[0],1,string_length(new_arr[0])), text[_y + view_start], _x);
	if(array_length(new_arr) > 1) {
		for(i=1; i<array_length(new_arr); i++){
			array_insert(text, _y + i + view_start, string_copy(new_arr[i], 1, string_length(new_arr[i])));
		}
	}
	
	Format_Text();
	Adjust_Viewable_Text();
}

Get_Text_Before_Coords = function(_x, _y){
	if(_y + view_start > array_length(text)) return "";
	return string_delete(text[view_start + _y], _x+1, string_length(text[view_start + _y]) - _x);
}

Get_Text_After_Coords = function(_x, _y){
	if(_y + view_start > array_length(text)) return "";
	return string_delete(text[view_start + _y], 1, _x);
}