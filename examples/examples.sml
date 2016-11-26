(* EXAMPLES FOR USAGE *)
(* use "examples/examples.sml"; after loading CM.make *)

(* Checking the IVs of a 10 CP / 10 HP Pidgey. *)
val pidgeys = PokemonGo.reverseIV 16 (10,10,200);

(* Checking the IVs of a 10 CP / 10 HP Pidgey that you're sure was a wild
 * catch or is not at a half level.
 *)
val wildPidgeys = PokemonGo.filterPkmn [PokemonGo.WILD] (PokemonGo.reverseIV 16 (10,10,200));

(* Checking the IVs of an egg-hatched Ekans of 459 CP / 50 HP / 2500 Star Dust
 * that Spark describes as:
 * - "looks like it can really battle with the best of them"
 * - "Its best quality is its HP", and
 * - "Its stats are the best I've ever seen!"
 *)
val ekans = PokemonGo.filterPkmn [PokemonGo.APPRAISE(4,4,(true,false,false)), PokemonGo.EGG] (PokemonGo.reverseIV 23 (459,50,2500));

(* Actually seeing its IVs or IV perfection percentage range
 * instead an opaque hyphen.
 *)
val exportedEkans = List.map (PokemonGo.export) ekans;
val ekansRange = PokemonGo.getIVPerfectionRange ekans;

(* Figure out how many Power Ups you need to figure out which IV combination
 * it really is.
 *)
val ekansDiverge = PokemonGo.divergeL ekans;
