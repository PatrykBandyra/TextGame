% Dynamic states section
:- dynamic i_am_at/1, at/2, holding/1, start_fuel/1, fuel/1, lives/2, is_alive/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(is_alive(_)), retractall(holding(_)), retractall(start_fuel(_)), retractall(fuel(_)).


% Starting position
i_am_at(eo).

% Starting fuel value
start_fuel(3).


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

path(somnus, w, artemi).
path(somnus, n, flora).
path(somnus, e, leda).

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
lives(angnet, leda).

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
is_alive(phelly).
is_alive(hardy).
is_alive(angnet).
is_alive(arler).
is_alive(thera).
is_alive(linda).
is_alive(jana).
is_alive(brusse).
is_alive(lica).

% Objects in locations
at(coolant, auster).
at(microprocessor, leda).
at(microchip, fates).
at(steel, avernus).
at(qubits, merope).
at(generator, castor).
at(plasma, demete).
at(black_hole, euterpe).
at(particle, pandora).
at(circuit, sileni).

% Objects you can craft together
craftable(coolant, microchip, shield).
craftable(steel, generator, hyperdrive).
craftable(plasma, particle, antimatter).
craftable(circuit, microprocessor, scanner).
craftable(qubits, black_hole, quantum_computer).

% Exchangable objects
%exchange(stone, kathri, iron).

% Technologies
technology(shield).
technology(hyperdrive).
technology(antimatter).
technology(scanner).
technology(quantum_computer).


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

/* These rules checks if new technology was aquired. */

check_technology(Name) :-
        technology(Name),
        execute_technology(Name),
        retract(holding(Name)), !.

check_technology(_).

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
        write('OK.'),  nl,
        !,
        check_technology(X).

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
        write('You successfully combined '), write(Object1), write(' and '), write(Object2), write(' into '), write(Product), write('.'), nl,
        !,
        check_technology(Product).

combine(Object1, Object2) :-
        holding(Object1),
        holding(Object2),
        craftable(Object2, Object1, Product),
        retract(holding(Object1)),
        retract(holding(Object2)),
        assert(holding(Product)),
        write('You successfully combined '), write(Object1), write(' and '), write(Object2), write(' into '), write(Product), write('.'), nl,
        !,
        check_technology(Product).

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
        write('You successfully exchanged '), write(Object), write(' for '), write(Given), write('.'), nl,
        !,
        check_technology(Given).

give(_, _) :-
        write('You failed the exchange.'), !, nl.

/* These rules set up a loop to mention all items you are currently holding. */

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

origin :- go(origin).

/* This rule tells how to move in a given direction. */

go(Direction) :-
        start_fuel(13),
        Direction == origin,
        i_am_at(Here),
        retract(i_am_at(Here)),
        assert(i_am_at(origin)),
        !, look.

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


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        nl,
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules set up a loop to mention all the NPcs in your vicinity. */

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
        write('talk(NPC).         -- to talk to an NPC.'), nl,
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

% Endgame
describe(origin) :- write('Wow, you did it! You left your Galaxy! In the distance you see a very bright point growing and growing with every moment. Is it a place where creatures which are responsible for your existence live?  PIP…PIP… What is that? PIP… INTERNAL SYSTEM ERROR. BUUUM!!! (your spaceship exploded and you died - it turned out that a software engineer who was partially responsible for kernel code in system of your spaceship was not in fact a real engineer and messed up code responsible for taking care of pressure in gas tanks - this was a direct cause of an explosion: bug in code that caused the pressure in gas tanks to raise too much and too fast) :('), nl.

/* These rules write how much fuel the player has. */
read_fuel(0) :- write('You don''t have any fuel.'), !, nl.
read_fuel(X) :- write('You have '), write(X), write(' fuel'), nl.

