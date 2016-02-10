{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
--{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns      #-}

module Main where

import           GHC.Generics               (Generic)

import           Text.Megaparsec
import           Text.Megaparsec.Expr
import           Text.Megaparsec.Perm
import           Text.Megaparsec.Pos
import           Text.Megaparsec.ShowToken

import           Text.Megaparsec.Prim
import           Text.Megaparsec.Text

import           Data.Word

import           Data.Functor

import           Data.Sequence
import           Data.String                (IsString)
import           Data.Text                  (Text, pack, unpack)

import           Control.DeepSeq

import           Pipes

import qualified Control.Monad.State.Strict as S
import qualified Pipes.Parse                as PP

type Parsed a = Either ParseError a

data MDPrim = MDIgnoreBegin
            | MDIgnoreEnd
            | MDAddTOC
            | MDLine Text
            | MDHeader { depth :: !Word32, title :: !Text }
            deriving (Eq, Show, Read, Generic, NFData)

data MDToken = MDPrim !MDPrim
             | MDIgnoreNext
             deriving (Eq, Show, Read, Generic, NFData)

newtype MDTokenStream = MDTokenStream (Seq MDToken)
                      deriving (Eq, Show, Read, Generic, NFData)

instance ShowToken MDToken where showToken = show
instance ShowToken MDPrim  where showToken = show

satisfyG :: (ShowToken t, MonadParsec s p t) => (t -> Bool) -> p t
satisfyG predicate = token (\_ p _ -> incSourceColumn p 1) test
  where
    test x | predicate x = Right x
           | otherwise   = Left . pure . Unexpected . showToken $ x

tokenP :: (Eq t, ShowToken t, MonadParsec s p t) => t -> p t
tokenP t = satisfyG (== t)

expected :: MonadParsec s m t => String -> m a
expected = failure . pure . Expected

mdPrimP :: (Stream s t, MonadParsec s p t, t ~ MDToken) => p MDPrim
mdPrimP = (\(MDPrim p) -> p) <$> satisfyG isMDPrim
  where
    isMDPrim (MDPrim _) = True
    isMDPrim _          = False

normalizeParser :: (Stream s t, MonadParsec s p t, t ~ MDToken) => p [MDPrim]
normalizeParser =     wrapIgnore <$> (tokenP MDIgnoreNext >> mdPrimP)
                  <|> pure <$> mdPrimP
                  <|> pure []
  where
    wrapIgnore x = [MDIgnoreBegin, x, MDIgnoreEnd]

-- | Evaluate a list of 'MDToken's, which can be context sensitive, to a list of
--   'MDPrim's, which are always context-free.
normalizeTokens :: Stream s MDToken => s -> Parsed [MDPrim]
normalizeTokens s = concat <$> runParser (many normalizeParser) "" s

mkPragmaP :: MonadParsec s p Char => String -> MDToken -> p MDToken
mkPragmaP s t = (string "[generate-toc-pragma]: " >> string s) $> t

addTOCP, ignoreBeginP, ignoreEndP, ignoreNextP :: Parser MDToken
addTOCP      = mkPragmaP "ADD_TOC"      $ MDPrim MDAddTOC
ignoreBeginP = mkPragmaP "IGNORE_BEGIN" $ MDPrim MDIgnoreBegin
ignoreEndP   = mkPragmaP "IGNORE_END"   $ MDPrim MDIgnoreEnd
ignoreNextP  = mkPragmaP "IGNORE_NEXT"    MDIgnoreNext

tokenParser :: Parser MDToken
tokenParser = pragmaParser <|> undefined
  where
    pragmaParser = addTOCP <|> ignoreBeginP <|> ignoreEndP <|> ignoreNextP

nextSkipEmpty :: (Monad m, Eq a, Monoid a)
              => Producer a m r
              -> m (Either r (a, Producer a m r))
nextSkipEmpty = go
  where
    go p0 = next p0 >>= go'
    go' x@(Left _)                      = return x
    go' x@(Right (a, p1)) | a == mempty = go p1
                          | otherwise   = return x

convertParser' :: (Stream s t, Eq s, Monoid s, Monad m)
               => String                           -- ^ File name
               -> Int                              -- ^ Tab width
               -> Parsec s x                       -- ^ Megaparsec parser
               -> PP.Parser s m (Maybe (Parsed x)) -- ^ Pipes parser
convertParser' file tabWidth parser = S.StateT go
  where
    go p0 = do
      x <- nextSkipEmpty p0
      case x of
        Left r        -> return (Nothing, return r)
        Right (a, p1) -> return $ step (yield a >>) (run parser a) p1
    run p s = runParser' p (initialState s)
    initialState input = State input (initialPos file) tabWidth
    step diffP (_,               e@(Left _))  p0 = (Just e, diffP p0)
    step _     (stateInput -> s, r@(Right _)) p0 = (Just r, yield s >> p0)

-- convertParser :: (Stream s t, Eq s, Monoid s, Monad m)
--               => Parsec s x                       -- ^ Megaparsec parser
--               -> Pipe s (Parsed x) m () -- ^ Pipes parser
convertParser :: (Stream s t, Eq s, Monoid s, Monad m) => Parsec s x -> PP.Parser s m (Maybe (Parsed x))
convertParser = convertParser' "" defaultTabWidth

newlineParser :: Stream s Char => Parsec s ()
newlineParser = undefined

parserPipe :: (Monad m, Stream s t)
           => String
           -> Int                              -- ^ Tab width
           -> Parsec s x
           -> Pipe s x m ()
parserPipe parser = undefined

main :: IO ()
main = return ()
