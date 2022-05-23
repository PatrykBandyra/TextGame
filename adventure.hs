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
    "speak person  -- to speak to a person on a planet", 
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

-- NPC, Dialog
type Dialog = (String, String)

-- takes npc, dialogs and returns corresponding dialog
findDialogByNPC :: String -> [Dialog] -> String
findDialogByNPC npc [] = "ERROR"
findDialogByNPC npc (x:xs) = let (npcName, dialog) = x in
                                 if npc == npcName then
                                     dialog
                                 else
                                     findDialogByNPC npc xs

-- Make NPC speak if he/she is in a given room from given position
speakTo :: String -> State -> IO ()
speakTo npc state = let (pos, fuel, sfuel, inv, rooms) = state
                        room = findRoomByPos pos rooms
                        (name, roomPos, items, npcs, desc) = room in
                        if elem npc npcs then
                           let dialog = findDialogByNPC npc dialogs in
                               do printLines [dialog]
                                  gameLoop state
                        else
                            do printLines ["There is no " ++ id npc ++ " here.\n"]
                               gameLoop state

replaceRoom :: Room -> [Room] -> [Room]
replaceRoom room [] = [("Error", (-1, -1), [], [], "Error")]
replaceRoom room (x:xs) = let (name, _, _, _, _) = room
                              (planetName, _, _, _, _) = x in
                                  if name == planetName then
                                      room:xs
                                  else
                                      x:replaceRoom room xs
                        

-- Maps planet - NPC
type PlanetNPC = (String, String)

-- Add dynamic NPC to a room after restart
addNPC :: State -> [PlanetNPC] -> State
addNPC state [] = state
addNPC state (x:xs) = let (pos, fuel, sfuel, inv, rooms) = state
                          room = findRoomByPos pos rooms
                          (name, roomPos, items, npcs, desc) = room
                          (planetName, npcName) = x in
                              if planetName == name then
                                  if elem npcName npcs then
                                      state
                                  else
                                      let newNpcs = npcs ++ [npcName]
                                          newRoom = (name, roomPos, items, newNpcs, desc)
                                          newRooms = replaceRoom newRoom rooms
                                          newState = (pos, fuel, sfuel, inv, newRooms) in
                                            newState
                              else
                                   addNPC state xs


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
                            (_, _, items, npcs, desc) = room in
                            do printLines [desc]
                               printItems items
                               printNPCs npcs

