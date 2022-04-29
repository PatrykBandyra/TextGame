% Dynamic states section
:- dynamic i_am_at/1, at/2, holding/1, start_fuel/1, fuel/1, lives/2, is_alive/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)), retractall(is_alive(_)).


% Starting position
i_am_at(eo).

% Starting fuel value
start_fuel(5).


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


% NPCs in locations
% Row 1
lives(phelly, eo).
lives(kathri, eo).
lives(hardy, auster).
lives(reby, artemi).
lives(jamy, somnus).
lives(anget, leda).

% Row 2
lives(arler, fates).
lives(thera, avernus).
lives(dave, cepheus).
lives(linda, flora).
lives(ryany, merope).

% Row 3
lives(jana, atlas).
lives(jery, boreas).
lives(jula, castor).
lives(brusse, electra).
lives(lyna, thanato).

% Row 4
lives(stimy, demete).
lives(mara, hade).
lives(patry, enyo).
lives(cathy, hecate).
lives(jimmy, orion).

% Row 5
lives(athen, euterpe).
lives(johnne, sol).
lives(sarie, nymphs).
lives(walter, pandora).
lives(lica, sileni).

% NPCs available from the start
is_alive(kathri).

% Objects in locations
at(stick, eo).
at(stone, eo).

% Objects you can craft toghether
craftable(stick, stone, pickaxe).

% Exchangable objects
exchange(stone, kathri, iron).

/* This rule takes you back to starting position and leaves new NPC on the current planet. */
restart :-
        write('You decided to settle on this planet and guide any future travellers that will meet you.'), nl, nl,
        i_am_at(Here),
        add_npc(Here),
        drop_all,
        retract(i_am_at(Here)),
        assert(i_am_at(eo)),
        fuel(Quantity),
        retract(fuel(Quantity)),
        start_fuel(NQuantity),
        assert(fuel(NQuantity)),
        look,
        check_fuel, !.


/* These rules adds new NPC, ensuring that they are not alive yet*/

add_npc(Place) :-
        lives(Person, Place),
        not(is_alive(Person)),
        assert(is_alive(Person)).

add_npc(_).

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

/* These rules describe how to talk to an NPC. */

talk(X) :-
        i_am_at(Place),
        lives(X, Place),
        is_alive(X),
        speak(X),
        !, nl.

talk(_) :- write("I don''t see this person here."), nl.

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

/* This rule drops all objects that you're holding. */

drop_all :-
        holding(Object),
        drop(Object),
        fail.

drop_all.

/* This rule combines two objects into a new object. */

combine(Object1, Object2) :-
        holding(Object1),
        holding(Object2),
        craftable(Object1, Object2, Product),
        retract(holding(Object1)),
        retract(holding(Object2)),
        assert(holding(Product)),
        write('You succesfully combined '), write(Object1), write(' and '), write(Object2), write(' into '), write(Product), write('.'), !, nl.

combine(Object1, Object2) :-
        holding(Object1),
        holding(Object2),
        craftable(Object2, Object1, Product),
        retract(holding(Object1)),
        retract(holding(Object2)),
        assert(holding(Product)),
        write('You succesfully combined '), write(Object1), write(' and '), write(Object2), write(' into '), write(Product), write('.'), !, nl.

combine(_, _) :-
        write('You can''t combine those two items together or you are''nt holding those items.'), !, nl.

/* This rule gives an item to an NPC in exchange for a different one. */

give(Object, Person) :-
        holding(Object),
        i_am_at(Place),
        lives(Person, Place),
        is_alive(Person),
        exchange(Object, Person, Given),
        retract(holding(Object)),
        assert(holding(Given)),
        write('You succesfully exchanged '), write(Object), write(' for '), write(Given), write('.'), !, nl.

give(_, _) :-
        write('You failed the exchange.'), !, nl.

/* These rules sets up a loop to mention all items you are currently holding. */

inv :-
        holding(Object),
        write('You have a '), write(Object), write('.'), nl,
        fail.

inv.

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
        notice_npcs_at(Place),
        nl.


/* These rules sets up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        nl,
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules sets up a loop to mention all the NPcs in your vicinity. */

notice_npcs_at(Place) :-
        lives(Person, Place),
        is_alive(Person),
        nl,
        write('There is a person named '), write(Person), write(' here.'), nl,
        fail.

