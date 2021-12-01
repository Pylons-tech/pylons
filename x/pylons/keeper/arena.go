package keeper

import (
	"encoding/binary"
	"fmt"
	"math/rand"
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetTradeCount get the total number of TypeName.LowerCamel
func (k Keeper) GetFighterCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterCountKey))
	byteKey := types.KeyPrefix(types.FighterCountKey)
	bz := store.Get(byteKey)

	// Count doesn't exist: no element
	if bz == nil {
		return 0
	}

	// Parse bytes
	count, err := strconv.ParseUint(string(bz), 10, 64)
	if err != nil {
		// Panic because the count should be always formattable to uint64
		panic("cannot decode count")
	}

	return count
}

// SetFighterCount set the total number of trade
func (k Keeper) SetFighterCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterCountKey))
	byteKey := types.KeyPrefix(types.FighterCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendFighter appends a fighter in the store with a new id and update the count
func (k Keeper) AppendFighter(
	ctx sdk.Context,
	fighter types.Fighter,
) uint64 {
	// Create the Listing of the Fighter
	count := k.GetFighterCount(ctx)

	// Set the ID of the appended value
	fighter.ID = count

	k.SetFighter(ctx, fighter)

	// Update trade count
	k.SetFighterCount(ctx, count+1)

	return count
}

// SetFighter set a specific fighter in the store
func (k Keeper) SetFighter(ctx sdk.Context, fighter types.Fighter) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	b := k.cdc.MustMarshal(&fighter)

	addr, _ := sdk.AccAddressFromBech32(fighter.Creator)
	k.addFighterToAddress(ctx, getFighterIDBytes(fighter.ID), addr)

	store.Set(getFighterIDBytes(fighter.ID), b)
}

// GetFighter returns a fighter from its id
func (k Keeper) GetFighter(ctx sdk.Context, id uint64) types.Fighter {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	var fighter types.Fighter
	k.cdc.MustUnmarshal(store.Get(getFighterIDBytes(id)), &fighter)
	return fighter
}

// HasFighter checks if the fighter exists in the store
func (k Keeper) HasFighter(ctx sdk.Context, id uint64) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	return store.Has(getFighterIDBytes(id))
}

// GetFighterOwner returns the creator of the
func (k Keeper) GetFighterOwner(ctx sdk.Context, id uint64) string {
	return k.GetFighter(ctx, id).Creator
}

// RemoveFighter removes a fighter from the store
func (k Keeper) RemoveFighter(ctx sdk.Context, id uint64, creator sdk.AccAddress) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	k.removeFighterFromAddress(ctx, getFighterIDBytes(id), creator)
	store.Delete(getFighterIDBytes(id))
}

// GetAllTrade returns all fighters
func (k Keeper) GetAllFighters(ctx sdk.Context) (list []types.Fighter) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Fighter
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

func getFighterIDBytes(id uint64) []byte {
	bz := make([]byte, 8)
	binary.BigEndian.PutUint64(bz, id)
	return bz
}

func (k Keeper) addFighterToAddress(ctx sdk.Context, FighterIDBytes []byte, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrFighterKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	addrStore.Set(FighterIDBytes, FighterIDBytes)
}

func (k Keeper) removeFighterFromAddress(ctx sdk.Context, FighterIDBytes []byte, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrFighterKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	addrStore.Delete(FighterIDBytes)
}

func (k Keeper) GetFightersByCreatorPaginated(ctx sdk.Context, creator sdk.AccAddress, pagination *query.PageRequest) ([]types.Fighter, *query.PageResponse, error) {
	fighters := make([]types.Fighter, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrFighterKey))
	store = prefix.NewStore(store, creator.Bytes())

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		id := binary.BigEndian.Uint64(value)
		fighter := k.GetFighter(ctx, id)
		fighters = append(fighters, fighter)
		return nil
	})

	if err != nil {
		return nil, nil, err
	}

	return fighters, pageRes, nil
}

