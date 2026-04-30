:- use_module(library(rbtrees)).

read_items(File, Items) :-
    setup_call_cleanup(
        open(File, read, Stream),
        read_term(Stream, Term, []),
        close(Stream)
    ),
    Term = (_ = Items).

make_carnet_tree(Tree) :-
    read_items('names2.txt', Items),
    rb_empty(Empty),
    add_students(Items, Empty, Tree).

add_students([], Tree, Tree).
add_students([StudentEntry|Rest], Tree0, Tree) :-
    student_entry(StudentEntry, Carnet, Name),
    rb_insert(Tree0, Carnet, Name, Tree1),
    add_students(Rest, Tree1, Tree).

student_entry(StudentText-_, Carnet, Name) :-
    parse_student_text(StudentText, Carnet, Name).
student_entry(StudentText, Carnet, Name) :-
    parse_student_text(StudentText, Carnet, Name).

parse_student_text(StudentText, Carnet, Name) :-
    atom_string(StudentText, Text),
    split_string(Text, "-", " ", [NameText, CarnetText]),
    number_string(Carnet, CarnetText),
    atom_string(Name, NameText).

first_items(0, _, []) :- !.
first_items(_, [], []).
first_items(N, [Item|Rest], [Item|First]) :-
    N > 0,
    Next is N - 1,
    first_items(Next, Rest, First).

example :-
    make_carnet_tree(Tree),
    rb_lookup(241018, Name, Tree),
    format("Carnet 241018 belongs to: ~w~n", [Name]),

    rb_visit(Tree, StudentsByCarnet),
    length(StudentsByCarnet, Count),
    first_items(10, StudentsByCarnet, FirstTen),
    format("Students loaded: ~w~n", [Count]),
    format("First 10 students by carnet: ~w~n", [FirstTen]).
