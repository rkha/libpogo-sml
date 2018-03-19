functor PokemonGoFn (PoGoBaseStats : POGOBASESTATS) :> POKEMONGO =
struct
	(* Type for a specific Pokemon instance *)
	type pkmn = int * string option * (int * bool) * (int * int * int);

	exception PoGo_Unimplemented;
	exception PoGo_InvalidValue of string;
	exception PoGo_InvalidOperation of string;
	exception PoGo_Overflow;
	exception PoGo_Converge of pkmn list;

	(* Generate new Pokemon instance.
	 * Input is: species ID + nickname (optional) + levels + IVs
	 * IVs are in order of: Attack * Defense * HP. TODO: Change order to HP * Attack * Defense to match in-game representation
	 * Note that level is actually a pair of int and bool to
	 * specify half levels because I don't want to deal with floats.
	 *)
	(* val new : int * string option * (int * bool) * (int * int * int) -> pkmn *)
	fun new (id, nick, (level, half), (stamina, attack, defense)) = (id, nick, (level, half), (stamina, attack, defense));

	(* CpMultiplier: "\022\203\300=4d*>\371\350\\>\275\355\202>\242\233\224>\230e\244>\001\314\262>\341\036\300>\025\224\314>\354Q\330>\376\336\342>\351\363\354>i\237\366>r\355\377>\356s\004?r\313\010?\300\000\r?\323\026\021?;\020\025?5\357\030?W\266\034?\264f ?\325\001$?\030\211\'?\271\375*?\323`.?f\2631?]\3664?\212*8?\261P;?v\336<?\374h>?W\360??\233tA?\331\365B?$tD?\215\357E?#hG?\370\335H?\032QJ?" *)
	(* Battle stat methods *)
	(* val getHP : pkmn -> int *)
	fun getHPr (id, nick, (level, half), (stamina, attack, defense)) =
	let
		val cpMult = PoGoBaseStats.getCPMult (level, half)
		val baseStamina = PoGoBaseStats.getBaseStamina id
		val rStamina = Real.fromInt (baseStamina + stamina)
	in
		(*Real.floor*) (rStamina * cpMult)
	end;
	fun getHP pkmn = Int.max(10, Real.floor (getHPr pkmn));
	(* val getAttack : pkmn -> int *)
	fun getAttack (id, nick, (level, half), (stamina, attack, defense)) =
	let
		val cpMult = PoGoBaseStats.getCPMult (level, half)
		val baseAttack = PoGoBaseStats.getBaseAttack id
		val rAttack = Real.fromInt (baseAttack + attack)
	in
		Real.floor (rAttack * cpMult)
	end;
	(* val getDefense : pkmn -> int *)
	fun getDefense (id, nick, (level, half), (stamina, attack, defense)) =
	let
		val cpMult = PoGoBaseStats.getCPMult (level, half)
		val baseDefense = PoGoBaseStats.getBaseDefense id
		val rDefense = Real.fromInt (baseDefense + defense)
	in
		Real.floor (rDefense * cpMult)
	end;

	(* Forward calculation functions *)
	(* CP is calculated by the following formula:
	 * CP = ((Base Attack + IV Attack) * sqrt(Base Defense + IV Defense) * sqrt(Base Stamina + IV Stamina) * CP_Multiplier^2) / 10
	 * Note that the Gamepress formula is just poorly worded, the final formula's Attack / Defense don't include CP_Multiplier
	 *   even though they specify it in the section above.
	 * Taken from: https://pokemongo.gamepress.gg/pokemon-stats-advanced
	 *)
	(* val getCP : pkmn -> int *)
	fun getCPr (id, nick, (level, half), (stamina, attack, defense)) =
	let
		val cpMult = PoGoBaseStats.getCPMult (level, half)

		val pkmnHP = Real.fromInt ((PoGoBaseStats.getBaseStamina id) + stamina)
		val pkmnAtt = Real.fromInt ((PoGoBaseStats.getBaseAttack id) + attack)
		val pkmnDef = Real.fromInt ((PoGoBaseStats.getBaseDefense id) + defense)

		val pkmnCP = ((pkmnAtt) * (Math.sqrt(pkmnDef)) * (Math.sqrt(pkmnHP)) * (cpMult * cpMult)) / 10.0
	in
		(* Real.floor *) pkmnCP
	end;
	fun getCP pkmn = Int.max(10, Real.floor (getCPr pkmn));
	(* val getCPHP : pkmn -> int * int *)
	fun getCPHP pkmn = (getCP pkmn, getHP pkmn);

	(* Accessor methods *)
	(* val getID : pkmn -> int *)
	fun getID (id, _, _, _) = id;
	(* val getNick : pkmn -> string option *)
	fun getNick (_, nick, _, _) = nick;
	(* val getLevel : pkmn -> int * bool *)
	fun getLevel (_, _, (level, half), _) = (level, half);
	(* val getLevelf : pkmn -> real *)
	fun getLevelf (_, _, (level, half), _) =
		let
			val lvlr = Real.fromInt level
		in
			lvlr + (if half then 0.5 else 0.0)
		end;
	(* val getIVs : pkmn -> int * int * int *)
	fun getIVs (_, _, _, (sta, att, def)) = (sta, att, def);

	(* val getIVPerfection : pkmn -> real *)
	fun getIVPerfection (_, _, _, (sta, att, def)) = (Real.fromInt (sta+att+def)) / (Real.fromInt(PoGoBaseStats.maxIV + PoGoBaseStats.maxIV + PoGoBaseStats.maxIV));
	(* val getIVPerfectionRange : pkmn list -> (real * real) *)
	fun getIVPerfectionRangeHelper acc [] = acc
	|   getIVPerfectionRangeHelper (minPkmn, maxPkmn) (x :: L) =
	let
		val xPerfection = getIVPerfection x
		val newMin = Real.min(minPkmn, xPerfection);
		val newMax = Real.max(maxPkmn, xPerfection);
	in
		getIVPerfectionRangeHelper (newMin, newMax) L
	end;
	fun getIVPerfectionRange L = getIVPerfectionRangeHelper (100.0, 0.0) L;

	(* Individual IV accessor functions *)
	(* val getHPIV : pkmn -> int *)
	fun getHPIV (_, _, _, (hp, _, _)) = hp;
	(* val getAttackIV : pkmn -> int *)
	fun getAttackIV (_, _, _, (_, att, _)) = att;
	(* val getDefenseIV : pkmn -> int *)
	fun getDefenseIV (_, _, _, (_, _, def)) = def;

	fun isMaxLevel (_, _, (40, false), _) = true
	|   isMaxLevel _ = false;

	(* Pokemon modification functions.
	 * Returns a new Pokemon with the modified stat.
	 *)
	(* val powerUp : pkmn -> pkmn *)
	fun powerUp (id, nick, (level, false), ivs) = (id, nick, (level, true), ivs)
	|   powerUp (id, nick, (level, true), ivs) = (id, nick, (level+1, false), ivs);
	fun powerUpN 0 mon = mon
	|   powerUpN n mon = powerUpN (n-1) (powerUp mon);
	fun powerDown (_, _, (1, false), _) = raise PoGo_InvalidOperation "Attempting to power down below lv 1."
	|   powerDown (id, nick, (level, false), ivs) = (id, nick, (level-1, true), ivs)
	|   powerDown (id, nick, (level, true), ivs) = (id, nick, (level, false), ivs);
	fun powerUpsToTrainerCap trainerLv (mon as (_, _, (level, half), _)) =
	if ((level = (PoGoBaseStats.maxLevel)) orelse (false andalso (level = (trainerLv+2))) orelse (level >= (trainerLv+2)))
	then
		0
	else
		1 + (powerUpsToTrainerCap trainerLv (powerUp mon));
	fun powerUpToTrainerCap trainerLv (id, nick, (level, half), ivs) = (id, nick, (if ((trainerLv+2) > (PoGoBaseStats.maxLevel)) then (PoGoBaseStats.maxLevel) else (trainerLv+2), false), ivs);
	fun powerUpToCP targetCP mon =
	if ((getCP mon) > targetCP)
	then
		NONE
	else if ((getCP mon) = targetCP)
	then
		SOME mon
	else (powerUpToCP targetCP (powerUp mon));
	fun powerUpsToCP targetCP mon =
	if ((getCP mon) > targetCP)
	then
		NONE
	else if ((getCP mon) = targetCP)
	then
		SOME 0
	else (case (powerUpsToCP targetCP (powerUp mon)) of
		NONE => NONE
	|	SOME i => SOME (i+1)
	);

	(* val setLevel : pkmn -> (int * bool) -> pkmn *)
	fun setLevel (id, nick, (_, _), ivs) (newLevel, newHalf) = (id, nick, (newLevel, newHalf), ivs);
	(* val evolve : pkmn -> pkmn *)
	fun evolve evo (id, nick, (level, half), ivs) = (case (PoGoBaseStats.getEvos id) of
		[] =>		raise PoGo_InvalidOperation ("Cannot evolve Pokemon of ID: " ^ (Int.toString id))
	|	[evoID] =>	if (evo=evoID)
				then
					(evo, nick, (level, half), ivs)
				else if (evo=0)
				then
					(evoID, nick, (level, half), ivs)
				else
					raise PoGo_InvalidOperation ("Cannot evolve Pokemon of ID: " ^ (Int.toString id) ^ " to " ^ (Int.toString evo))
	|	evoList =>	if (not(evo=0) andalso (List.exists (fn x => x=evo) evoList))
					then (evo, nick, (level, half), ivs)
					else raise PoGo_InvalidOperation ("Evo ID is not a valid evo: " ^ (Int.toString evo))
	);

	(* Value export *)
	(* val export : pkmn -> int * string option * (int * bool) * (int * int * int) *)
	fun export mon = mon;
	fun exportr (mon as (id, nick, (level, half), ivs)) = (id, nick, getLevelf mon, ivs);
	(* val toString : pkmn -> string *)
	fun toString (id, nick, (level, half), (sta, att, def)) = raise PoGo_Unimplemented;

	val minIVs = (PoGoBaseStats.minIV, PoGoBaseStats.minIV, PoGoBaseStats.minIV);
	val maxIVs = (PoGoBaseStats.maxIV, PoGoBaseStats.maxIV, PoGoBaseStats.maxIV);
	fun nextIVs (15, 15, 15) = raise PoGo_Overflow
	|   nextIVs (sta, 15, 15) = (sta+1, 0, 0)
	|   nextIVs (sta, att, 15) = (sta, att+1, 0)
	|   nextIVs (sta, att, def) = (sta, att, def+1);
	fun allIVsHelper acc ivs = allIVsHelper (ivs :: acc) (nextIVs ivs) handle PoGo_Overflow => List.rev (ivs :: acc);
	fun allIVs() = allIVsHelper [] minIVs;
	fun generateAllIVsAtLevel id level = List.map (new) (List.map (fn ivs => (id, NONE, level, ivs)) (allIVs()));
	(* Reverse IV calculator method
	 * Takes in species ID and the CP and HP stats (in that order) and
	 *   the star dust cost and returns a list of possible Pokemon.
	 *)
	(* val reverseIV : int -> int * int * int -> pkmn list *)
	fun reverseIV id (cp, hp, cost) =
	let
		val possibleLevels = PoGoBaseStats.getLevelsFromCost(cost)
		val allPossibleCombinations = List.map (new) (List.foldr (fn (x,z) => z @ (List.map (fn ivs => (id, NONE, x, ivs)) (allIVs()))) [] possibleLevels)
		val validCombinations = List.filter (fn pkmn => (getCPHP pkmn) = (cp, hp)) allPossibleCombinations
	in
		validCombinations
	end;
	fun slowIntersect (L1, L2) = List.filter (fn x => List.exists (fn y => (getIVs x) = (getIVs y)) L1) L2;
	fun reverseIVs id [] = []
	|   reverseIVs id [(cp, hp, cost)] = reverseIV id (cp, hp, cost)
	|   reverseIVs id ((cp, hp, cost) :: L) = slowIntersect (reverseIV id (cp, hp, cost), reverseIVs id L);
	(* val reverseIVs2 : (int * (int * int * int)) list -> pkmn list *)
	fun reverseIVs2 [] = []
	|   reverseIVs2 [(id, (cp, hp, cost))] = reverseIV id (cp, hp, cost)
	|   reverseIVs2 ((id, (cp, hp, cost)) :: L) = slowIntersect (reverseIV id (cp, hp, cost), reverseIVs2 L);
	(* val reverseIVByName : string -> (int * int * int) -> pkmn list *)
	fun reverseIVByName name (cp, hp, cost) = reverseIV (PkmnBaseStats.getIDByName name) (cp, hp, cost);

	(* Reverse CP calculator method
	 * Takes in species ID and just the CP and tries to brute force all
	 *   possible IV and level combinations that would evaluate to the
	 *   given CP input. Tries to lessen work by linearly searching
	 *   for the levels with CP ranges that would contain the CP input
	 *   first. Too lazy to implement something better like binary search
	 *   right now. Future work.
	 *)
	(* val reverseCP : int -> int -> pkmn list *)
	fun reverseCPHelper id cpTarget level =
	let
		val minCP = getCP (new(id, NONE, level, minIVs));
		val maxCP = getCP (new(id, NONE, level, maxIVs));
	in
		((cpTarget >= minCP) andalso (cpTarget <= maxCP))
	end;
	fun reverseCP id cp =
	let
		val validLevels = List.filter (fn x => reverseCPHelper id cp x) (PoGoBaseStats.getAllLevels())
		val allPossibleCombinations = List.foldr (fn (lvl,combinations) => (generateAllIVsAtLevel id lvl) @ combinations) [] validLevels
	in
		List.filter (fn x => (getCP x) = cp) allPossibleCombinations
	end;
	fun reverseCPHP id (cp, hp) = List.filter (fn x => (getHP x) = hp) (reverseCP id cp);
	fun reverseCPByName monName cp =
	let
		val id = PkmnBaseStats.getIDByName monName
	in
		reverseCP id cp
	end;
	fun reverseCPs id [] = []
	|   reverseCPs id [cp] = reverseCP id cp
	|   reverseCPs id (cp1 :: cps) = slowIntersect (reverseCP id cp1, reverseCPs id cps);
	fun reverseCPsByName monName cps =
	let
		val id = PkmnBaseStats.getIDByName monName
	in
		reverseCPs id cps
	end;

	(* Appraisal function.
	 * Given an appraisal from your team leader, it will evaluate a
	 *   Pokemon and return true or false on whether the Pokemon's
	 *   IVs matches the appraisal. Basically the appraisal is used
	 *   as a filter function argument on the reverseIV list.
	 *)
	(* val appraise : int * int * (bool * bool * bool) -> pkmn -> bool *)
	fun appraise (ivrange, statRange, (hp, att, def)) (_, _, _, (staiv, attiv, defiv)) =
		let
			val sumIV = attiv + defiv + staiv
			(* Checks whether the sum of the IVs fits the range *)
			val rangeCheck = (case ivrange of
					1 => sumIV < 23
				|	2 => (sumIV < 30) andalso (sumIV > 22)
				|	3 => (sumIV < 37) andalso (sumIV > 29)
				|	4 => sumIV > 36
				|	_ => raise PoGo_InvalidValue("IV sum range mismatch.")
			)
			(* Checks whether a specific IV fits the range *)
			fun statRangeCheck n stat = (case n of
					4 => stat = 15
				|	3 => (stat = 13) orelse (stat = 14)
				|	2 => (stat < 13) andalso (stat > 7)
				|	1 => stat < 8
				|	_ => raise PoGo_InvalidValue("Bad top stat level, got: " ^ (Int.toString n))
			)
			val bestCheck = ((not att) orelse (statRangeCheck statRange attiv))
				andalso ((not def) orelse (statRangeCheck statRange defiv))
				andalso ((not hp) orelse (statRangeCheck statRange staiv))
				andalso (att orelse def orelse hp)

			(* Checks whether the top stats are equal to each other or not *)
			(* Also checks whether the top stat is actually the top stat *)
			fun eqCheck true true true = (staiv = attiv) andalso (staiv = defiv)
			|   eqCheck true true false = (staiv = attiv) andalso (not(staiv = defiv)) andalso (staiv > defiv)
			|   eqCheck true false true = (staiv = defiv) andalso (not(staiv = attiv)) andalso (staiv > attiv)
			|   eqCheck false true true = (attiv = defiv) andalso (not(staiv = attiv)) andalso (staiv < attiv)
			|   eqCheck true false false = (not(staiv = attiv)) andalso (not(staiv = defiv)) andalso (staiv > attiv) andalso (staiv > defiv)
			|   eqCheck false true false = (not(attiv = staiv)) andalso (not(attiv = defiv)) andalso (attiv > staiv) andalso (attiv > defiv)
			|   eqCheck false false true = (not(defiv = staiv)) andalso (not(defiv = staiv)) andalso (defiv > staiv) andalso (defiv > attiv)
			|   eqCheck false false false = false (*raise PoGo_InvalidValue("Bad appraisal, no highest stat.")*)

		in
			rangeCheck andalso bestCheck andalso (eqCheck hp att def)
		end

	(* Filter function.
	 * Filters all Pokemon in a list depending on list of flags set.
	 *)
	(* val filterPkmn : filterFlag list -> pkmn list -> pkmn list *)
	datatype filterFlag	= APPRAISE of int * int * (bool * bool * bool)
				| TRAINER of int
				| WILD
				| EGG
				| IVSUM of int
				| BESTSTAT of bool * bool * bool
				| MAXSTATRANGE of int
				| MINIV of int
				| MAXLEVEL of int
				| STARTER
				| NOTHALF
				| HALF
				| WEATHER
				| RAID
				| WEATHERRAID;

	fun filterTrainer trainerLevel (_, _, (lv, half), _) = lv <= (trainerLevel+1);
	fun filterWild (_, _, (lv, half), _) = ((not(half)) andalso (lv < 31));
	fun filterNotHalf (_, _, (_, half), _) = not(half);
	fun filterHalf (_, _, (_, half), _) = half;
	fun filterIVsum ivrange (_, _, _, (attiv, defiv, hpiv)) =
	let
		val sumIV = attiv + defiv + hpiv
	in
		(case ivrange of
				1 => sumIV < 23
			|	2 => (sumIV < 30) andalso (sumIV > 22)
			|	3 => (sumIV < 37) andalso (sumIV > 29)
			|	4 => sumIV > 36
			|	_ => raise PoGo_InvalidValue("IV sum range mismatch.")
		)
	end;
	(* Note to self: Clean this up and merge with apppraisal function *)
	fun filterBestStat (true, true, true) (_, _, _, (staiv, attiv, defiv)) = (staiv = attiv) andalso (staiv = defiv)
	|   filterBestStat (true, true, false) (_, _, _, (staiv, attiv, defiv)) = (staiv = attiv) andalso (not(staiv = defiv))
	|   filterBestStat (true, false, true) (_, _, _, (staiv, attiv, defiv)) = (staiv = defiv) andalso (not(staiv = attiv))
	|   filterBestStat (false, true, true) (_, _, _, (staiv, attiv, defiv)) = (attiv = defiv) andalso (not(staiv = attiv))
	|   filterBestStat (true, false, false) (_, _, _, (staiv, attiv, defiv)) = (not(staiv = attiv)) andalso (not(staiv = defiv)) andalso (staiv > attiv) andalso (staiv > defiv)
	|   filterBestStat (false, true, false) (_, _, _, (staiv, attiv, defiv)) = (not(attiv = staiv)) andalso (not(attiv = defiv)) andalso (attiv > staiv) andalso (attiv > defiv)
	|   filterBestStat (false, false, true) (_, _, _, (staiv, attiv, defiv)) = (not(defiv = staiv)) andalso (not(defiv = staiv)) andalso (defiv > staiv) andalso (defiv > attiv)
	|   filterBestStat (false, false, false) (_, _, _, (staiv, attiv, defiv)) = false (*raise PoGo_InvalidValue("Bad appraisal, no highest stat.")*);

	fun max3 (a,b,c) = if (a > b) then (if (a > c) then a else c) else (if (b > c) then b else c);

	fun filterMaxStatRange range (_, _, _, ivs) = (case range of
		4 => (max3 ivs) = 15
	|	3 => ((max3 ivs) = 13) orelse ((max3 ivs) = 14)
	|	2 => ((max3 ivs) > 8) andalso ((max3 ivs) < 13)
	|	1 => (max3 ivs) < 9
	|	_ => false
	);
	fun filterMinIV i (_, _, _, (staiv, attiv, defiv)) = (staiv >= i) andalso (attiv >= i) andalso (defiv >= i);
	fun filterMaxLevel i (_, _, (level, half), _) = if (level = i) then half else (level < i);
	fun filterEgg (mon as (_, _, (lv, false), _)) = (filterMaxLevel 20 mon) andalso (filterMinIV 10 mon)
	|   filterEgg _ = false;
	fun filterWeather (mon as (_, _, (lv, half), _)) = (filterNotHalf mon) andalso (filterMinIV 3 mon) andalso (filterMaxLevel 35 mon);
	fun filterRaid mon = filterEgg mon;
	fun filterWeatherRaid (mon as (_, _, (lv, half), _)) = (filterMaxLevel 25 mon) andalso (filterNotHalf mon) andalso (filterMinIV 10 mon);
	fun filterStarter (_, _, _, ivs) = ivs = (10,10,10);
	fun filterHelper (APPRAISE(appraisal)) L = List.filter (appraise appraisal) L
	|   filterHelper EGG L = List.filter (filterEgg) L
	|   filterHelper WILD L = List.filter (filterWild) L
	|   filterHelper (TRAINER(lv)) L = List.filter (filterTrainer lv) L
	|   filterHelper (IVSUM(i)) L = List.filter (filterIVsum i) L
	|   filterHelper (BESTSTAT(hp,att,def)) L = List.filter (filterBestStat (hp,att,def)) L
	|   filterHelper (MAXSTATRANGE(i)) L = List.filter (filterMaxStatRange i) L
	|   filterHelper (MINIV(i)) L = List.filter (filterMinIV i) L
	|   filterHelper (MAXLEVEL(i)) L = List.filter (filterMaxLevel i) L
	|   filterHelper STARTER L = List.filter (filterStarter) L
	|   filterHelper NOTHALF L = List.filter (filterNotHalf) L
	|   filterHelper HALF L = List.filter (filterHalf) L
	|   filterHelper WEATHER L = List.filter (filterWeather) L
	|   filterHelper RAID L = List.filter (filterRaid) L
	|   filterHelper WEATHERRAID L = List.filter (filterWeatherRaid) L;

	fun filterPkmn [] L = L
	|   filterPkmn (flag :: flags) L = filterPkmn flags (filterHelper flag L);

	fun diverge (mon1 as (id1, _, (lv1, half1), (hp1, att1, def1)), mon2 as (id2, _, lv2, (hp2, att2, def2))) =
	let
		val _ = (if ((lv1 = (PoGoBaseStats.maxLevel)) andalso half1) then raise PoGo_Converge [mon1,mon2] else ())
		val (cp1, hp1) = getCPHP mon1
		val (cp2, hp2) = getCPHP mon2
	in
		(if ((cp1=cp2) andalso (hp1=hp2))
		then
			(1 + (diverge (powerUp mon1, powerUp mon2)))
		else
			0
		)
	end;

	datatype 'a tree = LEAF of (int * 'a) | NODE of int * 'a tree list;
	fun listSplit f L = (List.filter f L, List.filter (fn x => not(f x)) L);
	fun divergeHelper powerUps L =
	let
		val ((_, _, (levelCheck, half), _) :: _) = L
		val _ = if ((levelCheck, half) = (40, true)) then raise PoGo_Converge L else ()
		fun groupingToTree powerUps [] = raise PoGo_InvalidValue "Grouping problem"
		|   groupingToTree powerUps [mon] = LEAF(powerUps, mon)
		|   groupingToTree powerUps L = NODE(
			powerUps,
			([(divergeHelper (powerUps+1)) (List.map (powerUp) L)] handle PoGo_Converge(L) => (List.map (fn x => groupingToTree (~1) [powerDown x]) L))
		)

		fun divergeHelperHelper acc [] = acc
		|   divergeHelperHelper acc (L as (mon :: _)) =
		let
			val (cp, hp) = getCPHP mon
			val (filtered, unfiltered) = listSplit (fn x => (getCPHP x) = (cp,hp)) L
		in
			divergeHelperHelper (filtered :: acc) unfiltered
		end
		val groupings = divergeHelperHelper [] L
		val childList = List.map (groupingToTree powerUps) groupings
	in
		NODE(powerUps, childList)
	end;
	fun treeToList (LEAF(powerUps, mon)) = [(powerUps, mon)]
	|   treeToList (NODE(_, L)) = List.foldr (fn(x,z) => x @ z) [] (List.map (treeToList) L);
	fun divergeL [] = []
	|   divergeL [mon] = [(0,mon)]
	|   divergeL L = treeToList (divergeHelper 0 L);

	(* val getCost : (int * pkmn) -> {dust : int, candy : int} *)
	fun getCost (0, mon) = {dust = 0, candy = 0}
	|   getCost (powerUps, mon as (_, _, level, _)) = if (powerUps < 0) then {dust = 0, candy = 0}
	else
	let
		val (currentDust, currentCandy) = PoGoBaseStats.getPowerUpCost level
		val {dust=recdust, candy=reccandy} = getCost (powerUps-1, powerUp mon)
	in
		{dust = currentDust + recdust, candy = currentCandy + reccandy}
	end;
	fun getCostToMax (mon as (_, _, (level, half), _)) =
	let
		val powerUpCount = powerUpsToTrainerCap 40 mon
	in
		getCost (powerUpCount, mon)
	end;

	(* val getCost : (int * pkmn) -> {dust : int, candy : int} *)
	fun getDivergeCost (0, mon) = {dust = 0, candy = 0}
	|   getDivergeCost (powerUps, mon) = if (powerUps < 0) then {dust = 0, candy = 0}
	else
	let
		val downMon = powerDown mon
		val (currentDust, currentCandy) = PoGoBaseStats.getPowerUpCost (getLevel downMon)
		val {dust=recdust, candy=reccandy} = getDivergeCost (powerUps-1, downMon)
	in
		{dust = currentDust + recdust, candy = currentCandy + reccandy}
	end;

	(* Note: Printing percentages, not straight reals. e.g. 0.5 = 50.00% *)
	fun printPercent digits r = Real.fmt (StringCvt.FIX (SOME digits)) (r * 100.0);
	fun printLevel (level, half) = Real.fmt (StringCvt.FIX (SOME 1)) ((Real.fromInt level) + (if (half) then 0.5 else 0.0));
	fun printPkmn (id, nickname, level, (hpiv, atkiv, defiv)) =
	let
		val basePkmn = PkmnBaseStats.getNameByID id
	in
		(case nickname of
			NONE => ("Level " ^ (printLevel level) ^ " " ^ basePkmn ^ " (#" ^ (Int.toString id) ^ ") - IVs: (" ^ (Int.toString hpiv) ^ "/" ^ (Int.toString atkiv) ^ "/" ^ (Int.toString defiv) ^ ")")
		|	SOME(nick) => (nick ^ " - Level " ^ (printLevel level) ^ " " ^ basePkmn ^ " (#" ^ (Int.toString id) ^ ") - IVs: (" ^ (Int.toString hpiv) ^ "/" ^ (Int.toString atkiv) ^ "/" ^ (Int.toString defiv) ^ ")")
		)
	end
	fun printDiverge (~1, mon) = ("Impossible to determine for: " ^ (printPkmn mon))
	|   printDiverge (steps, mon) = (Int.toString steps) ^ " powerups for Pokemon " ^ (printPkmn mon) ^ " - CP: " ^ (Int.toString (getCP mon)) ^ ", HP: " ^ (Int.toString (getHP mon));

	fun analyseHelper candidateList =
	let
		val divergenceList = ListMergeSort.sort (fn ((x,_), (y,_)) => (x < 0) orelse (x > y)) (divergeL candidateList)
		val (ivRangeStart, ivRangeEnd) = getIVPerfectionRange candidateList
	in
		if ((List.length candidateList) = 0) then (print ("Reverseal error: No valid candidates found.\n"); [])
		else
		(print("The IV perfection range is: " ^ (printPercent 2 ivRangeStart) ^ "% to " ^ (printPercent 2 ivRangeEnd) ^ "%.\n");
		print("Reversal candidates:\n");
		List.map (fn x => print ((printPkmn x) ^ "\n")) candidateList;
		print("Divergence results:\n");
		List.map (fn x => print ((printDiverge x) ^ "\n")) divergenceList;
		candidateList
		)
	end;
	(* Need to clean up *)
	fun analyseByName appraisalList monName (monStats as (hp, cp, dust)) =
	let
		val candidateList = filterPkmn appraisalList (reverseIVByName monName monStats)
	in
		analyseHelper candidateList
	end;

	fun analyseByNameL appraisalList monName monStats =
	let
		val monID = (PkmnBaseStats.getIDByName monName)
		val candidateList = filterPkmn appraisalList (reverseIVs monID monStats)
	in
		analyseHelper candidateList
	end;

	fun analyseCPByName appraisalList monName cp =
	let
		val candidateList = filterPkmn appraisalList (reverseCPByName monName cp)
	in
		analyseHelper candidateList
	end;

	fun analyseCPsByName appraisalList monName cps =
	let
		val candidateList = filterPkmn appraisalList (reverseCPsByName monName cps)
	in
		analyseHelper candidateList
	end;

	fun analysePkmnEvoHelper (mon as (id, nick, lvl, ivs)) =
	let
		val evoList = PkmnBaseStats.getEvos (PkmnBaseStats.getPkmn id)
		val finalEvoList = List.foldl (fn (x,z) => (PkmnBaseStats.getEvos (PkmnBaseStats.getPkmn x)) @ z) [] evoList
		val ultimateEvoList = (case finalEvoList of
			[] => evoList
		|       _ => finalEvoList
		);
		val _ = List.map (fn (xid, (xcp, xhp)) => print("Final evolution: " ^ (PkmnBaseStats.getNameByID xid) ^ ", Max CP: " ^ (Int.toString xcp) ^ ", Max HP: " ^ (Int.toString xhp) ^"\n")) (List.map (fn x => (x, getCPHP (x, nick, lvl, ivs))) ultimateEvoList);
	in
		()
	end;

	fun analysePkmn (mon as (id, nick, (level, half), (staiv, atkiv, defiv))) =
	let
		val () = print("Pokemon ID: " ^ (Int.toString id) ^ ", Species: " ^ (PkmnBaseStats.getNameByID id) ^ "\n")
		val () = (case nick of
				NONE => ()
			|	SOME(nickstr) => print("Nickname: " ^ nickstr ^ ", ")
			)
		val () = print("Level: " ^ (printLevel (level, half)) ^ "\n");
		val (ivRangeStart, _) = getIVPerfectionRange [mon]
		val () = print("IVs: " ^ (Int.toString staiv) ^ " STA / " ^ (Int.toString atkiv) ^ " ATK / " ^ (Int.toString defiv) ^ " DEF. " ^ (printPercent 2 ivRangeStart) ^ "% IV Perfection\n");

		val {dust=maxDust, candy=maxCandy} = getCostToMax mon
		val maxPowerUps = powerUpsToTrainerCap 40 mon
		val maxMon = powerUpToTrainerCap 40 mon
		val () = print("Cost to power up to max Level: " ^ (Int.toString maxDust) ^ " star dust, " ^ (Int.toString maxCandy) ^ " candy over " ^ (Int.toString maxPowerUps) ^ " power ups.\n");
		val (maxCP, maxHP) = getCPHP maxMon
		val () = print("Max CP: " ^ (Int.toString maxCP) ^ ", Max HP: " ^ (Int.toString maxHP) ^ "\n");
		val () = analysePkmnEvoHelper maxMon
	in
		()
	end
end
