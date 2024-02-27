if(active){
	if(keyboard_lastkey)&&(keyboard_check_pressed(ord(chr(keyboard_lastkey))))
	&&(!keyboard_check_pressed(vk_backspace))&&(!keyboard_check_pressed(vk_tab))
	&&(!keyboard_check_pressed(vk_shift)){
		text += string(keyboard_lastchar);
	}

	if(keyboard_check_pressed(vk_enter) && keyboard_check(vk_shift)){
		repl.input = text;
		global.output_window.text = repl.Start();
		text = "";
	}
	
	if(keyboard_check_pressed(vk_backspace)) text = string_delete(text, string_length(text), 1);
}