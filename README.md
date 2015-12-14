Who Says?

Group Members:

      Pablo Javier García Martín, 150298
	Marta Madrid Sánchez, 150300
	Miren Irene Sainz Palomeque, 150299
URL of the group project repository:

	http://github.com/pabgarci/WhoSays
        https://play.google.com/store/apps/details?id=es.pabgarci.whosays
        http://www.pabgarci.es/project/whosays/dl/WhoSays-win32.zip

Description of the App:

	Simon Says is a memory game for android devices. In order to play you need to remember the sequence of colours showed to you and repeat it. The sequence will grow in each round as you succed.
The game consists in three different worlds, with different difficulties. The first wolrd only has 2 different colours for the sequence, the second one has 4, and the third one has 6. In addition to that, each world has a different number of levels. The difficulty of each level consist in the number of sequencies you need to get right to pass it.
There is an established  time for each level, and according to that you get a different number of stars depending on how successful you were on the level. If you pass the level in less time than 60% of the time limit you get 3 stars. If you take from 60% to 100% of the time you get 2 stars and if you take more that the time limit you still go to next level but you only get 1 star.
Simon Says is integrated to Google Play Services (Google Play Games) so you can link the game with your account and keep track of your achievements. It is also integrated to Facebook to share your results with your friends.
App Development:

	The game is programmed in Lua, using Corona SDK. Before this lecture, we didn’t know anything about game programming or this language, but we had the proposal to develop a game using this language and this tool, so we started learning them from scratch. 

Planning the game

	After discussing different possibilities in which we could arrange the levels and the difficulty of the game, we agreed to create three worlds with different number of levels: 
       - World 1: Two colours and six levels.
	- World 2: Four colours and twelve levels.
       - World 2: Six colours and eighteen levels.
For the score you get in each level, we decided to give from one to three stars, depending on the time you take to complete successfully the level:
       - One star: if the player completes the level.
	- Two stars: if the player completes the level from 60 to 100% of the estimated time for this level.
       - Three stars: if the player completes the level in less than 60% of the estimated time for this level.
The estimated time for each level is calculated following the next formula:

Programming the game

Game basics

       The game consists of nine programming .lua files and the build.settings file:
       - main.lua: sets the locale for localization. Initializes data bases. Runs unit tests. Calls the composer to load the menu.
	- menu.lua: connects and logs in with Google Play Game Services. If the log in is successful shows the player’s alias registered in GPGS. Plays the theme song of the game. Shows the name of the game, the different buttons (start/continue, levels, achievements) and checkboxes for turning on/off sound and vibration during the game.
       - game.lua: logs in with Facebook. Shows 2/4/6 rectangles – newRoundedRect - (depending on the world), texts indicating the level you are in, the number of sequences you need to do, and the total number of sequences to complete the level. All the game code is here (workflow explained later).
       - worlds.lua: buttons to select the three worlds.
       - levels.lua: level selection. All unpassed levels are blocked.
       - common.lua: contains all the functions that are used in more than one file, such as back, keys or data base functions.
       - config.lua: basic configuration for Corona SDK. For example weight, height, scale of the content and fps of the game.
       -unitTest.lua: some basic “unit test” functionalities.

Corona SDK basics

	The basic libraries we need to know about Corona SDK is “composer”. The “composer” library is the official scene creation and management in Corona SDK. This library provides us and easy way to create and transition between scenes. Each scene needs its own lua file. At the beginning of each lua file you have to load the composer library through the “require” function.

There are four different scene events:
	- scene:create(): code inside this function will be executed just once. If you re show the scene without destroying it before this code won’t be executed.
	- scene:show(): there are two different phases (“will” and “did”). Code inside this function will be executed every time the scene is shown. The “will” phase occurs just before the scene comes on screen. “Did” occurs when the scene is fully on screen.
	- scene:hide(): this function is triggered twice each time the scene is hidden. It can have “will” and “did” phases.
	- scene:destroy(): this function is where composer cleans up the scenes display objects.
