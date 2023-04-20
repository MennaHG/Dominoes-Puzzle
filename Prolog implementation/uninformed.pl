uSearch(Board, [R,C], Visited, Board):-
    not(action(Board, R, C, NewBoard)),
    write("Search is Complete"), !.
    

uSearch(Board,[R,C],Visited, Goal):-
    action(Board, R, C, NewBoard),
    not(member(NewBoard, Visited)),
    is_okay(NewBoard),
    append(Visited, [NewBoard], NewVisited),
    uSearch(NewBoard,[R,C],NewVisited, Goal).

    
