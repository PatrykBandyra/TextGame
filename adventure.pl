% Dynamic states section
:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).


% Starting position
i_am_at(eo).


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
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
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
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(eo) :- write('You are on eo.'), nl.

