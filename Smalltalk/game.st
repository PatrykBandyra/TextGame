FileStream fileIn: 'state.st'.

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
 
    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        state := State pos: startingPos fuel: 3 sFuel: 3.
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
       self printLines: introductionText.
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

        self printIntroduction.
        self printInstructions.

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
]

Game new run.
