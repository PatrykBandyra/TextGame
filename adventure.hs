-- The germ of a text adventure game
import Data.List

instructionsText = [
    "Available commands are:",
    "",
    "n s e w       -- to go in that direction",
    "take item     -- to pick up an item.",
    "drop item     -- to drop an item.",
    "look          -- to look around you again.",
    "fuel          -- to check how much fuel you have.",
    "inv           -- to check what items you are holding.",
    "restart       -- to settle on the current planet and start again.",
    "instructions  -- to see these instructions.",
    "quit          -- to end the game and quit.",
    ""
    ]

type Pos = (Int, Int)

data Move = North | South | East | West deriving Eq

-- Current Pos, Fuel, Starting Fuel, Items in inventory, Rooms
type State = (Pos, Int, Int, [String], [Room])

-- Name, Position, Items, NPCs, Description
type Room = (String, Pos, [String], [String], String)

-- Find Room in the list by its Pos
findRoomByPos :: Pos -> [Room] -> Room
findRoomByPos pos [] = ("Error", (-1, -1), [], [], "Error")
findRoomByPos pos (x:xs) = let (_, p, _, _, _) = x in
                               if pos == p then
                                  x
                               else
                                  findRoomByPos pos xs

-- Returns new Pos or Nothing if there is nothing there            
move :: Pos -> Move -> Maybe Pos
move (x, y) North | y == maxY = Nothing
                  | otherwise = Just (x, y+1)
move (x, y) South | y == 0 = Nothing
                  | otherwise = Just (x, y-1)
move (x, y) East  | x == maxX = Nothing
                  | otherwise = Just (x+1, y)
move (x, y) West  | x == 0 = Nothing
                  | otherwise = Just (x-1, y)

-- Go in chosen direction and return to gameLoop with new State
go :: State -> Move -> IO ()
go state dir = let (pos, fuel, sfuel, inv, rooms) = state in 
                   do if fuel == 0 then
                        do printLines ["You don't have any fuel left.", ""]
                           gameLoop state
                      else
                        do let newPos = move pos dir in
                               case newPos of
                                   Nothing -> do printLines ["You can't go there.", ""]
                                                 gameLoop state
                                   Just a -> let newState = (a, fuel -1, sfuel, inv, rooms) in
                                                 do printLookAround newState
                                                    printFuel newState
                                                    gameLoop newState

-- Pick up an item from the ground
takeItem :: State -> String -> IO ()
takeItem state item = let (pos, fuel, sfuel, inv, rooms) = state
                          room = findRoomByPos pos rooms
                          (name, roomPos, items, npcs, desc) = room in
                          if elem item inv then
                             do printLines ["You are already holding it.\n"]
                                gameLoop state
                          else
                             if elem item items then
                                let newItems = delete item items
                                    newInv = insert item inv 
                                    newRooms = insert (name, roomPos, newItems, npcs, desc) (delete room rooms) in
                                    do printLines ["OK\n"]
                                       gameLoop (pos, fuel, sfuel, newInv, newRooms)
                             else
                                 do printLines ["There is no " ++ id item ++ " here.\n"]
                                    gameLoop state

-- Drop an item on the ground
dropItem :: State -> String -> IO ()
dropItem state item = let (pos, fuel, sfuel, inv, rooms) = state
                          room = findRoomByPos pos rooms
                          (name, roomPos, items, npcs, desc) = room in
                          if elem item inv then
                             let newItems = insert item items
                                 newInv = delete item inv
                                 newRooms = insert (name, roomPos, newItems, npcs, desc) (delete room rooms) in
                                 do printLines ["OK\n"]
                                    gameLoop (pos, fuel, sfuel, newInv, newRooms)
                          else
                              do printLines ["You are not holding " ++ id item ++ ".\n"]
                                 gameLoop state


-- print strings from list in separate lines
printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)
                  
printInstructions = printLines instructionsText

-- print Look around
printLookAround :: State -> IO ()
printLookAround state = let (pos, _, _, _, rooms) = state
                            room = findRoomByPos pos rooms 
                            (_, _, items, _, desc) = room in
                            do printLines [desc]
                               printItems items

-- print fuel value
printFuel :: State -> IO ()
printFuel (_, fuel, _, _, _) | fuel == 0 = do printLines ["You don't have any fuel.\n"]
                             | otherwise = do printLines ["You have " ++ show fuel ++ " fuel left.\n"]

