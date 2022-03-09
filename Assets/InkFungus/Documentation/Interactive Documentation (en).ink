/*
===============================================================================
This is the interactive documentation in English for the Ink-Fungus Gateway. 
Version 1.1.0 created on March 9th, 2022.
===============================================================================
*/

VAR z = 7
LIST people = (Mauro), (Wauro)
VAR planet = ""

-> Welcome

=== Credits ===
Mauro "The Ink-Fungus Gateway was created by Mauro Vanetti in 2020, during the pandemic, and released to the public domain.
Mauro "It can be used freely, also for commercial games and other purposes.
Mauro "It can be modified and restributed, as long as credits to the original version are provided and the same free license applies.
Mauro "As an exception, no game of a racist, fascist or sexist character can be created using this tool or its derivatives. Why? Because screw nazis.
Mauro "Ink is a free software created and maintained by Inkle Studios with the support of their open-source community.
Mauro "Fungus is a free software originally created by Chris Gregan and currently maintained by a vibrant community of open-source developers.
Mauro "Hopefully, you can become part of the community of developers of the Ink-Unity Gateway, too.
-> Menu

=== Introduction ===
The Ink-Fungus Gateway is (no surprise here) a gateway between Ink and Fungus.
Ink is a scripting language for interactive fiction, developed by Inkle.
You can find more about Ink at www.inklestudios.com\/ink
Fungus is a visual storytelling and scripting tool for Unity.
You can find more about Fungus at fungusgames.com
Both tools are free and open source, as the Gateway itself.
Both tools are really good and useful, but unfortunately they could not be used together.
Until now!
If you have no idea about Ink and Fungus, you should check them first and come back to the Ink-Fungus Gateway afterwards.
-> Menu

=== Welcome ===
Welcome to the interactive tour of the Ink-Fungus Gateway for Unity.
This scene can be opened in Unity and studied to learn by example how to use the Gateway…
…but it can also be played as an interactive documentation.
You are suggested to play this scene from within Unity in order to check the inner workings of the Gateway on the fly.
-> Menu

=== Menu ===
What {|else }do you want to know about the Ink-Fungus Gateway?
+	What is the Gateway exactly?
	-> Introduction
+ How can I set up a scene for the Gateway?
	-> Setup
+	What are its basic features?
	-> Basic_features
+	What are its advanced features?
	-> Advanced_features
+	Who made this and how can I improve it?
	-> Credits

=== Setup ===
Create an empty scene or open a scene you want to augment with Ink and Fungus.
You need Fungus and the Ink Integration Plugin to be installed and enabled, of course, but you should have them if you're playing this.
Find the Tools > Fungus > Create submenu. You have to create 3 objects from there.
First of all, create the Ink-Fungus Gateway in your scene. Click on Tools > Fungus > Create > Ink-Fungus Gateway.
Then, create a Fungus SayDialog. Click on Tools > Fungus > Create > Say Dialog.
Finally, create a Fungus MenuDialog. Click on Tools > Fungus > Create > Menu Dialog.
You can and should customise these objects later, to modify their appearance and behaviour.
(Tweak the settings of SayDialog and MenuDialog for your game, otherwise it will look too much like this documentation!)
You're also going to need an Ink script file. That's just a text file with a .ink extension. Put it somewhere in your project.
That's it.
-> Menu

=== Basic_features ===
Which {|other }basic feature of the Ink-Fungus Gateway do you want to know about?
+	The conversation system.
	-> Conversation
+	The event system.
	-> Events
+	The synchronisation of variables.
	-> Variables
+ How to jump to another knot or stitch.
  -> Jumps
+	Bring me back to the main menu.
	-> Menu
	
= Conversation
Conversation is the core of these three tools: Ink, Fungus and the Gateway.
Games created with the Gateway are going to be driven by their narrative, i.e. by an Ink file.
Ink files are automatically compiled for usage by the Ink Unity Integration plugin provided by Inkle.
If this interactive tour is working properly, this means that the plugin is installed and working behind the scenes.
The Ink file you are going to use must be set in the Narrative Director component of the Ink-Fungus Gateway.
-> Conversation_submenu

= Conversation_submenu
What {|else }do you want to know about the conversation system?
+	Just how to show some text.
	-> Text
