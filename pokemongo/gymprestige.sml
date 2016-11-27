structure GymPrestige :> GYMPRESTIGE =
struct
	datatype team = NONE | VALOR | MYSTIC | INSTINCT
	type gym = {team : team, prestige : int, defenders : int list};
	exception FullGym
	exception InvalidTeam
	exception OverMaxLevel

	(* Maybe put these values in a separate structure and make this a functor. *)
	val teamSize = 6;
	val maxPrestige = 50000;
	val minLevel = 1;
	val maxLevel = 10;
	val defenderPrestige = 2000;
	val prestigePerDefeat = 1000;
	val sweepBonus = 1000;

	val tierList = [0, 2000, 4000, 8000, 12000, 16000, 20000, 30000, 40000, 50000];

	(* val prestigeAtLevel : int -> int *)
	fun prestigeAtLevel lv = List.nth (tierList, lv-1) handle Subscript => raise OverMaxLevel;
	(* val levelAtPrestige : int -> int *)
	fun levelAtPrestige prestige =
		List.foldl (fn (x,z) => if (prestige >= x) then z+1 else z) 0 tierList;

	(* val new : team * int * int list -> gym *)
	fun new (team, prestige, defenders) = {team=team, prestige=prestige, defenders=defenders};

	fun dropDefender (gym as {team=team, prestige=prestige, defenders=defenders}) = (case defenders of
		[] => gym
	|	(x :: L) => {team=team, prestige=prestige, defenders=L}
	);
	fun trimToSize (L, 0) = L
	|   trimToSize ([], i) = []
	|   trimToSize (L as (x :: xs), i) = if ((List.length L) <= i) then L else trimToSize (xs, i);
	(* val getLevel : gym -> int *)
	fun getLevel {team=_, prestige=prestige, defenders=_} = levelAtPrestige prestige;

	(* val setLevel : gym * int -> gym *)
	fun setLevel (gym as {team=team, prestige=prestige, defenders=defenders}, newLevel) =
	let
		val tierThreshold = prestigeAtLevel newLevel
	in
		if ((getLevel gym) = newLevel)
		then
			gym
		else if (prestige < tierThreshold)
		then
			{team=team, prestige=tierThreshold, defenders=defenders}
		else
			{team=team, prestige=tierThreshold, defenders=trimToSize (defenders,newLevel)}
	end;

	(* val getTeam : gym -> team*)
	fun getTeam {team=team, prestige=_, defenders=_} = team;
	(* val setTeam : gym * team -> gym *)
	fun setTeam ({team=_, prestige=prestige, defenders=defenders}, newTeam) = {team=newTeam, prestige=prestige, defenders=defenders};

	(* val getPrestige : gym -> int *)
	fun getPrestige {team=_, prestige=prestige, defenders=_} = prestige;
	(* val setPrestige : gym * int -> gym *)
	fun setPrestige (gym as {team=team, prestige=prestige, defenders=defenders}, newPrestige) =
	let
		val newLevel = levelAtPrestige newPrestige
		val boundedNewPrestige = Int.min(prestigeAtLevel maxLevel, Int.max(prestigeAtLevel minLevel, newPrestige))
	in
		if (boundedNewPrestige > prestige)
		then
			{team=team, prestige=boundedNewPrestige, defenders=defenders}
		else
			{team=team, prestige=boundedNewPrestige, defenders=trimToSize (defenders, newLevel)}
	end;

	(* val prestigeToPrevLevel : gym -> int *)
	fun prestigeToPrevLevel (gym as {team=_, prestige=prestige, defenders=_}) =
	if ((getLevel gym) = minLevel)
	then
		0
	else
		prestige - (prestigeAtLevel (getLevel gym));
	(* val prestigeToNextLevel : gym -> int *)
	fun prestigeToNextLevel (gym as {team=_, prestige=prestige, defenders=_}) =
	if ((getLevel gym) = maxLevel)
	then
		0
	else
		(prestigeAtLevel ((getLevel gym) + 1)) - prestige;

	(* val addDefender : gym * int -> gym *)
	fun addDefender ({team=team, prestige=prestige, defenders=defenders}, cp) =
	if ((levelAtPrestige prestige) = (List.length defenders))
	then
		raise FullGym
	else
		{team=team, prestige=prestige+defenderPrestige, defenders=cp :: defenders};
	(* val addPrestige : gym * int -> gym *)
	fun addPrestige ({team=team, prestige=prestige, defenders=defenders}, extraPrestige) =
		{team=team,
		prestige=Int.min(prestigeAtLevel maxLevel, prestige+extraPrestige),
		defenders=defenders};
	(* val dropPrestige : gym * int -> gym *)
	fun dropPrestige (gym as {team=_, prestige=prestige, defenders=_}, lostPrestige) =
		setPrestige (gym, prestige-lostPrestige);

	(* val minSweeps : gym -> int *)
	fun minSweeps (gym as {team=team, prestige=prestige, defenders=defenders}) =
	let
		val prestigeLost = sweepBonus + ((List.length defenders) * prestigePerDefeat)
	in
		1 + (if (prestigeLost >= prestige)
		then
			0
		else
			minSweeps (dropPrestige (gym, prestigeLost))
		)
	end;

	(* val trainingGain : gym * int -> int *)
	fun trainingGain attacker defender =
	let
		val ratio = (Real.fromInt defender / Real.fromInt attacker)
		val (rPrestige, rXP) = 
		if (attacker > defender)
		then
			(Real.max((155.0 * ratio) - 27.0, 50.0), (31.0 * ratio) - 5.0)
		else
			(Real.min(250.0 * ratio, 500.0), 50.0 * ratio)
	in
		{prestige = Real.round rPrestige, xp = Real.round rXP}
	end;
	(* val trainingGains : gym * int list -> int list *)
	fun trainingGains (gym as {team=_, prestige=_, defenders=defenders}, team) =
	let
		val maxAttacker = List.foldl (fn (x,z) => if (x>z) then x else z) 0 team
		val gains = 
		if (maxAttacker > 0)
		then
			List.map (trainingGain maxAttacker) defenders
		else
			raise InvalidTeam
		val (totalPrestige, totalXP) =
			List.foldl (fn ({prestige=x,xp=y},(a,b)) => (x+a,b+y)) (0,0) gains
	in
		{totalPrestige=totalPrestige, totalXP=totalXP, gains=gains}
	end;
end
