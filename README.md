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
- Data for the first 721 Pokemon from Gen I to Gen VI

# Supported Standard ML Implementations:
- SML/NJ

Mainly because I use the ListPair structure. You could probably grab a copy for your own implementation and then fire it up.

# How To Compile/Use
- Download zip file
- Unzip somewhere
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

# FAQ
## Why?
Because nobody had forward IV calculation (at least, when I started), future gens past II, and divergence.

## No, I mean, like...WHY?
Why not?

# Coming Soon:
- ~~Version 2 Base Stats from Nov. 21, 2016 Update~~ (Done)
- How much more dust / candy needed to reach a level target
- Lookups by name instead of just ID
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
