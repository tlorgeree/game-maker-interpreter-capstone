function GUI_Window_Manager() constructor{
	windows = [];
	
	Create_Window = function(_x, _y){
		var window = instance_create_layer(_x, _y,"Managers",obj_GUI_Window);
		array_push(windows, window);
		return window;
	}
}