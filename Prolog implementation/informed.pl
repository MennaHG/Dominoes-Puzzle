%Query:-iSearch([[[[*, *, 'O'], ['O', *,*],[*,*,*]],null,0,0,0]],[3,3] ,[],C,G).
%Query:-iSearch([[[[*, *, *,*], [*, 'O', 'O',*]],null,0,0,0]],[2,4] ,[],C,G).



iSearch(Open,[R,C] ,Closed,CurrentState,G):-
    search(Open,[R,C] ,Closed,G),
    getAllOtherOptimalSolutions(Open,[R,C] ,Closed,CurrentState,G).

getAllOtherOptimalSolutions(Open,[R,C] ,Closed,CurrentState,PG):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)),
    G=PG ,prettyPrint(CurrentState),nl. % Step 2.

getAllOtherOptimalSolutions(Open, [R,C],Closed,Goal,G):-
    getBestState(Open, CurrentNode, TmpOpen), % takes the best node through F 
    getAllValidChildren(CurrentNode,[R,C],TmpOpen,Closed,Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % append CurrentNode to Closed list as it is Visited.
    getAllOtherOptimalSolutions(NewOpen, [R,C],NewClosed,Goal,G). % Step 5.2% Implementation of step 3 to get the next states




%baseCase
search(Open,[R,C] ,Closed,G):-
    getBestState(Open, [CurrentState,Parent,G,H,F], _), % G actual cost ,H heuirstic cost ,F = G + H 
    not(move(CurrentState, R,C,Next, MoveCost)), % Step 2 no more moves to be done
    write(G),write(" is maximum number of dominoes that can be placed."),nl,
    !.

search(Open, [R,C],Closed,G):-
    getBestState(Open, CurrentNode, TmpOpen), % takes the best node through F 
    getAllValidChildren(CurrentNode,[R,C],TmpOpen,Closed,Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % append CurrentNode to Closed list as it is Visited.
    search(NewOpen, [R,C],NewClosed,G). % Step 5.2% Implementation of step 3 to get the next states





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
    max_list(Numbers, MaxOldF),
    MaxOldF < NewF.


% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
    findMax(Open, BestChild),
    delete(Open, BestChild, Rest).


findMax([X], X):- !.

findMax([Head|T], Max):-
    findMax(T, TmpMax),
    Head = [_,_,_,HeadH,HeadF],
    TmpMax = [_,_,_,TmpH,TmpF],
    (TmpF > HeadF -> Max = TmpMax ; Max = Head). % A* search


% right place (sorted open list) and getBestState just returns the head of open.

    



move(Board,Rows,Columns,NewBoard,1):-  %different moves doesnt have different cost
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

%calculate all possible actions that can be done

/*********************************Heuristic**************************************/

heuristic(Board,R,C,H):-
    findall(NewBoard,action(Board, R, C, NewBoard),List),
    length(List,H).
  



isOkay(Next):-true.
