BattleTowerTrainers:
; The trainer class is not used in Crystal 1.0 due to a bug.
; Instead, the sixth character in the trainer's name is used.
; See BattleTowerText in engine/events/battle_tower/trainer_text.asm.
	table_width (NAME_LENGTH - 1) + 1, BattleTowerTrainers
	; name, class
	db "ROSSI@@@@@", FISHER
	db "PERI@@@@@@", POKEMANIAC
	db "RICCI@@@@@", GUITARIST
	db "BIANCO@@@@", SCIENTIST
	db "OLSON@@@@@", POKEFANM
	db "CONTINI@@@", LASS
	db "WRIGHT@@@@", YOUNGSTER
	db "PANI@@@@@@", HIKER
	db "MIRTI@@@@@", TEACHER
	db "PARODI@@@@", POKEFANM
	db "FINZI@@@@@", KIMONO_GIRL
	db "RISI@@@@@@", BOARDER
	db "DALIO@@@@@", PICNICKER
	db "BIGLIA@@@@", BIKER
	db "MOTTI@@@@@", JUGGLER
	db "HUNTER@@@@", POKEFANF
	db "HILL@@@@@@", FIREBREATHER
	db "FOSCHI@@@@", SWIMMERF
	db "GHINI@@@@@", SWIMMERM
	db "LANZA@@@@@", SKIER
	db "McHIL@@@@@", CAMPER
	assert_table_length BATTLETOWER_NUM_UNIQUE_MON
; The following can only be sampled in Crystal 1.1.
	db "BRIANO@@@@", GENTLEMAN
	db "CARBONI@@@", BEAUTY
	db "MORSE@@@@@", SUPER_NERD
	db "YUFU@@@@@@", BLACKBELT_T
	db "RINI@@@@@@", COOLTRAINERF
	db "LOISI@@@@@", OFFICER
	db "LOPEZ@@@@@", PSYCHIC_T
	db "MANZATO@@@", POKEFANM
	db "RATTI@@@@@", SCIENTIST
	db "VALENTI@@@", BEAUTY
	db "BINI@@@@@@", CAMPER
	db "BOLLA@@@@@", BIRD_KEEPER
	db "FABI@@@@@@", PICNICKER
	db "RIO@@@@@@@", POKEMANIAC
	db "MORI@@@@@@", SCIENTIST
	db "ANDREWS@@@", SAGE
	db "PASTORE@@@", SCHOOLBOY
	db "SPADO@@@@@", FISHER
	db "HIKO@@@@@@", KIMONO_GIRL
	db "EASTON@@@@", PSYCHIC_T
	db "FARI@@@@@@", CAMPER
	db "BADANO@@@@", LASS
	db "SANTI@@@@@", GENTLEMAN
	db "JACKSON@@@", POKEFANF
	db "RE@@@@@@@@", POKEMANIAC
	db "LEONI@@@@@", YOUNGSTER
	db "MARINI@@@@", TEACHER
	db "NEWMAN@@@@", SAILOR
	db "KAWA@@@@@@", BLACKBELT_T
	db "MURA@@@@@@", SUPER_NERD
	db "PARK@@@@@@", COOLTRAINERF
	db "GATTI@@@@@", SWIMMERM
	db "SELLS@@@@@", BIRD_KEEPER
	db "WELL@@@@@@", BOARDER
	db "PICCININI@", LASS
	db "COSTA@@@@@", OFFICER
	db "TOSI@@@@@@", SKIER
	db "WALKER@@@@", SCHOOLBOY
	db "MAYER@@@@@", SWIMMERF
	db "JOHNSON@@@", YOUNGSTER
	db "ADAMS@@@@@", GUITARIST
	db "MITI@@@@@@", BUG_CATCHER
	db "TESI@@@@@@", BUG_CATCHER
	db "GINI@@@@@@", POKEMANIAC
	db "ORSI@@@@@@", SCIENTIST
	db "SMART@@@@@", SUPER_NERD
	db "BRUNI@@@@@", SWIMMERF
	db "JORDAN@@@@", BIKER
	db "RIZZO@@@@@", FIREBREATHER
	assert_table_length BATTLETOWER_NUM_UNIQUE_TRAINERS
