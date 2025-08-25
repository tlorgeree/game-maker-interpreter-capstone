# Purpose
This project was a college capstone requirement. Here, I used GameMaker to create a small application where the user can code within game to pathfind with the mouse through the maze.


## Interpreter: Capabilities
- Variables and assignment
- If statements
- For and while loops
- Arrays
- Functions
- Basic arithmetic operations
- Return

## Interpreter: REPL
- Read Evaluate Print Loop
- Responsible for handling player input and initiating
interpretation.
- Passes player input to Lexer and then to Parser
instances.
- Upon evaluation completion, output object value is
printed to the console.

## Interpreter: Lexer
- Determines the function of characters.
- Creates Tokens, the minimum functional input
units required for building the AST.
- Handles characters that serve multiple
purposes, such as '=' for assignment or
comparison.
- Checks if characters form keyword identifiers.

## Interpreter: Parser
- Controls a Lexer instance to parse user input.
- Assembles each node to insert into the AST.
- Maintains proper syntax.
- Nested nodes reference left and right
expressions surrounding the current token.

##Interpreter: Abstract Syntax Tree
- Maintains correct ordering of nested
expressions, such as PEMDAS rules for
arithmetic expressions.
- Each node of the AST contains its token, token
literal, and additional code specific to its type.
- Node-specific code is handled by the evaluator.

## Interpreter: Evaluator
- Responsible for evaluating the AST to generate
output.
- Begins with the deepest node within a branch,
evaluating its value and returning it to the parent
node.
- Follows the structure of AST assembly, evaluating
nested expressions before their parent nodes.
- Output objects produced by the evaluator
represent data types.

## Interpreter: Built-in Functions
- Native to the interpreter.
- Streamline code and help maintain focus on the
pathfinding objective.
- Evaluated like normal functions, returning objects
containing results.
- Text editing.
- Array manipulation.
- Maze information.
- Example pathfinding algorithms.

```
len(array)
array_add(array, index, value)
array_remove(array, index)
wall_at_coords(x, y)
a_star_path(x1, y1, x2, y2)
bfs_path(x1, y1, x2, y2)
dfs_path(x1, y1, x2, y2)
get_maze();
new_maze(int);
toggle_bfs_ghost();
toggle_dfs_ghost();

Player {
 get_x(), get_y(),
 move_up(), move_down(),
 move_left(), move_right(),
 set_path(path_arr),
 execute(), reset()
}
Goal {
 get_x(), get_y()
}
```

## Windows and Text Editing
- Window objects were used for flexible UI text
display.
- Used to handle the input text and display outputs
from the interpreter.
- Text editing system, highlighting, and clipboard
operations.
- Supports scrolling via mouse wheel or arrow keys.
- Helper methods ensure text stays within window
boundaries.
- Users can iterate on their code, copy from
references, and edit with preferred text editors if
desired.

## Maze and Generation
- Simple 2D grid format with cells containing either
walls (1) or clear paths (0).
- Player starts at bottom-left, Goal at top-right for
visual simplicity.
- Uses modified depth-first search algorithm.
- Initializes maze as grid of walls, then randomly
selects neighboring cells to form path.
- Imposes limitation on neighboring path tiles at any
coordinate to vary complexity.
- If no path to Goal exists, A* algorithm finds nearest
path tile to Goal to complete maze.