You have to insert the objects into a specific self.view for each scene for them to be destroyed or hidden in the functions mentioned above.
For changing scenes in Corona SDK you just have to use the “gotoScene” function. You can add some effects to the transition aswell. We used this code for all the scenes in our game.

You can add variables when you want to change the scene so you can get them in the next scene later. Example in the code box.

Workflow

	First of all, when the game starts, it gets the values of the sound and vibatrion settings from the data base.
Then, it checks if you come from a selected level or directly from the menu. If it’s from the selection of levels, it takes the level and the world the user chose through the composer. 
If the player comes from the menu the game will check on the data base the level in which the player was the last time he/she played, and load it.
The game begins showing one random sequence, which the player needs to repeat in order to add a new random value to the current sequence, each level determins how long the sequence needs to be in order to pass it successfully. If the player fails the sequence and taps to continue, the level will reload again from the beginning.
If the player passes the level, a message will be shown in the screen giving the option to share his/her results on Facebook, and continue or just continue without sharing. If you complete one world, it goes automatically to the first level of next world.
Touch listener

	As any other programming language, listeners are used to know when the user touched the screen. You have to set them on a specific object. There are also different phases for touch detection (“began”, “moved”, “ended”, “cancelled”).


Data base

	We worked with SQLite 3 for the data base. We arranged three tables in our db:
	- “data”: it has an id (integer primary key) and “info” column. In this table we store the current user level of each world, plus sound and vibration settings (on – 1 - / off -0 -).
idinfoCurrent level world 11valueCurrent level world 22ValueCurrent level world 33ValueSound setting4Value (0/1)Vibration setting5Value (0/1)
	- “world1”: it stores the stars the user got in each level of this world.
idstarsStars level 11Value (1-3)Stars level 22Value (1-3)* it continues until it reaches the total amount of current world’s levels.
	- “world2”: it stores the stars the user got in each level of this world.
	- “world3”: it stores the stars the user got in each level of this world.
We have “set/getSound()”,“set/getVibrate()”,“set/getCurrentLevel()”,“set/getStars()” to manage the data base (normal SQLite queries)
We also have functions to create, if it does not exist, the data base and tables and to initialize them.
Screen Adaptability

       Due to the variety of screen densities in the Android world we need to use scalable measures in order to maintain the same aspect relation between the objects despite the screen size. We took as reference measures the content width and height for all our objects.
       
Back functionality

	The main back function is in the common.lua file. We have an array where we store the information of the scene where we came from and provide the one of the scene we are supposed to go to as a parameter in order to call the back function.
When we come from the menu scene the back function calls “os.exit()” and exit the game.
We call this function from all the lua files no matter if we call it from the physical back button of the device, or the back button we created on the screen.

Localization

	As Corona SDK doesn’t provide us with a native functionality to localize an app we had to look through the internet to find a way to do it.
We used part of a mod and we modified it to adapt it to our code. 
The localization functionality is located in the mod_localize.lua file. Here we have a function to set the locale to a specific language. We call this function in “main” file after taking the phone locale.

