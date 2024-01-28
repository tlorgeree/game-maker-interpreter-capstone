#region Init
display_set_gui_size(1920, 1080);
global.debug = true;
window_set_fullscreen(0);
#endregion

#region Managers
	global.Window_Manager = new GUI_Window_Manager();
	global.Window_Manager.Create_Window(50, 50);
	global.Game_Manager = new Game_Manager();
#endregion

lexer = new Lexer("this is a test string");