module Main exposing (..)
import Playground exposing (..)


-- TYPE´S 
type alias Barril =
  { x : Float
  , y : Float
  , zigzag : Bool
  , vx : Float
  , jump : Float
  }

type alias Coin = 
  { x : Float
  , y : Float
  , img : String
  , points : Float
  }

type alias Hammer = 
  { x : Float
  , y : Float
  , img : String
  , points : Float
  }

-- OBJECT´S

donkey_kong = {width = 120, height = 120}
princess = {width = 44, height = 60, x = -526 , y = (suelo.height * 2)+(stair1.height*3.5)}
plataforma = {width = 100 , height = 100, x= -526, y= (suelo.height * 2)+(stair1.height*3.05)}
suelo = {width = 1350, height = 40}
trash = {width = 80, height = 120}
stair1 = {width = 70, height = 180, x = -70, y = 110 }
stair2 = {width = stair1.width, height = stair1.height, x = ((midTam stair1.width)*10), y= stair1.y}
stair3 = {width = stair1.width, height = stair1.height, x = -350, y = (stair1.y * 2.5)}
stair4 = {width = stair1.width, height = stair1.height, x = (stair3.x + (midTam stair1.width)*10), y = stair3.y}
stair5 = {width = stair1.width, height = stair1.height, x = 100, y = (stair1.y * 4)}
stair6 = {width = stair1.width, height = stair1.height, x = (stair5.x + (midTam stair1.width)*10) , y = stair5.y}
barrel = Barril -610 3 True 9 0
barrel2 = Barril -610 3 True 12 0
hammer = Hammer -200 140 "images/objetos/martillo/martillo.gif" 20
coin1 = Coin 600 140 "images/objetos/coin/coin.gif" 100
coin2 = Coin -610 320 "images/objetos/coin/coin.gif" 100
coin3 = Coin 600 520 "images/objetos/coin/coin.gif" 100

-- FUN´S GENERAL
boolToString : Bool -> String
boolToString bool = if bool then "True" else "False" 

midTam : Float -> Float
midTam x = (x/2)
-- MAIN
main =
  game view update
    { x = 0
    , y = 0
    , vx = 0
    , vy = 0
    , dir = "right"
    , power = False
    , bonus = False
    , rise = False
    , bar = barrel
    , bar2 = barrel2
    , c1 = coin1
    , c2 = coin2
    , c3 = coin3 
    , ham = hammer
    , hamTime = 0
    , oscilaciones = 0
    , score = 0
    , hammerPoints = 0
    , destroyBarrel = 0
    , coinPoints = 0
    , die = False
    , win = False
    }

