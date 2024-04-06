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
	&&(!keyboard_check_pressed(vk_left))&&(!keyboard_check_pressed(vk_right))))){
		text[cursor_coords[1] + view_start] = string_insert(string(keyboard_lastchar),
			text[cursor_coords[1] + view_start], cursor_coords[0]+1);
		Adjust_Viewable_Text();
		Cursor_Right();
		Format_Text();
	}

	if(keyboard_check_pressed(vk_enter) && keyboard_check(vk_shift)){
		repl.input = Get_Full_Text();
		var eval_code = repl.Start();
		var out_type = instanceof(eval_code);
		if(!is_undefined(out_type)){
			debug_print("Return type: " + (eval_code.Type() ?? "unknown type"));
			global.output_window.text = [eval_code.Inspect()];
			global.output_window.Format_Text();
			if(out_type == "ERROR") global.output_window.Set_Mode(STATUS.FAILURE);
			else global.output_window.Set_Mode(STATUS.SUCCESS);
			
		} else{ 
			global.output_window.text = ["No output"];
			global.output_window.Set_Mode(STATUS.NORMAL);
		}
	}
	
	if(keyboard_check_pressed(vk_backspace)){
		text[cursor_coords[1]] = string_delete(text[cursor_coords[1]], cursor_coords[0],1);
		Cursor_Left();
		Format_Text();
		Adjust_Viewable_Text();
	}
	if(keyboard_check_pressed(vk_enter)){
		array_insert(text, cursor_coords[1]+view_start+1, "");
		Calc_Num_Lines();
		Adjust_Viewable_Text();
		Cursor_Down();
		cursor_coords[0] = 0;
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
}

//Scroll wheel
if(mouse_wheel_up() && Mouse_Is_In_Window()) Scroll_Up();
else if(mouse_wheel_down() && Mouse_Is_In_Window()) Scroll_Down();

//Text Highlighting
if(mouse_check_button_pressed(mb_left) && Mouse_Is_In_Window()){
	highlighted_text_range = [[mouse_x, mouse_y]];
}

if(mouse_check_button_released(mb_left) && Mouse_Is_In_Window()){
	if(array_legnth(highlighted_text_range) != 1) return;
	array_push(highlighted_text_range, [mouse_x, mouse_y]);
	debug_print(highlighted_text_range);
}