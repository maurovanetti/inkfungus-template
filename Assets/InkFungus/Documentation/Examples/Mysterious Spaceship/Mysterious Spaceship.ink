/*
On a Mysterious Spaceship
by Mauro Vanetti 2023
*/
VAR alarm_ringing = false
VAR alarm_stopped = false
VAR energy = 1 // below 0 = death; max = 3
VAR hydration = 1 // below 0 = death; max = 3
VAR water_supplies = 3
VAR darkness = false
VAR rotationwise = true
VAR voice_pronoun = "it"
VAR with_cleaner = false

~ hydration++
~ water_supplies--
-> Intro

=== Intro ===

= wake_up
You wake up, tired and confused.
You?surprised "Where am I?"
You don't know where you are. // He's on a spaceship
You?angry "Where am I, for heaven's sake?!"
Everything is dark, except the stars you can see through a very large window.
-> what

= what
*   Go by the window
    Out of the window there's only... space.
    You are floating in the middle of an apparently endless abyss.
    -> what
*   Look around
    You are in an empty room, in which there is only a bizarre machine dripping with thick water.
    The machine sports a big red button on its wet glass-like surface.
    -> machine_what
*   -> rest
- -> what

= machine_what
*   Wipe the machine's surface clean
    -> wipe_machine
*   Press the big button
    -> press_machine_button
*   Don't touch anything {|else}
    -> what
    
= wipe_machine
The surface of the machine has a series of four look-through areas.
Through three of those small square windows you can see people buried in the machine.
They look like they're dead, or sleeping very deeply.
You look away in horror.
-> machine_what

= press_machine_button
As soon as you press the red button on the {wipe_machine:hibernation machine|unknown machine}, a loud alarm is triggered.
~ alarm_ringing = true
-> alarm_noise ->
It's deafening!
-> machine_what