-- VIEW
view computer mario =
  let
    w = computer.screen.width
    h = computer.screen.height
    b = computer.screen.bottom
  in
  [rectangle (blue) w h
  , rectangle (black) (suelo.width+20) h
  , image w suelo.height "images/fondo/suelo.gif"
      |> moveY (b+(midTam suelo.height))
  , image w suelo.height "images/fondo/suelo2.gif"
      |> moveY (b+(midTam suelo.height)+stair1.height)
  , image w suelo.height "images/fondo/suelo3.gif"
      |> moveY (b+(midTam suelo.height)+(stair1.height*2))
  , image w suelo.height "images/fondo/suelo2.gif"
      |> moveY (b+(midTam suelo.height)+(stair1.height*3))
  , image stair1.width stair1.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(midTam stair1.height)+ suelo.height)
      |> moveX stair1.x
  , image stair2.width stair2.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(midTam stair2.height)+ suelo.height)
      |> moveX stair2.x
  , image stair3.width stair3.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(stair3.height*1.5)+ suelo.height)
      |> moveX stair3.x
  , image stair4.width stair4.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(stair4.height*1.5)+ suelo.height)
      |> moveX stair4.x
  , image stair5.width stair5.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(stair5.height*2.5)+ suelo.height)
      |> moveX stair5.x
  , image stair6.width stair6.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(stair6.height*2.5)+ suelo.height)
      |> moveX stair6.x
  , image 40 40 "images/barrel/move.gif"
      |> move (gameOver_ mario.die mario.win mario.bar.x) (gameOver_ mario.die mario.win (barrelY b mario.bar.y))
  , image 40 40 "images/barrel/move.gif"
      |> move (gameOver_ mario.die mario.win mario.bar2.x) (gameOver_ mario.die mario.win (barrelY b (mario.bar2.y)))
  , image donkey_kong.width donkey_kong.height "images/donkey_kong/stand.gif"
      |> moveX (-(midTam suelo.width) + (midTam trash.width))
      |> moveY (b+(suelo.height * 2)+(stair1.height*3))
  , image 44 60 "images/princess/stand.gif"
      |> moveX princess.x
      |> moveY (b + princess.y)
  , image plataforma.width plataforma.height "images/fondo/plataforma.gif"
      |> moveX plataforma.x
      |> moveY (b + plataforma.y)
  , image trash.width trash.height "images/objetos/basura/basura.gif"
      |> moveY (b+(midTam trash.height)+ suelo.height)
      |> moveX (-(midTam suelo.width) + (midTam trash.width))

  , image 40 40 (mario.ham.img) 
      |> move hammer.x (b + hammer.y)
  ,image 40 40 mario.c1.img 
      |> move mario.c1.x (b + mario.c1.y)
  ,image 40 40 mario.c2.img 
      |> move mario.c2.x (b + mario.c2.y)
  ,image 40 40 mario.c3.img 
      |> move mario.c3.x (b + mario.c3.y)
  , image (transform_mario mario.power) (transform_mario mario.power) (toGif mario)
      |> move (gameOver_ mario.win mario.die mario.x) (gameOver_ mario.win mario.die (b + (transform_marioMoveY mario.power) + mario.y ))
  , image 700 400 (gameOver mario)
  , words white ("TIEMPO: "++(String.fromInt (round ( mario.oscilaciones / 60 )))++" SCORE: "++(String.fromInt (round ( mario.score ))))
      |> move (gameOver_ mario.win mario.die stair6.x) (gameOver_scoreY mario.die mario.win (b+(suelo.height * 2)+(stair1.height*3.5)))
      |> scale 1.5
  ]



transform_marioMoveY : Bool -> Float
transform_marioMoveY mario_bool = if mario_bool then 80 else 65

transform_mario : Bool -> Float
transform_mario mario_bool = if mario_bool then 80 else 50

midtransform_mario : Bool -> Float
midtransform_mario  mario_bool = (transform_mario mario_bool)/2

zigzag zig x = 
  if x > 620 then
    False 
  else if x < -610 then
    True 
  else
    zig


moveBarrelX zig x vx = 
  if zig then
    x + vx
  else
    x - vx

barrelY b y = (b+(suelo.height * 2)+(stair1.height*(y))-20)  

barrelMoreFast vx oscilaciones = vx + (oscilaciones / (3600 * 1000))

coinPointsRelease coin_ mario =
  if coin_ == mario.c1 then
    mario.c1.points
  else if coin_ == mario.c2 then
    mario.c2.points
  else if coin_ == mario.c3 then
    mario.c3.points
  else 
    mario.c1.points 
  

up_level x y = 
  if (y < 541 && y > 480) then
    if x > (600) then
      490
    else
      540
  else if (y < 361 && y > 310 ) then
    if x < (-590) then
      310
    else
      360
  else if (y < 181 && y > 150) then
    if x > 600 then
      170
    else
      180
  else if y < 0 then
    0
  else
    if (y < 351 && y > 180 ) then
      180
    else
      y

coin_movement x y =
  if (y < 180)  then
    coin1
  else if (y > 180 && y < 350) then 
    coin2
  else if (y > 350 && y < 650) then
    coin3
  else 
    coin1

stairs_movement x y =
  if (y < 180)  then
    if (x < (stair1.x + stair1.width )) then 
      stair1
    else
      stair2 
  else if (y > 180 && y < 350) then 
    if (x < (stair3.x + stair3.width)) then
      stair3
    else
      stair4
  else if (y > 350 && y < 650) then
    if (x < (stair5.x + stair5.width)) then
      stair5
    else
      stair6
  else 
      stair1

