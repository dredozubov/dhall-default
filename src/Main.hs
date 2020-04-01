module Main where

import Control.Monad.State.Strict
import Control.Monad.Writer.CPS
import Data.Text as T
-- import Debug.Trace
import Data.Text.IO as T
import Dhall
import Dhall.Context as C
import Dhall.Core
import Dhall.Map as M
import Dhall.Pretty
import Dhall.Src
import Dhall.TypeCheck
import Options.Generic
import System.IO


data Opts
  = Transform { filename :: String }
  deriving (Generic)

instance ParseRecord Opts

transformRec :: Expr Src X -> Either Text (Expr Src X)
transformRec (Record m) = do
  (fields, ty) <- runStateT (execWriterT (M.traverseWithKey processField m)) m
  let defRec = RecordLit fields
  let reducedType = Record ty
  let expr = Annot defRec reducedType
  case typeWith C.empty expr of
    Left tcErr -> Left $ "Please report a bug.\n"
      <> "expression: " <> (T.pack $ show $ prettyExpr expr) <> "\n"
      <> (pack $ show tcErr)
    Right res  -> pure res
  where
    processField
      :: Text
      -> Expr Src X
      -> WriterT
        (M.Map Text (Expr Src X))
        (StateT (M.Map Text (Expr Src X)) (Either Text))
        ()
    processField f (App Optional ty) = tell $ M.singleton f (App None ty)
    processField f _                = modify $ M.delete f
transformRec other         = Left $ "Record expected, found: " <> (T.pack . show $ other)

main :: IO ()
main = do
  opts <- getRecord "Opts"
  contents <- T.readFile $ filename opts
  doc <- inputExpr contents
  print doc -- debug
  case transformRec doc of
    Left err -> T.hPutStr stderr err
    Right r  -> T.hPutStr stdout $ T.pack $ show $ prettyExpr r
