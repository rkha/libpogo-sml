(* Fun egg hatching log so you can keep track of your hatched Pokemon.
 * Just follow the format of the entries already in the egg list.
 * Name, appraisal, stats.
 * Appraisal order is: (stat total, best stat value, (highest stats))
 * Boolean order is: HP, Attack, Defense
 *
 * So the Diglett example is:
 * - Your Diglett is very strong! -> 3
 * - Its best stat is its HP. -> (true,false,false)
 * - It's definitely got some good stats. Definitely! -> 2
 * Put these together into: APPRAISE(3,2,(true,false,false))
 *
 * The EGG filter applies the following filters:
 * - Each IV is minimum 10 or higher
 * - It's not at a half level (aka. you didn't power it up yet)
 * - Max level is 20.
 * Basically an alias for: [MINIV(10), WILD, MAXLEVEL(20)]
 * Under the hood, EGG has its own implementation, but the results should be equivalent.
 *)
open PokemonGo;

fun eggCheck (species, appraisal, (cp,hp,dust)) = filterPkmn [EGG,appraisal] (reverseIV (PkmnBaseStats.getIDByName species) (cp,hp,dust));

val eggList = [
	("Diglett", APPRAISE(3,2,(true,false,false)), (237,19,2500)),
	("Paras", APPRAISE(4,4,(false,false,true)), (460,50,2500)),
	("Krabby", APPRAISE(3,3,(true,false,false)), (760,43,2500)),
	("Weedle", APPRAISE(3,3,(false,true,false)), (211,53,2500)),
	("Meowth", APPRAISE(3,3,(false,false,true)), (338,54,2500))
];

val eggIVs = List.map eggCheck eggList;
