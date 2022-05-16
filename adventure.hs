-- The germ of a text adventure game

instructionsText = [
    "Available commands are:",
    "",
    "instructions  -- to see these instructions.",
    "n s e w       -- to go in that direction",
    "quit          -- to end the game and quit.",
    ""
    ]

type Pos = (Int, Int)

data Move = North | South | East | West deriving Eq

type State = (Pos, Int)

-- Gets Pos from State
getPos :: State -> Pos
getPos (pos, _) = pos

-- Gets Fuel from State
getFuel :: State -> Int
getFuel (_, fuel) = fuel

-- Returns new Pos or Nothing if there is nothing there            
move :: Pos -> Move -> Maybe Pos
move (x, y) North | y == maxY = Nothing
                  | otherwise = Just (x, y+1)
move (x, y) South | y == 0 = Nothing
                  | otherwise = Just (x, y-11)
move (x, y) East  | x == maxX = Nothing
                  | otherwise = Just (x+1, y)
move (x, y) West  | x == 0 = Nothing
                  | otherwise = Just (x-1, y)

-- Go in chosen direction and return to gameLoop with new State
go :: State -> Move -> IO ()
go state dir = do if (getFuel state) == 0 then do
                    printLines ["You don't have any fuel left.", ""]
                    gameLoop state
                  else do
                    let pos = move (getPos state) dir in
                        case pos of
                            Nothing -> do
                                printLines ["You can't go there.", ""]
                                gameLoop state
                            Just a ->
                                let newState = (a, (getFuel state) -1) in
                                    do printLines (lookAround newState)
                                       gameLoop newState

-- Look around and check fuel
lookAround :: State -> [String]
lookAround (pos, fuel) = [description $ planet $ pos, readFuel fuel]

-- Read fuel value
readFuel :: Int -> String
readFuel fuel | fuel == 0 = "You don't have any fuel.\n"
              | otherwise = "You have " ++ show fuel ++ " fuel left.\n"

-- print strings from list in separate lines
printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)
                  
printInstructions = printLines instructionsText

readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

-- map size
maxY = 4
maxX = 4


startingState = ((0::Int, 0::Int), 3)

-- note that the game loop may take the game state as
-- an argument, eg. gameLoop :: State -> IO ()
gameLoop :: State -> IO ()
gameLoop state = do
    cmd <- readCommand
    case cmd of
        "instructions" -> do printInstructions
                             gameLoop state
        "n" -> go state North
        "s" -> go state South
        "e" -> go state East
        "w" -> go state West
        "quit" -> return ()
        _ -> do printLines ["Unknown command.", ""]
                gameLoop state

main = do
    printInstructions
    printLines (lookAround startingState)
    gameLoop startingState

-- Planet names
planet :: Pos -> String
planet (0, 0) = "Eo"
planet (0, 1) = "Auster"
planet (0, 2) = "Artemi"
planet (0, 3) = "Somnus"
planet (0, 4) = "Leda"
planet (1, 0) = "Fates"
planet (1, 1) = "Avernus"
planet (1, 2) = "Cepheus"
planet (1, 3) = "Flora"
planet (1, 4) = "Merope"
planet (2, 0) = "Atlas"
planet (2, 1) = "Boreas"
planet (2, 2) = "Castor"
planet (2, 3) = "Electra"
planet (2, 4) = "Thanato"
planet (3, 0) = "Demete"
planet (3, 1) = "Hade"
planet (3, 2) = "Enyo"
planet (3, 3) = "Hecate"
planet (3, 4) = "Orion"
planet (4, 0) = "Eutrepe"
planet (4, 1) = "Sol"
planet (4, 2) = "Nymphs"
planet (4, 3) = "Pandora"
planet (4, 4) = "Sileni"

-- Planet desciptions
description :: String -> String
description "Eo"       = "You are on your home planet Eo.\n"
description "Auster"    = "You arrived on Auster, the only other planet you have ever been on. It is very similar to your home planet Eo. You can''t see much because the view is obstructed by all the skyscrapers.\n"
description "Artemi"    = "You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.\n"
description "Somnus"    = "You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.\n"
description "Leda"      = "You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.\n"
description "Fates"     = "You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.\n"
description "Avernus"   = "You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon.\n"
description "Cepheus"   = "You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.\n"
description "Flora"     = "You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.\n"
description "Merope"    = "You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.\n"
description "Atlas"     = "You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.\n"
description "Boreas"    = "You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.\n"
description "Castor"    = "You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.\n"
description "Electra"   = "You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.\n"
description "Thanato"   = "You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.\n"
description "Demete"    = "You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.\n"
description "Hade"      = "You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.\n"
description "Enyo"      = "You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.\n"
description "Hecate"    = "You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.\n"
description "Orion"     = "You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.\n"
description "Eutrepe"   = "You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.\n"
description "Sol"       = "You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.\n"
description "Nymphs"    = "You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.\n"
description "Pandora"   = "You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.\n"
description "Sileni"    = "You are on Sileni. It is a moon of the capital planet of your galaxy Orion. People on Orion had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Orion.\n"
