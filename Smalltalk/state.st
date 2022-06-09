FileStream fileIn: 'pos.st'.

Object subclass: State [
    |pos fuel sFuel|
    cantGoThere := #('You can''t go there.' '').
    notEnoughFuel := #('You don''t have any fuel left.' '').

    State class >> pos: apos fuel: afuel sFuel: asFuel[
        |instance|
        instance := super new.
        instance pos: apos.
        instance fuel: afuel.
        instance sFuel: asFuel.
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

    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
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
                    ].
            ].
    ]
]