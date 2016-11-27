signature GYMPRESTIGE =
sig
	datatype team = NONE | VALOR | MYSTIC | INSTINCT
	type gym
	exception FullGym
	exception InvalidTeam
	exception OverMaxLevel

	val teamSize : int
	val maxPrestige : int
	val minLevel : int
	val maxLevel : int
	val defenderPrestige : int
	val prestigePerDefeat : int
	val sweepBonus : int

	val tierList : int list

	val prestigeAtLevel : int -> int

	val new : team * int * int list -> gym

	val minSweeps : gym -> int

	val getLevel : gym -> int
	val setLevel : gym * int -> gym

	val getTeam : gym -> team
	val setTeam : gym * team -> gym

	val getPrestige : gym -> int
	val setPrestige : gym * int -> gym

	val prestigeToPrevLevel : gym -> int
	val prestigeToNextLevel : gym -> int

	val addDefender : gym * int -> gym
	val addPrestige : gym * int -> gym
	val dropPrestige : gym * int -> gym

	val trainingGain : int -> int -> {prestige : int, xp : int}
	val trainingGains : gym * int list -> {totalPrestige : int, totalXP : int, gains : {prestige : int, xp : int} list}
end
