
%state      board is made of matrix
% make a row in a list or a sub list.



insertHelper([_|B], 1, Char, [Char|B]):-!.

insertHelper([H|Tail], Column, Char, [H|NewTail]):-
    Column > 1,
    NewColumn is Column - 1,
    insertHelper(Tail, NewColumn, Char, NewTail).

insert([H|T], 1, Column, Char, [X|T]):- %stopping condition reached the row that i want to modify in
    insertHelper(H, Column, Char, X),!.

insert([H|Tail], Row, Column, Char, [H|NewTail]):-  % [H|Tail],[H|NewTail] , we use H so we have a copy to return
    Row > 1,
    NewRow is Row -1,
    insert(Tail,NewRow,Column, Char, NewTail).



row_helper(0,L,L):-!.     %stopping conditon
row_helper(Size,L,R):-
Size > 0 ,
NewSize is Size -1,
row_helper(NewSize,[*|L],R).

make_row(Size,R):-
row_helper(Size,[],R).



board_helper(0,_,B,B):-!.
board_helper(Rows,Columns,L,B):-  %Columns is length of each sub list and Rows is number of sub lists
 Rows > 0,                        %default for empty is '*'  and bomb is 'O'
 Newrows is Rows -1,
 make_row(Columns,R),
 board_helper(Newrows,Columns,[R|L],B).

make_board(Rows,Columns,[R1,C1],[R2,C2],B):- 
    board_helper(Rows,Columns,[],S),      % step 1 make an empty board
    insert(S, R1, C1, 'O', B1),         % step 2 poistion the two bomb
    insert(B1, R2, C2, 'O', B).      

/***********************    ACTIONS    *********************/

horizontal([R|_],OC,IndexRow,IndexColumn,IndexRow,IndexColumn):-
    R = [*,*|_] .

horizontal([R|T],OC,IndexRow,IndexColumn,IR,IC):-
    R = [],
    NewIndexRow is IndexRow -1,
    horizontal(T,OC,NewIndexRow,OC,IR,IC).

horizontal([R|T],OC,IndexRow,IndexColumn,IR,IC):-
    R =[H|T2],
    NewIndexColumn is IndexColumn - 1,
    horizontal([T2|T],OC,IndexRow,NewIndexColumn,IR,IC).

vertical([FirstRow,SecondRow|_], OC, IndexRow, IndexColumn, IndexRow, IndexColumn):-
    ColumnCordinate is OC - IndexColumn + 1,
    FirstRow = [*|_],
    nth1(ColumnCordinate, SecondRow, *).

vertical([R|T], OC, IndexRow, IndexColumn, IR, IC):-
    R = [],
    NewIndexRow is IndexRow -1,
    vertical(T, OC, NewIndexRow, OC, IR, IC).


vertical([R|T], OC, IndexRow, IndexColumn, IR, IC):-
    R =[H|T2],
    NewIndexColumn is IndexColumn - 1,
    vertical([T2|T], OC, IndexRow, NewIndexColumn, IR, IC).
    

action(Board,Rows,Columns,NewBoard):-
    % first Columns is the original columns number, so we can use it to reset the counter

    (
        Temp = Board,
        horizontal(Temp,Columns,Rows,Columns,IR,IC),
        RowCordinate is Rows - IR + 1,
        ColumnCordinate is Columns - IC + 1,
        SecondColumnCordinate is ColumnCordinate + 1,
        insert(Board, RowCordinate, ColumnCordinate, '-', Board2),
        insert(Board2, RowCordinate, SecondColumnCordinate, '-', NewBoard)
    ) ;

    (
        Temp = Board,
        vertical(Temp,Columns,Rows,Columns,IR,IC),
        RowCordinate is Rows - IR + 1,
        ColumnCordinate is Columns - IC + 1,
        SecondRowCordinate is RowCordinate + 1,
        insert(Board, RowCordinate, ColumnCordinate, l, Board2),
        insert(Board2, SecondRowCordinate, ColumnCordinate, l, NewBoard)
    ).

    
prettyPrint([]):-!.
prettyPrint([Row|RestOfMatrix]):-
    write(Row),nl,
    prettyPrint(RestOfMatrix).
    
is_okay(Board):-true.

/*
[
 [-,-,O]
 [O,*,*]
 [*,*,*]
 ]*/


