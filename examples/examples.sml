(* EXAMPLES FOR USAGE *)
(* use "examples/examples.sml"; after loading CM.make *)

(* Checking the IVs of a 10 CP / 10 HP Pidgey. *)
val pidgeys = PokemonGo.reverseIV 16 (10,10,200);

(* Checking the IVs of a 10 CP / 10 HP Pidgey that you're sure was a wild
 * catch or is not at a half level.
 *)
val wildPidgeys = PokemonGo.filterPkmn [PokemonGo.WILD] (PokemonGo.reverseIV 16 (10,10,200));

(* Checking the IVs of an egg-hatched Horsea of 93 CP / 19 HP / 400 Star Dust
 * that Spark describes as:
 * - "looks like it can really battle with the best of them"
 * - "Its best quality is its HP", and
 * - "Its stats are the best I've ever seen!"
 *)
val horsea = PokemonGo.filterPkmn [PokemonGo.APPRAISE(4,4,(true,false,false)), PokemonGo.WILD] (PokemonGo.reverseIV 116 (93,19,400));

(* Actually seeing its IVs or IV perfection percentage range
 * instead an opaque hyphen.
 *)
val exportedHorsea = List.map (PokemonGo.export) horsea;
val horseaRange = PokemonGo.getIVPerfectionRange horsea;

(* Figure out how many Power Ups you need to figure out which IV combination
 * it really is.
 *)
val horseaDiverge = PokemonGo.divergeL horsea;

(* Maybe if you evolve it to a Seadra first, you would need less Power Ups
 * because you value Star Dust more than Horsea Candies.
 *)
val seadra = List.map (PokemonGo.evolve 117) horsea;
val seadraDiverge = PokemonGo.divergeL seadra;
val exportedSeadraDiverge = List.map (fn (x,y) => (x,PokemonGo.getIVs y)) it;