/* These rules write NPC dialogue. */
speak(hardy) :- write('Hi! Are you from Eo? Yes? So cool, I have half of my family there. My name is Hardy. I call myself an adventurer, although I have never been outside of our solar system. Well… But you know what? Maybe you will help me out in my escape from this galaxy? I am so hungry for travel which I cannot afford. You are really trying to build this superb spaceship? So cool!!! I can even help you! I know about the Hyperdrive schema - I was an engineer… Before they threw me out of my company and took all the titles. So... You need a Reinforced Steel and Electromagnetic Generator. I have one more hint for you. If you were in need of a Gold-Plated Microchip, you would have to go to Fates where they have a small factory of these rare components.'), !, nl.
speak(jamy) :- write('Hello! Welcome on Somnus! I am Jame. Do you remember me? Yes? So cool. I am not going to waste your time. Good luck in your search!'), !, nl.
speak(arler) :- write('Welcome to Fates. Even though there are not many of us, we still were able to hold those barbarians from Hecate off of our precious resources. It is just information for you and you should share it with other travelers. And remember… We are the best friends for our friends and the greatest enemies for our enemies. In an act of goodwill, we are going to share with you our schema for Hyperdrive. Listen carefully. In order to construct this advanced piece of equipment, you need to obtain Reinforced Steel and Electromagnetic Generator. Good luck in your search!'), !, nl.
speak(dave) :- write('Hi! What an extraordinary meeting! I thought that you are already out there exploring other galaxies. Well… I wish you good luck. Come back again if you have free time.'), !, nl.
speak(ryany) :- write('Hi!!! Super nice to meet you again. Merope is such an amazing planet. You will never be bored here ever again. Maybe you should consider settling down here.'), !, nl.
speak(jery) :- write('Hello. How is your family doing back there on Eo? Good? Excellent! Okay, I am not going to bother you anymore. Good luck on your journey!'), !, nl.
speak(brusse) :- write('Hi! I am Brusse. Welcome to Electra. You should not stay here longer than you need to. Those crazy storms are extraordinarily dangerous. I do not live here. Just… I am just staying for one night, he he. What you need? Are you looking for Exotic Particle? I heard about it from locals that traveled north of Electra. Well, I do not know anything more about it.'), !, nl.
speak(stimy) :- write('Hey! Welcome on Demete. Nice to see you again, this time in better shape, ha ha.'), !, nl.
speak(patry) :- write('Welcome to Enyo, old friend. How is your search going on? Good? Nice to hear that!'), !, nl.
speak(jimmy) :- write('Hi! How are you? Did you find what you had been looking for? You are in hurry, I see. Well, I am not going to bother you then. See you again.'), !, nl.
speak(johnne) :- write('Hi! Nice to see you again. Will you stay this time a bit longer?'), !, nl.
speak(walter) :- write('Hi! Do you remember me? We met on Eo in this popular bar. Yeah! Exactly there! Okay, I wish you luck, friend.'), !, nl.
speak(phelly) :- write('Hello! I am Phelly Perry from Eosian ATF bureau and I wish you good luck in your adventure. I have something less official to tell you. Listen… We recently captured a smuggler on our outer frontier and he was in possession of something you may find very helpful. Look, I do you a favor  and maybe one day you will be able to repay me in one way or another, ha, ha. So I have a schema of Deflective Shield for you. You need Nanoparticle Coolant and Gold-Plated Microchip in order to create it.'), !, nl.
speak(reby) :- write('Hey! Nice to see you again! Are you still trying to find all those components? Good luck!'), !, nl.
speak(angnet) :- write('Hello traveler! I am Angnet. You will find nothing and nothing here. So I have no idea why you come to our planet. Nevertheless, welcome. You are in search of Platinum Circuit, he? That’s good. Because there are many people coming here from far North that have those rare chips implanted in their skulls. Crazy! Those chips cost a small fortune. Unfortunately, I cannot afford them. If I had, I would not live on this deserted planet, ehhh…'), !, nl.
speak(thera) :- write('Hello. Do I know where to get Platinum Circuit? Well, of course I do. You need to order them online. They are pretty expensive so I do not know if you can afford them. Personally, I have one of them. I am a well-established lawyer and… Have I mentioned that I am a lawyer? Yes? Good! Do I know where those chips come from? Of course, they are from Sileni. Where is this place? Ummm… I have no idea. Sorry, I have to go.'), !, nl.
speak(linda) :- write('Welcome! My name is Linda. You are my guest now. Unfortunately, not many people visit us. Our planet is so beautiful and untamed. It is heaven! What are you looking for? Deep Space Scanner? Hmmm… Why do you need that? Are you planning an escape from our galaxy? Really? Wow!!! Okay, I think you are a good person so I will tell you. To build a Deep Space Scanner, you first need to get a Platinum Circuit and Microprocessor. I hope it helped, see ya!'), !, nl.
speak(jana) :- write('Hi, traveler! I heard your ship. Pretty loud landing, ha ha. I know what you are looking for and might be able to help you. I have some distant relatives on Castor, which is located east of Atlas, and a few weeks ago a merchant spaceship made a hard landing there. Pretty loud bang, you know, ha, ha. There are many useful things laying around. Maybe even Electromagnetic Generator… Who knows?'), !, nl.
speak(jula) :- write('Hi! How are you? Would you like to settle here? Castor is a wonderful place. No? Well, good luck then.'), !, nl.
speak(lyna) :- write('Hi, old friend. You still cannot find your own place, huh?'), !, nl.
speak(mara) :- write('Hello, lone traveller! We meet again. I am Mara. Do you remember me?'), !, nl.
speak(cathy) :- write('Brother, help me out! I am stuck on this frozen planet! Wait…'), !, nl.
speak(athen) :- write('Hey! Welcome back to Euterpe! What a journey it was. I did not find what I was looking for, but I found peace. I wish you the same, brother.'), !, nl.
speak(sarie) :- write('Hello, old comrade. What a beautiful place to meet again.'), !, nl.
speak(lica) :- write('Hi! Welcome to my home. I am Lica. I heard from my friends from other planets that there is a lone traveler looking for strange things in the whole galaxy. Is that you? Superb! You are pretty famous. At least in a circle of my friends, ha, ha, ha. What do you need. I might be able to help you. Quantum Computer schema? Well… Good for you, because my husband is working as a researcher in Sol National Institute. Wait a minute… I will find a schema. Here you go! (Schema: Components: Sealed Micro Black Hole + Cluster of Qubit)'), !, nl.

