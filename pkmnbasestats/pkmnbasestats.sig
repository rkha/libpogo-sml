signature PKMNBASESTATS =
sig
	(* pkmn = ID * Name * int list * (Type 1, Type 2) * (HP * Attack * Defense * Sp. Attack * Sp. Defense * Speed) *)
	type pkmnType = PkmnType.pkmnType
	type pkmn

	val getAllPokemon : unit -> pkmn list

	val getID : pkmn -> int
	val getName : pkmn -> string
	val getSpecies : pkmn -> int
	val getEvos : pkmn -> int list
	val getTypes : pkmn -> pkmnType * pkmnType
	val getHP : pkmn -> int
	val getAttack : pkmn -> int
	val getDefense : pkmn -> int
	val getSpAttack : pkmn -> int
	val getSpDefense : pkmn -> int
	val getSpeed : pkmn -> int
	val getStats : pkmn -> int * int * int * int * int * int

	val export : pkmn -> (int * string * int * int list * (pkmnType * pkmnType) * (int * int * int * int * int * int))
end