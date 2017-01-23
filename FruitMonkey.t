%Kevin Jin Grid/Animation Program - Fred, the Greatest Fruit-Catching Monkey of All Time. Submitted May 24th, 2015. ADMIN PASSWORD IS "dankmemes".
%-----------------------------------------------------------------------------------------------------------
% Grid Record
%-----------------------------------------------------------------------------------------------------------
type boxData :
record
    xPos : int
    yPos : int
    basketstatus : boolean
    fruit1status : boolean
    fruit2status : boolean
end record

%-----------------------------------------------------------------------------------------------------------
% Highscore Record
%-----------------------------------------------------------------------------------------------------------
type highscore :
record
    name : string
    score : int
end record

%-----------------------------------------------------------------------------------------------------------
% Variable Declaration
%-----------------------------------------------------------------------------------------------------------
setscreen ("graphics:500;540")
var highscores : array 1 .. 11 of highscore 
var f1 : int 
var gold : int := RGB.AddColor (232/256,214/256,16/256)
var silver : int := RGB.AddColor (191/256,190/256,178/256)
var bronze : int := RGB.AddColor (110/256,30/256,30/256)

const BOX_SIZE := 250

%-----------------------------------------------------------------------------------------------------------
% Music
%-----------------------------------------------------------------------------------------------------------
const music : string := "music/music.mp3"
const titlescreenmusic : string := "music/titlescreenmusic.mp3"
const endmusic : string := "music/endmusic.mp3"
const highscoremusic : string := "music/highscoremusic.mp3"

%-----------------------------------------------------------------------------------------------------------
% More Variable Declaration
%-----------------------------------------------------------------------------------------------------------
var box : array 0 .. 10, 0 .. 10 of boxData
for j : 0 .. 10
    for i : 0 .. 10
	box (j, i).xPos := i * 50
	box (j, i).yPos := j * 50
	box (j, i).basketstatus := false
	box (j, i).fruit1status := false
	box (j, i).fruit2status := false
    end for
end for
    
var font1, font2 : int
font1 := Font.New ("Small Fonts:14")
font2 := Font.New ("Small Fonts:26")
var titleID, instructionsID, lvl1ID, lvl2ID, lvl3ID, lvl4ID, lvl5ID, continueID, nameID, endID, highscoreID, adminID : int
titleID := Pic.FileNew ("pictures/titlescreen.bmp")
instructionsID := Pic.FileNew ("pictures/instructions.bmp")
endID := Pic.FileNew ("pictures/gameover.bmp")
lvl1ID := Pic.FileNew ("pictures/level1.bmp")
lvl2ID := Pic.FileNew ("pictures/level2.bmp")
lvl3ID := Pic.FileNew ("pictures/level3.bmp")
lvl4ID := Pic.FileNew ("pictures/level4.bmp")
lvl5ID := Pic.FileNew ("pictures/level5.bmp")
nameID := Pic.FileNew ("pictures/entername.bmp")
continueID := Pic.FileNew ("pictures/continue.bmp")
highscoreID := Pic.FileNew ("pictures/highscoreback.bmp")
adminID := Pic.FileNew ("pictures/admin.bmp")

var column, x, y, button : int := 0
var row : int := 0

var basket : int := Pic.FileNew ("pictures/basket.bmp")
var reverse : int := Pic.FileNew ("pictures/reversebasket.bmp")
var strawberry : int := Pic.FileNew ("pictures/strawberry.bmp")
var orange : int := Pic.FileNew ("pictures/orange.bmp")
var pineapple : int := Pic.FileNew ("pictures/pineapple.bmp")

var basketsprite, reversesprite, strawberrysprite, orangesprite, pineapplesprite : int 
basketsprite := Sprite.New (basket)
reversesprite := Sprite.New (reverse)
strawberrysprite := Sprite.New (strawberry)
orangesprite := Sprite.New (orange)
pineapplesprite := Sprite.New (pineapple)

var chars : array char of boolean
var xPos : int := 200
var facingLeft : boolean := false
var facingRight : boolean := true

var speed : int := 30
var score : int := 0
var fruits : int := -1
var lives : int := 4
var background : int

process PlaySound (file : string)
    Music.PlayFileLoop (file)
end PlaySound

var counter := 0
var a,b : int := 0

