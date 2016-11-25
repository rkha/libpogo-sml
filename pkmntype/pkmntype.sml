structure PkmnType :> PKMNTYPE =
struct
	datatype pkmnType	= NONE | NORMAL | FIRE | WATER | ELECTRIC | GRASS | ICE
				| FIGHTING | POISON | GROUND | FLYING | PSYCHIC | BUG
				| ROCK | GHOST | DRAGON | DARK | STEEL | FAIRY
	datatype pkmnTypeEff	= EFF_NEUTRAL | EFF_SUPER | EFF_NOT | EFF_NONE

	(* Util functions *)
	(* val allTypes : unit -> pkmnType list *)
	fun allTypes() = [
		NORMAL, FIRE, WATER, ELECTRIC, GRASS, ICE, FIGHTING, POISON,
		GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON,
		DARK, STEEL, FAIRY
	];

	(* val typeMatchup : pkmnType -> pkmnType -> pkmnTypeEff *)
	(* Reference: http://serebii.net/games/typexy.shtml *)
	fun typeMatchup NONE _ = EFF_NEUTRAL
	|   typeMatchup _ NONE = EFF_NEUTRAL
	|   typeMatchup NORMAL ROCK	= EFF_NOT
	|   typeMatchup NORMAL GHOST	= EFF_NONE
	|   typeMatchup NORMAL STEEL	= EFF_NOT
	|   typeMatchup FIRE FIRE	= EFF_NOT
	|   typeMatchup FIRE WATER	= EFF_NOT
	|   typeMatchup FIRE GRASS	= EFF_SUPER
	|   typeMatchup FIRE ICE	= EFF_SUPER
	|   typeMatchup FIRE BUG	= EFF_SUPER
	|   typeMatchup FIRE ROCK	= EFF_NOT
	|   typeMatchup FIRE DRAGON	= EFF_NOT
	|   typeMatchup FIRE STEEL	= EFF_SUPER
	|   typeMatchup WATER FIRE	= EFF_SUPER
	|   typeMatchup WATER WATER	= EFF_NOT
	|   typeMatchup WATER GRASS	= EFF_NOT
	|   typeMatchup WATER GROUND	= EFF_SUPER
	|   typeMatchup WATER ROCK	= EFF_SUPER
	|   typeMatchup WATER DRAGON	= EFF_NOT
	|   typeMatchup ELECTRIC WATER	= EFF_SUPER
	|   typeMatchup ELECTRIC ELECTRIC	= EFF_NOT
	|   typeMatchup ELECTRIC GRASS	= EFF_NOT
	|   typeMatchup ELECTRIC GROUND	= EFF_NONE
	|   typeMatchup ELECTRIC FLYING	= EFF_SUPER
	|   typeMatchup ELECTRIC DRAGON	= EFF_NOT
	|   typeMatchup GRASS FIRE	= EFF_NOT
	|   typeMatchup GRASS WATER	= EFF_SUPER
	|   typeMatchup GRASS GRASS	= EFF_NOT
	|   typeMatchup GRASS POISON	= EFF_NOT
	|   typeMatchup GRASS GROUND	= EFF_SUPER
	|   typeMatchup GRASS FLYING	= EFF_NOT
	|   typeMatchup GRASS BUG	= EFF_NOT
	|   typeMatchup GRASS ROCK	= EFF_SUPER
	|   typeMatchup GRASS DRAGON	= EFF_NOT
	|   typeMatchup GRASS STEEL	= EFF_NOT
	|   typeMatchup ICE FIRE	= EFF_NOT
	|   typeMatchup ICE WATER	= EFF_NOT
	|   typeMatchup ICE GRASS	= EFF_SUPER
	|   typeMatchup ICE ICE	= EFF_NOT
	|   typeMatchup ICE GROUND	= EFF_SUPER
	|   typeMatchup ICE FLYING	= EFF_SUPER
	|   typeMatchup ICE DRAGON	= EFF_SUPER
	|   typeMatchup ICE STEEL	= EFF_NOT
	|   typeMatchup FIGHTING NORMAL	= EFF_SUPER
	|   typeMatchup FIGHTING ICE	= EFF_SUPER
	|   typeMatchup FIGHTING POISON	= EFF_NOT
	|   typeMatchup FIGHTING FLYING	= EFF_NOT
	|   typeMatchup FIGHTING PSYCHIC	= EFF_NOT
	|   typeMatchup FIGHTING BUG	= EFF_NOT
	|   typeMatchup FIGHTING ROCK	= EFF_SUPER
	|   typeMatchup FIGHTING GHOST	= EFF_NONE
	|   typeMatchup FIGHTING DARK	= EFF_SUPER
	|   typeMatchup FIGHTING STEEL	= EFF_SUPER
	|   typeMatchup FIGHTING FAIRY	= EFF_NOT
	|   typeMatchup POISON GRASS	= EFF_SUPER
	|   typeMatchup POISON POISON	= EFF_NOT
	|   typeMatchup POISON GROUND	= EFF_NOT
	|   typeMatchup POISON ROCK	= EFF_NOT
	|   typeMatchup POISON GHOST	= EFF_NOT
	|   typeMatchup POISON STEEL	= EFF_NONE
	|   typeMatchup POISON FAIRY	= EFF_SUPER
	|   typeMatchup GROUND FIRE	= EFF_SUPER
	|   typeMatchup GROUND ELECTRIC	= EFF_SUPER
	|   typeMatchup GROUND GRASS	= EFF_NOT
	|   typeMatchup GROUND POISON	= EFF_SUPER
	|   typeMatchup GROUND FLYING	= EFF_NONE
	|   typeMatchup GROUND BUG	= EFF_NOT
	|   typeMatchup GROUND ROCK	= EFF_SUPER
	|   typeMatchup GROUND STEEL	= EFF_SUPER
	|   typeMatchup FLYING ELECTRIC	= EFF_NOT
	|   typeMatchup FLYING GRASS	= EFF_SUPER
	|   typeMatchup FLYING FIGHTING	= EFF_SUPER
	|   typeMatchup FLYING BUG	= EFF_SUPER
	|   typeMatchup FLYING ROCK	= EFF_NOT
	|   typeMatchup FLYING STEEL	= EFF_NOT
	|   typeMatchup PSYCHIC FIGHTING	= EFF_SUPER
	|   typeMatchup PSYCHIC POISON	= EFF_SUPER
	|   typeMatchup PSYCHIC PSYCHIC	= EFF_NOT
	|   typeMatchup PSYCHIC DARK	= EFF_NONE
	|   typeMatchup PSYCHIC STEEL	= EFF_NOT
	|   typeMatchup BUG FIRE	= EFF_NOT
	|   typeMatchup BUG GRASS	= EFF_SUPER
	|   typeMatchup BUG FIGHTING	= EFF_NOT
	|   typeMatchup BUG POISON	= EFF_NOT
	|   typeMatchup BUG FLYING	= EFF_NOT
	|   typeMatchup BUG PSYCHIC	= EFF_SUPER
	|   typeMatchup BUG GHOST	= EFF_NOT
	|   typeMatchup BUG DARK	= EFF_SUPER
	|   typeMatchup BUG STEEL	= EFF_NOT
	|   typeMatchup BUG FAIRY	= EFF_NOT
	|   typeMatchup ROCK FIRE	= EFF_SUPER
	|   typeMatchup ROCK ICE	= EFF_SUPER
	|   typeMatchup ROCK FIGHTING	= EFF_NOT
	|   typeMatchup ROCK GROUND	= EFF_NOT
	|   typeMatchup ROCK FLYING	= EFF_SUPER
	|   typeMatchup ROCK BUG	= EFF_SUPER
	|   typeMatchup ROCK STEEL	= EFF_NOT
	|   typeMatchup GHOST NORMAL	= EFF_NONE
	|   typeMatchup GHOST PSYCHIC	= EFF_SUPER
	|   typeMatchup GHOST GHOST	= EFF_SUPER
	|   typeMatchup GHOST DARK	= EFF_NOT
	|   typeMatchup DRAGON DRAGON	= EFF_SUPER
	|   typeMatchup DRAGON STEEL	= EFF_NOT
	|   typeMatchup DRAGON FAIRY	= EFF_NONE
	|   typeMatchup DARK FIGHTING	= EFF_NOT
	|   typeMatchup DARK PSYCHIC	= EFF_SUPER
	|   typeMatchup DARK GHOST	= EFF_SUPER
	|   typeMatchup DARK DARK	= EFF_NOT
	|   typeMatchup DARK FAIRY	= EFF_NOT
	|   typeMatchup STEEL FIRE	= EFF_NOT
	|   typeMatchup STEEL WATER	= EFF_NOT
	|   typeMatchup STEEL ELECTRIC	= EFF_NOT
	|   typeMatchup STEEL ICE	= EFF_SUPER
	|   typeMatchup STEEL ROCK	= EFF_SUPER
	|   typeMatchup STEEL STEEL	= EFF_NOT
	|   typeMatchup STEEL FAIRY	= EFF_SUPER
	|   typeMatchup FAIRY FIRE	= EFF_NOT
	|   typeMatchup FAIRY FIGHTING	= EFF_SUPER
	|   typeMatchup FAIRY POISON	= EFF_NOT
	|   typeMatchup FAIRY DRAGON	= EFF_SUPER
	|   typeMatchup FAIRY DARK	= EFF_SUPER
	|   typeMatchup FAIRY STEEL	= EFF_NOT
	|   typeMatchup _ _	= EFF_NEUTRAL;

	(* val typeMatchup2 : pkmnType -> (pkmnType * pkmnType) -> (pkmnTypeEff * pkmnTypeEff) *)
	fun typeMatchup2 t (t1, t2) = (typeMatchup t t1, typeMatchup t t2);

	(* Attacking T1 is ______ against defending T2 *)
	(* val typeOffIsSuper : pkmnType -> pkmnType -> bool *)
	fun typeOffIsSuper tOff tDef = (case (typeMatchup tOff tDef) of
		EFF_SUPER => true
	|	_ => false
	);

	(* val typeOffIsNotEffective : pkmnType -> pkmnType -> bool *)
	fun typeOffIsNotEffective tOff tDef = (case (typeMatchup tOff tDef) of
		EFF_NOT => true
	|	_ => false
	);

	(* val typeOffIsNeutral : pkmnType -> pkmnType -> bool *)
	fun typeOffIsNeutral tOff tDef = (case (typeMatchup tOff tDef) of
		EFF_NEUTRAL => true
	|	_ => false
	);

	(* val typeOffIsKill : pkmnType -> pkmnType -> bool *)
	fun typeOffIsKill tOff tDef = (case (typeMatchup tOff tDef) of
		EFF_NONE => true
	|	_ => false
	);

	(* Defending T1 is ______ against attacking T2 *)
	(* val typeDefIsResist : pkmnType -> pkmnType -> bool *)
	fun typeDefIsResist tDef tOff = (case (typeMatchup tOff tDef) of
		EFF_NOT => true
	|	_ => false
	);

	(* val typeDefIsWeak : pkmnType -> pkmnType -> bool *)
	fun typeDefIsWeak tDef tOff = (case (typeMatchup tOff tDef) of
		EFF_SUPER => true
	|	_ => false
	);

	(* val typeDefIsNeutral : pkmnType -> pkmnType -> bool *)
	fun typeDefIsNeutral tDef tOff = (case (typeMatchup tOff tDef) of
		EFF_NEUTRAL => true
	|	_ => false
	);

	(* val typeDefIsImmune : pkmnType -> pkmnType -> bool *)
	fun typeDefIsImmune tDef tOff = (case (typeMatchup tOff tDef) of
		EFF_NONE => true
	|	_ => false
	);

	(* Operators *)
	(* val op= : (pkmnType * pkmnType) -> bool *)
	fun op= (NONE, NONE) = true
	|   op= (NORMAL, NORMAL) = true
	|   op= (FIRE, FIRE) = true
	|   op= (WATER, WATER) = true
	|   op= (ELECTRIC, ELECTRIC) = true
	|   op= (GRASS, GRASS) = true
	|   op= (ICE, ICE) = true
	|   op= (FIGHTING, FIGHTING) = true
	|   op= (POISON, POISON) = true
	|   op= (GROUND, GROUND) = true
	|   op= (FLYING, FLYING) = true
	|   op= (PSYCHIC, PSYCHIC) = true
	|   op= (BUG, BUG) = true
	|   op= (ROCK, ROCK) = true
	|   op= (GHOST, GHOST) = true
	|   op= (DRAGON, DRAGON) = true
	|   op= (DARK, DARK) = true
	|   op= (STEEL, STEEL) = true
	|   op= (FAIRY, FAIRY) = true
	|   op= (_, _) = false;

	(* val op> : (pkmnType * pkmnType) -> bool *)
	fun op> (t1, t2) = typeOffIsSuper t1 t2;

	(* val op>= : (pkmnType * pkmnType) -> bool *)
	fun op>= (t1, t2) = (typeOffIsSuper t1 t2) orelse (typeOffIsNeutral t1 t2);

	(* val op< : (pkmnType * pkmnType) -> bool *)
	fun op< (t1, t2) = (typeOffIsNotEffective t1 t2) orelse (typeOffIsKill t1 t2);

	(* val op<= : (pkmnType * pkmnType) -> bool *)
	fun op<= (t1, t2) = (typeOffIsNotEffective t1 t2) orelse (typeOffIsKill t1 t2) orelse (typeOffIsNeutral t1 t2);

	(* val op<> : (pkmnType * pkmnType) -> bool *)
	fun op<> (t1, t2) = not(op=(t1, t2));

	(* val isSTAB : pkmnType -> (pkmnType * pkmnType) -> bool *)
	fun isSTAB t (t1, t2) = (t = t1) orelse (t = t2);

	(* val toString : pkmnType -> string *)
	fun toString NONE = "n/a"
	|   toString NORMAL = "Normal"
	|   toString FIRE = "Fire"
	|   toString WATER = "Water"
	|   toString ELECTRIC = "Electric"
	|   toString GRASS = "Grass"
	|   toString ICE = "Ice"
	|   toString FIGHTING = "Fighting"
	|   toString POISON = "Poison"
	|   toString GROUND = "Ground"
	|   toString FLYING = "Flying"
	|   toString PSYCHIC = "Psychic"
	|   toString BUG = "Bug"
	|   toString ROCK = "Rock"
	|   toString GHOST = "Ghost"
	|   toString DRAGON = "Dragon"
	|   toString DARK = "Dark"
	|   toString STEEL = "Steel"
	|   toString FAIRY = "Fairy";
end