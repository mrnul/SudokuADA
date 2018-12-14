with Ada.Text_IO;
use Ada.Text_IO;

package body SudokuPackage is
  --=============================================================================================
  procedure PrintBoard
    (theBoard : Sudoku)
  is
  begin
    Put("--================--" & ASCII.LF);
    for i in theBoard'Range(1) loop
      for j in theBoard'Range(2) loop
        Put(Integer'Image(theBoard(i,j)));
        if j mod 3 = 0 then
          Put(' ');
        end if;
      end loop;
      if i mod 3 = 0 then
        New_Line;
      end if;
      New_Line;
    end loop;
    Put("--================--" & ASCII.LF);
  end PrintBoard;

  --=============================================================================================
  procedure Solve
    (theBoard : in out Sudoku)
  is
    consts : SudokuLogicalBoard;
    c : Cell := (1,0);
  begin
    SetSudokuLogicalBoard(theBoard, consts);

    while not Solved(theBoard) loop

      c := FindNextModifiable(consts, c);
      if c.x = -1 or c.y = -1 then
        raise Not_Solvable;
      end if;

      theBoard(c.x, c.y) := theBoard(c.x, c.y) + 1;

      while CheckRules(theBoard,c) = False loop

        while theBoard(c.x, c.y) = 9 loop
          theBoard(c.x, c.y) := 0;
          c := FindPrevModifiable(consts, c);
          if c.x = -1 or c.y = -1 then
            raise Not_Solvable;
          end if;
        end loop;

        theBoard(c.x, c.y) := theBoard(c.x, c.y) + 1;
      end loop;

    end loop;
  end Solve;

  --=============================================================================================
  function Solved
    (theBoard : Sudoku)
     return Boolean
  is
    c : Cell := (-1,-1);
  begin
    for i in theBoard'Range(1) loop
      for j in theBoard'Range(2) loop
        c.x := i;
        c.y := j;
        if theBoard(c.x, c.y) = 0 or CheckRules(theBoard, c) = False then
          return False;
        end if;
      end loop;
    end loop;
    return true;
  end Solved;

  --Private members begin here
  --=============================================================================================
  procedure SetSudokuLogicalBoard
    (theBoard :in Sudoku;
     consts : in out SudokuLogicalBoard)
  is
  begin
    for i in theBoard'Range(1) loop
      for j in theBoard'Range(2) loop
        if theBoard(i,j) /= 0 then
          consts(i, j) := True;
        else
          consts(i, j) := False;
        end if;
      end loop;
    end loop;

  end SetSudokuLogicalBoard;

  --=============================================================================================
  function CheckRules
    (theBoard : Sudoku;
     c : Cell)
     return Boolean
  is
    val : Integer := theBoard(c.x, c.y);
    boxLine : Integer;
    boxColumn : Integer;
  begin
    --Check line and column
    for l in theBoard'Range(1) loop
      if theBoard(l, c.y) = val and l /= c.x then
        return False;
      end if;

      if theBoard(c.x, l) = val and l /= c.y then
        return False;
      end if;
    end loop;

    --find box
    case c.x is
    when 1|2|3 =>
      boxLine := 1;
    when 4|5|6 =>
      boxLine := 4;
    when 7|8|9 =>
      boxLine := 7;
    when others =>
      boxLine := 1;
    end case;

    case c.y is
    when 1|2|3 =>
      boxColumn := 1;
    when 4|5|6 =>
      boxColumn := 4;
    when 7|8|9 =>
      boxColumn := 7;
    when others =>
      boxColumn := 1;
    end case;

    --check box
    for l in boxLine..(boxLine+2) loop
      for k in boxColumn..(boxColumn+2) loop
        if l /= c.x and k /= c.y and val = theBoard(l,k) then
          return false;
        end if;
      end loop;
    end loop;

    return True;
  end CheckRules;

  --=============================================================================================
  function FindNextModifiable
    (consts : SudokuLogicalBoard;
     c : Cell) return Cell
  is
    found : Cell := (-1, -1);
  begin
    for j in (c.y+1)..consts'Last(2) loop
      if consts(c.x, j) = False then
        found.x := c.x;
        found.y := j;
        return found;
      end if;
    end loop;

    for i in (c.x+1)..consts'Last(1) loop
      for j in consts'Range(2) loop
        if consts(i, j) = False then
          found.x := i;
          found.y := j;
          return found;
        end if;
      end loop;
    end loop;
    return found;
  end FindNextModifiable;

  --=============================================================================================
  function FindPrevModifiable
    (consts : SudokuLogicalBoard;
     c : Cell) return Cell
  is
    found : Cell := (-1, -1);
  begin
    for j in reverse 1..(c.y-1) loop
      if consts(c.x, j) = False then
        found.x := c.x;
        found.y := j;
        return found;
      end if;
    end loop;

    for i in reverse 1..(c.x-1) loop
      for j in reverse consts'Range(2) loop
        if consts(i, j) = False then
          found.x := i;
          found.y := j;
          return found;
        end if;
      end loop;
    end loop;
    return found;
  end FindPrevModifiable;

end SudokuPackage;