%-----------------------------------------------------------------------------------------------------------
% Sorting Procedure for Highscores
%-----------------------------------------------------------------------------------------------------------
proc sort
    for decreasing i : 10 .. 1
	if highscores (11).score > highscores (i).score and highscores (11).score <= highscores (i-1).score then 
	    for decreasing q : 10 .. i 
		highscores (q).score := highscores (q-1).score 
		highscores (q).name := highscores (q-1).name 
	    end for 
		highscores (i).score := highscores (11).score
	    highscores (i).name := highscores (11).name
	    exit
	elsif highscores (11).score > highscores (1).score and i = 2 then 
	    for decreasing q : 10 .. i 
		highscores (q).score := highscores (q-1).score 
		highscores (q).name := highscores (q-1).name 
	    end for 
		highscores (1).score := highscores (11).score 
	    highscores (1).name := highscores (11).name
	    exit
	end if
    end for
end sort

%-----------------------------------------------------------------------------------------------------------
% Drawing the Score on the Screen
%-----------------------------------------------------------------------------------------------------------
proc drawscores
    cls
    Pic.DrawSpecial (highscoreID, 0, 0, picCopy, picFadeIn, 500)
    Font.Draw (highscores (1).name,210,400-35,font1,gold)
    Font.Draw (intstr(highscores (1).score),390,400-(1*35),font1,gold)
    Font.Draw (highscores (2).name,210,400-70,font1,silver)
    Font.Draw (intstr(highscores (2).score),390,400-(2*35),font1,silver)
    Font.Draw (highscores (3).name,210,400-105,font1,bronze)
    Font.Draw (intstr(highscores (3).score),390,400-(3*35),font1,bronze)
    for i : 4 .. 10                     % this loop places data from array
	%put highscores (i).name, "  " ..  % into the screen
	%put highscores (i).score, "  " 
	Font.Draw (highscores (i).name,210,400-(i*35),font1,white)
	Font.Draw (intstr(highscores (i).score),390,400-(i*35),font1,white)
    end for
	for i : 1 .. 9
	Font.Draw (intstr(i),95,400-(i*35),font1,white)
    end for
	Font.Draw (intstr(10),92,400-(10*35),font1,white)
    open : f1, "highscore_data", write        % this loop gets data from data file
    for i : 1 .. 10                     % and places it into the array
	write : f1, highscores (i)
    end for
	close :f1
end drawscores

%-----------------------------------------------------------------------------------------------------------
% Title Screen
%-----------------------------------------------------------------------------------------------------------
var rules : boolean := false
proc titlescreen
    Pic.ScreenLoad ("pictures/titlescreen.bmp", 0, 0, picCopy)
    loop
	mousewhere (x, y, button)
	if button = 1 and x > 56 and x < 154 and y > 156 and y < 194 then
	    exit
	elsif button = 1 and x > 306 and x < 479 and y > 156 and y < 194 then
	    rules := true
	    exit
	end if
    end loop
end titlescreen

%-----------------------------------------------------------------------------------------------------------
% Instructions
%-----------------------------------------------------------------------------------------------------------
proc instructions
    Pic.DrawSpecial (instructionsID, 0, 0, picCopy, picFadeIn, 500)
    loop
	mousewhere (x, y, button)
	if button = 1 and x > 425 and x < 500 and y > 0 and y < 38 then
	    exit
	end if
    end loop
end instructions

%-----------------------------------------------------------------------------------------------------------
% Drawing the Game Background
%-----------------------------------------------------------------------------------------------------------
proc drawbackground
    Pic.Draw(background,0,0,picCopy)
    Font.Draw ("Level: 1",7,510,font1,white)
    Font.Draw ("Score:",170,510,font1,white)
    drawfillbox (230,500,320,540,black)
    Font.Draw (intstr(score),230,510,font1,white)
    Font.Draw ("Lives:",343,510,font1,white)
    for j : 0 .. 10
	for i : 0 .. 10
	    box (j, i).basketstatus := false
	    box (j, i).fruit1status := false
	    box (j, i).fruit2status := false
	end for
    end for
end drawbackground

