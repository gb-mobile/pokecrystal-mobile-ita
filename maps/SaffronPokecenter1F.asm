	object_const_def
	const SAFFRONPOKECENTER1F_NURSE
	const SAFFRONPOKECENTER1F_TEACHER
	const SAFFRONPOKECENTER1F_FISHER
	const SAFFRONPOKECENTER1F_YOUNGSTER

SaffronPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

SaffronPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

SaffronPokecenter1FTeacherScript:
	special Mobile_DummyReturnFalse
	iftrue .mobile
	jumptextfaceplayer SaffronPokecenter1FTeacherText

.mobile
	jumptextfaceplayer SaffronPokecenter1FTeacherMobileText

SaffronPokecenter1FFisherScript:
	faceplayer
	opentext
	checkevent EVENT_RETURNED_MACHINE_PART
	iftrue .SolvedKantoPowerCrisis
	writetext SaffronPokecenter1FFisherText
	waitbutton
	closetext
	end

.SolvedKantoPowerCrisis:
	writetext SaffronPokecenter1FFisherReturnedMachinePartText
	waitbutton
	closetext
	end

SaffronPokecenter1FYoungsterScript:
	jumptextfaceplayer SaffronPokecenter1FYoungsterText

SaffronPokecenter1FTeacherText:
	text "Come sono i CENTRI"
	line "#MON di"
	cont "JOHTO?"

	para "…Ah, capisco."
	line "Non sono tanto"

	para "diversi da quelli"
	line "di KANTO."

	para "Beh, allora posso"
	line "andare a JOHTO"
	cont "tranquillamente!"
	done

SaffronPokecenter1FTeacherMobileText:
	text "Come sono fatti"
	line "I CENTRI #MON"
	cont "di JOHTO?"

	para "…Ah, capisco."
	line "Quindi ti permet-"

	para "tono di connet-"
	line "terti con persone"
	cont "lontane?"

	para "Allora chiederò al"
	line "mio amico di JOHTO"

	para "di catturare un"
	line "MARILL e scambiar-"
	cont "melo!"
	done

SaffronPokecenter1FFisherText:
	text "Ho appena attra-"
	line "versato il TUNNEL-"
	cont "ROCCIOSO. Alla"
	cont "CENTRALE ELETTRICA"
	cont "c'era agitazione."
	done

SaffronPokecenter1FFisherReturnedMachinePartText:
	text "Le grotte crollano"
	line "facilmente."

	para "Negli scorsi anni"
	line "molte grotte sono"

	para "scomparse, come"
	line "quella vicino a"
	cont "CELESTOPOLI."

	para "Tutti gli"
	line "AVVENTURIERI"
	cont "lo sanno."
	done

SaffronPokecenter1FYoungsterText:
	text "La DIREZIONE della"
	line "SILPH SPA e la"

	para "STAZIONE del"
	line "SUPERTRENO sono i"

	para "luoghi da visitare"
	line "a ZAFFERANOPOLI."
	done

SaffronPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, SAFFRON_CITY, 4
	warp_event  4,  7, SAFFRON_CITY, 4
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FNurseScript, -1
	object_event  7,  2, SPRITE_TEACHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FTeacherScript, -1
	object_event  8,  6, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FFisherScript, -1
	object_event  1,  4, SPRITE_YOUNGSTER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FYoungsterScript, -1
