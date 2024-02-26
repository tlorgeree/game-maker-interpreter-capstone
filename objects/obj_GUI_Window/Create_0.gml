active = true;
window_w = 500;
window_h = 500;
text = "";

state = {
	Active : function(){
		
	},
	
	Inactive : function(){
		id.state.Active();
	}
}

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