%-----------------------------------------------------------------------------------------------------------
% Controlling the Monkey
%-----------------------------------------------------------------------------------------------------------
proc controls
    Input.KeyDown (chars)
    if chars (KEY_RIGHT_ARROW) and xPos <= 350 then
	facingLeft := true
	facingRight := false
	Sprite.Hide (reversesprite)
	xPos += 50
	Sprite.SetPosition (basketsprite,xPos,0,false)
	Sprite.Show (basketsprite)  
    elsif chars (KEY_LEFT_ARROW) and xPos >= 50 then
	facingLeft := false
	facingRight := true
	Sprite.Hide (basketsprite)
	xPos -= 50
	Sprite.SetPosition (reversesprite,xPos,0,false)
	Sprite.Show (reversesprite)
	%elsif chars ('n') then
	%for j : 0 .. 10
	%for i : 0 .. 10
	%box (j, i).xPos := i * 50
	%box (j, i).yPos := j * 50
	%drawbox (box (j, i).xPos , box (j, i).yPos, BOX_SIZE, BOX_SIZE, white)
	%end for
	    %end for
	    %elsif chars ('m') then
	%score += 1
	%fruits += 1
	%elsif chars ('b') then
	%lives := 0
    end if
    if facingLeft then
	box ((xPos div 50) + 1, 2).basketstatus := true 
    else
	box ((xPos div 50) + 2, 2).basketstatus := true 
    end if
end controls

%-----------------------------------------------------------------------------------------------------------
% Showing Score After Each Level
%-----------------------------------------------------------------------------------------------------------
procedure scorescreen
    drawfillbox (0,0,maxx,maxy,black)
    Font.Draw ("Your Score:", 155,360, font2, white)
    var width : int
    for i : 0 .. score
	width := Font.Width (intstr(score), font2)
	drawfillbox (140,240,380,340,black)
	Font.Draw (intstr(i), round (maxx / 2 - width / 2),290, font2, white)
	View.Update
	Time.DelaySinceLast (2500 div (score+1))
    end for
	if lives = 3 then
	score += 5
	delay (1000)
	drawfillbox (60,100,450,340,black)
	Font.Draw (intstr(score), round (maxx / 2 - width / 2),290, font2, white)
	Font.Draw ("Perfect Round! +5 Bonus Points.", 120,225, font1, white)
	delay (1000)
    end if
    setscreen ("nooffscreenonly")
    Pic.DrawSpecial (continueID, 0, 120, picMerge, picFadeIn, 500)
    setscreen ("offscreenonly")
    loop
	mousewhere (x,y,button)
	if button = 1 and x >= 55 and x <= 264 and y >= 125 and y <= 170 then
	    cls
	    exit
	elsif button = 1 and x >= 300 and x <= 432 and y >= 125 and y <= 170 then
	    cls
	    lives := 0
	    exit
	end if
    end loop
end scorescreen

%-----------------------------------------------------------------------------------------------------------
% Level 1
%-----------------------------------------------------------------------------------------------------------
proc lvl1
    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
    background := Pic.FileNew ("pictures/background.bmp")
    setscreen ("nooffscreenonly")
    Pic.DrawSpecial (lvl1ID, 17, 250, picMerge, picFadeIn, 2500)
    setscreen ("offscreenonly")
    fork PlaySound (music)
    loop   
	if fruits >= 25 then
	    exit
	end if
	var caught : boolean := false
	%Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	drawbackground
	Font.Draw ("Level: 1",7,510,font1,white)
	if lives = 2 then
	    drawfillbox (460,500,500,540,black)
	elsif lives = 1 then
	    drawfillbox (430,500,500,540,black)
	elsif lives = 0 then
	    drawfillbox (400,500,500,540,black)
	    exit
	end if
	
	controls
	
	Sprite.Show (strawberrysprite)
	Sprite.SetPosition (strawberrysprite, (row-1)*50+10, counter, false)
	
	counter -= speed
	box (row, counter div 50 + 1).fruit1status := true 
	for i : 2 .. 9
	    if box (i,2).basketstatus = true and box (i,1).fruit1status = true then  
		caught := true
		Sprite.Hide(strawberrysprite)
		counter -= 40
		score += 1  
		fruits += 1
	    end if
	end for
	    
	if caught = false and counter <= 0 then
	    lives -= 1
	    fruits += 1
	    Pic.ScreenLoad ("pictures/strawberrybroke.bmp",(row-1)*50 + 10,0,picMerge)
	    background := Pic.New(0,0,maxx,maxy)
	end if
	
	if counter < 0 then 
	    %randint (speed,10,60)
	    randint (row,2,9)
	    counter := 470
	end if
	
	View.UpdateArea (0, 0, maxx, maxy)
	Time.DelaySinceLast (100)
	%cls
    end loop
