functor PoGoBaseStats20161121 (PkmnBaseStats : PKMNBASESTATS) :> POGOBASESTATS =
struct
	type pkmnType = PkmnType.pkmnType;
	(* The Pokemon type that contains all the base stats per Pokemon.
	 * ID * Name * Evolution(s) * Evo cost * Species * (Stamina, Attack, Defense) * Types * Capture Rate * Flee Rate
	 *)
	type pkmn = int * string * int list * int * int * (int * int * int) * (pkmnType * pkmnType) * real * real;

	exception PoGoBaseStats_Unimplemented;

	(* Helper function that just swaps the order of the tuple around so the
	 * larger value stays on the left because the new formula cares which
	 * value is greater.
	 *)
	fun pairMaxMin (r1, r2) = if (Real.<(r1,r2)) then (r2,r1) else (r1,r2);
	fun statScale (phys, spec) =
	let
		val (statHigh, statLow) = pairMaxMin (phys, spec)
	in
		Real.fromInt (Real.round (2.0 * ((7.0 * statHigh / 8.0) + (statLow / 8.0))))
	end;

	fun baseStatsToPoGo ((id, name, species, evos, (t1, t2), (hp, atk, def, spatk, spdef, spd)), (evoCost, captureRate, fleeRate)) =
	let
		val (rATK, rDEF, rSPATK, rSPDEF, rSPD) = (
			Real.fromInt atk, Real.fromInt def,
			Real.fromInt spatk, Real.fromInt spdef, Real.fromInt spd
		)

		val speedMult = 1.0 + ((rSPD - 75.0) / 500.0)

		val baseSta = 2 * hp
		val baseAtk = Real.round (statScale(rATK, rSPATK) * speedMult)
		val baseDef = Real.round (statScale(rDEF, rSPDEF) * speedMult)
	in
		(id, name, evos, evoCost, species, (baseSta, baseAtk, baseDef), (t1, t2), captureRate, fleeRate)
	end;

	(* Where the non-mainline stats go.
	 * Evolution candy cost * Capture rate * Flee rate
	 * cat GAME_MASTER_POKEMON_v0_2.tsv | cut -f 7,8,27 | awk ' { t = $3; $3 = $2; $2 = $1; $1 = t; print; } ' OFS=$', ' | sed 's/^/(/' | sed 's/$/),/' >> basestats.dat
	 *)
	val pogostatslist = [
		(25, 0.1599999964237213, 0.10000000149011612),
		(100, 0.07999999821186066, 0.07000000029802322),
		(0, 0.03999999910593033, 0.05000000074505806),
		(25, 0.1599999964237213, 0.10000000149011612),
		(100, 0.07999999821186066, 0.07000000029802322),
		(0, 0.03999999910593033, 0.05000000074505806),
		(25, 0.1599999964237213, 0.10000000149011612),
		(100, 0.07999999821186066, 0.07000000029802322),
		(0, 0.03999999910593033, 0.05000000074505806),
		(12, 0.4000000059604645, 0.20000000298023224),
		(50, 0.20000000298023224, 0.09000000357627869),
		(0, 0.10000000149011612, 0.05999999865889549),
		(12, 0.4000000059604645, 0.20000000298023224),
		(50, 0.20000000298023224, 0.09000000357627869),
		(0, 0.10000000149011612, 0.05999999865889549),
		(12, 0.4000000059604645, 0.20000000298023224),
		(50, 0.20000000298023224, 0.09000000357627869),
		(0, 0.10000000149011612, 0.05999999865889549),
		(25, 0.4000000059604645, 0.20000000298023224),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.1599999964237213, 0.10000000149011612),
		(0, 0.07999999821186066, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(25, 0.4000000059604645, 0.15000000596046448),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(25, 0.4000000059604645, 0.15000000596046448),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(50, 0.23999999463558197, 0.10000000149011612),
		(0, 0.07999999821186066, 0.05999999865889549),
		(50, 0.23999999463558197, 0.10000000149011612),
		(0, 0.07999999821186066, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.20000000298023224),
		(0, 0.1599999964237213, 0.07000000029802322),
		(25, 0.47999998927116394, 0.15000000596046448),
		(100, 0.23999999463558197, 0.07000000029802322),
		(0, 0.11999999731779099, 0.05000000074505806),
		(50, 0.3199999928474426, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.23999999463558197, 0.10000000149011612),
		(0, 0.07999999821186066, 0.05999999865889549),
		(25, 0.4000000059604645, 0.15000000596046448),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(25, 0.4000000059604645, 0.9900000095367432),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(25, 0.4000000059604645, 0.10000000149011612),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(25, 0.4000000059604645, 0.15000000596046448),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(25, 0.4000000059604645, 0.10000000149011612),
		(100, 0.20000000298023224, 0.07000000029802322),
		(0, 0.10000000149011612, 0.05000000074505806),
		(50, 0.3199999928474426, 0.10000000149011612),
		(0, 0.11999999731779099, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(0, 0.23999999463558197, 0.09000000357627869),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.09000000357627869),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(25, 0.3199999928474426, 0.10000000149011612),
		(100, 0.1599999964237213, 0.07000000029802322),
		(0, 0.07999999821186066, 0.05000000074505806),
		(0, 0.1599999964237213, 0.09000000357627869),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.3199999928474426, 0.10000000149011612),
		(0, 0.11999999731779099, 0.05999999865889549),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.1599999964237213, 0.09000000357627869),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.3199999928474426, 0.09000000357627869),
		(0, 0.1599999964237213, 0.09000000357627869),
		(50, 0.4000000059604645, 0.10000000149011612),
		(0, 0.1599999964237213, 0.05999999865889549),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.07000000029802322),
		(50, 0.4000000059604645, 0.15000000596046448),
		(0, 0.1599999964237213, 0.05999999865889549),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(0, 0.23999999463558197, 0.09000000357627869),
		(400, 0.5600000023841858, 0.15000000596046448),
		(0, 0.07999999821186066, 0.07000000029802322),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.1599999964237213, 0.10000000149011612),
		(25, 0.3199999928474426, 0.10000000149011612),
		(0, 0.11999999731779099, 0.05999999865889549),
		(0, 0.11999999731779099, 0.05999999865889549),
		(0, 0.11999999731779099, 0.05999999865889549),
		(0, 0.3199999928474426, 0.09000000357627869),
		(50, 0.3199999928474426, 0.09000000357627869),
		(0, 0.11999999731779099, 0.05000000074505806),
		(50, 0.3199999928474426, 0.09000000357627869),
		(0, 0.11999999731779099, 0.05000000074505806),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.1599999964237213, 0.09000000357627869),
		(0, 0.0, 0.10000000149011612),
		(0, 0.0, 0.10000000149011612),
		(0, 0.0, 0.10000000149011612),
		(25, 0.3199999928474426, 0.09000000357627869),
		(100, 0.07999999821186066, 0.05999999865889549),
		(0, 0.03999999910593033, 0.05000000074505806),
		(0, 0.0, 0.10000000149011612),
		(0, 0.0, 0.10000000149011612),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0),
		(0, 0.0, 0.0)
	];
	val pkmnList = List.map (baseStatsToPoGo) (ListPair.zip (List.map (PkmnBaseStats.export) (PkmnBaseStats.getAllPokemon()), pogostatslist));
	val dustList = [
		200, 200, 200, 200, 400, 400, 400, 400,
		600, 600, 600, 600, 800, 800, 800, 800,
		1000, 1000, 1000, 1000, 1300, 1300, 1300, 1300,
		1600, 1600, 1600, 1600, 1900, 1900, 1900, 1900,
		2200, 2200, 2200, 2200, 2500, 2500, 2500, 2500,
		3000, 3000, 3000, 3000, 3500, 3500, 3500, 3500,
		4000, 4000, 4000, 4000, 4500, 4500, 4500, 4500,
		5000, 5000, 5000, 5000, 6000, 6000, 6000, 6000,
		7000, 7000, 7000, 7000, 8000, 8000, 8000, 8000,
		9000, 9000, 9000, 9000, 10000, 10000, 10000, 10000
	];
	val candyList = [
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 2, 2, 2, 2,
		2, 2, 2, 2, 2, 2, 2, 2,
		2, 2, 2, 2, 2, 2, 2, 2,
		3, 3, 3, 3, 3, 3, 3, 3,
		3, 3, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 6, 6, 6, 6,
		8, 8, 8, 8, 10, 10, 10, 10,
		12, 12, 12, 12, 15, 15, 15, 15
	];
	(* Taken from: https://www.reddit.com/r/pokemongodev/comments/4t59t1/decoded_game_master_protobuf_file_v01_all_pokemon/d5f2y91/ *)
	val multList = [ 0.094     ,  0.16639787,  0.21573247,  0.25572005,  0.29024988,
        0.3210876 ,  0.34921268,  0.37523559,  0.39956728,  0.42250001,
        0.44310755,  0.46279839,  0.48168495,  0.49985844,  0.51739395,
        0.53435433,  0.55079269,  0.56675452,  0.58227891,  0.59740001,
        0.61215729,  0.62656713,  0.64065295,  0.65443563,  0.667934  ,
        0.68116492,  0.69414365,  0.70688421,  0.71939909,  0.7317    ,
        0.73776948,  0.74378943,  0.74976104,  0.75568551,  0.76156384,
        0.76739717,  0.7731865 ,  0.77893275,  0.78463697,  0.79030001
    ];

	(* Lookup functions, most of them take a Pokemon ID as input *)
	(* val getName : int -> string *)
	fun getName pkmn =
	let
		val (_, pkmnName, _, _, _, _, _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		pkmnName
	end;

	(* val getEvos : int -> int option *)
	fun getEvos pkmn =
	let
		val (_, _, evoIDs, _, _, _, _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		evoIDs
	end;

	(* val getEvoCost : int -> int *)
	fun getEvoCost pkmn =
	let
		val (_, _, _, evoCost, _, _, _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		evoCost
	end;

	(* val getFamily : int -> int *)
	fun getFamily pkmn =
	let
		val (_, _, _, _, familyID, _, _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		familyID
	end;

	(* val getBaseStamina : int -> int *)
	fun getBaseStamina pkmn =
	let
		val (_, _, _, _, _, (sta, _, _), _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		sta
	end;
	(* val getBaseAttack: int -> int *)
	fun getBaseAttack pkmn =
	let
		val (_, _, _, _, _, (_, att, _), _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		att
	end;
	(* val getBaseDefense : int -> int *)
	fun getBaseDefense pkmn =
	let
		val (_, _, _, _, _, (_, _, def), _, _, _) = List.nth(pkmnList, pkmn-1)
	in
		def
	end;
	(* val getBaseStats : int -> int * int * int *)
	fun getBaseStats pkmn = (getBaseStamina pkmn, getBaseAttack pkmn, getBaseDefense pkmn);

	(* val getType1 : int -> pkmnType *)
	fun getType1 pkmn =
	let
		val (_, _, _, _, _, _, (t1, _), _, _) = List.nth(pkmnList, pkmn-1)
	in
		t1
	end;
	(* val getType2 : int -> pkmnType *)
	fun getType2 pkmn =
	let
		val (_, _, _, _, _, _, (_, t2), _, _) = List.nth(pkmnList, pkmn-1)
	in
		t2
	end;
	(* val getTypes : int -> pkmnType * pkmnType *)
	fun getTypes pkmn = (getType1 pkmn, getType2 pkmn);
	(* val getCaptureRate : int -> real *)
	fun getCaptureRate pkmn =
	let
		val (_, _, _, _, _, _, _, captureRate, _) = List.nth(pkmnList, pkmn-1)
	in
		captureRate
	end;
	(* val getFleeRate : int -> real *)
	fun getFleeRate pkmn =
	let
		val (_, _, _, _, _, _, _, _, fleeRate) = List.nth(pkmnList, pkmn-1)
	in
		fleeRate
	end;

	(* In-game values *)
	val minIV = 0;
	val maxIV = 15;
	(* val minLevel : int *)
	val minLevel = 1;
	(* val maxLevel : int *)
	val maxLevel = 40;
	(* val powerUpsPerLevel : int *)
	val powerUpsPerLevel = 2;
	fun getNextLevel (level, false) = (level, true)
	|   getNextLevel (level, true) = (level+1, false);
	fun getAllLevelsHelper acc (40, false) = List.rev acc
	|   getAllLevelsHelper acc level = getAllLevelsHelper (level :: acc) (getNextLevel level);
	fun getAllLevels() = getAllLevelsHelper [] (minLevel, false);
	(* val levelToPowerUps : (int * bool) -> int *)
	fun levelToPowerUps (level, half) = ((level - minLevel) * powerUpsPerLevel) + (if (half) then 1 else 0);

	(* val getDustCost : (int * bool) -> int *)
	fun getDustCost (level, half) = List.nth(dustList, (levelToPowerUps (level, half)) );
	(* val getCandyCost : (int * bool) -> int *)
	fun getCandyCost (level, half) = List.nth(candyList, (levelToPowerUps (level, half)) );
	(* val getPowerUpCost : (int * bool) -> (int * int) *)
	fun getPowerUpCost (level, half) = (getDustCost (level, half), getCandyCost (level, half));
	(* val getLevelFromCost : int -> (int * bool) list *)
	fun getLevelsFromCost cost = List.foldr (fn (x,z) => if ((getDustCost x) = cost) then (x::z) else z) [] (getAllLevels());
	(* val stabMult : real *)
	val stabMult = 1.25;
	(* val superMult : real *)
	val superMult = 1.25;
	(* val resistMult : real *)
	val resistMult = 0.80;
	(* val getCPMult : (int * bool) -> real *)
	fun getCPMult (level, false) = List.nth(multList, level-1)
	|   getCPMult (level, true) = Math.sqrt((Math.pow(List.nth(multList, level-1), 2.0) + Math.pow(List.nth(multList, level), 2.0)) / 2.0);
end