-- print npcs
printNPCs :: [String] -> IO ()
printNPCs [] = return ()
printNPCs (x:xs) = do printLines ["There is " ++ id x ++ " who you can speak to.\n"]
                      printNPCs xs
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
        ('s':'p':'e':'a':'k':' ':xs) -> do speakTo xs state
        "restart" -> do printLines ["You decided to settle on this planet and guide any future travellers that will meet you.", ""]
                        let newState = addNPC state dynamic_npcs
                            (pos, fuel, startingFuel, inv, rooms) = newState
                            newState2 = (startingPos, startingFuel, startingFuel, inv, rooms) in
                            do printLookAround newState2
                               printFuel newState2
                               gameLoop newState2
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
    ("Artemi",      (0, 2),      [],                [],                         "You are on Artemi, with your first glance you can see that it is not as populated as Eo or Artemi. There are a couple bigger cities here, but this planet mainly serves as a quarry for your home planet.\n"),
    ("Somnus",      (0, 3),      [],                [],                         "You are on Somnus. It has almost no human inhabitants because the whole planet is covered in water, but there is a whole civilization living at the bottom of the ocean.\n"),
    ("Leda",        (0, 4),      ["microprocesor"], ["Angnet"],                 "You are on Leda, a dwarf planet. The only thing that''s on this planet is a gas station.\n"),
    ("Fates",       (1, 0),      ["microchip"],     ["Arler"],                  "You are on Fates. It''s not even a planet, but actually a moon of your home planet. There is one city here, but other than that not much really.\n"),
    ("Avernus",     (1, 1),      ["steel"],         ["Thera"],                  "You are on Avernus. It is a moon of planet Auster. There are a couple of smaller cities here, but nothing impressive because it still is a moon.\n"),
    ("Cepheus",     (1, 2),      [],                [],                         "You are on Cepheus, which is mostly covered in sand. The only inhabitants of this planet are sand people, because only they can survive the extreme temperatures for longer periods of time.\n"),
    ("Flora",       (1, 3),      [],                ["Linda"],                  "You are on Flora. The whole planet is basically a huge rainforest. Not much is known about it. Because of many predators living here nobody wants to explore it deeper.\n"),
    ("Merope",      (1, 4),      ["qubits"],        [],                         "You are on Merope. Most of its inhabitants are fugitives and criminals who are banished from their own planets. There is a huge casino here.\n"),
    ("Atlas",       (2, 0),      [],                ["Jana"],                   "You are on Atlas, the desert planet. Every civilization owns part of the planet, from which they harvest valuable spice.\n"),
    ("Boreas",      (2, 1),      [],                [],                         "You are on Boreas. It is a wasteland where there is a lot of garbage. In the past it was a battlefield for many wars, which ruined the whole planet.\n"),
    ("Castor",      (2, 2),      ["generator"],     [],                         "You are on Castor, the whole planet is covered in big mountains and hills, so it''s difficult to build a big civilization here. But under all that rock there are a ton of valuable resources which locals trade for spice.\n"),
    ("Electra",     (2, 3),      [],                ["Brusse"],                 "You are on Electra. It is said that the storm here stops for only one day in a month. As a result almost no one wants to live here and most of the people here are travelers.\n"),
    ("Thanato",     (2, 4),      [],                [],                         "You are on Thanato. There are no animals or plants here, due to lack of natural reserves of water. Amazingly some people managed to survive on this planet, but only because of caravans bringing them necessary supplies, which they buy in exchange for fuel in which this planet is rich.\n"),
    ("Demete",      (3, 0),      ["plasma"],        [],                         "You are on Demete. The whole planet is a beach paradise. It is covered in one big ocean with lots of little and big islands. The inhabitants are very friendly and are known for their hospitality.\n"),
    ("Hade",        (3, 1),      [],                [],                         "You are on Hade, the volcanic planet. It is almost uninhabitable because of many active volcanoes and lava that covers most of the planet. Despite such extreme conditions some people managed to call this place home.\n"),
    ("Enyo",        (3, 2),      [],                [],                         "You are on Enyo. For some reason it is known as the land of wind and shade. The only inhabitant of this planet is a weird species of yellow salamanders. There is still a lot to learn about this unusual planet filled with oil lakes.\n"),
    ("Hecate",      (3, 3),      [],                [],                         "You are on Hecate, the frozen planet. There is really not much to it except for ice …. and snow.\n"),
    ("Orion",       (3, 4),      [],                [],                         "You are on Orion. It is the capital planet of your galaxy, similarly to your home planet it is mostly covered in skyscrapers. The locals can be quite eccentric, but nothing that you wouldn''t handle.\n"),
    ("Eutrepe",     (4, 0),      ["black hole"],    [],                         "You are on Euterpe. The planet is mostly covered in hot springs on which the local inhabitants make a lot of money. Many people (mostly wealthy ones) come here to escape from their daily lives and relax a little bit.\n"),
    ("Sol",         (4, 1),      [],                [],                         "You are on Sol. It is a colossal space station that was set up to study nearby star. With time it evolved to the size of a little city and is no longer used as a research facility.\n"),
    ("Nymphs",      (4, 2),      [],                [],                         "You are on Nymphs, a small planet on which you can find the biggest and most famous nightclubs. The upper class of Orion comes here to get high and cheat on their significant others.\n"),
    ("Pandora",     (4, 3),      ["particle"],      [],                         "You are on Pandora. It is covered with all kinds of beautiful vegetation. Its inhabitants are almost one with nature and they do not trust outsiders.\n"),
    ("Sileni",      (4, 4),      ["circuit"],       ["Lica"],                   "You are on Sileni. It is a moon of the capital planet of your galaxy Orion. People on Orion had problems with fitting on the planet, so they started migrating to its moon. It now acts as suburbs of Orion.\n")]