end lvl1

%-----------------------------------------------------------------------------------------------------------
% Level 2
%-----------------------------------------------------------------------------------------------------------
proc lvl2
    Sprite.Hide (strawberrysprite)
    if lives not= 0 then
	scorescreen
	if lives not= 0 then
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	    setscreen ("nooffscreenonly")
	    Pic.DrawSpecial (lvl2ID, 70, 250, picMerge, picFadeIn, 2500)
	    setscreen ("offscreenonly")  
	end if 
    end if
    counter := 500
    if lives not= 0 then
	speed := 40
	lives := 3
	loop   
	    if fruits >= 50 then
		delay (1000)
		exit 
	    end if
	    var caught : boolean := false
	    if counter = 25 then
		Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
		background := Pic.New(0,0,maxx,maxy)
	    end if
	    drawbackground
	    drawfillbox (0,500,150,540,black)
	    Font.Draw ("Level: 2",7,510,font1,white)
	    if lives = 2 then
		drawfillbox (460,500,500,540,black)
	    elsif lives = 1 then
		drawfillbox (430,500,500,540,black)
	    elsif lives = 0 then
		drawfillbox (400,500,500,540,black)
		exit
	    end if
	    
	    controls
	    
	    Sprite.Show (orangesprite)
	    Sprite.SetPosition (orangesprite, (row-1)*50+10, counter, false)
	    
	    counter -= speed
	    box (row, counter div 50 + 1).fruit1status := true 
	    for i : 2 .. 9
		if box (i,2).basketstatus = true and box (i,1).fruit1status = true then  
		    caught := true
		    Sprite.Hide(orangesprite)
		    counter -= 40
		    score += 1  
		    fruits += 1
		end if
	    end for
		
	    if caught = false and counter <= 0 then
		lives -= 1
		fruits += 1
		Pic.ScreenLoad ("pictures/orangebroke.bmp",(row-1)*50 + 10,0,picMerge)
		background := Pic.New(0,0,maxx,maxy)
	    end if
	    
	    if counter < 0 then 
		%randint (speed,10,60)
		randint (row,2,9)
		counter := 470
	    end if
	    
	    View.UpdateArea (0, 0, maxx, maxy)
	    Time.DelaySinceLast (100)
	end loop
    end if
end lvl2