+	How to pause and resume the narrative.
	-> Pause_resume
+	How to introduce speaking characters in the game.
	-> Characters
+	How to let the player choose among multiple options.
	-> Options
+	How to modify the text behaviour.
	-> Conversation_settings
+	Bring me back to the main menu.
	-> Menu

= Text
Write some lines in your Ink source file. You can use all the super-cool features of Ink.
-> Text_variations

= Text_variations
For {~example|instance}, {~one|you} can put variations in the text. (Try {~and|to} replay this line.)
+	Replay that line.
	-> Text_variations
+ Got it. Continue.
	-> Text_start

= Text_start
You don't always want the text to be displayed right away when the game starts.
For this reason, the visual part of the game is going to initiate the Ink narrative part that starts in pause mode.
At the beginning of this interactive tour, you had to push the Start/Resume button.
On click, that button executes the "Resume Narrative" command as specified in the Buttons Flowchart.
The new Fungus command "Ink/Resume Narrative" is the way to go when you want Ink to start piloting your game.
After that, the system will just process the Ink script and display its contents in the Fungus SayDialog.
-> Conversation_submenu

= Pause_resume
Ink scripts can contain tags. Check the Ink documentation about this.
An Ink tag is a hash sign followed by one or more words.
If you attach a "pause" tag to a line of your Ink file, the narrative will pause after the line is displayed.
Let's do that right now. Click on the button to resume. # pause
Easy.
This was an indefinite pause, which can only be ended by explicitly resuming the narrative flow.
There are also timed pauses. With a "pause 3.5" tag, for example, you can pause the narrative for 3.5 seconds.
Let's do a 5-second pause now. Don't press the button. # pause 5
You didn't need to press the button to end the pause after 5 seconds.
If you pressed the button (thus executing "Ink/Resume Narrative"), you've just cut the pause shorter.
Both kinds of pauses can be useful when you want to suspend the narrative to show something with Fungus.
When pausing or resuming happen, an "ink pause" or "ink resume" message is broadcast to all Fungus flowcharts, which can react accordingly.
For instance, the Start/Resume button is displayed or hidden when either message is received.
A similar tag is "wait".
+ Explain me "wait".
	-> Wait
+ I will check it later.
	-> Conversation_submenu
	
= Wait
# wait
We waited for your click BEFORE showing this line.
Sometimes you don't want to have a pause after a line: you want it before the line is displayed.
In order to pause the narrative flow before displaying a new line, you can use the "wait" tag.
The difference is clear when you want to take a break at the beginning of a new knot or stitch.
For example, you may want to have some time for a screen fade.
"wait" works pretty much like "pause": it can be indefinite or include a duration like "wait 3.5".
+ Can I see a working example?
	Check the "Fading Views" scene in the Assets\\InkFungus\\Documentation\\Examples subfolder.
+ Alright.
- -> Conversation_submenu

= Characters
Text lines can be "plain", like this one. This line contain no indication about who's speaking. # saystyle plain
Speaker "But there can also be a label indicating the speaker's name. # saystyle label
Speaker "In order to indicate the speaker's name, it has to be put at the line's beginning, followed by a blank space and a quote sign.
Speaker "The quote sign does not need to be "closed" at the end of the line. Quotes can be used in the usual way within the text.
Mauro "Characters can also be used in the conversation system, like this. # saystyle character
Mauro "The only difference is that the speaker's label corresponds to the name of a GameObject containing a Fungus Character component.
Mauro "In this case, the GameObject is called "Mauro", you can see it in the Hierarchy.
Mauro "Notice that the name displayed is not "Mauro" but "Dr Mauro", which is the value of property Name Text within the Character component.
Mauro "Character is a Fungus component, refer to the documentation for details.
Wauro "You can also switch to another character, like Mauro's evil alter ego Wauro, by changing the initial label in the next line.
Wauro?left "Characters can have multiple portraits, and you can pick one by writing a question mark followed by a portait tag. # saystyle portraits
Wauro?right "The portait tag is just any piece of the portait file name. The Gateway will look for a file containing it among the character's portaits.
Mauro?left "You can add all portraits you like in the Character component. A good use for this feature is to express different moods.
Mauro?right "If you don't specify any portrait, the first one will be used by default, so put your best choice there.
Mauro "The label colours are defined character-wise, but…
Speaker "…you can also define a default colour for those speaker names that correspond to no character. # saystyle plain
Speaker "The default colour for character-less labels is specified in a property of the Narrative Director component of the Ink-Fungus Gateway.
Wauro "If a Character component has the Set Say Dialog property pointing to another SayDialog, like Wauro does, that one will be used instead.
Wauro "This is very useful to have some characters speak through a completely different visual element (think a speech balloon or a phone screen).
-> Conversation_submenu

