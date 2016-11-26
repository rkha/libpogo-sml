functor PkmnBaseStatsFn (PS : PKMNSTATS) :> PKMNBASESTATS =
struct
	type pkmnType = PkmnType.pkmnType
	type pkmn = int * string * int * int list * (pkmnType * pkmnType) * (int * int * int * int * int * int);

	exception InvalidPkmnName of string;

	val pkmnList = PS.getAllPokemon();

	(* getAllPokemon : unit -> pkmn list *)
	fun getAllPokemon() = pkmnList;

	(* val getPkmn : int -> pkmn *)
	fun getPkmn id = List.nth (pkmnList, id-1);
	
	(* getID : pkmn -> int *)
	fun getID (id, _, _, _, _, _) = id;
	(* getName : pkmn -> string *)
	fun getName (_, name, _, _, _, _) = name;
	(* val getIDByName : string -> int *)
	fun getIDByName name = (case (List.find (fn x => (getName x) = name) pkmnList) of
		NONE => raise InvalidPkmnName(name)
	|	SOME(pkmn) => getID pkmn
	);
	(* val getNameByID : int -> string *)
	fun getNameByID id = getName (getPkmn id);
	(* val getSpecies : pkmn -> int *)
	fun getSpecies (_, _, species, _, _, _) = species;
	(* val getEvos : pkmn -> int list *)
	fun getEvos (_, _, _, evos, _, _) = evos;
	(* getTypes : pkmn -> pkmnType * pkmnType *)
	fun getTypes (_, _, _, _, types, _) = types;
	(* getHP : pkmn -> int *)
	fun getHP (_, _, _, _, _, (hp, _, _, _, _, _)) = hp;
	(* getAttack : pkmn -> int *)
	fun getAttack (_, _, _, _, _, (_, atk, _, _, _, _)) = atk;
	(* getDefense : pkmn -> int *)
	fun getDefense (_, _, _, _, _, (_, _, def, _, _, _)) = def;
	(* getSpAttack : pkmn -> int *)
	fun getSpAttack (_, _, _, _, _, (_, _, _, spatk, _, _)) = spatk;
	(* getSpDefense : pkmn -> int *)
	fun getSpDefense (_, _, _, _, _, (_, _, _, _, spdef, _)) = spdef;
	(* getSpeed : pkmn -> int *)
	fun getSpeed (_, _, _, _, _, (_, _, _, _, _, spd)) = spd;
	(* getStats : pkmn -> int * int * int * int * int * int *)
	fun getStats (_, _, _, _, _, stats) = stats;

	(* export : pkmn -> (int * string * int list * (pkmnType * pkmnType) * (int * int * int * int * int * int)) *)
	fun export pkmn = pkmn;
end