%-----------------------------------------------------------------------------------------------------------
% Level 3
%-----------------------------------------------------------------------------------------------------------
proc lvl3
    Sprite.Hide (orangesprite)
    if lives not= 0 then
	scorescreen
	if lives not= 0 then
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	    setscreen ("nooffscreenonly")
	    Pic.DrawSpecial (lvl3ID, 40, 250, picMerge, picFadeIn, 2500)
	    setscreen ("offscreenonly")
	end if
    end if
    
    var banana : int := Pic.FileNew ("pictures/banana.bmp")
    var bananaY, bananaspeed, bananarow, bananasprite: array 1..2 of int 
    if lives not= 0 then
	lives := 3
	for i : 1.. 2
	    bananaY (i) := 470
	    bananaspeed(1):= 10
	    bananaspeed(2):= 15
	    bananarow(i):= Rand.Int(2,9)
	    bananasprite (i) := Sprite.New (banana)
	    Sprite.Show (bananasprite (i))
	end for
	    var bananacaught: array 1..2 of boolean
	for i:1..2
	    bananacaught(i):= false
	end for   
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	background := Pic.FileNew ("pictures/background.bmp")
	loop
	    if fruits >= 75 then
		delay (1000)
		exit 
	    end if
	    var caught : boolean := false
	    if counter = 25 then
		Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
		background := Pic.FileNew ("pictures/background.bmp")
	    end if
	    drawbackground
	    drawfillbox (0,500,150,540,black)
	    Font.Draw ("Level: 3",7,510,font1,white)
	    if lives = 2 then
		drawfillbox (460,500,500,540,black)
	    elsif lives = 1 then
		drawfillbox (430,500,500,540,black)
	    elsif lives = 0 then
		drawfillbox (400,500,500,540,black)
		exit
	    end if
	    controls
	    for i:1..2
		Sprite.Show (bananasprite (i))
		Sprite.SetPosition(bananasprite(i),  (bananarow(i)-1)*50+10, bananaY(i), false)
		if bananaY(i) <= 0 then
		    bananacaught(i) := false
		    bananarow(i) := Rand.Int(2,9)
		    bananaspeed(i) := Rand.Int(10,15)
		    bananaY(i) := 470
		else
		    bananaY(i)-=bananaspeed(i)
		    if i = 1 then
			box (bananarow(i), bananaY(i) div 50 + 1).fruit1status := true
		    elsif i = 2 then 
			box (bananarow(i), bananaY(i) div 50 + 1).fruit2status := true
		    end if
		end if
		for j : 2 .. 9
		    if box (j,2).basketstatus = true and box (j,1).fruit1status = true then  
			bananacaught(1) := true
			Sprite.Hide(bananasprite(1))
			bananaY(1) -= 70 
		    elsif box (j,2).basketstatus = true and box (j,1).fruit2status = true then  
			bananacaught(2) := true
			Sprite.Hide(bananasprite(2))
			bananaY(2) -= 70
		    end if
		end for
		    if bananacaught(i) then
		    score += 1
		    fruits += 1
		end if
		if bananacaught(i) = false and bananaY(i) <= 0 then
		    lives -= 1
		    fruits += 1
		    Pic.ScreenLoad ("pictures/bananabroke.bmp",(bananarow(i)-1)*50 + 10,0,picMerge)
		    background := Pic.New(0,0,maxx,maxy)
		end if  
	    end for
		View.UpdateArea (0, 0, maxx, maxy)
	    Time.DelaySinceLast (100)
	end loop
	for i : 1 .. 2
	    Sprite.Hide (bananasprite(i))
	end for
    end if
end lvl3

%-----------------------------------------------------------------------------------------------------------
% Level 4
%-----------------------------------------------------------------------------------------------------------
proc lvl4
    if lives not= 0 then
	scorescreen
	if lives not= 0 then
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	    setscreen ("nooffscreenonly")
	    Pic.DrawSpecial (lvl4ID, 45, 250, picMerge, picFadeIn, 2500)
	    setscreen ("offscreenonly")
	end if
    end if
    var pear : int := Pic.FileNew ("pictures/pear.bmp")
    var pearY, pearspeed, pearrow, pearsprite: array 1..2 of int 
    if lives not= 0 then
	lives := 3
	for i : 1.. 2
	    pearY (i) := 470
	    pearspeed(1):= 15
	    pearspeed(2):= 23
	    pearrow(i):= Rand.Int(2,9)
	    pearsprite (i) := Sprite.New (pear)
	    Sprite.Show (pearsprite (i))
	end for
	    var pearcaught: array 1..2 of boolean
	for i:1..2
	    pearcaught(i):= false
	end for   
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	background := Pic.FileNew ("pictures/background.bmp")
	loop
	    if fruits >= 100 then
		delay (1000)
		exit 
	    end if
	    var caught : boolean := false
	    if counter = 25 then
		Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
		background := Pic.FileNew ("pictures/background.bmp")
	    end if
	    drawbackground
	    drawfillbox (0,500,150,540,black)
	    Font.Draw ("Level: 3",7,510,font1,white)
	    if lives = 2 then
		drawfillbox (460,500,500,540,black)
	    elsif lives = 1 then
		drawfillbox (430,500,500,540,black)
	    elsif lives = 0 then
		drawfillbox (400,500,500,540,black)
		exit
	    end if
	    controls
	    for i:1..2
		Sprite.Show (pearsprite (i))
		Sprite.SetPosition(pearsprite(i),  (pearrow(i)-1)*50+10, pearY(i), false)
		if pearY(i) <= 0 then
		    pearcaught(i) := false
		    pearrow(i) := Rand.Int(2,9)
		    pearspeed(i) := Rand.Int(20,25)
		    pearY(i) := 470
		else
		    pearY(i)-=pearspeed(i)
		    if i = 1 then
			box (pearrow(i), pearY(i) div 50 + 1).fruit1status := true
		    elsif i = 2 then 
			box (pearrow(i), pearY(i) div 50 + 1).fruit2status := true
		    end if
		end if
		for j : 2 .. 9
		    if box (j,2).basketstatus = true and box (j,1).fruit1status = true then  
			pearcaught(1) := true
			Sprite.Hide(pearsprite(1))
			pearY(1) -= 70 
		    elsif box (j,2).basketstatus = true and box (j,1).fruit2status = true then  
			pearcaught(2) := true
			Sprite.Hide(pearsprite(2))
			pearY(2) -= 70
		    end if
		end for
		    if pearcaught(i) then
		    score += 1
		    fruits += 1
		end if
		if pearcaught(i) = false and pearY(i) <= 0 then
		    lives -= 1
		    fruits += 1
		    Pic.ScreenLoad ("pictures/pearbroke.bmp",(pearrow(i)-1)*50 + 10,0,picMerge)
		    background := Pic.New(0,0,maxx,maxy)
		end if  
	    end for
		View.UpdateArea (0, 0, maxx, maxy)
	    Time.DelaySinceLast (100)
	end loop
	for i : 1 .. 2
	    Sprite.Hide (pearsprite(i))
	end for
    end if
