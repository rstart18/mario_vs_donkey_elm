module Main exposing (..)
import Playground exposing (..)

-- TYPE´S 
type alias Object =
  { x : Int
  , y : Int
  }

-- OBJECT´S

suelo = {width = 1350, height = 40}

trash = {width = 80, height = 120}

stairs = {width = 70, height = 180}

hammer = {x = -200, y = 140} --Object -200 180

coin = {x = -50, y = 140}

-- FUN´S

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
    }



-- VIEW


view computer mario =
  let
    w = computer.screen.width
    h = computer.screen.height
    b = computer.screen.bottom
  in
  [ rectangle (black) w h
  , image w suelo.height "images/fondo/suelo2.gif"
      |> moveY (b+(midTam suelo.height))
  , image w suelo.height "images/fondo/suelo2.gif"
      |> moveY (b+(midTam suelo.height)+stairs.height)
  , image trash.width trash.height "images/objetos/basura/basura.gif"
      |> moveY (b+(midTam trash.height)+ suelo.height)
      |> moveX (-(w/2)+(midTam trash.width))
  , image stairs.width stairs.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(midTam stairs.height)+ suelo.height)
      |> moveX ((midTam stairs.width)*2)
  , image stairs.width stairs.height "images/objetos/escalera/escalera.gif"
      |> moveY (b+(midTam stairs.height)+ suelo.height)
      |> moveX ((midTam stairs.width)*16)
    -- segundo piso
    -- mario y objetos
  , image 40 40 (toTakepower mario) 
      |> move hammer.x (b + hammer.y)
  ,image 40 40 (toTakebonus mario) 
      |> move coin.x (b + coin.y)
  , image (transform_mario mario.power) (transform_mario mario.power) (toGif mario)
      |> move mario.x (b + (transform_marioMoveY mario.power) + mario.y)
  , words white (String.fromInt (round (midtransform_mario mario.power)))  
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

transform_marioMoveY : Bool -> Float
transform_marioMoveY mario_bool = if mario_bool then 80 else 65

transform_mario : Bool -> Float
transform_mario mario_bool = if mario_bool then 80 else 50

midtransform_mario : Bool -> Float
midtransform_mario  mario_bool = (transform_mario mario_bool)/2








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
        if computer.keyboard.up then 7 else 0
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
                    if (b+(transform_mario power)+y > b+hammer.y-(midtransform_mario power) && b+(transform_mario power)+y < b+hammer.y+(midtransform_mario power)) && (x > hammer.x-(midtransform_mario power) && x < hammer.x+(midtransform_mario power)) then 
                      True 
                    else if power then
                      True
                    else
                      False

coin_coalision bonus b x y = 
                    if (b+(transform_mario bonus)+y > b+coin.y-(midtransform_mario bonus) && b+(transform_mario bonus)+y < b+coin.y+(midtransform_mario bonus)) && (x > coin.x-(midtransform_mario bonus) && x < coin.x+(midtransform_mario bonus)) then 
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
