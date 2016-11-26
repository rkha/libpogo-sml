signature PKMNSTATS =
sig
	type pkmn = int * string * int * int list * (PkmnType.pkmnType * PkmnType.pkmnType) * (int * int * int * int * int * int);
	val getAllPokemon : unit -> pkmn list
end
