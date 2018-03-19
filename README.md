# libpogo-sml
I wrote a Pokemon: GO IV Calculator library in Standard ML.

# Introduction
Do you play Pokemon: GO?
Do you find yourself wishing you had a library that wasn't written in some variant of JavaScript or VBscript that you could work with when computing your Pokemon's IVs?
Maybe other calculator apps don't tell you the specific piece of information you're looking for but you don't want to write your own library from scratch, or decipher another app's code / interface.
Or maybe you just want to gain a deeper understanding of a Pokemon's stats so that you can manage them more optimally (with regards to some arbitrary metric of your choosing).

Then this is the project for you!

This project aims to fully implement and make available all of the internal math and data involved with Pokemon: GO. You can (try to) figure out your Pokemon's IVs, predict how their CP would grow at any level, and even how many Power Ups you need to finally figure out whether your Pokemon is 88.8% IV perfection or 91.1% IV perfection because you powered up that 93 CP / 19 HP Horsea - that you caught - about 11 times already and it's driving you nuts that you still can't figure out what its IVs are yet.

And it's all available in one easy package. If it's in the game, it will eventually get included.
(You could probably make your own PoGo client with this or something)

# Main Features:
- Reverse IV calculation - Figure out a Pokemon's possible IVs from its CP, HP, and Power Up cost.
- Forward IV calculation - Figure out a Pokemon's CP and HP for an arbitrary IV and level combination.
- Reverse CP calculation - Figure out a Pokemon's possible IVs from its CP alone because you want to cheer yourself up with the fact that the 988 CP Dragonite probably had sub-50% IV perfection so it running away wasn't that much of a loss.
- Pokemon IV Divergence calculation - Figure out how many Power Ups you need to figure out when a list of possible IV combinations will diverge and confirm which IV combination is really is.

## Other Features:
- Filter Pokemon based on some attributes like whether it was a wild Pokemon catch, egg, appraisal, etc.
- Pokemon information lookup (name from ID, base stats, type information, etc.)
- Populated type matrix because you can't remember if Steel vs Water is neutral or the other way around or if Bug resists Psychic.
- Data for the first 802 Pokemon from Gen I to Gen VII

# Supported Standard ML Implementations:
- SML/NJ

Mainly because I use the ListPair structure. You could probably grab a copy for your own implementation and then fire it up.

# How To Compile/Use
- Download zip file
- Unzip somewhere
- Open your favourite command-line shell
- cd to libpogo-sml/
- Launch SML/NJ
- CM.make "pkmn.cm";
- Done!

# Basic Usage
## Checking the IVs of a 10 CP / 10 HP Pidgey
```sml
- PokemonGo.reverseIV 16 (10,10,200);
val it = [-,-,-,-,-,-,-,-,-,-,-,-,...] : PokemonGo.pkmn list
```

or

```sml
- PokemonGo.reverseIVByName "Pidgey" (10,10,200);
val it = [-,-,-,-,-,-,-,-,-,-,-,-,...] : PokemonGo.pkmn list
```

## Checking the IVs of a 10 CP / 10 HP Pidgey that you're sure was a wild catch or is not at a half level
```sml
- PokemonGo.filterPkmn [PokemonGo.WILD] (PokemonGo.reverseIV 16 (10,10,200));
val it = [-,-,-,-,-,-,-,-,-,-,-,-,...] : PokemonGo.pkmn list
```

## Checking the IVs of a wild Horsea with 93 CP / 19 HP / 400 Star Dust that Spark describes as "looks like it can really battle with the best of them", "Its best quality is its HP", and "Its stats are the best I've ever seen!".
```sml
- val horsea = PokemonGo.filterPkmn [PokemonGo.APPRAISE(4,4,(true,false,false)), PokemonGo.WILD] (PokemonGo.reverseIV 116 (93,19,400));
val horsea = [-,-,-,-,-,-,-,-] : PokemonGo.pkmn list
```

## Actually seeing its IVs or IV perfection percentage range
```sml
- List.map (PokemonGo.export) horsea;
[autoloading]
[autoloading done]
val it =
  [(116,NONE,(4,false),(15,12,13)),(116,NONE,(4,false),(15,12,14)),
   (116,NONE,(4,false),(15,13,11)),(116,NONE,(4,false),(15,13,12)),
   (116,NONE,(4,false),(15,13,13)),(116,NONE,(4,false),(15,14,9)),
   (116,NONE,(4,false),(15,14,10)),(116,NONE,(4,false),(15,14,11))]
  : (int * string option * (int * bool) * (int * int * int)) list
- PokemonGo.getIVPerfectionRange horsea;
val it = (0.844444444444,0.911111111111) : real * real
```
84.4% to 91.1%

Ranging from 15 HP / 14 Att / 9 Def to 15 HP / 13 Att / 13 Def

## Figure out how many Power Ups you need to figure out which IV combination it really is
```sml
- PokemonGo.divergeL horsea;
val it = [(10,-),(10,-),(24,-),(49,-),(49,-),(16,-),(33,-),(33,-)]
  : (int * PokemonGo.pkmn) list
```
Which means you need 10 to 49 Power Ups to figure it out. Holy toledo.

