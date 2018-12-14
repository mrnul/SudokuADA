with Ada.Text_IO;
use Ada.Text_IO;

with SudokuPackage;
use SudokuPackage;

procedure Main
is
  board : Sudoku := (
                     (0,0,0, 0,0,0, 1,2,3),
                     (0,9,0, 0,0,0, 4,5,6),
                     (0,0,0, 0,0,0, 7,8,9),

                     (0,0,0, 1,2,3, 0,0,0),
                     (0,0,0, 4,5,6, 0,0,0),
                     (0,0,0, 7,8,9, 0,0,0),

                     (1,2,3, 0,0,0, 0,0,0),
                     (4,5,6, 0,0,0, 0,9,0),
                     (7,8,9, 0,0,0, 0,0,0)
                    );

begin
  Solve(board);
  PrintBoard(board);
exception
  when Not_Solvable =>
    begin
      Put_Line("Cannot be solved");
    end;
end;
