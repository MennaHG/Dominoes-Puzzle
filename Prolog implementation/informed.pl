
/***************************    TO-DO:-FIGURE OUT STATE     ************************************/
%baseCase


search(Open,[R,C] ,Closed,G):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)), % Step 2
    !.

optimal(Open,[R,C] ,Closed,CurrentState,G):-
    search(Open,[R,C] ,Closed,G),
    isearch(Open,[R,C] ,Closed,CurrentState,G).

isearch(Open,[R,C] ,Closed,CurrentState,PG):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)),
    G>=PG ,nl. % Step 2.

isearch(Open, [R,C],Closed,Goal,G):-
    getBestState(Open, CurrentNode, TmpOpen), % takes the best node through F 
    getAllValidChildren(CurrentNode,[R,C],TmpOpen,Closed,Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % append CurrentNode to Closed list as it is Visited.
    isearch(NewOpen, [R,C],NewClosed,Goal,G). % Step 5.2% Implementation of step 3 to get the next states



/*search(Open,[R,C] ,Closed,Goal):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)), % Step 2
    write("Search is complete!"), nl,
    write([CurrentState,Parent,G,H,F]).*/

solution(List):-
   solution([],List).

find_all_solutions(Open,[R,C] ,Closed,CurrentState,Acc, List) :-
  search(Open,[R,C] ,Closed,CurrentState), % Replace with your predicate that finds a solution
  append(Acc, [X], NewAcc), % Add the new solution to the accumulator list
  find_all_solutions(Open,[R,C] ,Closed,CurrentState,NewAcc, List).
 
find_all_solutions(Open,[R,C] ,Closed,CurrentState,List, List).

search(Open, [R,C],Closed,G):-
    getBestState(Open, CurrentNode, TmpOpen), % takes the best node through F 
    getAllValidChildren(CurrentNode,[R,C],TmpOpen,Closed,Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % append CurrentNode to Closed list as it is Visited.
    search(NewOpen, [R,C],NewClosed,G). % Step 5.2% Implementation of step 3 to get the next states

/*search(Open,[R,C] ,Closed,CurrentState,[[State,_,PG,_,_]|T]):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)),PG > G,!. % Step 2*/



getAllValidChildren(Node, [R,C],Open, Closed, Children):-
    findall(Next, getNextState(Node,[R,C],Open,Closed,Next),Children).


getNextState([State,_,G,_,_],[R,C],Open,Closed,[Next,State,NewG,NewH,NewF]):-
    move(State,R,C,Next, MoveCost), 
    isOkay(Next),
    heuristic(Next,R,C,NewH),
    NewG is G + MoveCost,
    NewF is NewG + NewH,
    ( not(member([Next,_,_,_,_], Open)) ; memberButBetter(Next,Open,NewF) ),
    ( not(member([Next,_,_,_,_],Closed));memberButBetter(Next,Closed,NewF)).


memberButBetter(Next, List, NewF):-
    findall(F, member([Next,_,_,_,F], List), Numbers),
    min_list(Numbers, MinOldF),
    MinOldF < NewF.


% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).

% Implementation of findMin in getBestState determines the search
alg.
% Greedy best-first search
findMin([X], X):- !.

findMin([Head|T], Min):-
    findMin(T, TmpMin),
    Head = [_,_,_,HeadH,HeadF],
    TmpMin = [_,_,_,TmpH,TmpF],
    (TmpF > HeadF -> Min = TmpMin ; Min = Head). % A* search

% Instead of adding children at the end and searching for the best
% each time using getBestState, we can make addChildren add in the
% right place (sorted open list) and getBestState just returns the
% head of open.
% Implementation of printSolution to print the actual solution path

printSolution([State, null, G, H, F],_):-
    write([State, G, H, F]), nl.

printSolution([State, Parent, G, H, F], Closed):-
    member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
    write([State, G, H, F]), nl.
    


/*********************************Heuristic**************************************/
move(Board,Rows,Columns,NewBoard,1):- % tile decrease the cost with two cells 
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

%calculate number of empty tiles

/*h(Matrix,Hvalue):-
calculateH(Matrix,0,Hvalue).

calculateH([],Acc,Acc).
calculateH([H|T1],Acc,Hvalue):-      %iterate on rows
    calculateH_Helper(H,ListAcc),
    NewAcc is Acc+ListAcc,
    calculateH(T1,NewAcc,Hvalue).

calculateH_Helper([],0).

calculateH_Helper([*|T],Hvalue):-
    calculateH_Helper(T,Count),
    Hvalue is Count + 1.

calculateH_Helper([_|T],Hvalue):-
    calculateH_Helper(T,Hvalue).*/

heuristic(Board,R,C,H):-
    findall(NewBoard,action(Board, R, C, NewBoard),List),
    length(List,H).
  



isOkay(Next):-true.
