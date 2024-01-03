if(keyboard_lastkey)&&(keyboard_check_pressed(ord(chr(keyboard_lastkey))))
&&(!keyboard_check_pressed(vk_backspace))&&(!keyboard_check_pressed(vk_tab))
&&(!keyboard_check_pressed(vk_shift)){
	text += string(keyboard_lastchar);
}