{-# LANGUAGE OverloadedStrings #-}
module Main where

-- import UIHelper (mainLogic, keepTrying)
import HumanGame (humanPlayer)
-- import BotGame (botPlayer2)
import Prelude

import Brick
  ( App(..), AttrMap, BrickEvent(..), EventM, Next, Widget
  , customMain, neverShowCursor, attrName, simpleMain
  , continue, halt
  , hLimit, vLimit, vBox, hBox
  , padRight, padLeft, padTop, padAll, Padding(..)
  , withBorderStyle
  , str
  , attrMap, withAttr, emptyWidget, AttrName, on, fg
  , (<+>)
  )
import Brick.BChan (newBChan, writeBChan)
import qualified Brick.Widgets.Border as B
import qualified Brick.Widgets.Border.Style as BS
import qualified Brick.Widgets.Center as C
import qualified Brick.Util as U
import qualified Graphics.Vty as V
import Data.Sequence (Seq)
import qualified Data.Sequence as S
import Linear.V2 (V2(..))

drawInfo :: Widget ()
drawInfo = withBorderStyle BS.unicodeBold
  $ C.hCenter
  $ hLimit 80
  $ vLimit 400
  $ B.borderWithLabel (str "First hit enter. Then type which player you are.")
  $ vBox $ map (uncurry drawKey)
  $ [ ("r", "Random Chess Placement.")
    , ("d", "Demo Chess Placement.")
    , ("q", "Exit the Game.")
    ]
    where
      drawKey act key = (padRight Max $ padLeft (Pad 1) $ str act)
                        <+> (padLeft Max $ padRight (Pad 1) $ str key)

processLine :: String -> IO ()
processLine s = case s of
  "d" -> humanPlayer True
  "r" -> humanPlayer False
  "q" -> print "Successfully Exited!"
  _ -> main
  
  --"u" -> botPlayer 1
  -- "m" -> botPlayer2 $ keepTrying [[Just 2, Just 2, Nothing, Nothing],
  --                 [Nothing, Nothing, Nothing, Nothing],
  --                 [Nothing, Nothing, Nothing, Nothing],
  --                 [Nothing, Nothing, Nothing, Nothing]] (4,4,4)
  --"m" -> mainLogic

main :: IO ()
main = do
  simpleMain drawInfo -- just draw the help menu for choosing human/MC
  c <- getLine
  processLine c
