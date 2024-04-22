Scriptname ODN_IllusorySimulacrum_ForNPC_Script extends activemagiceffect  

Int property ODN_LevelMod = 0 auto
Spell property ODN_Ill_Simulacrum2_Spell_IllusorySimulacrum_Ab auto
Faction property MagicAllegianceFaction auto
Actor property PlayerRef auto
Actor GhostRef

function OnEffectStart(Actor akTarget, Actor akCaster)

	Float CasterAngle = akCaster.GetAngleZ()
	GhostRef = akTarget.PlaceActorAtMe(akCaster.GetBaseObject() as actorbase, ODN_LevelMod, none)
	GhostRef.Disable(false)
	GhostRef.SetGhost(true)
	GhostRef.Enable(false)
	utility.Wait(0.100000)
    ; Put ghost and caster into the same faction so ghost won't attack caster
    GhostRef.AddToFaction(MagicAllegianceFaction)
    akCaster.AddToFaction(MagicAllegianceFaction)

	GhostRef.AddSpell(ODN_Ill_Simulacrum2_Spell_IllusorySimulacrum_Ab, true)

    ; Bump ghost's aggression to attack player right away.
    GhostRef.SetActorValue("Aggression", 1)
    GhostRef.SetActorValue("Confidence", 4)
    GhostRef.StartCombat(akTarget)
	; If target is not the player, make sure that target switches its focus to the ghost.
    if akTarget != PlayerRef
        akTarget.StartCombat(GhostRef)
    endIf
endFunction

function OnEffectFinish(Actor akTarget, Actor akCaster)

	if akCaster
		while akCaster.IsInKillmove() || GhostRef.IsInKillmove()
			utility.Wait(0.100000)
		endWhile
        akCaster.RemoveFromFaction(MagicAllegianceFaction)
        GhostRef.RemoveFromFaction(MagicAllegianceFaction)
	endIf
	GhostRef.Delete()
endFunction
