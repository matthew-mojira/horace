module AST where

import Type

type Id = String

type Horace = [Mode]

-- Mode stuff

data Mode = Mode { modeName :: Id
                 , modeTypes :: [UserType]
                 , modeVars :: [MState]
                 , modeMain :: Expr
                 , modeFuncs :: [Func]
                 }
            deriving Show

data UserType = UserType { utypeName :: Id,
                           utypeCons :: [Variant] } deriving Show

data Variant = Variant { consName :: Id,
                         consFields :: [Type] } deriving Show

data MState = MState { mvarName :: Id,
                       mvarType :: Type,
                       mvarInit :: Expr } deriving Show

data Func = Func { funcName :: Id
                 , funcParams :: [Param]
                 , funcType :: Type
                 , funcBody :: Expr } deriving Show

data Param = Param { paramName :: Id
                   , paramType :: Type } deriving Show

-- Core Horace (Odes)

type Prog = Expr

data Expr
  = ExprLit Int
  | ExprBlock [Var] [Expr]
  | ExprVar Id
  | ExprAssign LVal Expr
  | ExprArrIndex Expr Expr      -- not planned to be supported yet
  | ExprCall Id [Expr]
  | ExprMethodCall Id Id [Expr] -- not planned to be supported yet
  | ExprConstruct Id [Expr]
  | ExprIf Pred Expr Expr
  | ExprMatch Expr [Case]       -- not planned to be supported yet
  | ExprFor Id Expr Expr Expr   -- not planned to be supported yet
  | ExprUnOp UnOp Expr
  | ExprBinOp BinOp Expr Expr
  | ExprVoid
  deriving (Show)

data LVal
  = LValId Id
  | LValArrIndex Id Expr        -- not implemented
  deriving (Show)

type Case = (Pattern, Expr)     -- not implemented

data Pattern
  = PatWildcard                 -- not implemented
  | PatLit Int                  -- not implemented
  | PatData Id [Pattern]        -- not implemented
  deriving (Show)

data Var =
  Var Id Type Expr
  deriving (Show)

{-
  Use of Maybe type allows for either intentionally specifying the target or
  leaving to be inferred (although the typechecker will not do any inference so
  those cases don't work at the moment).
-}
data UnOp
  = UnOpTransmute (Maybe Int) (Maybe Int)
  | UnOpShrink (Maybe Word)
  | UnOpExtend (Maybe Word)
  | UnOpSignExtend (Maybe Word)
  | UnOpDisplay                 -- not implemented
  deriving (Show)

data BinOp
  = BinOpAdd
  | BinOpSub
  | BinOpMult   -- not yet supported
  | BinOpDiv    -- not yet supported
  | BinOpMod    -- not yet supported
  | BinOpLShift -- not yet supported
  | BinOpRShift -- not yet supported
  | BinOpBitAnd
  | BinOpBitOr
  | BinOpBitEor
  deriving (Show)

data Pred
  = PredLit Bool
  | PredUnOp PredUnOp Pred
  | PredBinOp PredBinOp Pred Pred
  | PredComp CompOp Expr Expr
  deriving (Show)

data PredUnOp =
  PredNot
  deriving (Show)

data PredBinOp
  = PredAnd
  | PredOr
  deriving (Show)

data CompOp
  = CompEq
  | CompNeq
  | CompLe
  | CompLeq
  | CompGe
  | CompGeq
  | CompLeS
  | CompLeqS
  | CompGeS
  | CompGeqS
  deriving (Show)