notice_npcs_at(_).

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
        write('inv.               -- to check what items you are holding.'), nl,
        write('combine(O1, O2).   -- to combine two items together.'), nl,
        write('talk(NPC)          -- to talk to an NPC.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('check_fuel.        -- to check how much fuel you have.'), nl,
        write('restart.           -- to settle on the current planet and start again.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        start_fuel(Quantity),
        assert(fuel(Quantity)),
        instructions,
        look,
        check_fuel.


% These rules describe the various planets.  Depending on circumstances, a planet may have more than one description.
% Row 1
describe(eo) :- write('You are on your home planet Eo.'), nl.
describe(auster) :- write('You arrived on Auster, the only other planet you have ever been on. It is very similar to your home planet Eo. You can''t see much because the view is obstructed by all the skyscrapers.'), nl.
describe(artemi) :- write('You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.'), nl.
describe(somnus) :- write('You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.'), nl.
describe(leda) :- write('You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.'), nl.

% Row 2
describe(fates) :- write('You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.'), nl.
describe(avernus) :- write('You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon'), nl.
describe(cepheus) :- write('You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.'), nl.
describe(flora) :- write('You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.'), nl.
describe(merope) :- write('You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.'), nl.

% Row 3
describe(atlas) :- write('You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.'), nl.
describe(boreas) :- write('You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.'), nl.
describe(castor) :- write('You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.'), nl.
describe(electra) :- write('You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.'), nl.
describe(thanato) :- write('You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.'), nl.

% Row 4
describe(demete) :- write('You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.'), nl.
describe(hade) :- write('You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.'), nl.
describe(enyo) :- write('You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.'), nl.
describe(hecate) :- write('You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.'), nl.
describe(orion) :- write('You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.'), nl.

% Row 5
describe(euterpe) :- write('You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.'), nl.
describe(sol) :- write('You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.'), nl.
describe(nymphs) :- write('You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.'), nl.
describe(pandora) :- write('You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.'), nl.
describe(sileni) :- write('You are on Sileni. It is a moon of the capital planet of your galaxy Sol. People on Sol had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Sol.'), nl.

/* These rules write how much fuel the player has. */
read_fuel(0) :- write('You don''t have any fuel.'), !, nl.
read_fuel(X) :- write('You have '), write(X), write(' fuel'), nl.

/* These rules write NPC dialogue. */
speak(hardy) :- write('Hi my name is Hardy Carte'), !, nl.
speak(jamy) :- write('Hi my name is Jamy Mithy'), !, nl.
speak(arler) :- write('Hi my name is Arler Harra'), !, nl.
speak(dave) :- write('Hi my name is Dave Dezal'), !, nl.
speak(ryany) :- write('Hi my name is Ryany Gonzal'), !, nl.
speak(jery) :- write('Hi my name is Jery Bailey'), !, nl.
speak(brusse) :- write('Hi my name is Brusse Arkes'), !, nl.
speak(stimy) :- write('Hi my name is Stimy Jackson'), !, nl.
speak(patry) :- write('Hi my name is Patry Preeders'), !, nl.
speak(jimmy) :- write('Hi my name is Jimmy Carte'), !, nl.
speak(johnne) :- write('Hi my name is Johnne Reson'), !, nl.
speak(aandond) :- write('Hi my name is Aandond Greeders'), !, nl.
speak(walter) :- write('Hi my name is Walter Aker'), !, nl.
speak(phelly) :- write('Hi my name is Phelly Perry'), !, nl.
speak(reby) :- write('Hi my name is Reby Clore'), !, nl.
speak(anget) :- write('Hi my name is Angnet Bennez'), !, nl.
speak(thera) :- write('Hi my name is Thera Homart'), !, nl.
speak(linda) :- write('Hi my name is Linda Wellee'), !, nl.
speak(jana) :- write('Hi my name is Jana Rowner'), !, nl.
speak(jula) :- write('Hi my name is Jula Andell'), !, nl.
speak(lyna) :- write('Hi my name is Lyna Tewood'), !, nl.
speak(mara) :- write('Hi my name is Mara Campbell'), !, nl.
speak(cathy) :- write('Hi my name is Cathy Moore'), !, nl.
speak(athen) :- write('Hi my name is Athen Tinez'), !, nl.
speak(sarie) :- write('Hi my name is Sarie Halley'), !, nl.
speak(lica) :- write('Hi my name is Lica Phardson'), !, nl.

speak(kathri) :- write('Hello traveler! My name is Kathri and I am a commander chief of Eosian Space Program. I’m glad to finally meet you. I was told that you had the highest grades in your year at Space Academy. That is really impressive. As such, you are the only suitable person for our newest mission. We received a strange signal from deep space. Our greatest scientists analyzed and concluded it could be connected with the origin of our species. I think you understand the importance of finding the source of that signal. We could learn the true nature of our origin. Your mission is to explore the space and reach the place where the signal came from. I wish you good luck in your journey!'), !, nl.