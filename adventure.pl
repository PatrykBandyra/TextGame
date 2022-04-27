% Dynamic states section
:- dynamic i_am_at/1, at/2, holding/1, fuel/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).


% Starting position
i_am_at(eo).

% Starting fuel value
fuel(5).


% Available paths between planets
% Row 1
path(eo, n, fates).
path(eo, e, auster).

path(auster, w, eo).
path(auster, n, avernus).
path(auster, e, artemi).

path(artemi, w, auster).
path(artemi, n, cepheus).
path(artemi, e, somnus).

path(leda, n, merope).
path(leda, w, somnus).

% Row 2
path(fates, n, atlas).
path(fates, e, avernus).
path(fates, s, eo).

path(avernus, n, boreas).
path(avernus, e, cepheus).
path(avernus, s, auster).
path(avernus, w, fates).

path(cepheus, n, castor).
path(cepheus, e, flora).
path(cepheus, s, artemi).
path(cepheus, w, avernus).

path(flora, n, electra).
path(flora, e, merope).
path(flora, s, somnus).
path(flora, w, cepheus).

path(merope, n, thanato).
path(merope, s, leda).
path(merope, w, flora).

% Row 3
path(atlas, n, demete).
path(atlas, e, boreas).
path(atlas, s, fates).

path(boreas, n, hade).
path(boreas, e, castor).
path(boreas, s, avernus).
path(boreas, w, atlas).

path(castor, n, enyo).
path(castor, e, electra).
path(castor, s, cepheus).
path(castor, w, boreas).

path(electra, n, hecate).
path(electra, e, thanato).
path(electra, s, flora).
path(electra, w, castor).

path(thanato, n, orion).
path(thanato, s, merope).
path(thanato, w, electra).

% Row 4
path(demete, n, euterpe).
path(demete, e, hade).
path(demete, s, atlas).

path(hade, n, sol).
path(hade, e, enyo).
path(hade, s, boreas).
path(hade, w, demete).

path(enyo, n, nymphs).
path(enyo, e, hecate).
path(enyo, s, castor).
path(enyo, w, hade).

path(hecate, n, pandora).
path(hecate, e, orion).
path(hecate, s, electra).
path(hecate, w, enyo).

path(orion, n, sileni).
path(orion, s, thanato).
path(orion, w, hecate).

% Row 5
path(euterpe, e, sol).
path(euterpe, s, hade).

path(sol, e, nymphs).
path(sol, s, hade).
path(sol, w, euterpe).

path(nymphs, e, pandora).
path(nymphs, s, enyo).
path(nymphs, w, sol).

path(pandora, e, sileni).
path(pandora, s, hecate).
path(pandora, w, nymphs).

path(sileni, s, orion).
path(sileni, w, pandora).


% Objects in locations
at(stick, eo).

start_again :-
        write('You decided to settle on this planet and guide any future travellers that will meet you.'),
        write(' With your last resources you sent a package with all your items to your home planet eo.'), nl, nl,
        i_am_at(Here),
        retract(i_am_at(Here)),
        assert(i_am_at(eo)),
        fuel(Quantity),
        retract(fuel(Quantity)),
        assert(fuel(5)),
        look,
        check_fuel.

/* This rule prints out amount of fuel you have. */
check_fuel :-
        fuel(Quantity),
        read_fuel(Quantity), nl.

/* These rules manipulate the fuel value. */
use_fuel(X) :-
        fuel(Quantity),
        NQuantity is Quantity-X,
        retract(fuel(Quantity)),
        assert(fuel(NQuantity)).

add_fuel(X) :- 
        fuel(Quantity),
        NQuantity is Quantity+X,
        retract(fuel(Quantity)),
        assert(fuel(NQuantity)).

/* These rules describe how to pick up an object. */

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('OK.'),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('OK.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        fuel(Quantity),
        Quantity > 0,
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        use_fuel(1),
        !, look,
        check_fuel.

go(_) :-
        write('You can''t go that way or you don''t have any fuel left.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        nl,
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w.     -- to go in that direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        write('drop(Object).      -- to put down an object.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('check_fuel.        -- to check how much fuel you have.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look,
        check_fuel.


% These rules describe the various planets.  Depending on circumstances, a planet may have more than one description.
% Row 1
describe(eo) :- write('You are on eo.'), nl.
describe(auster) :- write('You are on auster.'), nl.
describe(artemi) :- write('You are on artemi.'), nl.
describe(somnus) :- write('You are on somnus.'), nl.
describe(leda) :- write('You are on leda.'), nl.

% Row 2
describe(fates) :- write('You are on fates.'), nl.
describe(avernus) :- write('You are on avernus.'), nl.
describe(cepheus) :- write('You are on cepheus.'), nl.
describe(flora) :- write('You are on flora.'), nl.
describe(merope) :- write('You are on merope.'), nl.

% Row 3
describe(atlas) :- write('You are on atlas.'), nl.
describe(boreas) :- write('You are on boreas.'), nl.
describe(castor) :- write('You are on castor.'), nl.
describe(electra) :- write('You are on electra.'), nl.
describe(thanato) :- write('You are on thanato.'), nl.

% Row 4
describe(demete) :- write('You are on demete.'), nl.
describe(hade) :- write('You are on hade.'), nl.
describe(enyo) :- write('You are on enyo.'), nl.
describe(hecate) :- write('You are on hecate.'), nl.
describe(orion) :- write('You are on orion.'), nl.

% Row 5
describe(euterpe) :- write('You are on euterpe.'), nl.
describe(sol) :- write('You are on sol.'), nl.
describe(nymphs) :- write('You are on nymphs.'), nl.
describe(pandora) :- write('You are on pandora.'), nl.
describe(sileni) :- write('You are on sileni.'), nl.

/* These rules write how much fuel the player has. */
read_fuel(0) :- write('You don''t have any fuel.'), nl.
read_fuel(1) :- write('You have 1 fuel.'), nl.
read_fuel(2) :- write('You have 2 fuel.'), nl.
read_fuel(3) :- write('You have 3 fuel.'), nl.
read_fuel(4) :- write('You have 4 fuel.'), nl.
read_fuel(5) :- write('You have 5 fuel.'), nl.
read_fuel(6) :- write('You have 6 fuel.'), nl.
read_fuel(7) :- write('You have 7 fuel.'), nl.
read_fuel(8) :- write('You have 8 fuel.'), nl.
read_fuel(9) :- write('You have 9 fuel.'), nl.
read_fuel(10) :- write('You have 10 fuel.'), nl.
read_fuel(11) :- write('You have 11 fuel.'), nl.
read_fuel(12) :- write('You have 12 fuel.'), nl.
read_fuel(13) :- write('You have 13 fuel.'), nl.
read_fuel(14) :- write('You have 14 fuel.'), nl.
read_fuel(15) :- write('You have 15 fuel.'), nl.
read_fuel(16) :- write('You have 16 fuel.'), nl.
read_fuel(17) :- write('You have 17 fuel.'), nl.
read_fuel(18) :- write('You have 18 fuel.'), nl.
read_fuel(19) :- write('You have 19 fuel.'), nl.
read_fuel(20) :- write('You have 20 fuel.'), nl.