gameOver mario = 
  if mario.die then
    "images/fondo/game_over.gif"
  else if mario.win then
    "images/fondo/you_win.gif"
  else
    ""

gameOver_ die win value =
  if die then
    0
  else if win then
    0
  else 
    value

gameOver_scoreY die win value = 
  if die then
    -100
  else if win then
    -100
  else
    value

toGif mario =
  if mario.y > 0 && mario.y /= 180 && mario.y /= 360 && mario.y /= 540 then
    if mario.power then 
      "images/mario/jump/attack/" ++ mario.dir ++ ".gif"
    else if mario.rise then
      "images/mario/up/up.gif"
    else
      "images/mario/jump/" ++ mario.dir ++ ".gif"
  else if mario.vx /= 0 then
    if mario.power then
      "images/mario/walk/attack/" ++ mario.dir ++ ".gif"
    else
      "images/mario/walk/" ++ mario.dir ++ ".gif"
  else
    if mario.power then
      "images/mario/stand/attack/" ++ mario.dir ++ ".gif"
    else if mario.die then
      ""
    else
      "images/mario/stand/" ++ mario.dir ++ ".gif"



-- UPDATE


update computer mario =
  let
    b = computer.screen.bottom

    dt = 1.666
    vx = toX computer.keyboard*1.5
    vy =
      if mario.rise then
        toY computer.keyboard
      else
        if mario.y == 0 || (mario.y == 180) || (mario.y == 360) || (mario.y == 540) then
          if computer.keyboard.up then 7 else 0
        else
          mario.vy - dt / 4
    x = mario.x + dt * vx
    y = if (mario.y == 180 && mario.x > 600) then 120 else if ( mario.y == 360 && mario.x < (-590)) then 300 else if (mario.y == 540 && mario.x > 600) then 490 else mario.y + dt * vy 


    zig = zigzag mario.bar.zigzag mario.bar.x
    zig2 = zigzag mario.bar2.zigzag mario.bar2.x

    moveBarrelY = if zig == mario.bar.zigzag then mario.bar.y else mario.bar.y - 1
    moveBarrelY2 = if zig2 == mario.bar2.zigzag then mario.bar2.y else mario.bar2.y - 1

    barY = if moveBarrelY == -1 then 3 else moveBarrelY
    barY2 = if moveBarrelY2 == -1 then 3 else moveBarrelY2

    barX = (moveBarrelX zig mario.bar.x mario.bar.vx)
    barX2 = (moveBarrelX zig2 mario.bar2.x mario.bar2.vx)

    barJump = if (mario.y + (barrelY b 0)) > (barrelY b barY) && (mario.y + (barrelY b 0)) < (barrelY b (barY+1)) && x < (barX+20) && x > (barX-20) && mario.rise /= True then mario.bar.jump + 10  else mario.bar.jump + 0
    barJump2 = if (mario.y + (barrelY b 0)) > (barrelY b barY2) && (mario.y + (barrelY b 0)) < (barrelY b (barY2+1)) && x < (barX2+20) && x > (barX2-20) && mario.rise /= True then mario.bar2.jump + 10  else mario.bar2.jump + 0


    bar = if mario.destroyBarrel == 1 then barrel else Barril barX barY zig (barrelMoreFast mario.bar.vx mario.oscilaciones) barJump
    bar2 = if mario.destroyBarrel == 2 then barrel2 else Barril barX2 barY2 zig2 (barrelMoreFast mario.bar2.vx mario.oscilaciones) barJump2

    ham = if mario.power then Hammer mario.ham.x mario.ham.y "" 0 else mario.ham

    coin_ = coin_movement mario.x mario.y

    c1 = if coin_ == mario.c1 && mario.bonus then Coin coin_.x coin_.y "" 0 else mario.c1
    c2 = if coin_ == mario.c2 && mario.bonus then Coin coin_.x coin_.y "" 0 else mario.c2
    c3 = if coin_ == mario.c3 && mario.bonus then Coin coin_.x coin_.y "" 0 else mario.c3

    coinX = coin_.x
    coinY = coin_.y

    stair = stairs_movement mario.x mario.y

    coinPoints = if mario.bonus then mario.coinPoints + (coinPointsRelease coin_ mario) else mario.coinPoints

    
    power = if (mario.hamTime/60)+10 <= (oscilaciones / 60) then False else mario.power
    bonus = mario.bonus
    rise = mario.rise
    die = mario.die
    win = mario.win

    winPoint = if win then 800 else 0

    destroyBarrel = if (barrel_coalision die mario.win mario.x (mario.y + (barrelY b 0)) barX (barrelY b barY)) then 1 else if (barrel_coalision mario.die mario.win mario.x (mario.y + (barrelY b 0)) barX2 (barrelY b barY2)) then 2 else 0 

    oscilaciones = if die then mario.oscilaciones else if win then mario.oscilaciones else mario.oscilaciones + 1 

    hammerPoints = if mario.power && destroyBarrel /= 0 then mario.hammerPoints + hammer.points else mario.hammerPoints

    hamTime = if mario.power then mario.hamTime + 0 else mario.hamTime + 1

    score = (oscilaciones / (60 * 2) + barJump + barJump2 + coinPoints + hammerPoints + winPoint)

  in
  { x = x
  , y = max (up_level x y)  y
  , vx = vx
  , vy = vy
  , dir = if vx == 0 then mario.dir else if vx < 0 then "left" else "right"
  , power = hammer_coalision power b x y
  , bonus = coin_coalision bonus b x y coinY coinX
  , rise = stair_coalision computer rise b x y stair
  , bar = bar
  , bar2 = bar2
  , c1 = c1
  , c2 = c2
  , c3 = c3 
  , ham = ham
  , hamTime = hamTime
  , oscilaciones = oscilaciones
  , score = score
  , coinPoints = coinPoints
  , hammerPoints = hammerPoints
  , destroyBarrel = destroyBarrel
  , die = if mario.power then False else (barrel_coalision die win x (mario.y + (barrelY b 0)) barX (barrelY b barY)) || (barrel_coalision die win x (mario.y + (barrelY b 0)) barX2 (barrelY b barY2)) 
  , win = princess_coalision win b x (mario.y + (barrelY b 0)) 
  }

  --COALISION

