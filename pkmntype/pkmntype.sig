signature PKMNTYPE =
sig
	datatype pkmnType	= NONE | NORMAL | FIRE | WATER | ELECTRIC | GRASS | ICE
				| FIGHTING | POISON | GROUND | FLYING | PSYCHIC | BUG
				| ROCK | GHOST | DRAGON | DARK | STEEL | FAIRY
	datatype pkmnTypeEff	= EFF_NEUTRAL | EFF_SUPER | EFF_NOT | EFF_NONE

	(* Util functions *)
	val allTypes : unit -> pkmnType list
	val typeMatchup : pkmnType -> pkmnType -> pkmnTypeEff
	val typeMatchup2 : pkmnType -> (pkmnType * pkmnType) -> (pkmnTypeEff * pkmnTypeEff)
	(* Attacking T1 is ______ against defending T2 *)
	val typeOffIsSuper : pkmnType -> pkmnType -> bool
	val typeOffIsNotEffective : pkmnType -> pkmnType -> bool
	val typeOffIsNeutral : pkmnType -> pkmnType -> bool
	val typeOffIsKill : pkmnType -> pkmnType -> bool
	(* Defending T1 is ______ against attacking T2 *)
	val typeDefIsResist : pkmnType -> pkmnType -> bool
	val typeDefIsWeak : pkmnType -> pkmnType -> bool
	val typeDefIsNeutral : pkmnType -> pkmnType -> bool
	val typeDefIsImmune : pkmnType -> pkmnType -> bool

	(* Operators *)
	val = : (pkmnType * pkmnType) -> bool
	val > : (pkmnType * pkmnType) -> bool
	val >= : (pkmnType * pkmnType) -> bool
	val < : (pkmnType * pkmnType) -> bool
	val <= : (pkmnType * pkmnType) -> bool
	val <> : (pkmnType * pkmnType) -> bool

	val isSTAB : pkmnType -> (pkmnType * pkmnType) -> bool

	val toString : pkmnType -> string
end