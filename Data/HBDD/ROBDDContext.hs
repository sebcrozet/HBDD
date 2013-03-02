module Data.HBDD.ROBDDContext
(
ROBDDId
, ROBDDContext
, mkContext
, allocId
, lookup
, insert
)
where

import Prelude hiding(lookup)
import Data.HBDD.ROBDD
import Data.HBDD.UIDGenerator hiding(allocId)
import qualified Data.HBDD.UIDGenerator as UIDG
import qualified Data.Map as M

type ROBDDId v = (UID, v, UID)
data ROBDDContext v = ROBDDContext UIDGenerator (M.Map (ROBDDId v) (ROBDD v))
                      deriving Show

mkContext :: ROBDDContext v
mkContext = ROBDDContext mkGenerator M.empty

allocId :: ROBDDContext v -> (UID, ROBDDContext v)
allocId (ROBDDContext generator c) = let (res, generator') = UIDG.allocId generator in
                                     (res, ROBDDContext generator' c)

lookup :: Ord v => ROBDDId v -> ROBDDContext v -> Maybe (ROBDD v)
lookup uid (ROBDDContext _ context) = M.lookup uid context

insert :: Ord v => ROBDDId v -> ROBDD v -> ROBDDContext v -> ROBDDContext v
insert uid t (ROBDDContext i context) = ROBDDContext i $ M.insert uid t context