barrel_coalision die win marioX marioY barX barY = 
  if win then
    False
  else if marioY == barY && marioX < (barX+20) && marioX > (barX-20) then
    True
  else if die then
    True
  else
    False



princess_coalision win b marioX marioY =
  if (marioY+10) >= (b + princess.y)  && marioX < (princess.x+22) && marioX > (princess.x-22) then
    True
  else if win then
    True
  else
    False 

hammer_coalision power b x y = 
  if (b+(transform_mario power)+y > b+hammer.y-(midtransform_mario power) && b+(transform_mario power)+y < b+hammer.y+(midtransform_mario power)) && (x > hammer.x-(midtransform_mario power) && x < hammer.x+(midtransform_mario power)) then 
    True
  else if power then
    True 
  else
    False

coin_coalision bonus b x y coinY coinX = 
  if (b+(transform_mario bonus)+y > b+coinY-(midtransform_mario bonus) && b+(transform_mario bonus)+y < b+coinY+(midtransform_mario bonus)) && (x > coinX-(midtransform_mario bonus) && x < coinX+(midtransform_mario bonus)) then 
    True 
  else
    False

stair_coalision computer rise b x y stair = 
  if (b+y > b+stair.y-(midtransform_mario rise) && b+y < b+stair.y+(midtransform_mario rise)) && (x > stair.x-(midtransform_mario rise) && x < stair.x+(midtransform_mario rise)) then 
    if computer.keyboard.up then
        True
    else if rise then
        True
    else
        False 
  else
    False


--  
  -- SOURCE CODES  
  --    DOCUMENTACION DE ELM
  -- https://guide.elm-lang.org/core_language.html
  --    LIBRERIA PLAYGROUND
  -- https://package.elm-lang.org/packages/evancz/elm-playground/latest/Playground#game
  --    LIBRERIA HTML
  -- https://package.elm-lang.org/packages/elm/http/latest/Http


  -- EQUIPO: JUAN SEBASTIAN BAEZ RUEDA
  --         MICHAEL CORRALES