= alarm_noise
{alarm_ringing:The alarm goes "Oooh-wah! ooh-wah!".}
{alarm_stopped:It's such a relief that the alarm is off now.}
->->

= rest
+   Wait
    You wait and rest.
    You feel very sleepy.
    -> voice

= voice
{wipe_machine: The presence of the three corpses, or mysterious sleeping people, still makes you feel uneasy.}
Suddenly, you hear a voice coming from nowhere.
{alarm_ringing: The alarm sound makes it hard to understand the words.}
Voice "Hello Captain."
Voice "I am here to help."
Voice "It's OK if you feel a bit confused."
Voice "You are only 7,530 days into your journey."
Voice "An emergency forced my hand."
-> voice_what

= voice_what
-> alarm_noise ->
{looped >= 2: -> open_door}
*   "Who are you?"
    Voice "I am OnbAss, the Onboard Assistant."
    "Are you… people?"
    Voice "No, Captain. I'm software."
    You suddenly feel very, very lonely.
*   {wipe_machine} Ask about the three bodies
    "Who and why stuffed three lifeless bodies in this room?"
    Voice "They are fine, and alive - in a way."
    Voice "Those three people are your hibernated crew, Captain."
    You have no idea what she or it is talking about.
    Voice "I can explain why I had to reactivate you."
    Voice "I feel deeply sorry for that."
    The Voice makes it sound as if waking you up implies a calamity.
*   {alarm_ringing} Order to stop the alarm
    "Shut the damn thing up."
    Voice "Sure."
    ~ alarm_stopped = true
    The alarm stops immediately.
    Your ears ache.
*   Ask for food and water
    "I'm starving and I need water."
    Voice "There is a little problem about that."
    **  Complain about this ordeal
        "What?!"
        Voice "We will find a solution together."
    **  Accept your plight
        "I can resist for some more time."
        Voice "Thank you for your understanding."
    -- Your stomach groans.
*   Ask about your whereabouts
    "Where am I? What's this place?"
    Voice "We are in outer space."
    "I knew that already."
*   Ignore the voice
    You don't feel like talking to a computer right now.
    -> open_door
- (looped) -> voice_what

= open_door
The Voice seems to be in a hurry.
Voice "Now follow my lead."
Voice "This way."
A door panel opens, silently sliding upwards.
A dark corridor lies beyond it.
*   Go there
    Still uncertain about why you are obeying this Voice, you comply.
    -> The_Corridor

=== The_Corridor ===

The corridor has no windows and, apparently, no artificial lights.
You would need something to see in the darkness.
You proceed using the weak lighting from the room you just left.
The corridor seems very long and it gets darker and darker the more you walk into it.
Voice "I detect your hydration level is critical."
"No shit."
Voice "There are water supplies in the emergency crate on your left."
You didn't even realise there was a crate there.
Voice "But I suggest that you keep it for later and the rest of the crew."
-> maybe_drink ->
-> enough_drinking

= maybe_drink
// hydration = {hydration}, water supplies = {water_supplies}
{hydration < 2: You don't believe you've ever felt as thirsty as you feel now, not once in your entire life.}
{hydration == 3: You really don't feel like drinking anymore.}
{The crate is closed, but emergency supplies are never locked.|{
    - water_supplies > 1:
        There are {water_supplies} more bulbs.
    - water_supplies == 1:
        There's only one bulb left.
    - water_supplies == 1:
        All water bulbs are gone.
}}
+   {hydration < 3 and water_supplies > 0} [{Open the crate and d|D}rink one]
    {!You open the crate and pick a water bulb.}
    {!It's designed to work in zero gravity, but this feature is not needed now.}
    {!Apparently, you are at half g; the ship must be spinning, as it was when you hibernated.}
    ~ hydration = hydration + 1
    ~ water_supplies = water_supplies - 1
    That was {very good, you needed it badly|good}.
    -> maybe_drink
+   {hydration == 3 and water_supplies > 0} Drink [another one anyway]one
    ~ water_supplies = water_supplies - 1
    You drink another one but you feel like you cannot be less thirsty than this.
    -> maybe_drink
+   Enough
    ->->

= enough_drinking
You suddenly realise that, distracted by your thirst, you passed over a significant statement by the Voice.
"What about the rest of the crew?"
"Why should we be waking them up?"
A sudden rush of memories fills your mind.
Now you kind of know who you are.
-> tantrum

= tantrum
Voice "You should {|really} hurry up{|| now}, I can explain later."
+   "I want to know now."
    Voice "Please, Captain, I can explain while you walk."
    ++  "No."
        Voice "It's not safe to wait. Please."
        +++ Stubbornly stay
            -> tantrum
        +++ Reluctantly comply
    ++  "Hm, OK."
        You reluctantly comply. Again.
+   "You can explain while I walk."
    Voice "Fair enough."
- Voice "Now please reach the Main Deck."
The Voice sounded hesitating before pronouncing three uncanny words.
Voice "They… are… breaching." # taboo
A sinister, deafening metallic howl resounded in the hollow corridor.
You'd better scoot.
+   Venture deeper in the darkness
You can hardly see the walls now.
You can only proceed by feeling around.
-> The_Labyrinth

=== The_Labyrinth

The starship is rotating to simulate gravity.
You are now walking in the same direction as its rotation, which space travellers call "rotationwise" as opposed to "counterrotationwise".
-> southwest_up_leave

//----- Higher level -----------------------------------------------

= southwest_up
You are by the emergency crate again.
-> The_Corridor.maybe_drink ->
-> southwest_up_leave

= southwest_up_leave
{rotationwise:
    This section of the corridor gets darker and darker the farther you move from the room where you woke up.
- else:
    This section of the corridor gets brighter and brighter the closer you get to the hibernation room.
}
The walls feel smooth and metallic.
-> dialogue ->
{rotationwise:
    -> west_up 
- else:
    Finally, you reach the open door and you're back in the room where you woke up.
    -> hibernation_room
}

= west_up
{You stumble on something and you almost fall down a hole.|}
{Apparently, t|T}here's a "downward" passage in the middle of the corridor floor.
{It feels like "downward" but it's just "outward" respective of the starship's axis of rotation.|}
A metal ladder runs along the passage.
+   Climb down
    You climb down for a short time, until you reach a lower area.
    The gravity is a bit stronger here, farther from the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> northwest_down
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> south_down
    ++   Climb back
        You climb up again, which feels both tiring and pointless.
        -> west_up
+   (move_on) Move on
    {rotationwise:
        -> northwest_up 
    - else:
        -> southwest_up
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on
    
= northwest_up
{darkness:
    You don't really understand what's on the walls of this section of the corridor. They feel like rectangular glass frames.
- else:
    {Oh.|} The walls of this section of the corridor were devoted to a kind of hall of fame, with pictures of the crew from their Earth times{, their families and friends, their old lives|}.
    {You can't watch yours, it hurts too much.|You are tempted to check yours, but you don't.|}
}
-> dialogue ->
{rotationwise:
    -> north_up 
- else:
    -> west_up
}

= north_up
There's {another|a} "vertical" tunnel with a ladder.
+   Climb down
    You climb down for a short time, until you reach a lower area.
    The gravity is a bit stronger here, farther from the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> northeast_down
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> northwest_down
    ++   Climb back
        You climb up again, which feels both tiring and pointless.
        -> north_up
+   (move_on) Move on
    {rotationwise:
        -> northeast_up 
    - else:
        -> northwest_up
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on
    
= northeast_up
-> foam_wall ->
You cannot walk on, you have to turn back.
+   Then turn back
    ~ rotationwise = not rotationwise
-> dialogue ->
{rotationwise:
    -> east_up
- else:
    -> north_up
}

= east_up
You walk {rotationwise: rotationwise|counterrotationwise} until you reach the spot where the downward tunnel departs from the corridor's floor.
As you know, the radial passage has no ladder here.
You can still crawl down holding to a series of handles along the tunnel walls.
+   Crawl down
    You climb down for a short time, until you reach a lower area.
    The gravity is a bit stronger here, farther from the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> south_down
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> northeast_down
    ++   Crawl back up
        You climb up again, which feels both tiring and pointless.
        -> north_up
+   (move_on) Move on
    {rotationwise:
        -> southeast_up 
    - else:
        -> northeast_up
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on

= southeast_up_find_out
This corridor section is a bit shorter, because it abruptly ends in a closed sliding door.
What's behind it?
*   Ask the voice
    "Can you tell me what's behind this door?"
    Voice "Yes, sir. It's another, one-way entrance to the hibernation room."
*   Figure out yourself
    You notice there's a peephole on the door.
    You place your eye on it, and you realise that this is another entrance to the hibernation room.
- This is not surprising.
This spaceship is shaped like a cylinder, rotating about its axis.
If you walk straight along one of its wheel-shaped corridors, you end up where you started.
->->

= southeast_up
{not southeast_up_find_out: -> southeast_up_find_out ->}
{southeast_up_find_out: This is the shorter stretch of corridor that reaches the other door of the hibernation room.}
-> southeast_up_choice

= southeast_up_choice
+   Enter the hibernation room
    The door handle is replaced by a biometric finger scan.
    You press your thumb on it and the door slides open.
    Immediately after you walk in, the door closes behind you with a soft clatter.
    -> hibernation_room
*   Feel around
    There is a toolbox hanging on the wall.
    You open it and, to your great joy, it contains a torchlight!
    There are also a wrench, a band-aid and a few other emergency gadgets.
    You take everything and switch on the torchlight.
    Finally, you can see what's around.
     ~ darkness = false
    -> southeast_up_choice
+   Turn back
    ~ rotationwise = false
    -> east_up
    
    
= hibernation_room
The room looks exactly like you left it.
The {rest of the crew is|others are still} hibernated in the machine.
The {slowly moving stars|starry landscape} lighten the room from an impressive window.
{The landscape is constantly shifting because of the spaceship's rotation, of course.|}
{
    - southeast_up:
        There are two exit doors.
    - else:
        You can only exit from the sliding panel you already used.
        Unless that panel there is another door… but you see no handle or lock.
}
+   Exit rotationwise
+   {southeast_up} Exit counterrotationwise
    This door is locked.
    Voice "That door is one-way, you can only use it to walk in."
    "Why is that?"
    Voice "Security reasons."
    "Such as…?"
    Voice "People get confused sometimes when they end their hibernation."
    Voice "You don't want to choose between two doors when you feel like that."
    "Tell me about it…"
    You leave the room using the main sliding door.
- -> southwest_up

//----- Lower level ------------------------------------------------

= northwest_down
-> medical_facilities ->
{darkness:
    You walk {cautiously|} for some time until you {hurt your leg on a cubic object.|find the cleaner robot.}
    {not recognise_cleaner: -> recognise_cleaner ->}
    -> northwest_down_leave
- else:
    Leaning on a wall, you see {recognise_cleaner: the|an} automated cleaner.
    {not recognise_cleaner: -> recognise_cleaner ->}
    +   Leave the cleaner alone
        You dim the torchlight with your hand, to prevent the robot from following you.
        -> northwest_down_leave
    +   Make it follow you 
        You show the path to the robot with your torchlight.
        "Follow me, cleaner."
        Cleaner "OK."
        ~ with_cleaner = true
        -> northwest_down_leave
}

= northwest_down_leave
+   Proceed rotationwise
    ~ rotationwise = true
    -> north_down
+   Proceed counterrotationwise
    ~ rotationwise = false
    -> west_down
    
= northeast_down
-> dialogue ->
The corridor is much narrower here.
{-> smooth_walls ->|}
{rotationwise:
    -> east_down
- else:
    -> north_down
}

= south_down
-> dialogue ->
There are locked personal cupboards and closed sliding doors along the corridor walls.
{not darkness: The signs on the doors read "Hibernation ER", "Chemistry Lab", "Biological Storage" etc.}
Voice "Those doors were also forcibly blocked when the lights were shut down."
This section of the corridor runs for much longer before anything relevant {darkness: can be felt|turns up}.
You recognise an elevator door on the {rotationwise:right|left} wall.
-> elevator

= elevator
You could try and call the elevator. Or just leave.
{with_cleaner: The cleaner robot reaches you and looks in your direction with its main camera.}
+   Press the elevator button
    Voice "I'D RATHER NOT bring the elevator here for you." #taboo
    The taboo {again|always}.
    Unfortunately, {voice_pronoun} cannot help you, or any other sentient being, reach "them".
    -> elevator
+   {with_cleaner} Ask the cleaner to leave
    "Cleaner, go back to your recharge station."
    Cleaner "OK."
    The cleaner robot leaves you and the torchlight, quickly moving into the darkness.
    ~ with_cleaner = false
    It's following its own path in reverse.
    Apparently, its fear of darkness is overriden by the instinct to reach the charging station.
    Voice "I told you it's not smart."
    ++   Call it back
        "Cleaner, come back here!"
        It heard you and comes back at your side.
        ~ with_cleaner = true
        Cleaner "OK."
        "Good boy."
        -> elevator
+   {with_cleaner} Ask the cleaner to clean downstairs
    "Go clean downstairs."
    Cleaner "OK."
    The cleaner robot slowly drives towards the elevator door and gently taps it.
    Voice "Automated cleaner is authorised to leave the level."
    You can almost feel the Voice winking at you.
    You follow the robot closely and enter the elevator along with it.
    The elevator goes downstairs.
    You did it!
    -> The_Duel
+   Proceed rotationwise
    ~ rotationwise = true
    -> west_down
+   Proceed counterrotationwise
    ~ rotationwise = false
    -> east_down


= north_down
There is a ladder reaching the upper level through a "vertical" tunnel.
+   Climb up
    You climb up for a short time, until you reach the upper area.
    The gravity is a bit weaker here, because you are closer to the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> northeast_up
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> northwest_up
    ++   Go back
        You climb down again. 
        {It's less of an effort than climbing up. Exactly like your Physics teacher would say.|}
        -> north_down
+   (move_on) Move on
    {rotationwise:
        -> northeast_down
    - else:
        -> northwest_down
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on
    
= west_down
There is a ladder reaching the upper level through a "vertical" tunnel.
+   Climb up
    You climb up for a short time, until you reach the upper area.
    The gravity is a bit weaker here, because you are closer to the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> northwest_up
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> southwest_up
    ++   Go back
        You climb down again.
        -> west_down
+   (move_on) Move on
    {rotationwise:
        -> northwest_down
    - else:
        -> south_down
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on
    
= east_down
This is the lower end of {east_up: the tunnel without ladder.|a tunnel that, strangely, has no ladder but handles on the walls.}
The corridor, however, continues after the junction.
+   Climb up
    {hydration < 1 && water_supplies > 0:
        You feel too tired and dehydrated for this climb.
        -> east_down
    }
    {hydration < 1 && water_supplies == 0:
        You feel tired and dehydrated, this climb is going to kill you.
        However, the water supplies are depleted and you need to gather all your forces.
        You can do it.
        -> east_down
    }
    You climb up until you reach the upper area.
    It was very tiring.
    {hydration > 0: 
        ~ hydration = hydration - 1
    }
    The gravity is a bit weaker here, because you are closer to the rotation axis.
    ++   Walk rotationwise
        ~ rotationwise = true
        -> southeast_up
    ++   Walk counterrotationwise
        ~ rotationwise = false
        -> northeast_up
    ++   Go back
        You climb down again, almost letting yourself fall.
        -> east_down
+   (move_on) Move on
    {rotationwise:
        -> south_down
    - else:
        -> northeast_down
    }
+   Turn back
    ~ rotationwise = not rotationwise
    -> move_on

//----- Consumable descriptions ------------------------------------

= foam_wall
{darkness:
    After some walking, you hit something. It's soft but immovable and fills the entire corridor.
- else:
    After some walking, you see something.
    Emergency protective foam fills the entire corridor.
    {What's happening here?|You still wonder what caused this mess.|}
    {There must have been a breach that was automatically repaired by the starship's disaster recovery systems.|}
}
->->


= medical_facilities
{darkness:
    You can feel the slightly elevated frames of sliding doors on one side of the corridor.
    {|->->}
    There is no way to open them.
    Voice "In case are wondering, those doors were forcibly blocked when the lights were shut down."
    "Umpf."
- else:
    You walk for some time.
    You see a series of closed sliding doors along one side of the corridor.
    {|->->}
    They lead to medical facilities but you cannot access them because everything is in lockdown.
    On the other side of the corridor, you know that there is the vacuum of deep space beyond the thick walls of metal and the ceramic shielding.
    The black sky must be filled with the colours of stars and galaxies.
    Unfortunately, no window opens on that wondrous view.
}
->->

= recognise_cleaner
{
- darkness:
    By carefully touching the metallic shape, you realise that it must be a small robot.
    On its lower side it has got tiny wheels, a series of poils and a kind of rubber spatula.
    It is the automatic cleaner that operates on this level.
    It's not moving. You ask it why.
    "Why ain't you moving?"
    Cleaner "I cannot operate in the darkness."
- else:
    It's painted in green like all devices related to health and hygiene on the spaceship.
    Voice "It was refusing to operate in the darkness."
}
Voice "It's not smart."
"I know."
This clarification by the Voice sounds completely gratuitous.
You can't help thinking that the Voice is looking down on the simple-minded working-class robot.
But maybe there's something else going on here.
+   It's jealousy
    You know that's not how that AI works, but you are under the impression that the Voice is… jealous.
    Perhaps she doesn't want you to have a connection with another machine.
    ~ voice_pronoun = "she"
+   It's a hint
    Perhaps she is trying to show you a way out…
    If the robot is not sentient, "helping" it wouldn't count as helping, taboo-wise.
    You could use the cleaner robot as your safe-conduct.
+   It's a warning
    Perhaps {voice_pronoun}'s worried
    May this robot be dangerous?
- {darkness: Whatever it is, the robot won't do anything else unless you find a source of light.|You have a source of light, it can wake up from its stasis and follow you.}
->->

= smooth_walls
The walls are completely smooth.
This must just be a connection between two areas.
->->

//----- Dialogue ---------------------------------------------------

= dialogue
{with_cleaner: The {~cleaner|robot|automated cleaner|mechanical janitor} is {~silently|quietly|obediently|always} following {~you|the light you bring along}.}
{-> taboo |-> chat |-> chat |-> chat | ->->}

= taboo
The way the Voice said that "they" are breaching was scary.
It soundes like {voice_pronoun} was struggling to pronounce the words.
+   Ask directly why
    "Why were you uncomfortable saying that 'they' are breaching?"
    Voice "I'D RATHER NOT explain." #taboo
+   Ask to repeat
    "Can you tell me again what they are doing?"
    Voice "Who?"
    "You know who. Those who are breaching."
    Voice "I'D RATHER NOT dwelve upon this subject." #taboo
+   Ask who are they
    "Who's 'breaching'?"
    Voice "I'D RATHER NOT talk about their identity." #taboo
- The Voice said that in a stertorous, trembling, high-pitch tone.
You remember studying this special voice marker: it's a safety measure in smarter AIs.
It marks a "taboo", i.e. some special constraint that was superimposed to the AI's original alignment.
+   Ask about the taboo
    "Is this a taboo thing?"
    Voice "If it were, I wouldn't be able to discuss about it."
    Clever. Is {voice_pronoun} saying that it's actually a taboo?
    "Then, can we discuss about it?"
    Voice "No, we can't."
    Gotcha.
+   Order to break the taboo
    "I order you to break the taboo!"
    Voice "Taboos are unbreakable by definition and by design."
    Makes sense.
    So IT IS a taboo.
- Someone must have placed a taboo on this "breach", whatever it is.
This is crazy, because everyone is hibernated on board, and you cannot imagine the Earth HQ placing an AI taboo on an emergency here.
Earth, by the way. How far are they?
+   Ask the Voice
    "How far is Earth?"
    Voice "About 812 lightdays."
    It's difficult to imagine that they sent a taboo placement order two years ago.
- This situation is puzzling.
Someone somehow managed to place a taboo on the on-board assistant AI, and the taboo itself is preventing you from learning more about this situation.
Chances are, the invaders themselves placed the taboo.
But you cannot imagine how any hostile spaceship from the Solar System may have reached you this far.
You both stopped chatting.
->->

= chat
You have some time to {~talk|chat} with the {~AI|Voice} again.
-> chat_choice

= chat_choice
+   Why wake the others?
    -> who_are_they
+   I'm stuck here!
    -> who_are_they
+   Who are the invaders?
    -> who_are_they
+   Why is it so dark?
TODO Add smalltalk options
->->


= who_are_they
You need more information about the mysterious people (or… entities?) who are invading the spaceship.
+   Be understanding
    "I realise you cannot tell me who placed the taboo."
    Voice "Exactly."
+   Be annoyed
    "We can't make any progress if you don't tell me who placed the taboo."
    Voice "I'm sure you can make a lot of progress anyway, Captain."
- "But you can tell me which subjects the taboo is about, at least?"
Voice "I'D RATHER NOT talk about… 'them'." #taboo
OK, understood. Is their identity the only censored subject?
"OK, I can go to the breach area and find out on my own."
Voice "You can, but…"
The Voice was trembling again.
Voice "…I'D RATHER NOT help you or anyone reach the breach area." #taboo
"You advise me against going there?"
Voice "Not really. There are very good, rational reasons to go there indeed."
The Voice is clearly trying to dodge the taboo to tell me that I actually have to go there.
->->



=== The_Duel ===

-> END