Translations are located in txt files in this folder: “/lang/*.txt”. For simplicity we only used one translation file for each language.
When we want to access to a translated word we have to write “_s(“word_label”)”.
Default locale is set to English (en), but the game offers translation to Spanish (es), Norwegian (no), German (de) and Portuguese (pt).

Sound and Vibration 

	Corona SDK has its own functionalities for sound and vibration management, but as always as you want to develop for android you need to ask for the permissions to use them. In this case we had to ask for the vibrate permission (“android.permission.VIBRATE”).
There are 32 audio channels available in Corona SDK. Each sound effect must play on a distinct channel in order to manage each sound separately, for example the volume.
Facebook integration

	For the integration with Facebook, first of all you have to register as a developer, and register your app. Facebook asks you for the package name, in this case “es.pabgarci.WhoSays”. In Facebook developer page you need to enter the class name in which you are calling the functionality to access facebook, but as we are using Corona SDK we have to enter the default Corona class name (“com.ansca.corona.CoronaActivity”).
You need to enter the keyhash obtained from the certificate that you are using to sign the app (we obtained it using the keytool of the Java Development Kit).
In order to sign in with Facebook in your app you need to have the app id, which Facebook provides you with. 

In our app, we use Facebook functionality to share the result of the user. When you finish a level, or a world, you can see your star result and decide to share your level, world and stars with your friends in Facebook. In your profile will appear your comment and a predefined message saying the level or world you passed and the stars you got.

If you click this message it’ll redirect you to a webpage we’ve created for the game. There you can link to the app in the Play Store or download the Desktop version of the game (for Windows)

Google Play Game Services
Our game is linked with Google Play Game Services in order to improve the game experience. With this integration, players can goal some achievements and see the progress of their friends in the Google Play Games app.
In order to make public the game and allow everyone to login in our game we had to sign the apk with a release key (explained more carefully some lines below in the certificate section). For that purpose we made a certificate with keytool (JDK tool). Now with the SHA1 we can register our package with Google. 


For the game we registered 5 achievements:
- First level
- Your first three stars
- First world
- Second world
- Third world
For each achievement Google gives us an identifier so when the player gets a new achievement done we call this function:
Google Play shows the notification automatically each time you succeed in an achievement.
In the menu you can find the achievement button, which shows you your achievements in the game.

Unit tests

	We could find a plugin that helped us with the unit tests in lua (lunatest).
In unitTest.lua can be found all the different tests we have for the game.
- test_getLevel(), where it’s checked if the data base is working as expected through an assert function (assert_not_equal and assert_number). 
- test_imageFiles(), it’s checked if the image files are correctly loaded.
- test_soundFiles(), it’s checked if the sound files are correctly loaded.
- test_sound(), checks the sound setting value in the data base.
- test_vibrate(),checks the vibration setting value in the data base.
You can see the tests results in the console if you write

Windows Desktop version

	Corona SDK provides us with the tools to build the app for Windows Desktop as well as Android we decided to adapt the content for Windows displays and build both versions ( apk and exe). 
In some scenes we had to create a function to check if we are in Windows or Android so we can adapt the content to both displays ( in Windows we use a variable called “valWin”).
Difficulties encountered while developing the App

One problem we had using Corona was the display settings it uses. It divides the screen in three parts: the toolbar space, the content space, and the buttons space. And we had to play with them in order to display correctly the aspect of the game.
Testing and user feedback

We carried on playtesting on four of our friends. We installed the game in their android phone and asked them to play with the game and to correct the translation mistakes with their own device, as they will do if they actually downloaded it from Google Play. 

We wanted to get as much feedback as possible, not only after they have played the game but also during the interaction, as it is when you can get more essential information of every detail. 

This is why we carried out the Think Aloud protocol. What this protocol does is that the user interacting with our game will speak out everything that comes into his/her mind when playing with our game. We also asked them to write a small paragraph after their experience. From two of them we got some written feedback:

Feedback 1:
       "The game is easy to learn and very intuitive to use, although it is based on the original game Simon Says in this game there are different worlds where the number of buttons varies, which makes the game more interesting and challenging. I thought that the begging was a bit boring because it was too long, as there were only two bottons it was pretty easy and the world one might be too long".
       

Feedback 2:
       "It is a nice looking game and the music is very original, although it can get a bit repetitive, so I found the button that could stop the music and vibration very interesting for some people that might don't like the sound effects. The rules of the game are very easy to understand, but it also might be because it is based on a very popular game. I also liked the fact that not only it gets faster, but you also get more buttons so that makes it more challenging. Another factor that is different from the original popular game is that this one has levels, and you get a ranking for each level, while in the original game I think there is only one infinite level."

App publishment – release build

	We signed the apk with the release key because we needed it for the Google Play Game Services. Signing the apk with the debug key implies not being able to use the GPGS with another Google account apart from the developer who added the achievements.
The Facebook functionalities are linked to the developer’s certificate too through the certificate’s hash.
For compiling the app you need to use Corona SDK. If you sign the app with the debug certificate, or with your own certificate you won’t be able to use the GPGS and Facebook Services. Anyway the game is completely usable without it.