func (k Keeper) Battle(ctx sdk.Context, FighterA types.Fighter, FighterB types.Fighter) (winner string, log string, err error) {

	type attack struct {
		damage     float64
		accuracy   float64
		damagetype string
		weaponName string
	}

	type combattant struct {
		attacks    []attack
		name			 string
		initiative float64
		armorName  string
		shieldName string
		sliceArmor float64
		bluntArmor float64
		stabArmor  float64
		boltArmor  float64
		hp         float64
	}

	// first we go through all items and calculate all data that is necessary for a nice bout
	calculateCombatSpecs := func(fighter types.Fighter) (readyFighter combattant, err error) {
		items := []string{fighter.LHitem, fighter.RHitem, fighter.Armoritem, fighter.NFT}

		readyFighter = combattant{
			attacks:    []attack{},
			name:				"no name yet",
			shieldName: "",
			initiative: 0.0,
			sliceArmor: 0.0,
			bluntArmor: 0.0,
			stabArmor:  0.0,
			boltArmor:  0.0,
			hp:         20.0,
		}

		// go through all items that are relevant for combat
		for index, itemIDstring := range items {
			item, _ := k.GetItem(ctx, fighter.CookbookID, itemIDstring)
			shield := false
			nft := false
			armor := false

			// string properties of items are read and saved
			for _, prop := range item.Strings {
				if prop.Key == "ItemType" {
					if prop.Value == "shield" {
						shield = true
					}
				}
				if prop.Key == "ItemType" {
					if prop.Value == "nft" {
						nft = true
					}
				}
				if prop.Key == "ItemType" {
					if prop.Value == "armor" {
						armor = true
					}
				}
				if prop.Key == "oneHanded" {
					// if the first item is inspected, only add it if it's one handed,
					// the second item is only added if there is none added yet or if it's one handed
					if index == 0 && prop.Value == "true" {
						readyFighter.attacks = append(readyFighter.attacks, attack{0, 1.0, "undefined", "undefined"})
					} else if len(readyFighter.attacks) == 0 || prop.Value == "true" {
						readyFighter.attacks = append(readyFighter.attacks, attack{0, 1.0, "undefined", "undefined"})
					}
				}

				//fmt.Println(prop.Key, prop.Value)
			}
			// second run necessary because attacks just exist now
			for _, prop := range item.Strings {
				if prop.Key == "DamageType" {
					readyFighter.attacks[index].damagetype = prop.Value
				}
				// write down the weapon names
				if prop.Key == "name" && index < 2 && !shield && !nft && !armor{
					readyFighter.attacks[index].weaponName = prop.Value
				} else if prop.Key == "name" && nft {
					readyFighter.name = prop.Value
				} else if prop.Key == "name" && armor {
					readyFighter.armorName = prop.Value
				} else if prop.Key == "name" && shield {
					readyFighter.shieldName = prop.Value
				}
			}

			// double properties of items are read and saved
			for _, prop := range item.Doubles {
				if prop.Key == "initiative" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.initiative += val
				} else if prop.Key == "accuracyModifier" {
					for i, _ := range readyFighter.attacks {
						val, err := prop.Value.Float64()
						if err != nil {
							return readyFighter, err
						}
						readyFighter.attacks[i].accuracy *= val
					}
				} else if prop.Key == "sliceDef" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.sliceArmor += val
				} else if prop.Key == "bluntDef" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.bluntArmor += val
				} else if prop.Key == "stabDef" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.stabArmor += val
				} else if prop.Key == "boltDef" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.boltArmor += val
				} else if prop.Key == "damage" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.attacks[index].damage += val
				} else if prop.Key == "accuracy" {
					val, err := prop.Value.Float64()
					if err != nil {
						return readyFighter, err
					}
					readyFighter.attacks[index].accuracy *= val
				}

				//fmt.Println(prop.Key, prop.Value)
			}
			//fmt.Println("--------")
		}
		return readyFighter, nil
	}

	combattantA, err := calculateCombatSpecs(FighterA)
	combattantB, err := calculateCombatSpecs(FighterB)

	// here this print should be removed it is for debugging
	//fmt.Println("Fighter A:",combattantA)
	//fmt.Println("Fighter B:",combattantB)

	combatLog := "EPIC BATTLE BEGINS\n"

	openerText := func (fighter combattant) string {
		weaponsString := ""
		shieldString := ""
		if len(fighter.shieldName) > 0 {
			shieldString = fmt.Sprintf("%swears a %s, ", weaponsString, fighter.shieldName)
		}
		for i, attack := range fighter.attacks {

			if i > 0 {
				weaponsString = fmt.Sprintf("%s and", weaponsString)
			}
			weaponsString = fmt.Sprintf("%s%s ", weaponsString, attack.weaponName)
		}
		return fmt.Sprintf("%s %spulls out %sand equips %s\n", fighter.name, shieldString, weaponsString, fighter.armorName)
	}

	combatLog = fmt.Sprintf("%s%s", combatLog, openerText(combattantA))
	combatLog = fmt.Sprintf("%s%s", combatLog, openerText(combattantB))

	// here is defined how one round in a combat from one attacker works (so a full round needs to run this 2 times)
	combatRound := func(attacker *combattant, defender *combattant) {
		for _, attack := range attacker.attacks {
			if rand.Float64() > attack.accuracy {
				damageReduction := 0.0
				if attack.damagetype == "slice" {
					damageReduction = defender.sliceArmor
				} else if attack.damagetype == "blunt" {
					damageReduction = defender.bluntArmor
				} else if attack.damagetype == "stab" {
					damageReduction = defender.stabArmor
				} else if attack.damagetype == "bolt" {
					damageReduction = defender.boltArmor
				}
				damage := attack.damage - damageReduction
				defender.hp -= damage

				combatLog = fmt.Sprintf("%sHits with %s! %s's HP: %.0f\n", combatLog, attack.weaponName, defender.name, defender.hp)
			} else {
				combatLog = fmt.Sprintf("%sStrikes with %s, EPIC FAIL!\n", combatLog, attack.weaponName)
			}
		}
	}

	// first if there are ranged weapons these are fired first!
	if combattantA.attacks[0].damagetype == "bolt" {
		combatLog = fmt.Sprintf("%s%s has a ranged weapon and shoots!\n", combatLog, combattantA.name)
		combatRound(&combattantA, &combattantB)
	}
	if combattantB.attacks[0].damagetype == "bolt" {
		combatLog = fmt.Sprintf("%s%s has a ranged weapon and shoots!\n", combatLog, combattantB.name)
		combatRound(&combattantB, &combattantA)
	}

	// from initiative we calculate how gets the first strike attempt each round
	Afirst := true
	if combattantA.initiative > combattantA.initiative {
		combatLog = fmt.Sprintf("%s%s has a higher initiative and gets the first strike!\n", combatLog, combattantA.name)
	} else if combattantA.initiative < combattantA.initiative {
		combatLog = fmt.Sprintf("%s%s has a higher initiative and gets the first strike!\n", combatLog, combattantB.name)
		Afirst = false
	} else {
		if rand.Int63n(2) == 0 {
			combatLog = fmt.Sprintf("%sBoth Fighters have the same Initiative, but the stars favor %s.\n", combatLog, combattantA.name)
		} else {
			combatLog = fmt.Sprintf("%sBoth Fighters have the same Initiative, but the stars favor %s.\n", combatLog, combattantB.name)
			Afirst = false
		}
	}

	// this function checks if the combat has ended because someone died
	checkEnd := func() (ended bool, winner string) {

		// this increments wins and losses in the nfts according to outcome
		updateNFT := func (NFT string, winner bool) {
			keyString := ""
			if winner {
				keyString = "wins"
			} else {
				keyString = "losses"
			}
			updatedNFT, _ := k.GetItem(ctx, FighterA.CookbookID, NFT)
			for i, prop := range updatedNFT.Doubles {
				if prop.Key == keyString {
					updatedNFT.Doubles[i].Value = prop.Value.Add(sdk.OneDec())
				}
			}
			k.SetItem(ctx, updatedNFT)
		}

		if combattantA.hp <= 0 {
			combatLog = fmt.Sprintf("%s%s has defeated %s and wins!\n", combatLog, combattantB.name, combattantA.name)

			updateNFT(FighterA.NFT, false)
			updateNFT(FighterB.NFT, true)

			return true, "B"
		} else if combattantB.hp <= 0 {
			combatLog = fmt.Sprintf("%s%s has defeated %s and wins!\n", combatLog, combattantA.name, combattantB.name)

			updateNFT(FighterA.NFT, true)
			updateNFT(FighterB.NFT, false)

			return true, "A"
		}
		return false, "none"
	}

	// here the actual fight happens
	// we limit the number of rounds to 1000 to prevent infinite loops, usually there should never be more than 30 rounds
	for round := 1; round < 1000; round++ {
		combatLog = fmt.Sprintf("%sRound %d:\n", combatLog, round)

		if Afirst {
			combatLog = fmt.Sprintf("%s%s attacks %s...\n", combatLog, combattantA.name, combattantB.name)
			combatRound(&combattantA, &combattantB)
			ended, winner := checkEnd()
			if ended {
				return winner, combatLog, nil
			}
		}
		combatLog = fmt.Sprintf("%s%s attacks %s...\n", combatLog, combattantB.name, combattantA.name)
		combatRound(&combattantB, &combattantA)
		ended, winner := checkEnd()
		if ended {
			return winner, combatLog, nil
		}
		if !Afirst {
			combatLog = fmt.Sprintf("%s%s attacks %s...\n", combatLog, combattantA.name, combattantB.name)
			combatRound(&combattantA, &combattantB)
			ended, winner := checkEnd()
			if ended {
				return winner, combatLog, nil
			}
		}
	}
	return "none", "unusual end of combat", nil
}
