package keeper

import (
	"encoding/binary"
	"strconv"
	"fmt"
	"math/rand"

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

// RemoveTrade removes a trade from the store
func (k Keeper) RemoveFighter(ctx sdk.Context, id uint64, creator sdk.AccAddress) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	k.removeFighterFromAddress(ctx, getFighterIDBytes(id), creator)
	store.Delete(getFighterIDBytes(id))
}

// GetAllTrade returns all trade
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

func (k Keeper) Battle(ctx sdk.Context, FighterA types.Fighter, FighterB types.Fighter) (result string, err error){

	type attack struct {
		damage float64
		accuracy float64
		damagetype string
	}

	type combattant struct {
		attacks []attack
		initiative float64
		sliceArmor float64
		bluntArmor float64
		stabArmor float64
		boltArmor float64
		hp float64
	}

	calculateCombatSpecs := func (fighter types.Fighter) (readyFighter combattant, err error) {
		items := []string{fighter.LHitem, fighter.RHitem, fighter.Armoritem}

		readyFighter = combattant{
			attacks: []attack{},
			initiative: 0.0,
			sliceArmor: 0.0,
			bluntArmor: 0.0,
			stabArmor: 0.0,
			boltArmor: 0.0,
			hp: 20.0,
		}

		for index, itemIDstring := range items {
			item, _ := k.GetItem(ctx, fighter.CookbookID, itemIDstring)

			// string properties of items are read and saved
			for _, prop := range item.Strings {
				if (prop.Key == "oneHanded") {
					// if the first item is inspected, only add it if it's one handed,
					// the second item is only added if there is none added yet or if it's one handed
					if (index == 0 && prop.Value == "true") {
						readyFighter.attacks = append(readyFighter.attacks, attack{0, 1.0, "undefined"})
						fmt.Println("1st weapon added")
					} else if (len(readyFighter.attacks) == 0 || prop.Value == "true" ){
						readyFighter.attacks = append(readyFighter.attacks, attack{0, 1.0, "undefined"})
						fmt.Println("2nd weapon added")
					}
				}
				if (prop.Key == "DamageType") {
					readyFighter.attacks[index].damagetype = prop.Value
				}

				fmt.Println(prop.Key, prop.Value)
			}

			// double properties of items are read and saved
			for _, prop := range item.Doubles {
				if (prop.Key == "initiative") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.initiative += val
				} else if (prop.Key == "accuracyModifier") {
					for i, _ := range readyFighter.attacks {
						val, err := prop.Value.Float64()
						if (err != nil) {
							return readyFighter, err
						}
						readyFighter.attacks[i].accuracy *= val
					}
				} else if (prop.Key == "sliceDef") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.sliceArmor += val
				} else if (prop.Key == "bluntDef") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.bluntArmor += val
				} else if (prop.Key == "stabDef") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.stabArmor += val
				} else if (prop.Key == "boltDef") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.boltArmor += val
				} else if (prop.Key == "damage") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.attacks[index].damage += val
				} else if (prop.Key == "accuracy") {
					val, err := prop.Value.Float64()
					if (err != nil) {
						return readyFighter, err
					}
					readyFighter.attacks[index].accuracy *= val
				}

				fmt.Println(prop.Key, prop.Value)
			}
			fmt.Println("--------")
		}
		return readyFighter, nil
	}

	combattantA, err := calculateCombatSpecs(FighterA)
	combattantB, err := calculateCombatSpecs(FighterB)

	fmt.Println(combattantA)
	fmt.Println(combattantB)

	combatRound := func (attacker *combattant, defender *combattant) {
		for _, attack := range attacker.attacks {
			if (rand.Float64() > attack.accuracy) {
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
				fmt.Println("Strike! remaining hp:", defender.hp)
			} else {
				fmt.Println("FAIL")
			}
		}
	}

	// here the actual fight happens
	round := 0

	if combattantA.attacks[0].damagetype == "slice" {
		fmt.Println("A has a ranged weapon and shoots!")
		combatRound(&combattantA, &combattantB)
	}
	if combattantB.attacks[0].damagetype == "slice" {
		fmt.Println("B has a ranged weapon and shoots!")
		combatRound(&combattantB, &combattantA)
	}

	Afirst := true
	if (combattantA.initiative > combattantA.initiative) {
		fmt.Println("A has a higher initiative and gets the first strike!")
	} else if combattantA.initiative < combattantA.initiative {
		fmt.Println("B has a higher initiative and gets the first strike!")
		Afirst = false
	} else {
		if (rand.Int63n(2) == 0 ) {
			fmt.Println("Both Fighters have the same Initiative, but the stars favor A.")
		} else {
			fmt.Println("Both Fighters have the same Initiative, but the stars favor B.")
			Afirst = false
		}
	}

	checkEnd := func () bool {
		if combattantA.hp <= 0 {
			fmt.Println("B has defeated A and wins!")
			return true
		} else if combattantB.hp <= 0 {
			fmt.Println("B has defeated A and wins!")
			return true
		}
		return false
	}

	for combattantA.hp > 0 && combattantB.hp > 0 {
		round += 1
		fmt.Println("Round", round, ":")

		if Afirst {
			fmt.Println("A attacks B...")
			combatRound(&combattantA, &combattantB)
			if checkEnd() {
				return "yes", nil
			}
			fmt.Println("B attacks A...")
			combatRound(&combattantB, &combattantA)
			if checkEnd() {
				return "yes", nil
			}
		} else {
			fmt.Println("B attacks A...")
			combatRound(&combattantB, &combattantA)
			if checkEnd() {
				return "yes", nil
			}
			fmt.Println("A attacks B...")
			combatRound(&combattantA, &combattantB)
			if checkEnd() {
				return "yes", nil
			}
		}

	}


	return "yes", nil
}