= Options
Ink is meant to be used for branching narratives.
This implies that sometimes there are different options to choose from, as you saw in the previous menus.
Let's make an example.
+   First option.
+   Second option.
- That's it. This magic happens in the Ink script, check the Ink documentation to know all the tricks.
Options are displayed using the Fungus MenuDialog. The appearance and behaviour of the menu can be modified by altering the MenuDialog.
The standard MenuDialog have a maximum of 6 option buttons. This means that your Ink should not include more than 6 choices in any branching.
-> Conversation_submenu

= Conversation_settings
There are some advanced features in the Gateway that enable more complex manipulation of the conversation system's behaviour.
Do you want to check them?
+	Bring me to the advanced-features menu.
	-> Advanced_features
+   Bring me back to the menu about the conversation system.
	-> Conversation_submenu
	
= Events
The Gateway sends a stream of messages to the Fungus flowcharts describing what's going on in the Ink-based narrative part.
Any event name always starts with "ink", as in "ink pause" or "ink refresh n". The "ink" prefix can be modified or removed altogether, though.
Such messages may be intercepted by Fungus flowcharts in order to trigger the activation of blocks. Check the Fungus documentation about this.
Let's show an example. The message "ink earthquake" will be broadcast when you click on this dialog.
And here is the earthquake. # earthquake
There is a Fungus flowchart called "Earthquake Flowchart" in this scene that does the trick.
-> Events_submenu

= Events_submenu
Which {|other }events do you want to know about?
+	Pause, resume and stop.
	-> Events_pauseresume
+ Load and save.
	-> Events_loadsave
+ Refresh variable.
	-> Events_refresh
+ Narrative progress.
	-> Events_at
+ Generic events.
	-> Events_generic
+	Bring me back to the main menu.
	-> Menu
	
= Events_pauseresume
When pausing or resuming happen, an "ink pause" or "ink resume" message is broadcast to all Fungus flowcharts.
"ink pause" and "ink resume" messages are broadcast for "wait" tags too.
This can be useful to rearrange the screen and switch from the narrative mode to the visual mode, enable/disable controls etc.
When the story reaches a stop, an "ink stop" message is broadcast to all Fungus flowcharts.
The stop event can mark the very end of the game or just a dead end of the narrative flow.
The "Ink/Jump To" command can be used to get out of such dead ends.
An "ink resume" message is also broadcast when, usually after a stop, a jump command is issued.
-> Events_submenu