speak(kathri) :- write('Hello traveler! My name is Kathri and I am a commander chief of Eosian Space Program. I''m glad to finally meet you. I was told that you had the highest grades in your year at Space Academy. That is really impressive. As such, you are the only suitable person for our newest mission. We received a strange signal from deep space. Our greatest scientists analyzed and concluded it could be connected with the origin of our species. I think you understand the importance of finding the source of that signal. We could learn the true nature of our origin. Your mission is to explore the space and reach the place where the signal came from. Explore, find new technology and maybe you would even meet someone that will help you. I wish you good luck in your journey!'), !, nl.

/* These rules execute effect of acquiring new technology */

execute_technology(shield) :-
        start_fuel(Quantity),
        retract(start_fuel(Quantity)),
        assert(start_fuel(5)),
        write('You acquired Deflector Shield, you will now have 5 fuel after restarting'), !, nl.

execute_technology(hyperdrive) :-
        start_fuel(Quantity),
        retract(start_fuel(Quantity)),
        assert(start_fuel(7)),
        write('You acquired Hyperdrive, you will now have 7 fuel after restarting'), !, nl.

execute_technology(antimatter) :-
        start_fuel(Quantity),
        retract(start_fuel(Quantity)),
        assert(start_fuel(9)),
        write('You acquired Antiamter Fuel, you will now have 9 fuel after restarting'), !, nl.

execute_technology(scanner) :-
        start_fuel(Quantity),
        retract(start_fuel(Quantity)),
        assert(start_fuel(11)),
        write('You acquired Deep Space Scanner, you will now have 11 fuel after restarting'), !, nl.

execute_technology(quantum_computer) :-
        start_fuel(Quantity),
        retract(start_fuel(Quantity)),
        assert(start_fuel(13)),
        write('You acquired Quantum Computer, you can now reach origin of the Signal. Type: origin.'), !, nl.
