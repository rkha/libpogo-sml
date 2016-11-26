signature POKEMONGO =
sig
	(* Type for a specific Pokemon instance *)
	type pkmn

	exception PoGo_Unimplemented
	exception PoGo_InvalidValue of string
	exception PoGo_InvalidOperation of string
	exception PoGo_Overflow;

	(* Generate new Pokemon instance.
	 * Input is: species ID + nickname (optional) + levels + IVs
	 * IVs are in order of: Attack * Defense * HP
	 * Note that level is actually a pair of int and bool to
	 * specify half levels because I don't want to deal with floats.
	 *)
	val new : int * string option * (int * bool) * (int * int * int) -> pkmn

	(* Battle stat methods *)
	val getHP : pkmn -> int
	val getHPr : pkmn -> real
	val getAttack : pkmn -> int
	val getDefense : pkmn -> int

	(* Forward calculation functions *)
	val getCP : pkmn -> int
	val getCPr : pkmn -> real
	val getCPHP : pkmn -> int * int

	(* Accessor methods *)
	val getID : pkmn -> int
	val getNick : pkmn -> string option
	val getLevel : pkmn -> int * bool
	val getLevelf : pkmn -> real
	val getIVs : pkmn -> int * int * int

	val getIVPerfection : pkmn -> real
	val getIVPerfectionRange : pkmn list -> (real * real)

	(* Individual IV accessor functions *)
	val getAttackIV : pkmn -> int
	val getDefenseIV : pkmn -> int
	val getHPIV : pkmn -> int

	(* Pokemon modification functions.
	 * Returns a new Pokemon with the modified stat.
	 *)
	val powerUp : pkmn -> pkmn
	val powerUpN : int -> pkmn -> pkmn
	val powerDown : pkmn -> pkmn
	val powerUpsToTrainerCap : int -> pkmn -> int
	val powerUpToTrainerCap : int -> pkmn -> pkmn
	val powerUpToCP : int -> pkmn -> pkmn option
	val powerUpsToCP : int -> pkmn -> int option
	val setLevel : pkmn -> (int * bool) -> pkmn
	val evolve : int -> pkmn -> pkmn

	(* Value export *)
	val export : pkmn -> int * string option * (int * bool) * (int * int * int)
	val exportr : pkmn -> int * string option * real * (int * int * int)

	(* Print out Pokemon *)
	val toString : pkmn -> string

	(* Reverse IV calculator method
	 * Takes in species ID and the CP and HP stats (in that order) and
	 *   the star dust cost and returns a list of possible Pokemon.
	 *)
	val reverseIV : int -> (int * int * int) -> pkmn list
	val reverseIVs : int -> (int * int * int) list -> pkmn list
	val reverseIVs2 : (int * (int * int * int)) list -> pkmn list
	val reverseIVByName : string -> (int * int * int) -> pkmn list

	(* Reverse CP calculator method
	 * Takes in species ID and just the CP and tries to brute force all
	 *   possible IV and level combinations that would evaluate to the
	 *   given CP input.
	 *)
	val reverseCP : int -> int -> pkmn list
	val reverseCPHP : int -> (int * int) -> pkmn list

	(* Appraisal function.
	 * Given an appraisal from your team leader, it will evaluate a
	 *   Pokemon and return true or false on whether the Pokemon's
	 *   IVs matches the appraisal. Basically used as a filter argument
	 *   on the reverseIV list.
	 *)
	val appraise : int * int * (bool * bool * bool) -> pkmn -> bool

	(* Filter function.
	 * Filters all Pokemon in a list depending on list of flags set.
	 *)
	datatype filterFlag	= APPRAISE of int * int * (bool * bool * bool)
				| TRAINER of int
				| WILD
				| EGG
				| IVSUM of int
				| BESTSTAT of bool * bool * bool
				| MAXSTATRANGE of int
				| MINIV of int
				| MAXLEVEL of int
				| STARTER;
	val filterPkmn : filterFlag list -> pkmn list -> pkmn list

	(* Need a pkmn list intersect function *)
	(* Diverge function *)
	val diverge : (pkmn * pkmn) -> int
	val divergeL : pkmn list -> (int * pkmn) list
	val getCost : (int * pkmn) -> {dust : int, candy : int}
	val getDivergeCost : (int * pkmn) -> {dust : int, candy : int}
end
