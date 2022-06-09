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