= Events_loadsave
Loading and saving is described in details among the advanced features.
What you need to know here is that saving and loading happen in "slots" and you can tell slots apart using their names.
Whenever saving happens, an "ink save" message is broadcast to all Fungus flowcharts.
Another, more detailed message, is also broadcast, "ink save X" where "X" is replaced with the actual slot name.
There is also a lot of automatic saving going on in the "auto", "precheckpoint" and "checkpoint" slots. These saves are not notified to Fungus.
The same happens with loading, you get "ink load" and "ink load X" where "X" is replaced with the actual slot name.
There is also a special event for the outcome of the loading attempt: "ink load ok" or "ink load fail".
(Please don't call your saving slots "ok" or "fail" - or "auto" or "precheckpoint" or "checkpoint" - because that would mess everything up.)
These messages can be useful to display a floppy-disk icon, to prepare the scene to restart in another location etc.
-> Events_submenu

= Events_refresh
Some variables are shared between the Fungus (visual) side and the Ink (narrative) side. This is handled by the Gateway.
Every time a Fungus variable is automatically updated by the Gateway, two messages are broadcast to all affected Fungus flowcharts.
A generic "ink refresh" message is sent, and a more detailed "ink refresh X" where "X" is replaced with the variable name.
Notice that flowcharts lacking reference to the updated variable are not going to receive the message.
These messages can be useful to trigger a refresh behaviour, e.g. when you click on this dialog the "z" variable will be increased.
~ z = z + 1
As you can see, Fungus was notified of the change and a listening flowchart has updated the value displayed.
-> Events_submenu

= Events_at
Whenever the narrative reaches a new knot or stitch, two messages are broadcast to all Fungus flowcharts.
If it is a new knot, the message sent will be "ink at K" where "K" is the knot name.
If it is a new stitch, the message sent will be "ink at K.S" where "K" is the knot name and "S" is the stitch name.
In all cases, a generic "ink at" message will also be sent.
These messages can be useful to change the scene according to the proceeding of the narrative.
-> Events_submenu

= Events_generic
Any unrecognized tag in the Ink script is echoed in the form of a broadcast message sent to all Fungus flowcharts.
To avoid interference with messages sent by other parts of the project, messages coming from Ink start with "ink".
For instance, a custom tag "fadeout 5" will be translated as "ink fadeout 5".
-> Events_submenu

= Variables
Global variables exist in Ink and in Fungus, although there are some subtle differences between them.
+ Yeah, I know.	
+ Which differences?
	Some. You can only have integers, floats, strings and Booleans in Ink. Other variable types in Fungus cannot be synchronised.	
	Then you have lists, in Ink, but not in Fungus. Find about them in the advanced-features area.
	Let's check the easy case now.
- For instance, "z" is defined as a global variable in the Ink script underlying this interactive tour.
A global variable with the same name, "z", is also defined on the Fungus side of this interactive tour.
Why don't you click on the mushroom? (That's the Fungus logo.)
We can use the "z" variable in the narrative, for example we can say that its current value is {z}.
The Ink-Fungus Gateway takes care of keeping in sync global variables that share the same name.
When a variable changes on the Fungus side, Ink needs to know, which can be done by executing the "Sync Variables" command.
This new Fungus command can be found looking for "Ink/Sync Variables" in the command list.
When a variable changes on the Ink side, it is automatically updated on the Fungus side and "ink refresh" messages are sent.
A working model for a Fungus flowchart to handle a shared global variable is the Variable Processor prefab.
A Variable Processor can be created in your scene by clicking on Tools > Fungus > Create > Variable Processor.
Read the notes and comments in the Variable Processor's flowchart to find out how to adapt it to your needs.
Open this scene in the editor to study how the Variable Processor's flowchart was modified for usage in this interactive tour.
You can also find more about the refresh messages in the events area of the documentation. Do you want to go there?
+	Tell me about the events.
	-> Events
+	Bring me back to the main menu.
	-> Menu

= Jumps
If your interactive story is driven by the Ink script, you don't need any "jumps".
The flow of your story can just follow the branching and weaving and tunnelling defined in your Ink script.
But you may want to have the visual (Unity/Fungus) side of your game drive the narrative sometimes.
For example, you might make a game in which you freely walk around and sometimes you meet an NPC and a conversation begins.
One of several possible ways to do that is using the new command "Ink/Jump To".
Let's test the "Jump To" command now.
There is a Jumps Flowchart handling the current situation. Check it, it was enabled right now. # canjump
This flowchart listens to "ink stop" and "ink resume" events.
We are now about to interrupt the story flow and give control to the visuals.
You will be able to proceed only by clicking on something. Click on the sprite to talk to Dr Mauro. # yes hide
-> DONE

= Jumps_outcome
{ 
	- Detached_knot:
		The last time you spoke to Mauro you chose {planet}.
	- else:
		You didn't speak to Mauro. OK, whatever.
}
You probably don't want to combine these two styles as this interactive documentation does.
They are two opposite ways to organise your game: either you make it story-driven or visual-driven.
Jumps are more useful in visual-driven games such as point-and-click adventures. Visual novels, on the opposite, are usually story-driven.
The Jumps Flowchart was now disabled again to prevent it from interfering with the main flow. # cantjump
-> Basic_features

=== Detached_knot ===
Mauro "You clicked on Mauro's sprite and you reached this knot in the Ink script.
Mauro "This will go on until the story fragment is over, then you can jump back to where you were before.
Mauro "You can still keep track of what the players do in areas they jump to.
Mauro "Example: pick your favorite inner planet.
+ Mercury
	~ planet = "Mercury"
