signature POGOBASESTATS =
sig
	(* The Pokemon type that contains all the base stats per Pokemon *)
	type pkmnType
	type pkmn

	exception PoGoBaseStats_Unimplemented;

	(* Lookup functions, most of them take a Pokemon ID as input *)
	val getName : int -> string
	val getEvos : int -> int list
	val getEvoCost : int -> int
	val getFamily : int -> int
	val getBaseStamina : int -> int
	val getBaseAttack: int -> int
	val getBaseDefense : int -> int
	val getBaseStats : int -> int * int * int
	val getType1 : int -> pkmnType
	val getType2 : int -> pkmnType
	val getTypes : int -> pkmnType * pkmnType
	val getCaptureRate : int -> real
	val getFleeRate : int -> real

	(* In-game values *)
	val minIV : int
	val maxIV : int
	val minLevel : int
	val maxLevel : int
	val getAllLevels : unit -> (int * bool) list
	val powerUpsPerLevel : int
	val getDustCost : (int * bool) -> int
	val getCandyCost : (int * bool) -> int
	val getPowerUpCost : (int * bool) -> (int * int)
	val getLevelsFromCost : int -> (int * bool) list
	val stabMult : real
	val superMult : real
	val resistMult : real
	val getCPMult : (int * bool) -> real
end
