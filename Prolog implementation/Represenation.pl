
%state      board is made of matrix
% make a row in a list or a sub list.

row_helper(0,L,L):-!.     %stopping conditon
row_helper(Size,L,R):-
Size > 0 ,
NewSize is Size -1,
row_helper(NewSize,[*|L],R).

make_row(Size,R):-
row_helper(Size,[],R).

insertbombColumn_at(1,[_|B],['O'|B]):-!.            %stopping condition  -> put the bomb 'O' instead of '*'
insertbombColumn_at(Column,[H|Tail],[H|NewTail]):-  % our list and result list
Column > 1,
NewColumn is Column - 1,
insertbombColumn_at(NewColumn,Tail,NewTail).


insertbombRow_at(1,Column,[H|T],[X|T]):- %stopping condition reached the row that i want to modify in
insertbombColumn_at(Column,H,X),!.
insertbombRow_at(Row,Column,[H|Tail],[H|NewTail]):-
Row > 1,
NewRow is Row -1,
insertbombRow_at(NewRow,Column,Tail,NewTail).



board_helper(0,_,B,B):-!.
board_helper(Rows,Columns,L,B):-  %Columns is length of each sub list and Rows is number of sub lists
 Rows > 0,                        %default for empty is '*'  and bomb is 'O'
 Newrows is Rows -1,
 make_row(Columns,R),
 board_helper(Newrows,Columns,[R|L],B).

make_board(Rows,Columns,[R1,C1],[R2,C2],B):- 
 board_helper(Rows,Columns,[],S),                                   %step 1 make an empty board
 insertbombRow_at(R1,C1,S,B1) ,  insertbombRow_at(R2,C2,B1,B).      %step 2 poistion the two bombs

%Actions    put a domino on the wall
%Rules      
%Each domino piece completely covers two squares. (You are allowed to rotate the domino pieces)
% No two dominoes overlap.
% Each domino lies entirely inside the board It is allowed to touch the edges of the board and not allowed to lie on the bomb cell
