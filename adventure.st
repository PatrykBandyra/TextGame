Object subclass: Pos [
    |x y|
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
        
        (direction == #west and: [x < minX])
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

Object subclass: Planet [
    |name pos items npcs description|

    Planet class >> name: aname pos: apos items: aitems npcs: anpcs description: adescription [
        |instance|
        instance := super new.
        instance name: aname.
        instance pos: apos.
        instance items: aitems.
        instance npcs: anpcs.
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

    description: adescription [
        description := adescription.
    ]

    Planet class >> new [
        self error: 'Please use name:pos:items:npcs:desciption to create Planet instance'.
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

    getDescription [
        ^description.
    ]
]

Object subclass: State [
    |pos fuel sFuel inv planets|
    cantGoThere := #('You can''t go there.' '').
    notEnoughFuel := #('You don''t have any fuel left.' '').

    State class >> pos: apos fuel: afuel sFuel: asFuel inv: ainv planets: aplanets[
        |instance|
        instance := super new.
        instance pos: apos.
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
        self error: 'Please use pos: to create State instance'.
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

    findRoomByPos: apos [
        |found|
        found := Planet name: 'Error' pos: [Pos x: -1 y: -1] items: {} npcs: {} description: ''.
        planets do: [ :planet |
            (planet getPos getX = apos getX and: [planet getPos getY = apos getY])
                ifTrue: [found := planet]. 
        ].
        ^found.
    ]

    printLookAround [
        |planet desc|
        planet := self findRoomByPos: pos.
        desc := planet getDescription.
        self printLines: {desc. ''}.
    ]

    printFuel [
        fuel == 0
            ifTrue: [self printLines: #('You don''t have any fuel.' '')]
            ifFalse: [self printLines: {'You have ', (fuel asString), ' fuel left.'. ''}].
    ]

    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]
]

Object subclass: Game [
    |isGameOver state|
    startingPos := Pos x: 0 y: 0.

    instructionsText := #(
        'Available commands are:'
        ''
        'n s e w                -- to go in that direction.'
        'instructions           -- to see these instructions.'
        'quit                   -- to end the game and quit.'
        ''
    ).

    startingPlanets := {
        Planet name: 'Eo'           pos: (Pos x: 0 y: 0)    items: {}               npcs: {}            description: 'You are on your home planet Eo.'.
        Planet name: 'Auster'       pos: (Pos x: 0 y: 1)    items: {}               npcs: {}            description: 'You arrived on Auster, the only other planet you have ever been on. It is very similar to your home planet Eo. You can''t see much because the view is obstructed by all the skyscrapers.'.
        Planet name: 'Artemi'       pos: (Pos x: 0 y: 2)    items: {}               npcs: {}            description: 'You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.'.
        Planet name: 'Somnus'       pos: (Pos x: 0 y: 3)    items: {}               npcs: {}            description: 'You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.'.
        Planet name: 'Leda'         pos: (Pos x: 0 y: 4)    items: {}               npcs: {}            description: '"You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.'.
        Planet name: 'Fates'        pos: (Pos x: 1 y: 0)    items: {}               npcs: {}            description: 'You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.'.
        Planet name: 'Avernus'      pos: (Pos x: 1 y: 1)    items: {}               npcs: {}            description: 'You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon.'.
        Planet name: 'Cepheus'      pos: (Pos x: 1 y: 2)    items: {}               npcs: {}            description: 'You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.'.
        Planet name: 'Flora'        pos: (Pos x: 1 y: 3)    items: {}               npcs: {}            description: 'You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.'.
        Planet name: 'Merope'       pos: (Pos x: 1 y: 4)    items: {}               npcs: {}            description: 'You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.'.
        Planet name: 'Atlas'        pos: (Pos x: 2 y: 0)    items: {}               npcs: {}            description: 'You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.'.
        Planet name: 'Boreas'       pos: (Pos x: 2 y: 1)    items: {}               npcs: {}            description: 'You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.'.
        Planet name: 'Castor'       pos: (Pos x: 2 y: 2)    items: {}               npcs: {}            description: 'You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.'.
        Planet name: 'Electra'      pos: (Pos x: 2 y: 3)    items: {}               npcs: {}            description: 'You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.'.
        Planet name: 'Thanato'      pos: (Pos x: 2 y: 4)    items: {}               npcs: {}            description: 'You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.'.
        Planet name: 'Demete'       pos: (Pos x: 3 y: 0)    items: {}               npcs: {}            description: 'You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.'.
        Planet name: 'Hade'         pos: (Pos x: 3 y: 1)    items: {}               npcs: {}            description: 'You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.'.
        Planet name: 'Enyo'         pos: (Pos x: 3 y: 2)    items: {}               npcs: {}            description: 'You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.'.
        Planet name: 'Hecate'       pos: (Pos x: 3 y: 3)    items: {}               npcs: {}            description: 'You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.'.
        Planet name: 'Orion'        pos: (Pos x: 3 y: 4)    items: {}               npcs: {}            description: 'You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.'.
        Planet name: 'Eutrepe'      pos: (Pos x: 4 y: 0)    items: {}               npcs: {}            description: 'You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.'.
        Planet name: 'Sol'          pos: (Pos x: 4 y: 1)    items: {}               npcs: {}            description: 'You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.'.
        Planet name: 'Nymphs'       pos: (Pos x: 4 y: 2)    items: {}               npcs: {}            description: 'You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.'.
        Planet name: 'Pandora'      pos: (Pos x: 4 y: 3)    items: {}               npcs: {}            description: 'You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.'.
        Planet name: 'Sileni'       pos: (Pos x: 4 y: 4)    items: {}               npcs: {}            description: 'You are on Sileni. It is a moon of the capital planet of your galaxy Orion. People on Orion had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Orion.'.
    }.

    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        state := State pos: startingPos fuel: 3 sFuel: 3 inv: {} planets: startingPlanets.
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
                state move: #north
            ].

            cmd = 's' ifTrue: [
                state move: #south
            ].

            cmd = 'e' ifTrue: [
                state move: #east
            ].

            cmd = 'w' ifTrue: [
                state move: #west
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

" Game new run. "