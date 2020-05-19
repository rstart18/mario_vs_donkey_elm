module Main exposing (..)
import Playground exposing (..)

-- TYPE´S 


-- OBJECT´S

hammer = {x = -200, y = 180}

coin = {x = -50, y = 180}

-- FUN´S

boolToString : Bool -> String
boolToString bool = if bool then "True" else "False" 

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
    }



-- VIEW


view computer mario =
  let
    w = computer.screen.width
    h = computer.screen.height
    b = computer.screen.bottom
  in
  [ rectangle (black) w h
  , image w h "images/fondo/suelo.gif"
      |> moveY -270
  , image 80 120 "images/objetos/basura/basura.gif"
      |> moveY (b+100)
      |> moveX (-(w/2)+40)
  , image 40 40 (toTakepower mario) 
      |> move hammer.x (b + hammer.y)
  ,image 40 40 (toTakebonus mario) 
      |> move coin.x (b + coin.y)
  , image (transform mario) (transform mario) (toGif mario)
      |> move mario.x (b + (transformMoveY mario) + mario.y)
  , words white (String.fromInt (round b))  
  ]

toTakepower mario = 
  if mario.power then
    ""
  else
    "images/objetos/martillo/martillo.gif"

toTakebonus mario =
  if mario.bonus then
    ""
  else
    "images/objetos/coin/coin.gif"

transformMoveY mario = 
    if mario.power then
      80
    else 
      65

transform mario = 
    if mario.power then
      80
    else 
      50

toGif mario =
  if mario.y > 0 then
    if mario.power then 
      "images/mario/jump/attack/" ++ mario.dir ++ ".gif"
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
    else
    "images/mario/stand/" ++ mario.dir ++ ".gif"



-- UPDATE


update computer mario =
  let
    b = computer.screen.bottom

    dt = 1.666
    vx = toX computer.keyboard*1.5
    vy =
      if mario.y == 0 then
        if computer.keyboard.up then 8 else 0
      else
        mario.vy - dt / 4
    x = mario.x + dt * vx
    y = mario.y + dt * vy

    power = mario.power
    bonus = mario.bonus

  in
  { x = x
  , y = max 0 y
  , vx = vx
  , vy = vy
  , dir = if vx == 0 then mario.dir else if vx < 0 then "left" else "right"
  , power = hammer_coalision power b x y
  , bonus = coin_coalision bonus b x y
  }

  --COALISION


hammer_coalision power b x y = 
                    if (b+50+y > b+hammer.y-25 && b+50+y < b+hammer.y+25) && (x > hammer.x-25 && x < hammer.x+25) then 
                      True 
                    else if power then
                      True
                    else
                      False

coin_coalision bonus b x y = 
                    if (b+50+y > b+coin.y-25 && b+50+y < b+coin.y+25) && (x > coin.x-25 && x < coin.x+25) then 
                      True 
                    else if bonus then
                      True
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


  -- HECHO POR: JUAN SEBASTIAN BAEZ RUEDA
