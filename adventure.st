"Pos class

Responsibilities:
* handle position variables
* handle moving"

Object subclass: Pos [
    |x y|
    "Initialize borders of the map."
    maxX := 4.
    maxY := 4.
    minX := 0.
    minY := 0.

    Pos class >> x: ax y: ay [
        |instance|
        instance := super new.
        instance x: ax.
        instance y: ay.
        ^instance.
    ]

    x: ax [
        x := ax.
    ]

    y: ay [
        y := ay.
    ]

    Pos class >> new [
        self error: 'Please use x:y: to create Pos instance'.
    ]

    "Returns new Pos depending on the direction,
     does not change current Pos."
    move: direction [
        |newX newY|
        newX := x.
        newY := y.
        (direction == #north and: [y < maxY])
            ifTrue: [newY := y + 1].
        
        (direction == #south and: [y > minY])
            ifTrue: [newY := y - 1].

        (direction == #east and: [x < maxX])
            ifTrue: [newX := x + 1].
        
        (direction == #west and: [x > minX])
            ifTrue: [newX := x - 1].
        
        ^Pos x: newX y: newY
    ]

    getX [
        ^x.
    ]

    getY [
        ^y.
    ]
]

"Dialog class

Responsibilities:
* handle Dialog variables"

Object subclass: Dialog [
    |person dialog|

    Dialog class >> person: aperson dialog: adialog [
        |instance|
        instance := super new.
        instance person: aperson.
        instance dialog: adialog.
        ^instance.
    ]

    person: aperson [
        person := aperson.
    ]

    dialog: adialog [
        dialog := adialog.
    ]

    Dialog class >> new [
        self error: 'Please use person:dialog to create Dialog instance'.
    ]

    getPerson [
        ^person.
    ]

    getDialog [
        ^dialog.
    ]
]

"Recipe class

Responsibilities:
* handle Recipe variables"

Object subclass: Recipe [
    |result first second|

    Recipe class >> result: aresult first: afirst second: asecond [
        |instance|
        instance := super new.
        instance result: aresult.
        instance first: afirst.
        instance second: asecond.
        ^instance.
    ]

    result: aresult [
        result := aresult.
    ]

    first: afirst [
        first := afirst.
    ]

    second: asecond [
        second := asecond.
    ]

    Recipe class >> new [
        self error: 'Please use result:first:second to create Recipe instance'.
    ]

    getResult [
        ^result.
    ]

    getFirst [
        ^first.
    ]

    getSecond [
        ^second.
    ]
]

"Planet class

Responsibilities:
* handle Planet variables
* handle items on the Planet"

Object subclass: Planet [
    |name pos items npcs dNpc description|

    Planet class >> name: aname pos: apos items: aitems npcs: anpcs dNpc: adNpc description: adescription [
        |instance|
        instance := super new.
        instance name: aname.
        instance pos: apos.
        instance items: aitems.
        instance npcs: anpcs.
        instance dNpc: adNpc.
        instance description: adescription.
        ^instance.
    ]

    name: aname [
        name := aname.
    ]

    pos: apos [
        pos := apos.
    ]

    items: aitems [
        items := aitems.
    ]

    npcs: anpcs [
        npcs := anpcs.
    ]

    dNpc: adNpc [
        dNpc := adNpc.
    ]

    description: adescription [
        description := adescription.
    ]

    Planet class >> new [
        self error: 'Please use name:pos:items:npcs:dNpc:desciption to create Planet instance'.
    ]

    getName [
        ^name.
    ]

    getPos [
        ^pos.
    ]

    getItems [
        ^items.
    ]

    getNpcs [
        ^npcs.
    ]

    getDNpc [
        ^dNpc.
    ]

    getDescription [
        ^description.
    ]

    "Remove item from the planet."
    removeItem: item [
        items := (items reject: [:e | e = item]).
    ]

    "Add item to the planet."
    addItem: item [
        items := items copyWith: item.
    ]

    "Add npc to the planet."
    addNpc: npc [
        npcs := npcs copyWith: npc.
    ]
]

"State class

Responsibilities:
* print outputs
* handle game State
* handle all commands available in game"

Object subclass: State [
    |pos fuel sFuel inv planets|
    startingPos := Pos x: 0 y: 0. "Initialize starting Pos."
    cantGoThere := #('You can''t go there.' '').
    notEnoughFuel := #('You don''t have any fuel left.' '').

    "Initialize recipes."
    recipes := {
        Recipe result: 'shield'             first: 'coolant'      second: 'microchip'.    
        Recipe result: 'hyperdrive'         first: 'generator'    second: 'steel'.
        Recipe result: 'antimatter'         first: 'particle'     second: 'plasma'.
        Recipe result: 'scanner'            first: 'circuit'      second: 'microprocessor'.    
        Recipe result: 'quantum_computer'   first: 'black_hole'   second: 'qubits'.           
    }.

    "Initialize dialogs."
    dialogs := {
        Dialog person: 'Hardy'         dialog: 'Hi! Are you from Eo? Yes? So cool, I have half of my family there. My name is Hardy. I call myself an adventurer, although I have never been outside of our solar system. Well… But you know what? Maybe you will help me out in my escape from this galaxy? I am so hungry for travel which I cannot afford. You are really trying to build this superb spaceship? So cool!!! I can even help you! I know about the Hyperdrive schema - I was an engineer… Before they threw me out of my company and took all the titles. So... You need a Reinforced Steel and Electromagnetic Generator. I have one more hint for you. If you were in need of a Gold-Plated Microchip, you would have to go to Fates where they have a small factory of these rare components.'.
        Dialog person: 'Jamy'          dialog: 'Hello! Welcome on Somnus! I am Jame. Do you remember me? Yes? So cool. I am not going to waste your time. Good luck in your search!'.
        Dialog person: 'Arler'         dialog: 'Welcome to Fates. Even though there are not many of us, we still were able to hold those barbarians from Hecate off of our precious resources. It is just information for you and you should share it with other travelers. And remember… We are the best friends for our friends and the greatest enemies for our enemies. In an act of goodwill, we are going to share with you our schema for Hyperdrive. Listen carefully. In order to construct this advanced piece of equipment, you need to obtain Reinforced Steel and Electromagnetic Generator. Good luck in your search!'.
        Dialog person: 'Dave'          dialog: 'Hi! What an extraordinary meeting! I thought that you are already out there exploring other galaxies. Well… I wish you good luck. Come back again if you have free time.'.
        Dialog person: 'Ryany'         dialog: 'Hi!!! Super nice to meet you again. Merope is such an amazing planet. You will never be bored here ever again. Maybe you should consider settling down here.'.
        Dialog person: 'Jery'          dialog: 'Hello. How is your family doing back there on Eo? Good? Excellent! Okay, I am not going to bother you anymore. Good luck on your journey!'.
        Dialog person: 'Brusse'        dialog: 'Hi! I am Brusse. Welcome to Electra. You should not stay here longer than you need to. Those crazy storms are extraordinarily dangerous. I do not live here. Just… I am just staying for one night, he he. What you need? Are you looking for Exotic Particle? I heard about it from locals that traveled north of Electra. Well, I do not know anything more about it.'.
        Dialog person: 'Stimy'         dialog: 'Hey! Welcome on Demete. Nice to see you again, this time in better shape, ha ha.'.
        Dialog person: 'Patry'         dialog: 'Welcome to Enyo, old friend. How is your search going on? Good? Nice to hear that!'.
        Dialog person: 'Jimmy'         dialog: 'Hi! How are you? Did you find what you had been looking for? You are in hurry, I see. Well, I am not going to bother you then. See you again.'.
        Dialog person: 'Johnne'        dialog: 'Hi! Nice to see you again. Will you stay this time a bit longer?'.
        Dialog person: 'Walter'        dialog: 'Hi! Do you remember me? We met on Eo in this popular bar. Yeah! Exactly there! Okay, I wish you luck, friend.'.
        Dialog person: 'Phelly'        dialog: 'Hello! I am Phelly Perry from Eosian ATF bureau and I wish you good luck in your adventure. I have something less official to tell you. Listen… We recently captured a smuggler on our outer frontier and he was in possession of something you may find very helpful. Look, I do you a favor  and maybe one day you will be able to repay me in one way or another, ha, ha. So I have a schema of Deflective Shield for you. You need Nanoparticle Coolant and Gold-Plated Microchip in order to create it.'.
        Dialog person: 'Kathri'        dialog: 'Hello traveler! My name is Kathri and I am a commander chief of Eosian Space Program. I am glad to finally meet you. I was told that you had the highest grades in your year at Space Academy. That is really impressive. As such, you are the only suitable person for our newest mission. We received a strange signal from deep space. Our greatest scientists analyzed and concluded it could be connected with the origin of our species. I think you understand the importance of finding the source of that signal. We could learn the true nature of our origin. Your mission is to explore the space and reach the place where the signal came from. Explore, find new technology. Maybe you would even meet someone that will help you. I wish you good luck in your journey!'.
        Dialog person: 'Reby'          dialog: 'Hey! Nice to see you again! Are you still trying to find all those components? Good luck!'.
        Dialog person: 'Angnet'        dialog: 'Hello traveler! I am Angnet. You will find nothing and nothing here. So I have no idea why you come to our planet. Nevertheless, welcome. You are in search of Platinum Circuit, he? That’s good. Because there are many people coming here from far North that have those rare chips implanted in their skulls. Crazy! Those chips cost a small fortune. Unfortunately, I cannot afford them. If I had, I would not live on this deserted planet, ehhh…'.
        Dialog person: 'Thera'         dialog: 'Hello. Do I know where to get Platinum Circuit? Well, of course I do. You need to order them online. They are pretty expensive so I do not know if you can afford them. Personally, I have one of them. I am a well-established lawyer and… Have I mentioned that I am a lawyer? Yes? Good! Do I know where those chips come from? Of course, they are from Sileni. Where is this place? Ummm… I have no idea. Sorry, I have to go.'.
        Dialog person: 'Linda'         dialog: 'Welcome! My name is Linda. You are my guest now. Unfortunately, not many people visit us. Our planet is so beautiful and untamed. It is heaven! What are you looking for? Deep Space Scanner? Hmmm… Why do you need that? Are you planning an escape from our galaxy? Really? Wow!!! Okay, I think you are a good person so I will tell you. To build a Deep Space Scanner, you first need to get a Platinum Circuit and Microprocessor. I hope it helped, see ya!'.
        Dialog person: 'Jana'          dialog: 'Hi, traveler! I heard your ship. Pretty loud landing, ha ha. I know what you are looking for and might be able to help you. I have some distant relatives on Castor, which is located east of Atlas, and a few weeks ago a merchant spaceship made a hard landing there. Pretty loud bang, you know, ha, ha. There are many useful things laying around. Maybe even Electromagnetic Generator… Who knows?'.
        Dialog person: 'Jula'          dialog: 'Hi! How are you? Would you like to settle here? Castor is a wonderful place. No? Well, good luck then.'.
        Dialog person: 'Lyna'          dialog: 'Hi, old friend. You still cannot find your own place, huh?'.
        Dialog person: 'Mara'          dialog: 'Hello, lone traveller! We meet again. I am Mara. Do you remember me?'.
        Dialog person: 'Cathy'         dialog: 'Brother, help me out! I am stuck on this frozen planet! Wait…'.
        Dialog person: 'Athen'         dialog: 'Hey! Welcome back to Euterpe! What a journey it was. I did not find what I was looking for, but I found peace. I wish you the same, brother.'.
        Dialog person: 'Sarie'         dialog: 'Hello, old comrade. What a beautiful place to meet again.'.
        Dialog person: 'Lica'          dialog: 'Hi! Welcome to my home. I am Lica. I heard from my friends from other planets that there is a lone traveler looking for strange things in the whole galaxy. Is that you? Superb! You are pretty famous. At least in a circle of my friends, ha, ha, ha. What do you need. I might be able to help you. Quantum Computer schema? Well… Good for you, because my husband is working as a researcher in Sol National Institute. Wait a minute… I will find a schema. Here you go! (Schema: Components: Sealed Micro Black Hole + Cluster of Qubit)'.
    }.

    State class >> fuel: afuel sFuel: asFuel inv: ainv planets: aplanets[
        |instance|
        instance := super new.
        instance pos: startingPos.
        instance fuel: afuel.
        instance sFuel: asFuel.
        instance inv: ainv.
        instance planets: aplanets.
        ^instance.
    ]

    pos: apos [
        pos := apos.
    ]

    fuel: afuel [
        fuel := afuel.
    ]

    sFuel: asFuel [
        sFuel := asFuel.
    ]

    inv: ainv [
        inv := ainv.
    ]

    planets: aplanets [
        planets := aplanets.
    ]

    State class >> new [
        self error: 'Please use fuel:sFuel:inv:planets to create State instance'.
    ]

    getPos [
        ^pos.
    ]

    getFuel [
        ^fuel.
    ]

    getSFuel [
        ^sFuel.
    ]

    getInv [
        ^inv.
    ]

    getPlanets [
        ^planets.
    ]

    "Go in chosen direction and print appropriate text."
    move: direction [
        |newPos|
        fuel == 0
            ifTrue: [self printLines: notEnoughFuel]
            ifFalse: [
                newPos := pos move: direction.
                (pos getX == newPos getX and: [pos getY == newPos getY])
                    ifTrue: [self printLines: cantGoThere]
                    ifFalse: [
                        pos := newPos.
                        fuel := fuel - 1.
                        self printLookAround.
                        self printFuel.
                    ].
            ].
    ]

    "Find Room in the list by its Pos."
    findRoomByPos: apos [
        |found|
        found := Planet name: 'Error' pos: [Pos x: -1 y: -1] items: {} npcs: {} dNpc: '' description: ''.
        planets do: [ :planet |
            (planet getPos getX = apos getX and: [planet getPos getY = apos getY])
                ifTrue: [found := planet]. 
        ].
        ^found.
    ]

    "Pick up an item from the ground."
    takeItem: item [
        |planet items|
        (inv includes: item)
            ifTrue: [self printLines: #('You are already holding it.' '')]
            ifFalse: [
                planet := self findRoomByPos: pos.
                items := planet getItems.
                (items includes: item)
                    ifTrue: [
                        planet removeItem: item.
                        self addItem: item.
                        self printLines: #('OK' '').]
                    ifFalse: [self printLines: {'There is no ', item, ' here.'. ''}].
            ].
    ]

    "Drop an item on the ground"
    dropItem: item [
        |planet|
        (inv includes: item)
            ifTrue: [
                planet := self findRoomByPos: pos.
                planet addItem: item.
                self removeItem: item.
                self printLines: #('OK' '').]
            ifFalse: [self printLines: {'You are not holding ', item, '.'. ''}].
    ]

    "Combine items in inventory"
    combineItems: itemsToCombine [
        |words first second result|
        words := itemsToCombine tokenize: ' '.
        words size > 1
            ifTrue: [
                first := words at: 1.
                second := words at: 2.
                ((inv includes: first) and: [inv includes: second])
                    ifTrue: [
                        result := self craft: words.
                        result = 'NaN'
                            ifTrue: [self printLines: #('You can''t combine those items.' '')]
                            ifFalse: [
                                self removeItem: first.
                                self removeItem: second.
                                self execute: result.
                            ].
                    ]
                    ifFalse: [self printLines: #('Some of the items you wish to combine are not in your inventory.' '')].
            ]
            ifFalse: [self printLines: #('You can only combine at least two items.' '')].
    ]

    "Check if items match any of the craftings."
    craft: items [
        |sortedItems result first second|
        sortedItems := items sorted: [ :x :y | x first < y first].
        first := sortedItems at: 1.
        second := sortedItems at: 2.
        result := 'NaN'.
        recipes do: [ :recipe |
            (first = recipe getFirst and: [second = recipe getSecond])
                ifTrue: [result := recipe getResult].].
        ^result
    ]

    "Aquire new technology"
    execute: technology [
        technology = 'shield' ifTrue: [
            self printLines: #('You acquired Deflector Shield, you will now have 5 fuel after restarting.' '').
            sFuel := 5.
        ].

        technology = 'hyperdrive' ifTrue: [
            self printLines: #('You acquired Hyperdrive, you will now have 7 fuel after restarting.' '').
            sFuel := 7.
        ].

        technology = 'antimatter' ifTrue: [
            self printLines: #('You acquired Antiamter Fuel, you will now have 9 fuel after restarting.' '').
            sFuel := 9.
        ].

        technology = 'scanner' ifTrue: [
            self printLines: #('You acquired Deep Space Scanner, you will now have 11 fuel after restarting.' '').
            sFuel := 11.
        ].

        technology = 'quantum_computer' ifTrue: [
            self printLines: #('You acquired Quantum Computer, you can now reach origin of the Signal. Type: origin.' '').
            sFuel := 13.
        ].
    ]

    "Endgame action"
    origin [
        sFuel == 13
            ifTrue: [
                self printLines: #('Wow, you did it! You left your Galaxy! In the distance you see a very bright point growing and growing with every moment. Is it a place where creatures which are responsible for your existence live?  PIP…PIP… What is that? PIP… INTERNAL SYSTEM ERROR. BUUUM!!! (your spaceship exploded and you died - it turned out that a software engineer who was partially responsible for kernel code in system of your spaceship was not in fact a real engineer and messed up code responsible for taking care of pressure in gas tanks - this was a direct cause of an explosion: bug in code that caused the pressure in gas tanks to raise too much and too fast) :(' '').
                pos := Pos x: -1 y: -1.
            ]
            ifFalse: [self printLines: #('Unknown command.' '')].
    ]

    "Remove item from the inventory."
    removeItem: item [
        inv := (inv reject: [:e | e = item]).
    ]

    "Add item to the inventory."
    addItem: item [
        inv := inv copyWith: item.
    ]

    findDialogByNpc: npc [
        |found|
        found := 'NaN'.
        dialogs do: [ :dialog |
            dialog getPerson = npc
                ifTrue: [found := dialog getDialog].].
        ^found.
    ]

    speakTo: npc [
        |planet npcs  dialog|
        planet := self findRoomByPos: pos.
        npcs := planet getNpcs.
        (npcs includes: npc)
            ifTrue: [
                dialog := self findDialogByNpc: npc.
                self printLines: {dialog. ''}.
            ]
            ifFalse: [self printLines: {'There is no ', npc, ' here.'. ''}].
    ]

    "Drop all items on the ground and restart the game"
    restart [
        self printLines: #('You decided to settle on this planet and guide any future travellers that will meet you.' '').
        self dropAll.
        self addNpc.
        fuel := sFuel.
        pos := startingPos.
        self printLookAround.
        self printFuel.
    ]

    "Drop all items on the ground."
    dropAll [
        |planet|
        planet := self findRoomByPos: pos.
        inv do: [ :item |
            planet addItem: item.
            self removeItem: item.].
    ]

    "Add dynamic NPC to a room after restart."
    addNpc [
        |planet npc|
        planet := self findRoomByPos: pos.
        npc := planet getDNpc.
        npc = ''
            ifFalse: [
                planet addNpc: npc.
                planet dNpc: ''.
            ]
    ]

    "Print look around."
    printLookAround [
        |planet desc items npcs|
        planet := self findRoomByPos: pos.
        desc := planet getDescription.
        items := planet getItems.
        npcs := planet getNpcs.
        self printLines: {desc. ''}.
        self printItems: items.
        self printNpcs: npcs.
    ]

    "Print npcs."
    printNpcs: npcs [
        npcs do: [ :npc |
            self printLines: {'There is ', npc, ' who you can speak to.'. ''}].
    ]

    "Print fuel value."
    printFuel [
        fuel == 0
            ifTrue: [self printLines: #('You don''t have any fuel.' '')]
            ifFalse: [self printLines: {'You have ', (fuel asString), ' fuel left.'. ''}].
    ]

    "Print items lying on the ground."
    printItems: items [
        items do: [ :item |
            self printLines: {'There is a/an ', item, ' here.'. ''}].
    ]

    "Print items in the inventory."
    printInventory [
        inv do: [ :item |
            self printLines: {'You have a/an ', item, '.'. ''}].
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]
]

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* handle all commands"

Object subclass: Game [
    |isGameOver state|

    instructionsText := #(
        'Available commands are:'
        ''
        'n s e w                -- to go in that direction.'
        'take item              -- to pick up an item.'
        'drop item              -- to drop an item.'
        'combine item1 item2    -- to combine items.'
        'look                   -- to look around you again.'
        'fuel                   -- to check how much fuel you have.'
        'inv                    -- to check what items you are holding.'
        'speak person           -- to speak to a person on a planet.'
        'restart                -- to settle on the current planet and start again.'
        'instructions           -- to see these instructions.'
        'quit                   -- to end the game and quit.'
        ''
    ).

    "Initialize starting values for all Planets."
    startingPlanets := {
        Planet name: 'Eo'           pos: (Pos x: 0 y: 0)    items: {}                       npcs: {'Kathri'. 'Phelly'}   dNpc: ''          description: 'You are on your home planet Eo.'.
        Planet name: 'Auster'       pos: (Pos x: 0 y: 1)    items: {'coolant'}              npcs: {'Hardy'}               dNpc: ''          description: 'You arrived on Auster, the only other planet you have ever been on. It is very similar to your home planet Eo. You can''t see much because the view is obstructed by all the skyscrapers.'.
        Planet name: 'Artemi'       pos: (Pos x: 0 y: 2)    items: {}                       npcs: {}                      dNpc: 'Reby'      description: 'You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.'.
        Planet name: 'Somnus'       pos: (Pos x: 0 y: 3)    items: {}                       npcs: {}                      dNpc: 'Jamy'      description: 'You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.'.
        Planet name: 'Leda'         pos: (Pos x: 0 y: 4)    items: {'microprocessor'}       npcs: {'Angnet'}              dNpc: ''          description: '"You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.'.
        Planet name: 'Fates'        pos: (Pos x: 1 y: 0)    items: {'microchip'}            npcs: {'Arler'}               dNpc: ''          description: 'You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.'.
        Planet name: 'Avernus'      pos: (Pos x: 1 y: 1)    items: {'steel'}                npcs: {'Thera'}               dNpc: ''          description: 'You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon.'.
        Planet name: 'Cepheus'      pos: (Pos x: 1 y: 2)    items: {}                       npcs: {}                      dNpc: 'Dave'      description: 'You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.'.
        Planet name: 'Flora'        pos: (Pos x: 1 y: 3)    items: {}                       npcs: {'Linda'}               dNpc: ''          description: 'You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.'.
        Planet name: 'Merope'       pos: (Pos x: 1 y: 4)    items: {'qubits'}               npcs: {}                      dNpc: 'Ryany'     description: 'You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.'.
        Planet name: 'Atlas'        pos: (Pos x: 2 y: 0)    items: {}                       npcs: {'Jana'}                dNpc: ''          description: 'You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.'.
        Planet name: 'Boreas'       pos: (Pos x: 2 y: 1)    items: {}                       npcs: {}                      dNpc: 'Jery'      description: 'You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.'.
        Planet name: 'Castor'       pos: (Pos x: 2 y: 2)    items: {'generator'}            npcs: {}                      dNpc: 'Jula'      description: 'You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.'.
        Planet name: 'Electra'      pos: (Pos x: 2 y: 3)    items: {}                       npcs: {'Brusse'}              dNpc: ''          description: 'You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.'.
        Planet name: 'Thanato'      pos: (Pos x: 2 y: 4)    items: {}                       npcs: {}                      dNpc: 'Lyna'      description: 'You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.'.
        Planet name: 'Demete'       pos: (Pos x: 3 y: 0)    items: {'plasma'}               npcs: {}                      dNpc: 'Stimy'     description: 'You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.'.
        Planet name: 'Hade'         pos: (Pos x: 3 y: 1)    items: {}                       npcs: {}                      dNpc: 'Mara'      description: 'You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.'.
        Planet name: 'Enyo'         pos: (Pos x: 3 y: 2)    items: {}                       npcs: {}                      dNpc: 'Patry'     description: 'You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.'.
        Planet name: 'Hecate'       pos: (Pos x: 3 y: 3)    items: {}                       npcs: {}                      dNpc: 'Cathy'     description: 'You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.'.
        Planet name: 'Orion'        pos: (Pos x: 3 y: 4)    items: {}                       npcs: {}                      dNpc: 'Jimmy'     description: 'You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.'.
        Planet name: 'Eutrepe'      pos: (Pos x: 4 y: 0)    items: {'black_hole'}           npcs: {}                      dNpc: 'Athen'     description: 'You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.'.
        Planet name: 'Sol'          pos: (Pos x: 4 y: 1)    items: {}                       npcs: {}                      dNpc: 'Johnne'    description: 'You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.'.
        Planet name: 'Nymphs'       pos: (Pos x: 4 y: 2)    items: {}                       npcs: {}                      dNpc: 'Sarie'     description: 'You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.'.
        Planet name: 'Pandora'      pos: (Pos x: 4 y: 3)    items: {'particle'}             npcs: {}                      dNpc: 'Walter'    description: 'You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.'.
        Planet name: 'Sileni'       pos: (Pos x: 4 y: 4)    items: {'circuit'}              npcs: {'Lica'}                dNpc: ''          description: 'You are on Sileni. It is a moon of the capital planet of your galaxy Orion. People on Orion had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Orion.'.
    }.

    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        state := State fuel: 3 sFuel: 3 inv: {} planets: startingPlanets.
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    "Return first n element of the string.
     If the string is smaller than n returns string."
    resize: string to: n [
        string size < n
            ifTrue: [^string]
            ifFalse: [^string first: n].
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printInstructions.
        state printLookAround.
        state printFuel.

        "Game loop."
        [isGameOver] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            cmd = 'n' ifTrue: [
                state move: #north.
                isUnknown := false
            ].

            cmd = 's' ifTrue: [
                state move: #south.
                isUnknown := false
            ].

            cmd = 'e' ifTrue: [
                state move: #east.
                isUnknown := false
            ].

            cmd = 'w' ifTrue: [
                state move: #west.
                isUnknown := false
            ].

            ((self resize: cmd to: 5) = 'take ') ifTrue: [
                state takeItem: (cmd copyFrom: 6).
                isUnknown := false
            ].

            ((self resize: cmd to: 5) = 'drop ') ifTrue: [
                state dropItem: (cmd copyFrom: 6).
                isUnknown := false
            ].

            ((self resize: cmd to: 8) = 'combine ') ifTrue: [
                state combineItems: (cmd copyFrom: 9).
                isUnknown := false
            ].

            cmd = 'look' ifTrue: [
                state printLookAround.
                isUnknown := false
            ].

            cmd = 'fuel' ifTrue: [
                state printFuel.
                isUnknown := false
            ].

            cmd = 'inv' ifTrue: [
                state printInventory.
                isUnknown := false
            ].

            ((self resize: cmd to: 6) = 'speak ') ifTrue: [
                state speakTo: (cmd copyFrom: 7).
                isUnknown := false
            ].

            cmd = 'restart' ifTrue: [
                state restart.
                isUnknown := false
            ].

            cmd = 'origin' ifTrue: [
                state origin.
                isUnknown := false
            ].

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].
                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]

    getState [
        ^state.
    ]
]

Game new run.
