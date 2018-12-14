package SudokuPackage is

  Not_Solvable : exception;

  type Sudoku is array(1..9, 1..9) of Integer range 0..9;

  procedure PrintBoard
    (theBoard : Sudoku);
  procedure Solve
    (theBoard : in out Sudoku);
  function Solved
    (theBoard : Sudoku)
     return Boolean;

private

  type SudokuLogicalBoard is array(1..9, 1..9) of Boolean;

  type Cell is record
    x : Integer;
    y : Integer;
  end record;

  procedure SetSudokuLogicalBoard
    (theBoard :in Sudoku;
     consts : in out SudokuLogicalBoard);
  function CheckRules
    (theBoard : Sudoku;
     c : Cell)
     return Boolean;
  function FindNextModifiable
    (consts : SudokuLogicalBoard;
     c : Cell)
     return Cell;
  function FindPrevModifiable
    (consts : SudokuLogicalBoard;
     c : Cell)
     return Cell;
end SudokuPackage;