+ Venus
	~ planet = "Venus"
+ Earth
	~ planet = "Earth"
+ Mars
	~ planet = "Mars"
- Mauro "OK! I will remember that. # yes hide
-> DONE

=== Advanced_features ===
Which {|other }advanced feature of the Ink-Fungus Gateway do you want to know about?
+	Synchronised lists.
	-> Lists
+	The settings.
	-> Settings
+	Saving and loading.
	-> Save_load
+	Localization.
	-> Localization
+	Bring me back to the main menu.
	-> Menu
	
= Lists
Lists are a special kind of variables in Ink. Check the documentation.
Did you read already about synchronising variables through the Gateway?
+ Nope.
	OK, then it's too early to read about lists. Listen to this first.
	-> Basic_features.Variables
+ Yeah.
- In this case, you are ready to know about synchronising Ink lists to Fungus.
The trick is: we treat Ink lists as a collection of Booleans (true/false) in Fungus.
For instance, we have a list called "people" in this Ink script. This list can or cannot contain items called "Mauro" and "Wauro".
We are keeping the Ink list in sync with two global Boolean variable called "people__Mauro" and "people__Wauro" in Fungus.
-> Lists_test

= Lists_test
Let's play with this list.
+ Keep Mauro off the list and Wauro on the list.
	~ people -= Mauro
	~ people += Wauro
	OK. Mauro out, Wauro in.
+ Keep Wauro off the list and Mauro on the list.
	~ people -= Wauro
	~ people += Mauro
	OK. Mauro in, Wauro out.
- You can now push the buttons to change the in/out state of either guy.
Let's check what we have in the list now, using Ink.
Ink sees "Mauro" {people has Mauro:in}{people hasnt Mauro:out of} "people".
Ink sees "Wauro" {people has Wauro:in}{people hasnt Wauro:out of} "people".
+ Let's play again.
	-> Lists_test
+ I got it.
	Great.
	You just need to call the global Fungus Boolean "LIST__ITEM" where "LIST" is the Ink list name and "ITEM" is the Ink list item name.
	-> Advanced_features
	
= Settings
The Narrative Director component of the Ink-Fungus Gateway GameObject has several settings that can be altered via the Inspector.
-> Settings_submenu

= Settings_submenu
Which settings of the Narrative Director do you want to know more about{|, now|, this time}?
+	Those in the Basic Settings area.
	-> Settings_basic
+	Those in the Default Flags area.
	-> Settings_flags
+	Those in the Messages to Fungus area.
	-> Settings_messages
+	Those in the Advanced Settings area.
	-> Settings_advanced
+	Bring me back to the main menu.
	-> Menu

= Settings_basic
This area is very straightforward. The only required value is the Ink field: you need to place your Ink script asset here.
The Say Dialog and Menu Dialog fields can be left empty: if there is only one instance of each required Fungus object, the Gateway will find it.
If for some reason there are multiple Say Dialog and Menu Dialog objects, they can be specified there.
Both values can also be replaced at runtime by executing the new Fungus commands called "Ink/Replace Say Dialog" and "Ink/Replace Menu Dialog".
This advanced feature can deliver interesting results, e.g. by differentiating conversation options from other sorts of menus (inventory, shops etc.).
Narrator "The Default Character Color field specifies the text colour used for the speaker label when no corresponding Character is available.
Narrator "This is exactly what we're doing here with the "Narrrator" label.
Mauro "When a speaker name corresponds to an existing Fungus Character GameObject, as in this other case, their specific label colour is used.
-> Settings_submenu