end lvl4

%-----------------------------------------------------------------------------------------------------------
% Level 5
%-----------------------------------------------------------------------------------------------------------
proc lvl5
    if lives not= 0 then
	scorescreen
	if lives not= 0 then
	    Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
	    setscreen ("nooffscreenonly")
	    Pic.DrawSpecial (lvl5ID, 98, 250, picMerge, picFadeIn, 2500)
	    setscreen ("offscreenonly")  
	end if 
    end if
    if lives not= 0 then
	speed := 25
	lives := 3
	loop   
	    var caught : boolean := false
	    if counter = 25 then
		Pic.ScreenLoad ("pictures/background.bmp",0,0,picCopy)
		background := Pic.New(0,0,maxx,maxy)
	    end if
	    drawbackground
	    drawfillbox (0,500,150,540,black)
	    Font.Draw ("Level: 2",7,510,font1,white)
	    if lives = 2 then
		drawfillbox (460,500,500,540,black)
	    elsif lives = 1 then
		drawfillbox (430,500,500,540,black)
	    elsif lives = 0 then
		drawfillbox (400,500,500,540,black)
		exit
	    end if
	    
	    controls
	    
	    Sprite.Show (pineapplesprite)
	    Sprite.SetPosition (pineapplesprite, (row-1)*50+10, counter, false)
	    
	    counter -= speed
	    box (row, counter div 50 + 1).fruit1status := true 
	    for i : 2 .. 9
		if box (i,2).basketstatus = true and box (i,1).fruit1status = true then  
		    caught := true
		    Sprite.Hide(pineapplesprite)
		    counter -= 40
		    score += 1  
		    fruits += 1
		    speed += 1
		end if
	    end for
		
	    if caught = false and counter <= 0 then
		lives -= 1
		fruits += 1
		speed -= 1
		Pic.ScreenLoad ("pictures/pineapplebroke.bmp",(row-1)*50 + 10,0,picMerge)
		background := Pic.New(0,0,maxx,maxy)
	    end if
	    
	    if counter < 0 then 
		randint (row,2,9)
		counter := 470
	    end if
	    
	    View.UpdateArea (0, 0, maxx, maxy)
	    Time.DelaySinceLast (80)
	end loop
    end if
end lvl5

%-----------------------------------------------------------------------------------------------------------
% Running the Actual Game
%-----------------------------------------------------------------------------------------------------------
loop
    fork PlaySound (titlescreenmusic)
    titlescreen
    if rules then
	instructions
    end if
    Music.PlayFileStop
    setscreen ("offscreenonly")
    Sprite.SetPosition (reversesprite,xPos,0,false)
    Sprite.Show (reversesprite)
    lvl1
    lvl2
    lvl3
    lvl4
    lvl5
    