-- print items lying on the ground
printItems :: [String] -> IO ()
printItems [] = return ()
printItems (x:xs) = do printLines ["There is a/an " ++ id x ++ " here.\n"]
                       printItems xs

-- print items in the inventory
printInventory :: [String] -> IO ()
printInventory [] = return ()
printInventory (x:xs) = do printLines ["You have a/an " ++ id x ++ ".\n"]
                           printInventory xs

readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

-- map size
maxY = 4
maxX = 4


startingPos = (0::Int, 0::Int)

-- note that the game loop may take the game state as
-- an argument, eg. gameLoop :: State -> IO ()
gameLoop :: State -> IO ()
gameLoop state = do
    cmd <- readCommand
    case cmd of
        "n" -> go state North
        "s" -> go state South
        "e" -> go state East
        "w" -> go state West
        ('t':'a':'k':'e':' ':xs) -> do takeItem state xs
        ('d':'r':'o':'p':' ':xs) -> do dropItem state xs
        "look" -> do printLookAround state
                     gameLoop state
        "fuel" -> do printFuel state
                     gameLoop state
        "inv" -> let (_, _, _, items, _) = state in
                     do printInventory items
                        gameLoop state
        "restart" -> do printLines ["You decided to settle on this planet and guide any future travellers that will meet you.", ""]
                        let (pos, fuel, startingFuel, inv, rooms) = state
                            newState = (startingPos, startingFuel, startingFuel, inv, rooms) in
                            do printLookAround newState
                               printFuel newState
                               gameLoop newState
        "instructions" -> do printInstructions
                             gameLoop state
        "quit" -> return ()
        _ -> do printLines ["Unknown command.", ""]
                gameLoop state

main = do
    printInstructions
    let newState = (startingPos, 3, 3, [], rooms) in
        do printLookAround newState
           printFuel newState
           gameLoop newState

rooms = [
    ("Eo",          (0, 0),      [],                ["Phelly", "Kathri"],       "You are on your home planet Eo.\n"),
    ("Auster",      (0, 1),      ["coolant"],       ["Hardy"],                  "You arrived on Auster, the only other planet you have ever been on. It is very similar to your home planet Eo. You can''t see much because the view is obstructed by all the skyscrapers.\n"),
    ("Artemi",      (0, 2),      [],                ["Reby"],                   "You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.\n"),
    ("Somnus",      (0, 3),      [],                ["Jamy"],                   "You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.\n"),
    ("Leda",        (0, 4),      ["microprocesor"], ["Angnet"],                 "You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.\n"),
    ("Fates",       (1, 0),      ["microchip"],     ["Arler"],                  "You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.\n"),
    ("Avernus",     (1, 1),      ["steel"],         ["Thera"],                  "You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon.\n"),
    ("Cepheus",     (1, 2),      [],                ["Dave"],                   "You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.\n"),
    ("Flora",       (1, 3),      [],                ["Linda"],                  "You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.\n"),
    ("Merope",      (1, 4),      ["qubits"],        ["Ryany"],                  "You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.\n"),
    ("Atlas",       (2, 0),      [],                ["Jana"],                   "You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.\n"),
    ("Boreas",      (2, 1),      [],                ["Jery"],                   "You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.\n"),
    ("Castor",      (2, 2),      ["generator"],     ["Jula"],                   "You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.\n"),
    ("Electra",     (2, 3),      [],                ["Brusse"],                 "You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.\n"),
    ("Thanato",     (2, 4),      [],                ["Lyna"],                   "You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.\n"),
    ("Demete",      (3, 0),      ["plasma"],        ["Stimy"],                  "You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.\n"),
    ("Hade",        (3, 1),      [],                ["Mara"],                   "You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.\n"),
    ("Enyo",        (3, 2),      [],                ["Patry"],                  "You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.\n"),
    ("Hecate",      (3, 3),      [],                ["Cathy"],                  "You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.\n"),
    ("Orion",       (3, 4),      [],                ["Jimmy"],                  "You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.\n"),
    ("Eutrepe",     (4, 0),      ["black hole"],    ["Athen"],                  "You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.\n"),
    ("Sol",         (4, 1),      [],                ["Johnne"],                 "You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.\n"),
    ("Nymphs",      (4, 2),      [],                ["Sarie"],                  "You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.\n"),
    ("Pandora",     (4, 3),      ["particle"],      ["Walter"],                 "You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.\n"),
    ("Sileni",      (4, 4),      ["circuit"],       ["Lica"],                   "You are on Sileni. It is a moon of the capital planet of your galaxy Orion. People on Orion had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Orion.\n")]
