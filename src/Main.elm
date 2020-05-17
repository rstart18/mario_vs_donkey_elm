module Main exposing (..)
import Playground exposing (..)

-- TYPE´S 


-- OBJECT´S

queso = {x = -310, y = 180}

-- FUN´S

boolToString : Bool -> String
boolToString bool = if bool then "True" else "False" 

-- MAIN


main =
  game view update
    { x = -9
    , y = 0
    , vx = 0
    , vy = 0
    , dir = "right"
    , cheese = False
    }



-- VIEW


view computer spiry =
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
  , image 40 40 (toTakeCheese spiry) 
      |> move queso.x (b + queso.y)
  , image 50 50 (toGif spiry)
      |> move spiry.x (b + 70 + spiry.y)
  , words white (String.fromInt (round b))  
  ]

toTakeCheese spiry = 
  if spiry.cheese then
    ""
  else 
    "images/objetos/martillo/martillo.gif"

toGif spiry =
  if spiry.y > 0 then
    "images/mario/jump/" ++ spiry.dir ++ ".gif"
  else if spiry.vx /= 0 then
    "images/mario/walk/" ++ spiry.dir ++ ".gif"
  else
    "images/mario/stand/" ++ spiry.dir ++ ".gif"

--COALISION

condicion_queso = (b+70+y > b+queso.y-25 && b+70+y < b+queso.y+25) && (x > queso.x-25 && x < queso.x+25)

-- UPDATE


update computer spiry =
  let
    b = computer.screen.bottom

    dt = 1.666
    vx = toX computer.keyboard*1.5
    vy =
      if spiry.y == 0 then
        if computer.keyboard.up then 8 else 0
      else
        spiry.vy - dt / 4
    x = spiry.x + dt * vx
    y = spiry.y + dt * vy

  in
  { x = x
  , y = max 0 y
  , vx = vx
  , vy = vy
  , dir = if vx == 0 then spiry.dir else if vx < 0 then "left" else "right"
  , cheese = if (b+70+y > b+queso.y-25 && b+70+y < b+queso.y+25) && (x > queso.x-25 && x < queso.x+25) then True else False
  }
--  
  -- SOURCE CODES  
  --    DOCUMENTACION DE ELM
  -- https://guide.elm-lang.org/core_language.html
  --    LIBRERIA PLAYGROUND
  -- https://package.elm-lang.org/packages/evancz/elm-playground/latest/Playground#game
  --    LIBRERIA HTML
  -- https://package.elm-lang.org/packages/elm/http/latest/Http


  -- HECHO POR: JUAN SEBASTIAN BAEZ RUEDA
