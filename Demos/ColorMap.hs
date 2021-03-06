import Data.HBDD.Operations
import Control.Monad.State.Strict
import Data.HBDD.ROBDDContext
import Data.HBDD.ROBDDState
import Data.List
import Prelude hiding(and,or,not)

main :: IO ()
main = do
       let (bdd, context) = runState usa mkContext
       putStrLn $ show $ getSat context bdd

-- | Restriction saying that the neighbourgs of a node cannot have the same color
edge :: Int -> Int -> ROBDDState Int
edge state1 state2 = (state1Color1 .=>. notState2Color1)     -- incompatible colors
                     .&. (state1Color2 .=>. notState2Color2)
                     .&. (state1Color3 .=>. notState2Color3)
                     .&. (state1Color4 .=>. notState2Color4)
                     where
                     state1Color1 = singletonC $ state1 + 0 -- + r
                     state1Color2 = singletonC $ state1 + 1 -- + g
                     state1Color3 = singletonC $ state1 + 2 -- + b
                     state1Color4 = singletonC $ state1 + 3 -- + y
                     notState2Color1 = singletonNotC $ state2 + 0 -- + r
                     notState2Color2 = singletonNotC $ state2 + 1 -- + g
                     notState2Color3 = singletonNotC $ state2 + 2 -- + b
                     notState2Color4 = singletonNotC $ state2 + 3 -- + y

-- | Restrictions saying that a state has only one color
oneColor :: Int -> ROBDDState Int
oneColor statec = foldr1 (.|.) $ map forbid colors
                  where
                  forbid i = singletonC i
                             .&. foldr1 (.&.) [ singletonNotC c | c <- colors, c /= i ]
                  color1 = statec + 0 -- + r
                  color2 = statec + 1 -- + g
                  color3 = statec + 2 -- + b
                  color4 = statec + 3 -- + y
                  colors = [ color1, color2 , color3, color4 ]

-- | BDD of the USA graph-coloring problem.
usa :: ROBDDState Int
usa = (foldr1 (.&.) $ map oneColor allStates)
      .&. edge al fl   .&. edge al ga  .&. edge al ms  .&. edge al tn
      .&. edge ar la   .&. edge ar mo  .&. edge ar ms  .&. edge ar ok
      .&. edge ar tn   .&. edge ar tx  .&. edge az ca  .&. edge az nm
      .&. edge az nv   .&. edge az ut  .&. edge ca nv  .&. edge ca or_
      .&. edge co ks   .&. edge co ne  .&. edge co nm  .&. edge co ok
      .&. edge co ut   .&. edge co wy  .&. edge ct ma  .&. edge ct ny
      .&. edge ct ri   .&. edge de md  .&. edge de nj  .&. edge de pa
      .&. edge fl ga   .&. edge ga nc  .&. edge ga sc  .&. edge ga tn
      .&. edge ia il   .&. edge ia mn  .&. edge ia mo  .&. edge ia ne
      .&. edge ia sd   .&. edge ia wi  .&. edge id_ mt .&. edge id_ nv
      .&. edge id_ or_ .&. edge id_ ut .&. edge id_ wa .&. edge id_ wy
      .&. edge il in_  .&. edge il ky  .&. edge il mo  .&. edge il wi
      .&. edge in_ ky  .&. edge in_ mi .&. edge in_ oh .&. edge ks mo
      .&. edge ks ne   .&. edge ks ok  .&. edge ky mo  .&. edge ky oh
      .&. edge ky tn   .&. edge ky va  .&. edge ky wv  .&. edge la ms
      .&. edge la tx   .&. edge ma nh  .&. edge ma ny  .&. edge ma ri
      .&. edge ma vt   .&. edge md pa  .&. edge md va  .&. edge md wv
      .&. edge me nh   .&. edge mi oh  .&. edge mi wi  .&. edge mn nd
      .&. edge mn sd   .&. edge mn wi  .&. edge mo ne  .&. edge mo ok
      .&. edge mo tn   .&. edge ms tn  .&. edge mt nd  .&. edge mt sd
      .&. edge mt wy   .&. edge nc sc  .&. edge nc tn  .&. edge nc va
      .&. edge nd sd   .&. edge ne sd  .&. edge ne wy  .&. edge nh vt
      .&. edge nj ny   .&. edge nj pa  .&. edge nm ok  .&. edge nm tx
      .&. edge nv or_  .&. edge nv ut  .&. edge ny pa  .&. edge ny vt
      .&. edge oh pa   .&. edge oh wv  .&. edge ok tx  .&. edge or_ wa
      .&. edge pa wv   .&. edge sd wy  .&. edge tn va  .&. edge ut wy
      .&. edge va wv
      where
      allStates = 
        [al , az , ar , ca , co , ct , de , fl , ga , id_ , il , in_ , ia , ks , ky , la , me , md
        , ma , mi , mn , ms , mo , mt , ne , nv , nh , nj , nm , ny , nc , nd , oh , ok , or_ , pa
        , ri , sc , sd , tn , tx , ut , vt , va , wa , wv , wi , wy]
      al  = 1 * 4 :: Int
      -- ak = 2 * 4 :: Int
      az  = 3 * 4 :: Int
      ar  = 4 * 4 :: Int
      ca  = 5 * 4 :: Int
      co  = 6 * 4 :: Int
      ct  = 7 * 4 :: Int
      de  = 8 * 4 :: Int
      fl  = 9 * 4 :: Int
      ga  = 10 * 4 :: Int
      -- hi = 11 * 4 :: Int
      id_ = 12 * 4 :: Int
      il  = 13 * 4 :: Int
      in_ = 14 * 4 :: Int
      ia  = 15 * 4 :: Int
      ks  = 16 * 4 :: Int
      ky  = 17 * 4 :: Int
      la  = 18 * 4 :: Int
      me  = 19 * 4 :: Int
      md  = 20 * 4 :: Int
      ma  = 21 * 4 :: Int
      mi  = 22 * 4 :: Int
      mn  = 23 * 4 :: Int
      ms  = 24 * 4 :: Int
      mo  = 25 * 4 :: Int
      mt  = 26 * 4 :: Int
      ne  = 27 * 4 :: Int
      nv  = 28 * 4 :: Int
      nh  = 29 * 4 :: Int
      nj  = 30 * 4 :: Int
      nm  = 31 * 4 :: Int
      ny  = 32 * 4 :: Int
      nc  = 33 * 4 :: Int
      nd  = 34 * 4 :: Int
      oh  = 35 * 4 :: Int
      ok  = 36 * 4 :: Int
      or_ = 37 * 4 :: Int
      pa  = 38 * 4 :: Int
      ri  = 39 * 4 :: Int
      sc  = 40 * 4 :: Int
      sd  = 41 * 4 :: Int
      tn  = 42 * 4 :: Int
      tx  = 43 * 4 :: Int
      ut  = 44 * 4 :: Int
      vt  = 45 * 4 :: Int
      va  = 46 * 4 :: Int
      wa  = 47 * 4 :: Int
      wv  = 48 * 4 :: Int
      wi  = 49 * 4 :: Int
      wy  = 50 * 4 :: Int