## Maybe if you evolve it to a Seadra first, you would need less Power Ups because you value Star Dust more than Horsea Candies
```sml
- val seadra = List.map (PokemonGo.evolve 117) horsea;
val seadra = [-,-,-,-,-,-,-,-] : PokemonGo.pkmn list
- PokemonGo.divergeL seadra;
val it = [(3,-),(3,-),(15,-),(15,-),(11,-),(7,-),(23,-),(23,-)]
  : (int * PokemonGo.pkmn) list
- List.map (fn (x,y) => (x,PokemonGo.getIVs y)) it;
val it =
  [(3,(15,14,11)),(3,(15,13,13)),(15,(15,14,10)),(15,(15,13,12)),
   (11,(15,12,14)),(7,(15,14,9)),(23,(15,13,11)),(23,(15,12,13))]
  : (int * (int * int * int)) list
```
The 91.1% cases require either 3 or 11 Power Ups, which isn't as bad anymore, if the Horsea/Seadra is truly 91.1%. If it's 84.4%, then you'll know after 7 Power Ups. The 15 or 23 Power Up cases only figure out which of the four 88.8% cases it is and that's a waste of Power Ups if you don't care about Pokemon under 90%.

## (NEW) You can also just skip all that manual work with the following one-liner:
```sml
- val horsea = analyseByName [APPRAISE(4,4,(true,false,false)),WILD] "Horsea" (93,19,400);
The IV perfection range is: 82.22% to 88.89%.
Reversal candidates:
Level 4.0 Horsea (#116) - IVs: (15/11/13)
Level 4.0 Horsea (#116) - IVs: (15/11/14)
Level 4.0 Horsea (#116) - IVs: (15/12/11)
Level 4.0 Horsea (#116) - IVs: (15/12/12)
Level 4.0 Horsea (#116) - IVs: (15/12/13)
Level 4.0 Horsea (#116) - IVs: (15/13/9)
Level 4.0 Horsea (#116) - IVs: (15/13/10)
Level 4.0 Horsea (#116) - IVs: (15/13/11)
Level 4.0 Horsea (#116) - IVs: (15/14/8)
Level 4.0 Horsea (#116) - IVs: (15/14/9)
Divergence results:
10 powerups for Pokemon Level 9.0 Horsea (#116) - IVs: (15/12/13) - CP: 229, HP: 29
12 powerups for Pokemon Level 10.0 Horsea (#116) - IVs: (15/14/8) - CP: 254, HP: 31
12 powerups for Pokemon Level 10.0 Horsea (#116) - IVs: (15/13/11) - CP: 256, HP: 31
12 powerups for Pokemon Level 10.0 Horsea (#116) - IVs: (15/14/9) - CP: 255, HP: 31
16 powerups for Pokemon Level 12.0 Horsea (#116) - IVs: (15/13/9) - CP: 304, HP: 34
24 powerups for Pokemon Level 16.0 Horsea (#116) - IVs: (15/13/10) - CP: 407, HP: 40
33 powerups for Pokemon Level 20.5 Horsea (#116) - IVs: (15/11/13) - CP: 521, HP: 45
33 powerups for Pokemon Level 20.5 Horsea (#116) - IVs: (15/12/11) - CP: 520, HP: 45
49 powerups for Pokemon Level 28.5 Horsea (#116) - IVs: (15/11/14) - CP: 727, HP: 53
49 powerups for Pokemon Level 28.5 Horsea (#116) - IVs: (15/12/12) - CP: 726, HP: 53
val horsea = [-,-,-,-,-,-,-,-,-,-] : pkmn list
```
What this means is that if after 10 powerups, the Horsea's stats are 229 CP and 29 HP, then its IVs are definitely 15/12/13 STA/ATK/DEF.

After 2 more powerups after that (aka. 12 total), if the stats are 254 CP and 31 HP, then its IVs are 15/14/8.

And so on.

This makes it easy to tell at a glance how much you will have to invest to figure out which of a Pokemon's multiple possible IV configurations it actually is, and also whether it is worth it. 49 powerups does not seem like it is worth it.

# FAQ
## Why?
Because nobody had forward IV calculation (at least, when I started), future gens past II, and divergence.

## No, I mean, like...WHY?
Why not?

# Coming Soon:
- ~~Version 2 Base Stats from Nov. 21, 2016 Update~~ (Done)
- ~~How much more dust / candy needed to reach a level target~~ (Done)
- ~~Lookups by name instead of just ID~~ (Done)
- Catch probabilities
- Catch bonuses
- Flee rates
- Expected number of Pokeballs used on a particular encounter
- Movelists
- More egg information
- ~~Gen VII Base Stats (Sun & Moon)~~ (Done)
- Alternate forms of existing Pokemon

## Coming Less Soon:
- Battle calculations
- C and Python ports

## Coming Soon When Niantic Feels Like It
- Gen II movesets
