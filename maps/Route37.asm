	object_const_def
	const ROUTE37_WEIRD_TREE1
	const ROUTE37_WEIRD_TREE2
	const ROUTE37_YOUNGSTER
	const ROUTE37_FRUIT_TREE1
	const ROUTE37_SUNNY
	const ROUTE37_FRUIT_TREE2
	const ROUTE37_FRUIT_TREE3

Route37_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, Route37SunnyCallback

Route37SunnyCallback:
	readvar VAR_WEEKDAY
	ifequal SUNDAY, .SunnyAppears
	disappear ROUTE37_SUNNY
	endcallback

.SunnyAppears:
	appear ROUTE37_SUNNY
	endcallback

TrainerTwinsAnnandanne1:
	trainer TWINS, ANNANDANNE1, EVENT_BEAT_TWINS_ANN_AND_ANNE, TwinsAnnandanne1SeenText, TwinsAnnandanne1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext TwinsAnnandanne1AfterBattleText
	waitbutton
	closetext
	end

TrainerTwinsAnnandanne2:
	trainer TWINS, ANNANDANNE2, EVENT_BEAT_TWINS_ANN_AND_ANNE, TwinsAnnandanne2SeenText, TwinsAnnandanne2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext TwinsAnnandanne2AfterBattleText
	waitbutton
	closetext
	end

TrainerPsychicGreg:
	trainer PSYCHIC_T, GREG, EVENT_BEAT_PSYCHIC_GREG, PsychicGregSeenText, PsychicGregBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PsychicGregAfterBattleText
	waitbutton
	closetext
	end

SunnyScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_MAGNET_FROM_SUNNY
	iftrue SunnySundayScript
	readvar VAR_WEEKDAY
	ifnotequal SUNDAY, SunnyNotSundayScript
	checkevent EVENT_MET_SUNNY_OF_SUNDAY
	iftrue .MetSunny
	writetext MeetSunnyText
	promptbutton
	setevent EVENT_MET_SUNNY_OF_SUNDAY
.MetSunny:
	checkflag ENGINE_PLAYER_IS_FEMALE
	iftrue .Kris
	writetext SunnyGivesGiftText1
	promptbutton
	sjump .next
.Kris:
	writetext SunnyGivesGiftText2
	promptbutton
.next
	verbosegiveitem MAGNET
	iffalse SunnyDoneScript
	setevent EVENT_GOT_MAGNET_FROM_SUNNY
	writetext SunnyGaveGiftText
	waitbutton
	closetext
	end

SunnySundayScript:
	writetext SunnySundayText
	waitbutton
SunnyDoneScript:
	closetext
	end

SunnyNotSundayScript:
	writetext SunnyNotSundayText
	waitbutton
	closetext
	end

Route37Sign:
	jumptext Route37SignText

Route37FruitTree1:
	fruittree FRUITTREE_ROUTE_37_1

Route37FruitTree2:
	fruittree FRUITTREE_ROUTE_37_2

Route37FruitTree3:
	fruittree FRUITTREE_ROUTE_37_3

Route37HiddenEther:
	hiddenitem ETHER, EVENT_ROUTE_37_HIDDEN_ETHER

TwinsAnnandanne1SeenText:
	text "ANNA: ANN ed io"
	line "siamo socie!"
	done

TwinsAnnandanne1BeatenText:
	text "ANNA&ANN: Ahi… Un"
	line "po' troppo forte…"
	done

TwinsAnnandanne1AfterBattleText:
	text "ANNA: So sempre"
	line "ciò che pensano"

	para "ANN e i miei"
	line "#MON!"
	done

TwinsAnnandanne2SeenText:
	text "ANN: ANNA ed io"
	line "siamo socie!"
	done

TwinsAnnandanne2BeatenText:
	text "ANNA&ANN: Ahi… Un"
	line "po' troppo forte…"
	done

TwinsAnnandanne2AfterBattleText:
	text "ANN: Siamo in"
	line "sintonia con i"
	cont "nostri #MON."
	done

PsychicGregSeenText:
	text "I #MON non pos-"
	line "sono far nulla"
	cont "quando dormono."

	para "Vuoi vedere"
	line "com'è terribile?"
	done

PsychicGregBeatenText:
	text "Ho perso, che"
	line "tristezza…"
	done

PsychicGregAfterBattleText:
	text "Far addormentare"
	line "i #MON o"
	cont "paralizzarli sono"
	cont "tecniche ottime."
	done

MeetSunnyText:
	text "DORINO: Ciao!"

	para "Sono DORINO della"
	line "domenica, e oggi è"
	cont "proprio domenica!"
	done

SunnyGivesGiftText1:
	text "Mi han detto di"
	line "darti questo se"
	cont "ti vedevo!"
	done

SunnyGivesGiftText2:
	text "Mi hanno detto di"
	line "darti questo, se"
	cont "ti vedevo!"
	done

SunnyGaveGiftText:
	text "DORINO: Dicevo?"

	para "Uhm…"

	para "… L'ho scordato…"

	para "…"

	para "Ah! Adesso"
	line "ricordo!"

	para "Dovresti darlo ad"
	line "un #MON che"

	para "usa attacchi di"
	line "tipo elettro."

	para "Mia sorella LUANA"
	line "dice che potenzia"
	cont "gli attacchi"
	cont "di tipo elettro!"
	done

SunnySundayText:
	text "DORINO: I miei"
	line "fratelli e sorelle"
	cont "si chiamano LUANA,"
	cont "MARTA, ERCOLE,"
	cont "GIORGIO, VERONICA"
	cont "SABATINO."

	para "Sono tutti più"
	line "grandi di me!"
	done

SunnyNotSundayText:
	text "DORINO: Ma oggi"
	line "non è domenica?"
	cont "Uhm… Non"
	cont "ricordo!"
	done

Route37SignText:
	text "PERCORSO 37"
	done

Route37_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event  5,  3, BGEVENT_READ, Route37Sign
	bg_event  4,  2, BGEVENT_ITEM, Route37HiddenEther

	def_object_events
	object_event  6, 12, SPRITE_WEIRD_TREE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerTwinsAnnandanne1, -1
	object_event  7, 12, SPRITE_WEIRD_TREE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerTwinsAnnandanne2, -1
	object_event  6,  6, SPRITE_YOUNGSTER, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, TrainerPsychicGreg, -1
	object_event 13,  5, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route37FruitTree1, -1
	object_event 16,  8, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SunnyScript, EVENT_ROUTE_37_SUNNY_OF_SUNDAY
	object_event 16,  5, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route37FruitTree2, -1
	object_event 15,  7, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route37FruitTree3, -1