dynamic_npcs = [   
    ("Somnus", "Jamy"),
    ("Cepheus", "Dave"),
    ("Merope", "Ryany"),
    ("Boreas", "Jery"),
    ("Demete", "Stimy"),
    ("Enyo", "Patry"),
    ("Orion", "Jimmy"),
    ("Sol", "Johnne"),
    ("Pandora", "Walter"),
    ("Artemi", "Reby"),
    ("Jula", "Castor"),
    ("Thanato", "Lyna"),
    ("Hade", "Mara"),
    ("Hecate", "Cathy"),
    ("Euterpe", "Athen"),
    ("Nymphs", "Sarie")]

dialogs = [
    ("Hardy", "Hi! Are you from Eo? Yes? So cool, I have half of my family there. My name is Hardy. I call myself an adventurer, although I have never been outside of our solar system. Well… But you know what? Maybe you will help me out in my escape from this galaxy? I am so hungry for travel which I cannot afford. You are really trying to build this superb spaceship? So cool!!! I can even help you! I know about the Hyperdrive schema - I was an engineer… Before they threw me out of my company and took all the titles. So... You need a Reinforced Steel and Electromagnetic Generator. I have one more hint for you. If you were in need of a Gold-Plated Microchip, you would have to go to Fates where they have a small factory of these rare components."),
    ("Jamy", "Hello! Welcome on Somnus! I am Jame. Do you remember me? Yes? So cool. I am not going to waste your time. Good luck in your search!"),
    ("Arler", "Welcome to Fates. Even though there are not many of us, we still were able to hold those barbarians from Hecate off of our precious resources. It is just information for you and you should share it with other travelers. And remember… We are the best friends for our friends and the greatest enemies for our enemies. In an act of goodwill, we are going to share with you our schema for Hyperdrive. Listen carefully. In order to construct this advanced piece of equipment, you need to obtain Reinforced Steel and Electromagnetic Generator. Good luck in your search!"),
    ("Dave", "Hi! What an extraordinary meeting! I thought that you are already out there exploring other galaxies. Well… I wish you good luck. Come back again if you have free time."),
    ("Ryany", "Hi!!! Super nice to meet you again. Merope is such an amazing planet. You will never be bored here ever again. Maybe you should consider settling down here."),
    ("Jery", "Hello. How is your family doing back there on Eo? Good? Excellent! Okay, I am not going to bother you anymore. Good luck on your journey!"),
    ("Brusse", "Hi! I am Brusse. Welcome to Electra. You should not stay here longer than you need to. Those crazy storms are extraordinarily dangerous. I do not live here. Just… I am just staying for one night, he he. What you need? Are you looking for Exotic Particle? I heard about it from locals that traveled north of Electra. Well, I do not know anything more about it."),
    ("Stimy", "Hey! Welcome on Demete. Nice to see you again, this time in better shape, ha ha."),
    ("Patry", "Welcome to Enyo, old friend. How is your search going on? Good? Nice to hear that!"),
    ("Jimmy", "Hi! How are you? Did you find what you had been looking for? You are in hurry, I see. Well, I am not going to bother you then. See you again."),
    ("Johnne", "Hi! Nice to see you again. Will you stay this time a bit longer?"),
    ("Walter", "Hi! Do you remember me? We met on Eo in this popular bar. Yeah! Exactly there! Okay, I wish you luck, friend."),
    ("Phelly", "Hello! I am Phelly Perry from Eosian ATF bureau and I wish you good luck in your adventure. I have something less official to tell you. Listen… We recently captured a smuggler on our outer frontier and he was in possession of something you may find very helpful. Look, I do you a favor  and maybe one day you will be able to repay me in one way or another, ha, ha. So I have a schema of Deflective Shield for you. You need Nanoparticle Coolant and Gold-Plated Microchip in order to create it."),
    ("Kathri", "Hello traveler! My name is Kathri and I am a commander chief of Eosian Space Program. I am glad to finally meet you. I was told that you had the highest grades in your year at Space Academy. That is really impressive. As such, you are the only suitable person for our newest mission. We received a strange signal from deep space. Our greatest scientists analyzed and concluded it could be connected with the origin of our species. I think you understand the importance of finding the source of that signal. We could learn the true nature of our origin. Your mission is to explore the space and reach the place where the signal came from. Explore, find new technology. Maybe you would even meet someone that will help you. I wish you good luck in your journey!"),
    ("Reby", "Hey! Nice to see you again! Are you still trying to find all those components? Good luck!"),
    ("Angnet", "Hello traveler! I am Angnet. You will find nothing and nothing here. So I have no idea why you come to our planet. Nevertheless, welcome. You are in search of Platinum Circuit, he? That’s good. Because there are many people coming here from far North that have those rare chips implanted in their skulls. Crazy! Those chips cost a small fortune. Unfortunately, I cannot afford them. If I had, I would not live on this deserted planet, ehhh…"),
    ("Thera", "Hello. Do I know where to get Platinum Circuit? Well, of course I do. You need to order them online. They are pretty expensive so I do not know if you can afford them. Personally, I have one of them. I am a well-established lawyer and… Have I mentioned that I am a lawyer? Yes? Good! Do I know where those chips come from? Of course, they are from Sileni. Where is this place? Ummm… I have no idea. Sorry, I have to go."),
    ("Linda", "Welcome! My name is Linda. You are my guest now. Unfortunately, not many people visit us. Our planet is so beautiful and untamed. It is heaven! What are you looking for? Deep Space Scanner? Hmmm… Why do you need that? Are you planning an escape from our galaxy? Really? Wow!!! Okay, I think you are a good person so I will tell you. To build a Deep Space Scanner, you first need to get a Platinum Circuit and Microprocessor. I hope it helped, see ya!"),
    ("Jana", "Hi, traveler! I heard your ship. Pretty loud landing, ha ha. I know what you are looking for and might be able to help you. I have some distant relatives on Castor, which is located east of Atlas, and a few weeks ago a merchant spaceship made a hard landing there. Pretty loud bang, you know, ha, ha. There are many useful things laying around. Maybe even Electromagnetic Generator… Who knows?"),
    ("Jula", "Hi! How are you? Would you like to settle here? Castor is a wonderful place. No? Well, good luck then."),
    ("Lyna", "Hi, old friend. You still cannot find your own place, huh?"),
    ("Mara", "Hello, lone traveller! We meet again. I am Mara. Do you remember me?"),
    ("Cathy", "Brother, help me out! I am stuck on this frozen planet! Wait…"),
    ("Athen", "Hey! Welcome back to Euterpe! What a journey it was. I did not find what I was looking for, but I found peace. I wish you the same, brother."),
    ("Sarie", "Hello, old comrade. What a beautiful place to meet again."),
    ("Lica", "Hi! Welcome to my home. I am Lica. I heard from my friends from other planets that there is a lone traveler looking for strange things in the whole galaxy. Is that you? Superb! You are pretty famous. At least in a circle of my friends, ha, ha, ha. What do you need. I might be able to help you. Quantum Computer schema? Well… Good for you, because my husband is working as a researcher in Sol National Institute. Wait a minute… I will find a schema. Here you go! (Schema: Components: Sealed Micro Black Hole + Cluster of Qubit)")]
