if(active){
	cursor_timer--;
	if(cursor_timer<=0){
		cursor_timer = cursor_timer_max;
		cursor_visible = !cursor_visible;
	}
	if(keyboard_lastkey)&&(keyboard_check_pressed(ord(chr(keyboard_lastkey))))
	&&(!keyboard_check_pressed(vk_backspace))&&(!keyboard_check_pressed(vk_tab))
	&&(!keyboard_check_pressed(vk_shift)){
		text += string(keyboard_lastchar);
	}

	if(keyboard_check_pressed(vk_enter) && keyboard_check(vk_shift)){
		repl.input = text;
		var eval_code = repl.Start();
		var out_type = instanceof(eval_code);
		if(!is_undefined(out_type)){
			debug_print("Return type: " + (eval_code.Type() ?? "unknown type"));
			global.output_window.text = eval_code.Inspect();
			if(out_type == "Error") global.output_window.Set_Mode(STATUS.FAILURE);
			else global.output_window.Set_Mode(STATUS.SUCCESS);
			
		} else{ 
			global.output_window.text = "No output";
			global.output_window.Set_Mode(STATUS.NORMAL);
		}
	}
	
	if(keyboard_check_pressed(vk_backspace)) text = string_delete(text, string_length(text), 1);
}