%-----------------------------------------------------------------------------------------------------------
% Game Over
%-----------------------------------------------------------------------------------------------------------
    Sprite.Hide (pineapplesprite)
    Sprite.Hide (basketsprite)
    Sprite.Hide (reversesprite)
    setscreen ("nooffscreenonly")
    
    fork PlaySound (endmusic)
    setscreen ("nooffscreenonly")
    Pic.DrawSpecial (endID, 0, 0, picCopy, picFadeIn, 2500)
    var width : int
    for i : 0 .. score
	width := Font.Width (intstr(score), font2)
	drawfillbox (294,204,500,284,black)
	Font.Draw (intstr(i), round (maxx / 2 - width / 2)+123,250, font2, white)
	View.Update
	Time.DelaySinceLast (2500 div (score+1))
    end for
	Pic.DrawSpecial (nameID, 155, 460, picCopy, picFadeIn, 500)
    
%-----------------------------------------------------------------------------------------------------------
% Highscores
%-----------------------------------------------------------------------------------------------------------
    open : f1, "highscore_data", read    
    for i : 1 .. 10                    
	read : f1, highscores (i)
    end for
	close :f1
    Text.LocateXY (179,480)
    get highscores (11).name :*
    if length (highscores (11).name) > 11 then
	Pic.ScreenLoad ("pictures/invalid.bmp",167,473,picCopy)
	delay (500)
	drawfillbox (167,473,326,494,white)
	loop
	    Text.LocateXY (179,480)
	    get highscores (11).name :*
	    if length (highscores (11).name) <= 11 then
		exit
	    else
		Pic.ScreenLoad ("pictures/invalid.bmp",167,473,picCopy)
		delay (500)
		drawfillbox (167,473,326,494,white)
	    end if
	end loop
    end if
    highscores (11).score := score
    sort
    if highscores (11).score > highscores (10).score then
	fork PlaySound (highscoremusic)
	Font.Draw ("YOU GOT A HIGHSCORE!",264,200,font1,white)
    end if
    var showscore, finished : boolean := false
    var password : string
    loop
	mousewhere (x,y,button)
	if button = 1 and x >= 114 and x <= 400 and y >= 100 and y <= 140 then
	    showscore := true
	    drawscores
	    loop
		mousewhere (x,y,button)
		if button = 1 and x >= 0 and x <= 72 and y >= 507 and y <= 540 then
		    Pic.ScreenLoad ("pictures/password.bmp",110,496,picCopy)
		    Text.LocateXY (250,520)
		    get password 
		    drawfillbox (105,490,366,540,black)
		    if password = "dankmemes" then
			
%-----------------------------------------------------------------------------------------------------------
% Admin Mode - Password: "dankmemes"
%-----------------------------------------------------------------------------------------------------------
			Pic.DrawSpecial (adminID, 110, -3, picCopy, picFadeIn, 500)
			loop
			    mousewhere (x,y,button)
			    if button = 1 and x >= 158 and x <= 235 and y >= 10 and y <= 62 then
				Pic.ScreenLoad ("pictures/adminchange.bmp", 110, -3, picCopy)
				Text.LocateXY (280,50)
				get highscores (11).name
				Text.LocateXY (280,20)
				get highscores (11).score 
				sort
				exit
			    elsif button = 1 and x >= 270 and x <= 346 and y >= 10 and y <= 62 then
				for i : 1 .. 10                   
				    highscores (i).name := "N/A"   
				    highscores (i).score := 0
				end for 
				    open : f1, "highscore_data", write      
				for i : 1 .. 10
				    write : f1, highscores (i)
				end for
				    close :f1
				exit
			    end if
			end loop
			drawscores
		    end if
		elsif button = 1 and x >= 374 and x <= 500 and y >= 509 and y <= 540 then
		    score := 0
		    lives := 3
		    fruits := 0
		    xPos := 200
		    rules := false
		    facingLeft := false
		    facingRight := true
		    exit
		end if
	    end loop
	    exit 
	    
%-----------------------------------------------------------------------------------------------------------
% Play Again
%-----------------------------------------------------------------------------------------------------------
	elsif button = 1 and x >= 54 and x <= 246 and y >= 42 and y <= 78 then
	    score := 0
	    lives := 3
	    fruits := 0
	    xPos := 200
	    rules := false
	    facingLeft := false
	    facingRight := true
	    exit
	    
%-----------------------------------------------------------------------------------------------------------
% Quit
%-----------------------------------------------------------------------------------------------------------
	elsif button = 1 and x >= 348 and x <= 426 and y >= 42 and y <= 78 then
	    finished := true
	    exit
	end if
    end loop
    if finished then
	exit
    end if
end loop
cls
return
