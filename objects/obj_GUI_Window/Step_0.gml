if(active){
	cursor_timer--;
	if(cursor_timer<=0){
		cursor_timer = cursor_timer_max;
		cursor_visible = !cursor_visible;
	}
	
	if(keyboard_lastkey)&&(keyboard_check_pressed(ord(chr(keyboard_lastkey))))
	&&(!keyboard_check_pressed(vk_backspace))&&(!keyboard_check_pressed(vk_tab))
	&&(!keyboard_check_pressed(vk_shift)&&(!keyboard_check_pressed(vk_enter)
	&&(!keyboard_check_pressed(vk_up)&&(!keyboard_check_pressed(vk_down))
	&&(!keyboard_check_pressed(vk_left))&&(!keyboard_check_pressed(vk_right))
	&& (!keyboard_check(vk_control)&& (!keyboard_check(vk_delete)))
	))){
		text[cursor_coords[1] + view_start] = string_insert(string(keyboard_lastchar),
			text[cursor_coords[1] + view_start], cursor_coords[0]+1);
		Adjust_Viewable_Text();
		Cursor_Right();
		Format_Text();
	}

	if(keyboard_check_pressed(vk_enter)){
		if (keyboard_check(vk_shift)){
			repl.input = Get_Full_Text();
			var eval_code = repl.Start();
			var out_type = instanceof(eval_code);
			if(!is_undefined(out_type)){
				debug_print("Return type: " + (eval_code.Type() ?? "unknown type"));
				global.output_window.text = [eval_code.Inspect()];
				global.output_window.view_start = 0;
				global.output_window.cursor_coords = [0,0];
				global.output_window.Format_Text();
				if(out_type == "ERROR") global.output_window.Set_Mode(STATUS.FAILURE);
				else global.output_window.Set_Mode(STATUS.SUCCESS);
			
			} else{ 
				global.output_window.text = ["No output"];
				global.output_window.Set_Mode(STATUS.NORMAL);
			}
		} else{
			array_insert(text, cursor_coords[1]+view_start+1, Get_Text_After_Coords(cursor_coords[0], cursor_coords[1]+view_start));
			text[cursor_coords[1]+view_start] = Get_Text_Before_Coords(cursor_coords[0], cursor_coords[1]+view_start);
			Calc_Num_Lines();
			Adjust_Viewable_Text();
			Cursor_Down();
			cursor_coords[0] = 0;
		}
	}
	
	if(keyboard_check_pressed(vk_backspace)){
		if(array_length(highlighted_text_range) == 2){
			Text_Delete_Range(highlighted_text_range[0,0], highlighted_text_range[0,1], 
				highlighted_text_range[1,0], highlighted_text_range[1,1]);
			highlighted_text_range = [];	
			return;
		}
		if((cursor_coords[0] == 0) && ((cursor_coords[1] + view_start) != 0)){
			var str;
			var prev_line_len = string_length(viewable_text[cursor_coords[1] -1]);
			var curr_line_len = string_length(viewable_text[cursor_coords[1]]);
			
			if(string_char_at(viewable_text[cursor_coords[1] - 1], 
				prev_line_len) == " "){
				str = string_copy(viewable_text[cursor_coords[1]], 1, curr_line_len);
			} else str = " " + string_copy(viewable_text[cursor_coords[1]], 1, curr_line_len);			
			
			text[cursor_coords[1] -1 + view_start] += str;
			array_delete(text, cursor_coords[1] + view_start , 1);						
			
		}else text[cursor_coords[1] + view_start] = string_delete(text[cursor_coords[1] + view_start], cursor_coords[0],1);
		
		Cursor_Left();
		Format_Text();
		Adjust_Viewable_Text();
	}
	
	//cursor movement
	if(keyboard_check_pressed(vk_up)) Cursor_Up();
	if(keyboard_check_pressed(vk_down)) Cursor_Down();	
	if(keyboard_check_pressed(vk_left)) Cursor_Left();	
	if(keyboard_check_pressed(vk_right)) Cursor_Right();
	
	//move cursor on click
	if(mouse_check_button_pressed(mb_left) && mouse_x > x && mouse_x < x + window_w)
	&&(mouse_y > y && mouse_y < y + window_h){
		Cursor_To_Position(mouse_x, mouse_y);	
	}
	
	if((array_length(highlighted_text_range) == 2) && keyboard_check(vk_control)){
		if(keyboard_check_pressed(ord("C"))){
			Text_Copy_Range(highlighted_text_range[0,0], highlighted_text_range[0,1], 
				highlighted_text_range[1,0], highlighted_text_range[1,1]);
		}else if(keyboard_check_pressed(ord("X"))){
			Text_Cut_Range(highlighted_text_range[0,0], highlighted_text_range[0,1], 
				highlighted_text_range[1,0], highlighted_text_range[1,1]);
			highlighted_text_range = [];
		}
	}
	
	if(keyboard_check_pressed(ord("V")) && keyboard_check(vk_control)){
		if(array_length(highlighted_text_range) == 2){
			Text_Delete_Range(highlighted_text_range[0,0], highlighted_text_range[0,1],
				highlighted_text_range[1,0], highlighted_text_range[1,1]);
		}
		
		Text_Paste(cursor_coords[0], cursor_coords[1]);
	}
}

//Scroll wheel
if(mouse_wheel_up() && Mouse_Is_In_Window() && array_length(highlighted_text_range) == 0) Scroll_Up();
else if(mouse_wheel_down() && Mouse_Is_In_Window() && array_length(highlighted_text_range) == 0) Scroll_Down();

//Text Highlighting
if(mouse_check_button_pressed(mb_left) && Mouse_Is_In_Window()){
	highlighted_text_range = [Click_Get_Position()];
}

if(mouse_check_button_released(mb_left) && Mouse_Is_In_Window()){
	if(array_length(highlighted_text_range) != 1) return;
	array_push(highlighted_text_range, Click_Get_Position());
	if(highlighted_text_range[0,0] == highlighted_text_range[1,0]
		&& highlighted_text_range[0,1] == highlighted_text_range[1,1]){
			highlighted_text_range = [];
			return;
	}
	
	if((highlighted_text_range[0,1] > highlighted_text_range[1,1])
		|| ((highlighted_text_range[0,1] == highlighted_text_range[1,1]) 
		&& (highlighted_text_range[0,0] > highlighted_text_range[1,0]))){
		var temp = highlighted_text_range[0];
		array_delete(highlighted_text_range, 0, 1);
		array_push(highlighted_text_range, temp);
	}
}