= Settings_flags
Flags are binary (true/false) values that control some optional behaviours of the Gateway.
Flags are set to their default values unless they are altered by the Ink script itself.
There are two ways to modify the value of a flag in the Ink script: permanent and temporary.
Permanent changes to a flag are applied after an "on FLAG" or "off FLAG" tag are processed (replace "FLAG" with the flag name, of course).
Imagine this as permanently switching on or off that particular flag.
Sometimes, though, you just want to make a temporary exception to the usual behaviour. This is called a temporary flag change.
Temporary changes last only for the time span of a conversation line (including the multiple-option menu if it's the line preceding a choice).
Temporary changes to a flag are applied when a "yes FLAG" or "no FLAG" tag are processed (again: replace "FLAG" with the flag name).
To sum up: default flags are overriden by on/off tags, and both are temporarily overriden by yes/no tags.
-> Flags

= Flags
Which {|other }flag do you want to know about?
+	Hide Questions ("hide").
	-> Flag_hide
+ Echo Answers ("echo").
	-> Flag_echo
+ Auto Proceed ("auto").
	-> Flag_auto
+ Ignore Dialog Regex ("verbatim").
	-> Flag_verbatim
+ Choice Timer ("timer").
	-> Flag_timer
+	Bring me back to the main menu.
	-> Menu
	
= Flag_hide
The "hide" flag controls whether the last conversation line before a choice is kept in display or not when the options are shown.
This also applies to the final line before the story stops or ends.
Let's learn by example.
This is what happens with the "hide" flag ON. Got it? # yes hide
+	Yeah.
+	Yep.
+	Got it.
- Glad you understood.
And this is what happens with the "hide" flag OFF. Got it? # no hide
+	Oh yes.
+	Definitely.
+	Hell yeah.
- {You are a fast learner.|I hope you really understood.|Hmm. I hope so.}
Remember that Ink does not allow for tags in choice options, therefore the "on/off/yes/no hide" tags are to be applied to the previous line.
-> Flags

= Flag_echo
The "echo" flag controls whether choices are treated as answers that are to be echoed back into the conversation.
Notice that Ink was designed to treat them like that (as if the "echo" flag was always on) and has some special syntax to do that smartly.
Let's learn by example.
This is what happens with the "echo" flag ON. Got it? # yes echo
+	Yeah.
+	Yep.
+	Got it.
- Glad you understood.
And this is what happens with the hide flag OFF. Got it? # no echo
+	Oh yes.
+	Definitely.
+	Hell yeah.
- {You are a fast learner.|I hope you really understood.|Hmm. I hope so.}
Remember that Ink does not allow for tags in choice options, therefore the "on/off/yes/no echo" tags are to be applied to the previous line.
-> Flags

= Flag_auto
The "auto" flag controls whether the narrative proceeds automatically as soon as the text has been displayed, or not.
Fungus conversation lines can be typed in gradually, therefore switching this flag on can make sense in some situations.
It can also be useful for some dramatic effect.
As an example, this is what happens with the "auto" flag ON. # yes auto
Oh, yes, it's very dramatic. # yes auto
The longer the line is, the longer it stay on screen. But you must be warned… # yes auto
Beware short lines!  # yes auto
Remember that the speed, style and sound effects of typing can be tweaked in Fungus, altering the properties of the Say Dialog component.
Check Fungus documentation about it.
-> Flags

= Flag_verbatim
The "verbatim" flag is subtle. It's a Latin word meaning "literally".
The "verbatim" flag is connected to the regular expression used to extract the optional speaker's name and portait from each Ink line.
A regular expression (regex) is a complex and powerful entity used in coding to match text strings with predefined patterns. Look it up online.
Mauro?left "We're using a complicated regex to interpret this Ink line. 
Mauro?left "The regex extracts the "Mauro" part (for the character) and the "left" part (for the portrait) and the Gateway acts accordingly.
Mauro?left "For some reason, we may prefer to give up this subsystem entirely and just display each line as it is.
Wauro?right "Why don't we try that right now?
Mauro?left "OK, Wauro.
Mauro?left "We're NOT using the regex to interpret this Ink line. # yes verbatim
Mauro?left "As you can see, we're not using the Gateway syntax to parse this line, only the Ink syntax. # yes verbatim
Mauro?left "This is what happens with the "verbatim" flag ON. # yes verbatim
Mauro?left "And this is what happens with the "verbatim" flag OFF. # no verbatim
You can also modify the regex but that's really for very advanced users of the Gateway.
+	I'm brave. Show me how to change the regex.
	I knew you would ask that. It's a really bad idea. However…
	-> Regex
+	You're giving me headache.
	-> Flags

= Flag_timer
The "timer" flag controls whether there is a maximum time to pick an option when the narrative branches.
The timer is a feature of the Fungus conversation system. Check the Fungus documentation to know more about it.
When "timer" is ON, the user has 5 seconds to pick an option, otherwise the first option in the list will be automatically selected.
Let's learn by example.
This is what happens with the "timer" flag ON. Got it? # yes timer
+	Yeah.
+	Yep.
+	Got it.
- Glad you understood.
And this is what happens with the "hide" flag OFF. Got it? # no timer
+	Oh yes.
+	Definitely.
+	Hell yeah.
- {You are a fast learner.|I hope you really understood.|Hmm. I hope so.}
Remember that Ink does not allow for tags in choice options, therefore the "on/off/yes/no timer" tags are to be applied to the previous line.
The countdown time can be changed in the Advanced Settings area of the Inspector and through the "timer" tag (not flag!).
+	Explain how to change the timer duration.
	-> Choice_time
+ I'm not using it right now.
	-> Flags

= Settings_messages
This area in the Inspector of the Narrative Director component is called "Messages to Fungus for Ink Events". This say it all.
Some Ink events trigger the broadcasting of messages to the Fungus flowcharts. The Gateway handles these communications.
In order to enable the adaptation of an Ink layer to a pre-existing Fungus game prototype, such messages are configurable.
First of all, every message has a universal prefix, "ink" followed by a blank space. This can be modified: it's the Prefix For All Messages.
If you change the prefix, be careful with the blank space. You can remove it if you like, but if you want it to be there, write it in the input field.
You can also remove the prefix altogether. In this case, watch out for colliding messages coming from Fungus itself or some Unity script.
The other properties just list all existing special messages sent by the Gateway and let you change them if you like.
Obviously, your Fungus Flowchart blocks should listen to the right messages if you want your magic to happen.
-> Settings_submenu

= Settings_advanced
{Wauro "Here be lions.|}
Wauro "Which of the obscure configurations in the Advanced Settings area of the Narrative Director component are you interested in?
+	The Dialog Regex.
	-> Regex
+ The Gateway Flowchart.
	-> Gateway_flowchart
+	The Choice Time.
	-> Choice_time
+	Bring me back to the main menu. I'm scared and I feel unwell.
	-> Menu

= Regex
Wauro "You're likely to screw this up if you don't know what a regular expression is.
+	I have no clue.
	Then give up.
	-> Settings_advanced
+	Everybody stand back - I know regular expressions! (This is an xkcd reference.)
- Wauro "OK, well, in this case I can show you what this is for.
Wauro "The Gateway uses this regex to tell apart the optional character and portait parts from the actual text to be displayed in the Say Dialog.
Wauro "This is done through named groups. The main named group is called "text".
Wauro "We also have an optional group named "character" and an even-more-optional group named "portrait".
Wauro?left "This is done with the portait thing, by the way.
Wauro?right "And also this.
Wauro "The regex is so complex because we want to be lenient with the quote signs.
Wauro "This regex allow for quotes to be used in the actual text, "like this", as long as they are properly opened and closed nothing bad happens.
Wauro "There are some limitations in the characters you can use for the speaker label and the portrait tag. Which can be a problem for some.
Wauro "Perhaps you want to come out with a much cooler syntax? OK, try. 
Wauro "As long as there are the grouped names "text", "character" and "portrait", it's fine.
+	Bring me back to the main menu. I'm scared and I feel unwell.
	-> Menu
+ More advanced stuff, please.
	-> Settings_advanced

= Gateway_flowchart
Wauro "You definitely don't need to change this setting.
Wauro "When there are multiple choices, this flowchart is used to handle the player's choice.
Wauro "Basically, what the Gateway does is associating each option with the corresponding block inside a special flowchart.
Wauro "According to the option picked by the player, the new command "Ink/Choose Option" is called with an integer argument.
Wauro "The argument is the option number (starting from 0, of course).
Wauro "I can't imagine of a reasonable purpose for you to delegate this behaviour to another flowchart, but the world is full of suprises.
Mauro "Well, perhaps someone wants to allow for more than just 6 options.
Wauro "Hmm, seems legit but remember that the default Fungus Menu Dialog has 6 options max, too. So that ought to be changed as well.
Mauro "Fair enough. Still, you never kwow what those crazy indie developers might want to do.
Wauro "Or AAA developers. You can make good stuff with the Gateway.
Mauro "Indie stuff is good stuff.
Wauro "Sometimes it is. I concede that.
Mauro "Whatever. Shut up.
-> Settings_advanced

= Choice_time
Wauro "If you know what the "timer" flag is, you must be thrilled to know that you can change the duration of the countdown.
# on timer
Wauro "Basically, when you switch the "timer" flag ON, a countdown starts each time the player must pick an option.
Wauro "Check it out.
+ What?
+ Hm?
+ Got it.
- Wauro "The countdown lasts 5 seconds, but you can change its default duration by modifying the Choice Time property.
Wauro "You can also change the countdown in the Ink script, though.
Wauro "In order to do that, use the special "timer" tag. I'm doing it right now: hash sign, "timer 100". # timer 100
Wauro "Check it out.
+ Oh, I see, I have plenty of time. 
+ I can definitely appreciate how long I can take to pick my option now.
+ It's getting late.
- Wauro "You can also set your timer really fast: hash sign, "timer 2.5". # timer 2.5
Wauro "Check it out.
+ I…
+ Wh…
+ Hey!
- Wauro "You get it.
Wauro "We can switch it off again. # off timer
-> Settings_advanced

= Save_load
In most projects heavily relying on Fungus, implementing a save-and-load system in parallel with Ink is going to be a nightmare.
The Gateway provides some tricks to help the process but please consider this feature as almost experimental and prone to failure.
The Ink-Fungus Gateway allows for saving the Ink state in two different modes: snapshot and checkpoint.
By executing the new command "Ink/Save Snapshot" (which can be done from a Fungus Flowchart block) you save the current state…
…at the moment when the current conversation line was displayed. Subsequent changes in variables (done through Fungus) are not going to be saved.
By invoking another new command, "Ink/Save Checkpoint", you save the story state at the beginning of the current knot and stitch.
This follows two different styles of saving used in many video games, even though it doesn't really allow for moment-to-moment save.
Both save styles ask for a slot name. This is going to be used to form the file names for the save files (each save is several files).
Notice that there is a lot of automatic saving going on, using slots "auto", "precheckpoint" and "checkpoint". Don't call your slots like that.
The default slot name for manual saves is, predictably, "manual". If you just need one slot, use that one.
To load what you saved in a slot, you've got to do the other way round: execute "Ink/Load" with the slot name as an argument.
Messages are broadcast at save and load events, you can check the event section in the basic features part of this interactive documentation.
Obviously you can restrict the saving even more than that, by letting that happen only at some special milestones of your game, like chapters.
Remember that everything Fungus (and even worse, everything Unity out of Fungus) is not going to be magically stored in your Ink save files.
This means that if you save the state of your narrative but not the state of your visuals, including the non-global variables etc., you are doomed.
Wauro "Hope I scared you enough.
-> Advanced_features

= Localization
Localization is complicated. Fungus has its own way of translating text, which is fine but it's not what we're using in the Gateway.
The best way to localize an Ink script is to write another Ink script with the same knots-and-stitches structure, the same variables, the same logic.
The Gateway helps in switching between "twin" Ink scripts in different language, by means of the Alternate Language Narrative Director component.
In interactive narrative, as in narrative in general, there cannot always be a 1-to-1 relationship between translated sentences.
For this reason, the checkpoint logic is applied to language switching in the Gateway.
-> Localization_testable

= Localization_testable
This means that if the player switches to a new language, they have to start from the last checkpoint.
That's why we have the "precheckpoint" save slot: that's where we rewind our story back to, when we switch language.
You can test this by clicking on the alternate-language button right now.
Clicking on the button will execute the new command "Ink/Switch Language" with the "it" (Italian) language tag as argument.
-> Localization_backtoenglish

= Localization_backtoenglish
Back to English now.
"Ink/Switch Language" was executed with an empty argument to restore the original language (in this case, English).
In order to add extra languages to your game, you need to attach one instance of the Alternate Language Narrative Director component per extra language.
The Alternate Language Narrative Director component has two properties: a language tag and the corresponding Ink script.
Be careful in keeping the translated Ink script identical to the original version as far as knots, stitches, variables and logic are concerned.
Also, consider other paths. For example, you may force the player to pick a language at the beginning and then stick with it. Much easier to implement.
-> Advanced_features
