DEF EZCHAT_WORD_COUNT EQU EASY_CHAT_MESSAGE_WORD_COUNT
DEF EZCHAT_WORD_LENGTH EQU 8
DEF EZCHAT_WORDS_PER_ROW EQU 2
DEF EZCHAT_WORDS_PER_COL EQU 4
DEF EZCHAT_WORDS_IN_MENU EQU EZCHAT_WORDS_PER_ROW * EZCHAT_WORDS_PER_COL
DEF EZCHAT_CUSTOM_BOX_BIG_SIZE EQU 9
DEF EZCHAT_CUSTOM_BOX_BIG_START EQU 4
DEF EZCHAT_CUSTOM_BOX_START_X EQU 5
DEF EZCHAT_CUSTOM_BOX_START_Y EQU $1B
DEF EZCHAT_CHARS_PER_LINE EQU 18
DEF EZCHAT_BLANK_SIZE EQU 5

	const_def
	const EZCHAT_SORTED_A
	const EZCHAT_SORTED_B
	const EZCHAT_SORTED_C
	const EZCHAT_SORTED_D
	const EZCHAT_SORTED_E
	const EZCHAT_SORTED_F
	const EZCHAT_SORTED_G
	const EZCHAT_SORTED_H
	const EZCHAT_SORTED_I
	const EZCHAT_SORTED_J
	const EZCHAT_SORTED_K
	const EZCHAT_SORTED_L
	const EZCHAT_SORTED_M
	const EZCHAT_SORTED_N
	const EZCHAT_SORTED_O
	const EZCHAT_SORTED_P
	const EZCHAT_SORTED_Q
	const EZCHAT_SORTED_R
	const EZCHAT_SORTED_S
	const EZCHAT_SORTED_T
	const EZCHAT_SORTED_U
	const EZCHAT_SORTED_V
	const EZCHAT_SORTED_W
	const EZCHAT_SORTED_X
	const EZCHAT_SORTED_Y
	const EZCHAT_SORTED_Z
	const EZCHAT_SORTED_ETC
	const EZCHAT_SORTED_ERASE
	const EZCHAT_SORTED_MODE
	const EZCHAT_SORTED_CANCEL
DEF NUM_EZCHAT_SORTED EQU const_value
DEF EZCHAT_SORTED_NULL EQU $ff

; These functions seem to be related to the selection of preset phrases
; for use in mobile communications.  Annoyingly, they separate the
; Battle Tower function above from the data it references.

EZChat_LoadOneWord:
; hl = where to place it to
; d,e = params?
	ld a, e
	or d
	jr z, .error
	ld a, e
	and d
	cp $ff
	jr z, .error
	call CopyMobileEZChatToC608
	and a
	ret

.error
	ld c, l
	ld b, h
	scf
	ret

EZChat_RenderOneWord:
; hl = where to place it to
; d,e = params?
	push hl
	call EZChat_LoadOneWord
	pop hl
	ld a, 0
	ret c
	call PlaceString
	and a
	ret

Function11c075:
	push de
	ld a, c
	call Function11c254
	pop de
	ld bc, wEZChatWords ; (?)
	call EZChat_RenderWords
	ret

Function11c082: ; unreferenced
	push de
	ld a, c
	call Function11c254
	pop de
	ld bc, wEZChatWords
	call PrintEZChatBattleMessage
	ret

Function11c08f:
EZChat_RenderWords:
	ld l, e
	ld h, d
	ld a, EZCHAT_WORDS_PER_ROW ; Determines the number of easy chat words displayed before going onto the next line
	call .single_line
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	ld a, EZCHAT_WORDS_PER_ROW
.single_line
	push hl
.loop
	push af
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	push bc
	call EZChat_RenderOneWord
	jr c, .okay
	inc bc

.okay
	ld l, c
	ld h, b
	pop bc
	pop af
	dec a
	jr nz, .loop
	pop hl
	ret

PrintEZChatBattleMessage:
; Use up to 6 words from bc to print text starting at de.
	; Preserve [wJumptableIndex], [wcf64]
	ld a, [wJumptableIndex]
	ld l, a
	ld a, [wcf64]
	ld h, a
	push hl
	; reset value at [wc618] (not preserved)
	ld hl, wc618
	ld a, $0
	ld [hli], a
	; preserve de
	push de
	; [wJumptableIndex] keeps track of which line we're on (0, 1, 2 or 3)
	; [wcf64] keeps track of how much room we have left in the current line
	xor a
	ld [wJumptableIndex], a
	ld a, EZCHAT_CHARS_PER_LINE
	ld [wcf64], a
	ld a, EZCHAT_WORD_COUNT
.loop
	push af
	; load the 2-byte word data pointed to by bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	; if $0000, we're done
	or e
	jr z, .done
	
	cp $ff
	jr nz, .d_not_ff
	ld a, e
	cp $ff
	jr z, .done ; de == $ffff, done

.d_not_ff
	; preserving hl and bc, get the length of the word
	push hl
	push bc
	call CopyMobileEZChatToC608
	call GetLengthOfWordAtC608
	ld e, c
	pop bc
	pop hl
	; if the functions return 0, we're done
	ld a, e
	or a
	jr z, .done
.loop2
	; e contains the length of the word
	; add 1 for the space, unless we're at the start of the line
	ld a, [wcf64]
	cp EZCHAT_CHARS_PER_LINE
	jr z, .skip_inc
	inc e

.skip_inc
	; if the word fits, put it on the same line
	cp e
	jr nc, .same_line
	; otherwise, go to the next line
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	; if we're on line 1, insert "<NEXT>"
	ld [hl], "<NEXT>"
	rra
	jr c, .got_line_terminator
	; otherwise, insert "<CONT>" in line 0 and 2
	ld [hl], "<CONT>"

.got_line_terminator
	inc hl
	; init the next line, holding on to the same word
	ld a, EZCHAT_CHARS_PER_LINE
	ld [wcf64], a
	dec e
	jr .loop2

.same_line
	; add the space, unless we're at the start of the line
	cp EZCHAT_CHARS_PER_LINE
	jr z, .skip_space
	ld [hl], " "
	inc hl

.skip_space
	; deduct the length of the word
	sub e
	ld [wcf64], a
	ld de, wEZChatWordBuffer
.place_string_loop
	; load the string from de to hl
	ld a, [de]
	cp "@"
	jr z, .done
	inc de
	ld [hli], a
	jr .place_string_loop

.done
	; next word?
	pop af
	dec a
	jr nz, .loop
	; we're finished, place "<DONE>"
	ld [hl], "<DONE>"
	; now, let's place the string from wc618 to bc
	pop bc
	ld hl, wc618
	call PlaceHLTextAtBC
	; restore the original values of [wJumptableIndex] and [wcf64]
	pop hl
	ld a, l
	ld [wJumptableIndex], a
	ld a, h
	ld [wcf64], a
	ret

GetLengthOfWordAtC608: ; Finds the length of the word being stored for EZChat?
	ld c, $0
	ld hl, wEZChatWordBuffer
.loop
	ld a, [hli]
	cp "@"
	ret z
	inc c
	jr .loop

CopyMobileEZChatToC608:
	ldh a, [rSVBK]
	push af
	ld a, $1
	ldh [rSVBK], a
	ld a, "@"
	ld hl, wEZChatWordBuffer
	ld bc, NAME_LENGTH + 1
	call ByteFill
	ld a, d
	and a
	jr z, .get_name
; load in name
	ld hl, MobileEZChatCategoryPointers
	dec d
	sla d
	ld c, d
	ld b, $0
	add hl, bc
; got category pointer
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
; bc -> hl
	push bc
	pop hl
	ld c, e
	ld b, $0
; got which word
; bc * (5 + 1 + 1 + 1) = bc * 8
;	sla c
;	rl b
;	sla c
;	rl b
;	sla c
;	rl b
;	add hl, bc
rept EZCHAT_WORD_LENGTH + 3 ; fuck it, do (bc * 11) this way
	add hl, bc
endr
; got word address
	ld bc, EZCHAT_WORD_LENGTH
.copy_string
	ld de, wEZChatWordBuffer
	call CopyBytes
	ld de, wEZChatWordBuffer
	pop af
	ldh [rSVBK], a
	ret

.get_name
	ld a, e
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld a, 1
	ld [wEZChatPokemonNameRendered], a
	ld bc, NAME_LENGTH
	jr .copy_string

Function11c1ab:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call Function11c1b9
	pop af
	ldh [hInMenu], a
	ret

Function11c1b9:
	call .InitKanaMode
	ldh a, [rSVBK]
	push af
	ld a, $5
	ldh [rSVBK], a
	call EZChat_MasterLoop
	pop af
	ldh [rSVBK], a
	ret

.InitKanaMode: ; Possibly opens the appropriate sorted list of words when sorting by letter?
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	ld [wEZChatBlinkingMask], a
	ld [wEZChatSelection], a
	ld [wEZChatCategorySelection], a
	ld [wEZChatSortedSelection], a
	ld [wEZChatPokemonNameRendered], a
	ld [wcd35], a
	ld [wEZChatCategoryMode], a
	ld a, $ff
	ld [wEZChatSpritesMask], a
	ld a, [wMenuCursorY]
	dec a
	call Function11c254
	call ClearBGPalettes
	call ClearSprites
	call ClearScreen
	call Function11d323
	call SetPalettes
	call DisableLCD
	ld hl, SelectStartGFX ; GFX_11d67e
	ld de, vTiles2
	ld bc, $60
	call CopyBytes
	ld hl, EZChatSlowpokeLZ ; LZ_11d6de
	ld de, vTiles0
	call Decompress
	call EnableLCD
	farcall ReloadMapPart
	farcall ClearSpriteAnims
	farcall LoadPokemonData
	farcall Pokedex_ABCMode
	ldh a, [rSVBK]
	push af
	ld a, $5
	ldh [rSVBK], a
	ld hl, wc6d0
	ld de, wLYOverrides
	ld bc, $100
	call CopyBytes
	pop af
	ldh [rSVBK], a
	call EZChat_GetCategoryWordsByKana
	call EZChat_GetSeenPokemonByKana
	ret

Function11c254:
	push af
	ld a, BANK(sEZChatIntroductionMessage)
	call OpenSRAM
	ld hl, sEZChatIntroductionMessage
	pop af
; a * 4 * 2
	sla a
	sla a
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld de, wEZChatWords
	ld bc, EZCHAT_WORD_COUNT * 2
	call CopyBytes
	call CloseSRAM
	ret

EZChat_ClearBottom12Rows: ; Clears area below selected messages.
	ld a, "　"
	hlcoord 0, 6 ; Start of the area to clear
	ld bc, (SCREEN_HEIGHT - 6) * SCREEN_WIDTH
	call ByteFill
	ret

EZChat_MasterLoop:
.loop
	call JoyTextDelay
	ldh a, [hJoyPressed]
	ldh [hJoypadPressed], a
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .exit
	call .DoJumptableFunction
	farcall PlaySpriteAnimations
	farcall ReloadMapPart
	jr .loop

.exit
	farcall ClearSpriteAnims
	call ClearSprites
	ret

.DoJumptableFunction:
	jumptable .Jumptable, wJumptableIndex

.Jumptable: ; and jumptable constants
	const_def

	const EZCHAT_SPAWN_OBJECTS
	dw .SpawnObjects ; 00

	const EZCHAT_INIT_RAM
	dw .InitRAM ; 01

	const EZCHAT_02
	dw Function11c35f ; 02

	const EZCHAT_03
	dw Function11c373 ; 03

	const EZCHAT_DRAW_CHAT_WORDS
	dw EZChatDraw_ChatWords ; 04

	const EZCHAT_MENU_CHAT_WORDS
	dw EZChatMenu_ChatWords ; 05

	const EZCHAT_DRAW_CATEGORY_MENU
	dw EZChatDraw_CategoryMenu ; 06

	const EZCHAT_MENU_CATEGORY_MENU
	dw EZChatMenu_CategoryMenu ; 07

	const EZCHAT_DRAW_WORD_SUBMENU
	dw EZChatDraw_WordSubmenu ; 08

	const EZCHAT_MENU_WORD_SUBMENU
	dw EZChatMenu_WordSubmenu ; 09

	const EZCHAT_DRAW_ERASE_SUBMENU
	dw EZChatDraw_EraseSubmenu ; 0a

	const EZCHAT_MENU_ERASE_SUBMENU
	dw EZChatMenu_EraseSubmenu ; 0b

	const EZCHAT_DRAW_EXIT_SUBMENU
	dw EZChatDraw_ExitSubmenu ; 0c

	const EZCHAT_MENU_EXIT_SUBMENU
	dw EZChatMenu_ExitSubmenu ; 0d

	const EZCHAT_DRAW_MESSAGE_TYPE_MENU
	dw EZChatDraw_MessageTypeMenu ; 0e

	const EZCHAT_MENU_MESSAGE_TYPE_MENU
	dw EZChatMenu_MessageTypeMenu ; 0f

	const EZCHAT_10
	dw Function11cbf5 ; 10 (Something related to sound)

	const EZCHAT_MENU_WARN_EMPTY_MESSAGE
	dw EZChatMenu_WarnEmptyMessage ; 11 (Something related to SortBy menus)

	const EZCHAT_12
	dw Function11cd04 ; 12 (Something related to input)

	const EZCHAT_DRAW_SORT_BY_MENU
	dw EZChatDraw_SortByMenu ; 13

	const EZCHAT_MENU_SORT_BY_MENU
	dw EZChatMenu_SortByMenu ; 14

	const EZCHAT_DRAW_SORT_BY_CHARACTER
	dw EZChatDraw_SortByCharacter ; 15

	const EZCHAT_MENU_SORT_BY_CHARACTER
	dw EZChatMenu_SortByCharacter ; 16

.SpawnObjects:
	depixel 3, 1, 2, 5
	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	depixel 8, 1, 2, 5

	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $1 ; Message Menu Index (?)
	ld [hl], a

	depixel 9, 2, 2, 0
	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $3 ; Word Menu Index (?)
	ld [hl], a

	depixel 10, 16
	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $4
	ld [hl], a

	depixel 10, 4
	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $5 ; Sort By Menu Index (?)
	ld [hl], a

	depixel 10, 2
	ld a, SPRITE_ANIM_INDEX_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, $2 ; Sort By Letter Menu Index (?)
	ld [hl], a

	ld hl, wEZChatBlinkingMask
	set 1, [hl]
	set 2, [hl]
	jp EZChat_IncreaseJumptable

.InitRAM:
	ld a, $9
	ld [wcd2d], a
	ld a, $2
	ld [wcd2e], a
	ld [wcd2f], a
	ld [wcd30], a
	ld de, wcd2d
	call EZChat_Textbox
	jp EZChat_IncreaseJumptable

Function11c35f:
	ld hl, wcd2f
	inc [hl]
	inc [hl]
	dec hl
	dec hl
	dec [hl]
	push af
	ld de, wcd2d
	call EZChat_Textbox
	pop af
	ret nz
	jp EZChat_IncreaseJumptable

Function11c373:
	ld hl, wcd30
	inc [hl]
	inc [hl]
	dec hl
	dec hl
	dec [hl]
	push af
	ld de, wcd2d
	call EZChat_Textbox
	pop af
	ret nz
	call EZChat_VerifyWordPlacement
	call EZChatMenu_MessageSetup
	jp EZChat_IncreaseJumptable

EZChatMenu_RerenderMessage:
; nugget of a solution
	ld de, EZChatBKG_ChatWords
	call EZChat_Textbox
	call EZChat_ClearAllWords
	jr EZChatMenu_MessageSetup

EZChatMenu_GetRealChosenWordSize:
	push hl
	push de
	ld hl, wEZChatWords
	sla a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	jr EZChatMenu_DirectGetRealChosenWordSize.after_initial_setup

EZChatMenu_DirectGetRealChosenWordSize:
	push hl
	push de
.after_initial_setup
	push bc
	ld a, e
	or d
	jr z, .emptystring
	ld a, e
	and d
	cp $ff
	jr z, .emptystring
	call EZChat_LoadOneWord
	ld a, 0
	jr c, .done
	call GetLengthOfWordAtC608
	ld a, c
.done
	pop bc
	pop de
	pop hl
	ret

.emptystring
	xor a
	jr .done

EZChatMenu_GetChosenWordSize:
	push af
	call EZChatMenu_GetRealChosenWordSize
	pop hl
	and a
	ret nz
	ld a, h
	and 1
	ld a, h
	jr z, .after_decrement
	dec a
	dec a
.after_decrement
	inc a
	call EZChatMenu_GetRealChosenWordSize
	sub (EZCHAT_CHARS_PER_LINE - EZCHAT_BLANK_SIZE)
	ld h, a
	ld a, EZCHAT_BLANK_SIZE
	ret c
	sub h
	dec a
	ret

EZChatMenu_MessageLocationSetup:
	push de
	push bc
	ld bc, wMobileBoxSpritePositionDataTotal
	ld a, [bc]
	cp EZCHAT_WORDS_PER_ROW
	decoord 0, 2
	ld a, EZCHAT_CUSTOM_BOX_START_Y
	jr c, .after_initial_setup
	decoord 0, 4
	add $0F
.after_initial_setup
	ld d, a
	ld a, l
	sub e
	sla a
	sla a
	sla a
	add EZCHAT_CUSTOM_BOX_START_X
	ld e, a
	ld a, [bc]
	inc a
	ld [bc], a
	dec a
	inc bc
	push hl
	sla a
	ld h, 0
	ld l, a
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	pop bc
	pop de
	ret

EZChatMenu_MessageSetup:
	ld a, EZCHAT_MAIN_RESET
	ld [wMobileBoxSpriteLoadedIndex], a
	xor a
	ld [wMobileBoxSpritePositionDataTotal], a
	hlcoord 1, 2
	ld bc, wEZChatWords
	call .after_initial_setup
	ld a, EZCHAT_WORDS_PER_ROW
	hlcoord 1, 4

.after_initial_setup
	push af
	inc a
	call EZChatMenu_GetRealChosenWordSize
	push af
	push hl
	call .print_word_of_line
	pop hl
	pop de
	pop af
	call EZChatMenu_GetRealChosenWordSize
	sub EZCHAT_CHARS_PER_LINE - ((EZCHAT_CHARS_PER_LINE - 1) / 2)
	ld e, EZCHAT_CHARS_PER_LINE - ((EZCHAT_CHARS_PER_LINE - 1) / 2) + 1
	jr nc, .after_size_calcs
	dec e
	ld a, d
	cp ((EZCHAT_CHARS_PER_LINE - 1) / 2) + 1
	jr c, .after_size_set
	sub ((EZCHAT_CHARS_PER_LINE - 1) / 2)
	ld d, a
	ld a, e
	sub d
	jr .after_size_increase
.after_size_calcs
	add e
.after_size_increase
	ld e, a
.after_size_set
	ld d, 0
	add hl, de

.print_word_of_line
	ld d, a
	ld a, [bc]
	inc bc
	push bc
	ld e, a
	ld a, [bc]
	ld b, d
	ld d, a
	or e
	jr z, .emptystring
	ld a, e
	and d
	cp $ff
	jr z, .emptystring
	call EZChatMenu_MessageLocationSetup
	call EZChat_RenderOneWord
	jr .asm_11c3b5
.emptystring
	ld de, EZChatString_EmptyWord
	ld a, b
	sub EZCHAT_CHARS_PER_LINE - EZCHAT_BLANK_SIZE
	jr c, .after_shrink
	add e
	ld e, a
	adc d
	sub e
	ld d, a
.after_shrink
	call EZChatMenu_MessageLocationSetup
	call PlaceString
.asm_11c3b5
	pop bc
	inc bc
	ret

EZChatString_EmptyWord: ; EZChat Unassigned Words
	db "-----@"

; ezchat main options
	const_def
	const EZCHAT_MAIN_WORD1
	const EZCHAT_MAIN_WORD2
	const EZCHAT_MAIN_WORD3
	const EZCHAT_MAIN_WORD4
	;const EZCHAT_MAIN_WORD5
	;const EZCHAT_MAIN_WORD6

	const EZCHAT_MAIN_RESET
	const EZCHAT_MAIN_QUIT
	const EZCHAT_MAIN_OK

EZChatDraw_ChatWords: ; Switches between menus?, not sure which.
	call EZChat_ClearBottom12Rows
	ld de, EZChatBKG_ChatExplanation
	call EZChat_Textbox2
	hlcoord 1, 7 ; Location of EZChatString_ChatExplanation
	ld de, EZChatString_ChatExplanation
	call PlaceString
	hlcoord 1, 16 ; Location of EZChatString_ChatExplanationBottom
	ld de, EZChatString_ChatExplanationBottom
	call PlaceString
	call EZChatDrawBKG_ChatWords
	ld hl, wEZChatSpritesMask
	res 0, [hl]
	call EZChat_IncreaseJumptable

EZChatMenu_ChatWords: ; EZChat Word Menu

; ----- (00) ----- (01) ----- (02)
; ----- (03) ----- (04) ----- (05)
; RESET (06)  QUIT (07)   OK  (08)

; to

; -------- (00) -------- (01)
; -------- (02) -------- (03)
; RESET (04)  QUIT (05)   OK  (06)

	ld hl, wEZChatSelection
	ld de, hJoypadPressed
	ld a, [de]
	and START
	jr nz, .select_ok
	ld a, [de]
	and B_BUTTON
	jr nz, .click_sound_and_quit
	ld a, [de]
	and A_BUTTON
	jr nz, .select_option
	ld de, hJoyLast
	ld a, [de]
	and D_UP
	jp nz, .up
	ld a, [de]
	and D_DOWN
	jp nz, .down
	ld a, [de]
	and D_LEFT
	jp nz, .left
	ld a, [de]
	and D_RIGHT
	jp nz, .right
; manage blinkies
	ld hl, wEZChatBlinkingMask
	set 0, [hl]
	ret

.click_sound_and_quit
	call PlayClickSFX
.to_quit_prompt
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_DRAW_EXIT_SUBMENU
	jr .move_jumptable_index

.select_ok
	ld a, EZCHAT_MAIN_OK
	ld [wEZChatSelection], a
	ret

.select_option
	ld a, [wEZChatSelection]
	cp EZCHAT_MAIN_RESET
	jr c, .to_word_select
	sub EZCHAT_MAIN_RESET
	jr z, .to_reset_prompt
	dec a
	jr z, .to_quit_prompt
; ok prompt
	ld hl, wEZChatWords
	ld c, EZCHAT_WORD_COUNT * 2
	xor a
.go_through_all_words
	or [hl]
	inc hl
	dec c
	jr nz, .go_through_all_words
	and a
	jr z, .if_all_empty

; filled out
	ld de, EZChatBKG_ChatWords
	call EZChat_Textbox
	decoord 1, 2
	ld bc, wEZChatWords
	call EZChat_RenderWords
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_DRAW_MESSAGE_TYPE_MENU
	jr .move_jumptable_index

.if_all_empty
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_MENU_WARN_EMPTY_MESSAGE
	jr .move_jumptable_index

.to_reset_prompt
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_DRAW_ERASE_SUBMENU
	jr .move_jumptable_index

.to_word_select
	call EZChat_MoveToCategoryOrSortMenu
.move_jumptable_index
	ld [wJumptableIndex], a
	call PlayClickSFX
	ret

.up
	ld a, [hl]
	cp EZCHAT_MAIN_WORD3
	ret c
	sub 2
	cp EZCHAT_MAIN_WORD4
	jr nz, .keep_checking_up
	dec a
.keep_checking_up
	cp EZCHAT_MAIN_RESET
	jr nz, .finish_dpad
	dec a
.finish_dpad
	ld [hl], a
	ret

.down
	ld a, [hl]
	cp 4
	ret nc
	add 2
	ld [hl], a
	ret

.left
	ld a, [hl]
	and a
	ret z
	cp 2
	ret z
	cp EZCHAT_MAIN_RESET
	ret z
	dec a
	ld [hl], a
	ret

.right
	ld a, [hl]
; rightmost side of everything
	cp 1
	ret z
	cp 3
	ret z
	cp EZCHAT_MAIN_OK
	ret z
	inc a
	ld [hl], a
	ret

EZChat_CheckCategorySelectionConsistency:
	ld a, [wEZChatCategoryMode]
	bit 7, a
	ret z
	set 0, a
	ld [wEZChatCategoryMode], a
	ret

EZChat_MoveToCategoryOrSortMenu:
	call EZChat_CheckCategorySelectionConsistency
	ld hl, wEZChatBlinkingMask
	res 0, [hl]
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .to_sort_menu
	xor a
	ld [wEZChatCategorySelection], a
	ld a, EZCHAT_DRAW_CATEGORY_MENU ; from where this is called, it sets jumptable stuff
	ret

.to_sort_menu
	xor a
	ld [wEZChatSortedSelection], a
	ld a, EZCHAT_DRAW_SORT_BY_CHARACTER
	ret

EZChatDrawBKG_ChatWords:
	ld a, $1
	hlcoord 0, 6, wAttrmap 	; Draws the pink background for 'Combine words'
	ld bc, $a0 				; Area to fill
	call ByteFill
	ld a, $7
	hlcoord 0, 14, wAttrmap ; Clears white area at bottom of menu
	ld bc, $28 				; Area to clear
	call ByteFill
	farcall ReloadMapPart
	ret

EZChatString_ChatExplanation: ; Explanation string
	db   "Abbina quattro";"６つのことば¯くみあわせます"
	next "parole o frasi.";"かえたいところ¯えらぶと　でてくる"
	next "Scegli uno spazio";"ことばのグループから　いれかえたい"
	next "e una parola.";"たんご¯えらんでください"
	db   "@"

EZChatString_ChatExplanationBottom: ; Explanation commands string
	db "RESET　ESCI  　OK@";"ぜんぶけす　やめる　　　けってい@"

; ezchat categories defines
def EZCHAT_CATEGORIES_ROWS EQU 5
def EZCHAT_CATEGORIES_COLUMNS EQU 2
def EZCHAT_DISPLAYED_CATEGORIES EQU (EZCHAT_CATEGORIES_ROWS * EZCHAT_CATEGORIES_COLUMNS)
def EZCHAT_NUM_CATEGORIES EQU 15
def EZCHAT_NUM_EXTRA_ROWS EQU ((EZCHAT_NUM_CATEGORIES + 1 - EZCHAT_DISPLAYED_CATEGORIES) / 2)
def EZCHAT_EMPTY_VALUE EQU ((EZCHAT_NUM_EXTRA_ROWS << 5) | (EZCHAT_DISPLAYED_CATEGORIES - 1))

	const_def EZCHAT_DISPLAYED_CATEGORIES
	const EZCHAT_CATEGORY_CANC
	const EZCHAT_CATEGORY_MODE
	const EZCHAT_CATEGORY_OK

EZChatDraw_CategoryMenu: ; Open category menu
; might need no change here
	call DelayFrame
	call EZChat_ClearBottom12Rows
	call EZChat_PlaceCategoryNames
	call EZChat_SortMenuBackground
	ld hl, wEZChatSpritesMask
	res 1, [hl]
	call EZChat_IncreaseJumptable

EZChatMenu_CategoryMenu: ; Category Menu Controls
	ld hl, wEZChatCategorySelection
	ld de, hJoypadPressed

	ld a, [de]
	and START
	jr nz, .start

	ld a, [de]
	and SELECT
	jr nz, .select

	ld a, [de]
	and B_BUTTON
	jr nz, .b

	ld a, [de]
	and A_BUTTON
	jr nz, .a

	ld de, hJoyLast

	ld a, [de]
	and D_UP
	jp nz, .up

	ld a, [de]
	and D_DOWN
	jp nz, .down

	ld a, [de]
	and D_LEFT
	jp nz, .left

	ld a, [de]
	and D_RIGHT
	jp nz, .right

; manage blinkies
	ld a, [hl]
	and $0f
	cp EZCHAT_CATEGORY_CANC
	ld hl, wEZChatBlinkingMask
	jr nc, .blink
; no blink
	res 1, [hl]
	ret
.blink
	set 1, [hl]
	ret

.a
	ld a, [wEZChatCategorySelection]
	and $0f
	cp EZCHAT_CATEGORY_CANC
	jr c, .got_category
	sub EZCHAT_CATEGORY_CANC
	jr z, .done
	dec a
	jr z, .mode
	jr .b

.start
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_MAIN_OK
	ld [wEZChatSelection], a

.b
	ld a, EZCHAT_DRAW_CHAT_WORDS
	jr .go_to_function

.select
	ld a, [wEZChatCategoryMode]
	xor (1 << 0) + (1 << 7)
	ld [wEZChatCategoryMode], a
	ld a, EZCHAT_DRAW_SORT_BY_CHARACTER
	jr .go_to_function

.mode
	ld a, EZCHAT_DRAW_SORT_BY_MENU
	jr .go_to_function

.got_category
	ld a, EZCHAT_DRAW_WORD_SUBMENU

.go_to_function
	ld hl, wEZChatSpritesMask
	set 1, [hl]
	ld [wJumptableIndex], a
	call PlayClickSFX
	ret

.done
	ld a, [wEZChatSelection]
	call EZChatDraw_EraseWordsLoop
	call EZChatMenu_RerenderMessage
	call PlayClickSFX
	ret

.up
	ld a, [hl]
	cp EZCHAT_CATEGORIES_COLUMNS
	ret c
	ld e, a
	and $f0
	ld d, a
	ld a, e
	and $0f
	cp EZCHAT_CATEGORIES_COLUMNS
	jr nc, .normal_up
	ld a, e
	sub EZCHAT_CATEGORIES_COLUMNS << 4
	ld [hl], a
	ld a, EZCHAT_DRAW_CATEGORY_MENU
	jr .go_to_function

.normal_up
	ld a, e
	and $0f
	cp EZCHAT_CATEGORY_MODE
	jr c, .continue_normal_up
	ld a, EZCHAT_CATEGORY_CANC
.continue_normal_up
	sub EZCHAT_CATEGORIES_COLUMNS
.up_end
	or d
	jr .finish_dpad

.down
	ld a, [hl]
	cp EZCHAT_EMPTY_VALUE - EZCHAT_CATEGORIES_COLUMNS
	jr nz, .continue_down
	dec a
.continue_down
	ld e, a
	and $f0
	ld d, a
	ld a, e
	and $0f
	cp EZCHAT_CATEGORY_CANC
	ret nc
	cp EZCHAT_DISPLAYED_CATEGORIES - EZCHAT_CATEGORIES_COLUMNS
	jr c, .normal_down
	ld a, d
	cp EZCHAT_NUM_EXTRA_ROWS << 5
	jr nz, .print_down
	ld a, EZCHAT_CATEGORY_CANC
	jr .down_end
.print_down
	ld a, e
	add EZCHAT_CATEGORIES_COLUMNS << 4
	cp EZCHAT_EMPTY_VALUE
	jr nz, .continue_print_down
	dec a
.continue_print_down
	ld [hl], a
	ld a, EZCHAT_DRAW_CATEGORY_MENU
	jr .go_to_function

.normal_down
	add EZCHAT_CATEGORIES_COLUMNS
.down_end
	or d
	jr .finish_dpad

.left
	ld a, [hl]
	and $0f
	cp EZCHAT_CATEGORY_OK
	jr z, .left_okay
	bit 0, a
	ret z
.left_okay
	ld a, [hl]
	dec a
	jr .finish_dpad

.right
	ld a, [hl]
	cp EZCHAT_EMPTY_VALUE - 1
	ret z
	and $0f
	cp EZCHAT_CATEGORY_MODE
	jr z, .right_okay
	bit 0, a
	ret nz
	cp EZCHAT_CATEGORY_OK
	ret z
.right_okay
	ld a, [hl]
	inc a

.finish_dpad
	ld [hl], a
	jp DelayFrame

EZChat_FindNextCategoryName:
	; The category names are padded with "@".
	; To find the next category, the system must
	; find the first character at de that is not "@".
.find_end_loop
	ld a, [de]
	inc de
	cp "@"
	jr nz, .find_end_loop
.find_next_loop
	ld a, [de]
	inc de
	cp "@"
	jr z, .find_next_loop
	dec de
	ret

EZChat_GetSelectedCategory:
	push de
	ld e, a
	and $0f
	ld d, a
	ld a, e
	swap a
	and $0f
	add d
	pop de
	ret

EZChat_PlaceCategoryNames:
	ld de, MobileEZChatCategoryNames
	ld a, [wEZChatCategorySelection]
	swap a
	and $0f
	jr z, .setup_start
.start_loop
	push af
	call EZChat_FindNextCategoryName
	pop af
	dec a
	jr nz, .start_loop
.setup_start
	hlcoord  1,  7
	ld a, 10 / 2 ; Number of EZ Chat categories displayed
.loop
	push af
	call PlaceString
	call EZChat_FindNextCategoryName
	ld bc, 10
	add hl, bc
	call PlaceString
	call EZChat_FindNextCategoryName
	ld bc, 30
	add hl, bc
	pop af
	dec a
	jr nz, .loop
	ld de, EZChatString_Stop_Mode_Cancel
	call PlaceString
	ret

EZChat_SortMenuBackground:
	ld a, $2
	hlcoord 0, 6, wAttrmap
	ld bc, $c8
	call ByteFill
	farcall ReloadMapPart
	ret

EZChatString_Stop_Mode_Cancel:
	db "CANC 　MODAL　ESCI@";"けす　　　　モード　　　やめる@"

EZChatDraw_WordSubmenu: ; Opens/Draws Word Submenu
	call EZChat_ClearBottom12Rows
	call EZChat_DetermineWordCounts
	ld de, EZChatBKG_WordSubmenu
	call EZChat_Textbox2
	call EZChat_WhiteOutLowerMenu
	call EZChat_RenderWordChoices
	call EZChatMenu_WordSubmenuBottom
	ld hl, wEZChatSpritesMask
	res 3, [hl]
	xor a
	ld hl, wEZChatScrollBufferIndex
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call EZChat_IncreaseJumptable

EZChatMenu_WordSubmenu: ; Word Submenu Controls
	ld hl, wEZChatWordSelection
	ld de, hJoypadPressed
	ld a, [de]
	and A_BUTTON
	jp nz, .a
	ld a, [de]
	and B_BUTTON
	jp nz, .b
	ld a, [de]
	and START
	jr nz, .next_page
	ld a, [de]
	and SELECT
	jr z, .check_joypad

; select
	ld a, [wEZChatPageOffset]
	and a
	ret z
	ld e, EZCHAT_WORDS_PER_COL
.select_loop
	call .move_menu_up_by_one
	dec e
	jr nz, .select_loop
	jr .navigate_to_page

.next_page
	ld a, EZCHAT_WORDS_PER_COL
	call EZChatGetValidWordsLine
	ret nc
	ld a, d
	ld hl, wEZChatLoadedItems
	cp [hl]
	ret nc
	ld e, EZCHAT_WORDS_PER_COL
.start_loop
	push de
	call .force_menu_down_by_one
	pop de
	dec e
	jr nz, .start_loop
.navigate_to_page
	call DelayFrame
	call Function11c992
	call EZChat_RenderWordChoices
	call EZChatMenu_WordSubmenuBottom
	ld hl, wEZChatWordSelection
	ld a, [hl]
	jp .finish_dpad

.check_joypad
	ld de, hJoyLast
	ld a, [de]
	and D_UP
	jr nz, .up
	ld a, [de]
	and D_DOWN
	jr nz, .down
	ld a, [de]
	and D_LEFT
	jr nz, .left
	ld a, [de]
	and D_RIGHT
	jr nz, .right
	ret

.failure_to_set
	ld de, SFX_WRONG
	call PlaySFX
	jp WaitSFX

.a
	call EZChat_SetOneWord
	jr nc, .failure_to_set
	call EZChat_VerifyWordPlacement
	call EZChatMenu_RerenderMessage
	ld a, EZCHAT_DRAW_CHAT_WORDS
	ld [wcd35], a

; autoselect "OK" if all words filled
; not when only word #4 is filled
	push af
	ld hl, wEZChatWords
	ld c, EZCHAT_WORD_COUNT
.check_word
	ld b, [hl]
	inc hl
	ld a, [hli]
	or b
	jr z, .check_done
	dec c
	jr nz, .check_word
	ld a, $6 ; OK
	ld [wEZChatSelection], a
.check_done
	pop af
	jr .jump_to_index

.b
	call EZChat_CheckCategorySelectionConsistency
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .to_sorted_menu
	ld a, EZCHAT_DRAW_CATEGORY_MENU
	jr .jump_to_index

.to_sorted_menu
	ld a, EZCHAT_DRAW_SORT_BY_CHARACTER
.jump_to_index
	ld [wJumptableIndex], a
	ld hl, wEZChatSpritesMask
	set 3, [hl]
	call PlayClickSFX
	ret

.up
	ld a, [hl]
	sub EZCHAT_WORDS_PER_ROW
	jr nc, .finish_dpad
	call .move_menu_up_by_one
	ret nc
	jp .navigate_to_page

.down
	ld a, [hl]
	add EZCHAT_WORDS_PER_ROW
	cp EZCHAT_WORDS_IN_MENU
	jr c, .finish_dpad
	call .move_menu_down_by_one
	ret nc
	jp .navigate_to_page

.left
	ld a, [hl]
	and a ; cp a, 0
	ret z
	and 1
	ret z
	ld a, [hl]
	dec a
	jr .finish_dpad

.right
	ld a, [hl]
	and 1
	ret nz
	ld a, [hl]
	inc a

.finish_dpad
	push af
	srl a
	inc a
	call EZChatGetValidWordsLine
	pop bc
	and a
	ld c, a
	ld a, b
	jr nz, .after_y_positioning
	sub EZCHAT_WORDS_PER_ROW
	jr nc, .finish_dpad
	xor a
	ld b, a
.after_y_positioning
	and 1
	jr z, .done
	dec c
	jr nz, .done
	dec b
.done
	ld a, b
	ld [wEZChatWordSelection], a
	ret

.move_menu_up_by_one
	ld a, [wEZChatPageOffset]
	and a
	ret z
	ld hl, wEZChatScrollBufferIndex
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hli], a
	inc hl
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	ld [wEZChatPageOffset], a
	scf
	ret

.move_menu_down_by_one
	ld a, EZCHAT_WORDS_PER_COL
	call EZChatGetValidWordsLine
	ret nc
	ld a, d
	ld hl, wEZChatLoadedItems
	cp [hl]
	ret nc
.force_menu_down_by_one
	ld hl, wEZChatScrollBufferIndex
	ld a, [hli]
	cp [hl]
	jr nc, .not_found_previous_value
	dec hl
	inc a
	ld [hli], a
	inc hl
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	ld [wEZChatPageOffset], a
	jr .after_scroll_buffer_setup

.not_found_previous_value
	ld a, 1
	call EZChatGetValidWordsLine
	ld a, d
	ld [wEZChatPageOffset], a
	ld hl, wEZChatScrollBufferIndex
	ld a, [hl]
	inc a
	jr z, .after_scroll_buffer_setup
	ld [hli], a
	cp [hl]
	jr c, .after_scroll_max_increase
	ld [hl], a
.after_scroll_max_increase
	inc hl
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld [hl], d
.after_scroll_buffer_setup
	scf
	ret

EZChat_DetermineWordCounts:
	xor a
	ld [wEZChatWordSelection], a
	ld [wEZChatPageOffset], a
	ld [wcd27], a
	ld [wcd29], a
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .is_sorted_mode
	ld a, [wEZChatCategorySelection]
	and a
	jr z, .is_pokemon_selection
	; load from data array
	call EZChat_GetSelectedCategory
	dec a
	sla a
	ld hl, MobileEZChatData_WordAndPageCounts
	ld c, a
	ld b, 0
.prepare_items_load
	add hl, bc
	ld a, [hl]
.set_loaded_items
	ld [wEZChatLoadedItems], a
	ret

.is_pokemon_selection
	; compute from [wc7d2]
	ld a, [wc7d2]
	jr .set_loaded_items

.is_sorted_mode
	; compute from [c6a8 + 2 * [cd22]]
	ld hl, wc6a8 ; $c68a + 30
	ld a, [wEZChatSortedSelection]
	ld c, a
	ld b, 0
	add hl, bc
	jr .prepare_items_load
	
EZChat_RenderWordChoices:
	ld bc, EZChatCoord_WordSubmenu
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .is_sorted
; grouped
	ld a, [wEZChatCategorySelection]
	call EZChat_GetSelectedCategory
	ld d, a
	and a
	ld a, [wEZChatPageOffset]
	ld e, a
	jr nz, .loop
	ld hl, wListPointer
	add hl, de
.loop
	call .printing_one_word
	cp -1
	ret z
	cp ((EZCHAT_CHARS_PER_LINE - 2) / 2) + 1
	jr nc, .skip_one
	push de
	inc e
	push hl
	call .get_next_word
	call EZChatMenu_DirectGetRealChosenWordSize
	pop hl
	pop de
	cp ((EZCHAT_CHARS_PER_LINE - 2) / 2) + 1
	jr nc, .skip_one
	inc e
	ld a, [wEZChatLoadedItems]
	cp e
	ret z
	call .printing_one_word
	jr .after_skip
.skip_one
	inc bc
	inc bc
.after_skip
	inc e
	ld a, [wEZChatLoadedItems]
	cp e
	jr nz, .loop
	ret

.is_sorted
	ld hl, wEZChatSortedWordPointers
	ld a, [wEZChatSortedSelection]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
; got word
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
; de -> hl
	push de
	pop hl
	ld a, [wEZChatPageOffset]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [wEZChatPageOffset]
	ld e, a
	ld d, $80
	jr .loop

.printing_one_word
	push de
	call .get_next_word
	push hl
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	inc bc
	and l
	cp -1
	jr z, .printing_loop_exit
	push bc
	call EZChat_RenderOneWord
	ld a, c
	sub l
	pop bc
.printing_loop_exit
	pop hl
	pop de
	ret

.get_next_word
	ld a, d
	and $7F
	ret nz
	ld a, [hli]
	ld e, a
	ld a, d
	and a
	ret z
	ld a, [hli]
	ld d, a
	ret

EZChatCoord_WordSubmenu: ; Word coordinates (within category submenu)
	dwcoord  2,  8
	dwcoord  11,  8 ; 8, 8 MENU_WIDTH
	dwcoord  2, 10
	dwcoord  11, 10 ; 8, 10 MENU_WIDTH
	dwcoord  2, 12
	dwcoord  11, 12 ; 8, 12 MENU_WIDTH
	dwcoord  2, 14
	dwcoord  11, 14 ; 8, 14 MENU_WIDTH
	dw -1
	dw -1

EZChatMenu_WordSubmenuBottom: ; Seems to handle the bottom of the word menu.
	ld a, [wEZChatPageOffset]
	and a
	jr z, .asm_11c88a
	hlcoord 0, 17 	; Draw PREV string (2, 17)
	ld de, MobileString_Prev
	call PlaceString
	hlcoord 7, 17 	; Draw SELECT tiles
	ld c, $3 		; SELECT tile length
	xor a
.asm_11c883
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_11c883
	jr .asm_11c895
.asm_11c88a
	hlcoord 0, 17 	; Clear PREV/SELECT (2, 17)
	ld c, $a 		; Clear PREV/SELECT length
	ld a, $7f
.asm_11c891
	ld [hli], a
	dec c
	jr nz, .asm_11c891
.asm_11c895
	ld a, EZCHAT_WORDS_PER_COL
	call EZChatGetValidWordsLine
	jr nc, .asm_11c8b7
	ld a, d
	ld hl, wEZChatLoadedItems
	cp [hl]
	jr nc, .asm_11c8b7
	hlcoord 14, 17 	; NEXT string (16, 17)
	ld de, MobileString_Next
	call PlaceString
	hlcoord 11, 17 	; START tiles
	ld a, $3 		; START tile length
	ld c, a
.asm_11c8b1
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_11c8b1
	ret

.asm_11c8b7
	hlcoord 17, 16
	ld a, $7f
	ld [hl], a
	hlcoord 11, 17 	; Clear START/NEXT
	ld c, $9 		; Clear START/NEXT length
.asm_11c8c2
	ld [hli], a
	dec c
	jr nz, .asm_11c8c2
	ret

BCD2String: ; unreferenced
	inc a
	push af
	and $f
	ldh [hDividend], a
	pop af
	and $f0
	swap a
	ldh [hDividend + 1], a
	xor a
	ldh [hDividend + 2], a
	push hl
	farcall Function11a80c
	pop hl
	ld a, [wcd63]
	add "０"
	ld [hli], a
	ld a, [wcd62]
	add "０"
	ld [hli], a
	ret

MobileString_Page: ; unreferenced
	db "PAG@";"ぺージ@"

MobileString_Prev:
	db "PRECED.@";"まえ@"

MobileString_Next:
	db " SUCC.@";"つぎ@"

EZChat_VerifyWordPlacement:
	push hl
	push bc
	push de
	ld a, [wEZChatSelection]
	ld b, a
	srl a
	sla a
	ld c, a
	push bc

	ld d, 0
	ld e, EZCHAT_WORDS_PER_ROW
.loop_line
	push bc
	push de
	ld a, c
	call EZChatMenu_GetRealChosenWordSize
	pop de
	pop bc
	add d
	inc a
	ld d, a
	inc c
	dec e
	jr nz, .loop_line
	ld a, d
	dec a

	pop bc
	cp EZCHAT_CHARS_PER_LINE + 1
	jr c, .after_sanitization
	ld a, b
	and 1
	ld hl, wEZChatWords
	jr nz, .chosen_base
	inc hl
	inc hl
.chosen_base
	ld a, c
	sla a
	ld d, 0
	ld e, a
	add hl, de
	xor a
	ld [hli], a
	ld [hl], a

.after_sanitization
	pop de
	pop bc
	pop hl
	ret

EZChat_SetOneWord:
; get which category mode
	ld a, [wEZChatWordSelection]
	srl a
	call EZChatGetValidWordsLine
	ld a, [wEZChatWordSelection]
	and 1
	add d
	ld b, 0
	ld c, a
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .alphabetical
; categorical
	ld a, [wEZChatCategorySelection]
	call EZChat_GetSelectedCategory
	ld d, a
	and a
	jr z, .pokemon
	ld e, c
.put_word
	call EZChatMenu_DirectGetRealChosenWordSize
	ld b, a
	ld a, [wEZChatSelection]
	ld c, a
	and 1
	ld a, c
	jr z, .after_dec
	dec a
	dec a
.after_dec
	inc a
	call EZChatMenu_GetRealChosenWordSize
	add b
	inc a
	cp EZCHAT_CHARS_PER_LINE + 1
	ret nc
	ld b, 0
	ld hl, wEZChatWords
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
; finished
	scf
	ret

.pokemon
	ld hl, wListPointer
	add hl, bc
	ld a, [hl]
	ld e, a
	jr .put_word

.alphabetical
	ld hl, wEZChatSortedWordPointers
	ld a, [wEZChatSortedSelection]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	jr .put_word

EZChat_GetWordSize:
; get which category mode
	push hl
	push de
	push bc
	push af
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .alphabetical
; categorical
	ld a, [wEZChatCategorySelection]
	call EZChat_GetSelectedCategory
	ld d, a
	and a
	jr z, .pokemon
	pop af
.got_word_entry
	ld e, a
.get_word_size
	call EZChatMenu_DirectGetRealChosenWordSize
	pop bc
	pop de
	pop hl
	ret

.pokemon
	pop af
	ld c, a
	ld b, 0
	ld hl, wListPointer
	add hl, bc
	ld a, [hl]
	jr .got_word_entry

.alphabetical
	ld hl, wEZChatSortedWordPointers
	ld a, [wEZChatSortedSelection]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	jr .get_word_size

EZChatGetValidWordsLine:
	push af
	ld a, [wEZChatPageOffset]
	ld d, a
	pop af
	and a
	ret z
	push bc
	ld hl, wEZChatLoadedItems
	ld e, a
.loop
	ld c, 0
	ld a, d
	cp [hl]
	jr nc, .early_end
	inc c
	call EZChat_GetWordSize
	inc d
	cp ((EZCHAT_CHARS_PER_LINE - 2) / 2) + 1
	jr nc, .decrease_e
	ld a, d
	cp [hl]
	jr nc, .early_end
	call EZChat_GetWordSize
	cp ((EZCHAT_CHARS_PER_LINE - 2) / 2) + 1
	jr nc, .decrease_e
	inc c
	inc d

.decrease_e
	dec e
	jr nz, .loop
	scf
.end
	ld a, c
	pop bc
	ret

.early_end
	dec e
	jr z, .after_end_sanitization
	ld c, 0
.after_end_sanitization
	and a
	jr .end

EZChat_ClearAllWords:
	hlcoord 1, 1
	call .after_initial_position
	hlcoord 1, 3
.after_initial_position
	push hl
	call .clear_line
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
.clear_line
	ld c, EZCHAT_CHARS_PER_LINE
	ld a, " "
.clear_word
	ld [hli], a
	dec c
	jr nz, .clear_word
	ret

Function11c992: ; Likely related to the word submenu, references the first word position
	ld a, $8
	hlcoord 2, 7
.asm_11c997
	push af
	ld a, $7f
	push hl
	ld bc, $11
	call ByteFill
	pop hl
	ld bc, $14
	add hl, bc
	pop af
	dec a
	jr nz, .asm_11c997
	ret

EZChat_WhiteOutLowerMenu:
	ld a, $7
	hlcoord 0, 6, wAttrmap
	ld bc, $c8
	call ByteFill
	farcall ReloadMapPart
	ret

EZChatDraw_EraseSubmenu:
	ld de, EZChatString_EraseMenu
	call EZChatDraw_ConfirmationSubmenu

EZChatMenu_EraseSubmenu: ; Erase submenu controls
	ld hl, wcd2a
	ld de, hJoypadPressed
	ld a, [de]
	and $1 ; A
	jr nz, .a
	ld a, [de]
	and $2 ; B
	jr nz, .b
	ld a, [de]
	and $40 ; UP
	jr nz, .up
	ld a, [de]
	and $80 ; DOWN
	jr nz, .down
	ret

.a
	ld a, [hl]
	and a
	jr nz, .b
	call EZChatMenu_EraseWordsAccept
	xor a
	ld [wEZChatSelection], a
.b
	ld hl, wEZChatSpritesMask
	set 4, [hl]
	ld a, EZCHAT_DRAW_CHAT_WORDS
	ld [wJumptableIndex], a
	call PlayClickSFX
	ret

.up
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.down
	ld a, [hl]
	and a
	ret nz
	inc [hl]
	ret

Function11ca01: ; Erase Yes/No Menu (?)
	hlcoord 15, 7, wAttrmap
	ld de, $14
	ld a, $5
	ld c, a
.asm_11ca0a
	push hl
	ld a, $5
	ld b, a
	ld a, $7
.asm_11ca10
	ld [hli], a
	dec b
	jr nz, .asm_11ca10
	pop hl
	add hl, de
	dec c
	jr nz, .asm_11ca0a

Function11ca19:
	hlcoord 0, 12, wAttrmap
	ld de, $14
	ld a, $6
	ld c, a
.asm_11ca22
	push hl
	ld a, $14
	ld b, a
	ld a, $7
.asm_11ca28
	ld [hli], a
	dec b
	jr nz, .asm_11ca28
	pop hl
	add hl, de
	dec c
	jr nz, .asm_11ca22
	farcall ReloadMapPart
	ret

EZChatString_EraseMenu: ; Erase words string, accessed from erase command on entry menu for EZ chat
	db   "Eliminerà le";"とうろくちゅう<NO>あいさつ¯ぜんぶ"
	next "parole. Va bene?@";"けしても　よろしいですか？@"

EZChatString_EraseConfirmation: ; Erase words confirmation string
	db   "SÌ";"はい"
	next "NO@";"いいえ@"

EZChatMenu_EraseWordsAccept:
	xor a
.loop
	call EZChatDraw_EraseWordsLoop
	inc a
	cp EZCHAT_WORD_COUNT
	jr nz, .loop
	call EZChatMenu_RerenderMessage
	ret

EZChatDraw_EraseWordsLoop:
	ld hl, wEZChatWords
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld [hl], b
	inc hl
	ld [hl], b
	ret

EZChatDraw_ConfirmationSubmenu:
	push de
	ld de, EZChatBKG_SortBy
	call EZChat_Textbox
	ld de, EZChatBKG_SortByConfirmation
	call EZChat_Textbox
	hlcoord 1, 14
	pop de
	call PlaceString
	hlcoord 17, 8
	ld de, EZChatString_EraseConfirmation
	call PlaceString
	call Function11ca01
	ld a, $1
	ld [wcd2a], a
	ld hl, wEZChatSpritesMask
	res 4, [hl]
	call EZChat_IncreaseJumptable
	ret

EZChatDraw_ExitSubmenu:
	ld de, EZChatString_ExitPrompt
	call EZChatDraw_ConfirmationSubmenu

EZChatMenu_ExitSubmenu: ; Exit Message menu
	ld hl, wcd2a
	ld de, hJoypadPressed
	ld a, [de]
	and $1 ; A
	jr nz, .a
	ld a, [de]
	and $2 ; B
	jr nz, .b
	ld a, [de]
	and $40 ; UP
	jr nz, .up
	ld a, [de]
	and $80 ; DOWN
	jr nz, .down
	ret

.a
	call PlayClickSFX
	ld a, [hl]
	and a
	jr nz, .asm_11cafc
	ld a, [wcd35]
	and a
	jr z, .asm_11caf3
	cp $ff
	jr z, .asm_11caf3
	ld a, $ff
	ld [wcd35], a
	hlcoord 1, 14
	ld de, EZChatString_ExitConfirmation
	call PlaceString
	ld a, $1
	ld [wcd2a], a
	ret

.asm_11caf3
	ld hl, wJumptableIndex
	set 7, [hl] ; exit
	ret

.b
	call PlayClickSFX
.asm_11cafc
	ld hl, wEZChatSpritesMask
	set 4, [hl]
	ld a, EZCHAT_DRAW_CHAT_WORDS
	ld [wJumptableIndex], a
	ld a, [wcd35]
	cp $ff
	ret nz
	ld a, $1
	ld [wcd35], a
	ret

.up
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.down
	ld a, [hl]
	and a
	ret nz
	inc [hl]
	ret

EZChatString_ExitPrompt: ; Exit menu string
	db   "Vuoi smettere ";"あいさつ<NO>とうろく¯ちゅうし"
	next "di scrivere?@";"しますか？@"

EZChatString_ExitConfirmation: ; Exit menu confirmation string
	db   "Esci senza salvare";"とうろくちゅう<NO>あいさつ<WA>ほぞん"
	next "questo messaggio?@";"されません<GA>よろしい　ですか？@"

EZChatDraw_MessageTypeMenu: ; Message Type Menu Drawing (Intro/Battle Start/Win/Lose menu)
	ld hl, EZChatString_MessageDescription
	ld a, [wMenuCursorY]
.asm_11cb58
	dec a
	jr z, .asm_11cb5f
	inc hl
	inc hl
	jr .asm_11cb58
.asm_11cb5f
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	call EZChatDraw_ConfirmationSubmenu

EZChatMenu_MessageTypeMenu: ; Message Type Menu Controls (Intro/Battle Start/Win/Lose menu)
	ld hl, wcd2a
	ld de, hJoypadPressed
	ld a, [de]
	and $1 ; A
	jr nz, .a
	ld a, [de]
	and $2 ; B
	jr nz, .b
	ld a, [de]
	and $40 ; UP
	jr nz, .up
	ld a, [de]
	and $80 ; DOWN
	jr nz, .down
	ret

.a
	ld a, [hl]
	and a
	jr nz, .clicksound
	ld a, BANK(sEZChatIntroductionMessage)
	call OpenSRAM
	ld hl, sEZChatIntroductionMessage
	ld a, [wMenuCursorY]
	dec a
	sla a
	sla a
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld de, wEZChatWords
	ld c, EZCHAT_WORD_COUNT * 2
.save_message
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .save_message
	call CloseSRAM
	call PlayClickSFX
	ld de, EZChatBKG_SortBy
	call EZChat_Textbox
	ld hl, EZChatString_MessageSet
	ld a, [wMenuCursorY]
.asm_11cbba
	dec a
	jr z, .asm_11cbc1
	inc hl
	inc hl
	jr .asm_11cbba
.asm_11cbc1
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	hlcoord 1, 14
	call PlaceString
	ld hl, wJumptableIndex
	inc [hl]
	inc hl
	ld a, $10
	ld [hl], a
	ret

.clicksound
	call PlayClickSFX
.b
	call EZChatMenu_RerenderMessage
	ld hl, wEZChatSpritesMask
	set 4, [hl]
	ld a, EZCHAT_DRAW_CHAT_WORDS
	ld [wJumptableIndex], a
	ret

.up
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.down
	ld a, [hl]
	and a
	ret nz
	inc [hl]
	ret

Function11cbf5:
	call WaitSFX
	ld hl, wcf64
	dec [hl]
	ret nz
	dec hl
	set 7, [hl]
	ret

EZChatString_MessageDescription: ; Message usage strings
	dw EZChatString_MessageIntroDescription
	dw EZChatString_MessageBattleStartDescription
	dw EZChatString_MessageBattleWinDescription
	dw EZChatString_MessageBattleLoseDescription

EZChatString_MessageIntroDescription:
	db   "Presentazioni da";"じこしょうかい　は"
	next "mostrare. Va bene?@";"この　あいさつで　いいですか？@"

EZChatString_MessageBattleStartDescription:
	db   "Mostra se inizi la";"たいせん　<GA>はじまるとき　は"
	next "lotta. Va bene?@";"この　あいさつで　いいですか？@"

EZChatString_MessageBattleWinDescription:
	db   "Mostra se vinci la";"たいせん　<NI>かったとき　は"
	next "lotta. Va bene?@";"この　あいさつで　いいですか？@"

EZChatString_MessageBattleLoseDescription:
	db   "Mostra se perdi la";"たいせん　<NI>まけたとき　は"
	next "lotta. Va bene?@";"この　あいさつで　いいですか？@"

EZChatString_MessageSet: ; message accept strings, one for each type of message.
	dw EZChatString_MessageIntroSet
	dw EZChatString_MessageBattleStartSet
	dw EZChatString_MessageBattleWinSet
	dw EZChatString_MessageBattleLoseSet

EZChatString_MessageIntroSet:
	db   "Impostati i saluti"		;"じこしょうかい　の"
	next "di Presentazione!@"	;next "あいさつ¯とうろくした！@"

EZChatString_MessageBattleStartSet:
	db   "Impostati i saluti"		;"たいせん　<GA>はじまるとき　の"
	next "di Inizio Lotta!@"	;next "あいさつ¯とうろくした！@"

EZChatString_MessageBattleWinSet:
	db   "Impostati i saluti"		;"たいせん　<NI>かったとき　の"
	next "di Lotta Vinta!@"	;next "あいさつ¯とうろくした！@"

EZChatString_MessageBattleLoseSet:
	db   "Impostati i saluti"		;"たいせん　<NI>まけたとき　の"
	next "di Lotta Persa!@"	;next "あいさつ¯とうろくした！@"

EZChatMenu_WarnEmptyMessage:
	ld de, EZChatBKG_SortBy
	call EZChat_Textbox
	hlcoord 1, 14
	ld de, EZChatString_EnterSomeWords
	call PlaceString
	call Function11ca19
	call EZChat_IncreaseJumptable

Function11cd04:
	ld de, hJoypadPressed
	ld a, [de]
	and a
	ret z
	ld a, EZCHAT_DRAW_CHAT_WORDS
	ld [wJumptableIndex], a
	ret

EZChatString_EnterSomeWords:
	db   "Scrivi una frase";"なにか　ことば¯いれてください@"
	next "o una parola.@"

EZChatDraw_SortByMenu: ; Draws/Opens Sort By Menu
	call EZChat_ClearBottom12Rows
	ld de, EZChatBKG_SortBy
	call EZChat_Textbox
	hlcoord 1, 14
	ld a, [wEZChatCategoryMode]
	ld [wcd2c], a
	bit 0, a
	jr nz, .asm_11cd3a
	ld de, EZChatString_SortByCategory
	jr .asm_11cd3d
.asm_11cd3a
	ld de, EZChatString_SortByAlphabetical
.asm_11cd3d
	call PlaceString
	hlcoord 2, 8
	ld de, EZChatString_SortByMenu
	call PlaceString
	call Function11cdaa
	ld hl, wEZChatSpritesMask
	res 5, [hl]
	call EZChat_IncreaseJumptable

EZChatMenu_SortByMenu: ; Sort Menu Controls
	ld hl, wcd2c
	res 7, [hl]
	ld de, hJoypadPressed
	ld a, [de]
	and A_BUTTON
	jr nz, .a
	ld a, [de]
	and B_BUTTON
	jr nz, .b
	ld a, [de]
	and D_UP
	jr nz, .up
	ld a, [de]
	and D_DOWN
	jr nz, .down
	ret

.a
	ld a, [hl]
	bit 0, a
	jr z, .a_skip_setting_7
	set 7, a
	jr .a_ok
.a_skip_setting_7
	res 7, a
.a_ok
	ld [wEZChatCategoryMode], a
.b
	ld a, [wEZChatCategoryMode]
	bit 0, a
	jr nz, .asm_11cd7d
	ld a, EZCHAT_DRAW_CATEGORY_MENU
	jr .jump_to_index

.asm_11cd7d
	ld a, EZCHAT_DRAW_SORT_BY_CHARACTER
.jump_to_index
	ld [wJumptableIndex], a
	ld hl, wEZChatSpritesMask
	set 5, [hl]
	call PlayClickSFX
	ret

.up
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld de, EZChatString_SortByCategory
	jr .asm_11cd9b

.down
	ld a, [hl]
	and a
	ret nz
	inc [hl]
	ld de, EZChatString_SortByAlphabetical
.asm_11cd9b
	push de
	ld de, EZChatBKG_SortBy
	call EZChat_Textbox
	pop de
	hlcoord 1, 14
	call PlaceString
	ret

Function11cdaa:
	ld a, $2
	hlcoord 0, 6, wAttrmap
	ld bc, 6 * SCREEN_WIDTH
	call ByteFill
	ld a, $7
	hlcoord 0, 12, wAttrmap
	ld bc, 4 * SCREEN_WIDTH
	call ByteFill
	farcall ReloadMapPart
	ret

EZChatString_SortByCategory:
; Words will be displayed by category
	db   "Parole elencati";"ことば¯しゅるいべつに"
	next "per categoria.@";"えらべます@"

EZChatString_SortByAlphabetical:
; Words will be displayed in alphabetical order
	db   "Parole in ordine";"ことば¯アイウエオ　の"
	next "alfabetico.@";"じゅんばんで　ひょうじ　します@"

EZChatString_SortByMenu:
	db   "MODALITÀ CATEGORIA";"しゅるいべつ　モード"  ; Category mode
	next "Dalla A alla Z@";"アイウエオ　　モード@" ; ABC mode

EZChatDraw_SortByCharacter: ; Sort by Character Menu
	call EZChat_ClearBottom12Rows
	hlcoord 1, 7
	ld de, EZChatScript_SortByCharacterTable
	call PlaceString
	hlcoord 1, 17
	ld de, EZChatString_Stop_Mode_Cancel
	call PlaceString
	call EZChat_SortMenuBackground
	ld hl, wEZChatSpritesMask
	res 2, [hl]
	call EZChat_IncreaseJumptable

EZChatMenu_SortByCharacter: ; Sort By Character Menu Controls
	ld a, [wEZChatSortedSelection] ; x 4
	sla a
	sla a
	ld c, a
	ld b, 0
	ld hl, .NeighboringCharacters
	add hl, bc

; got character
	ld de, hJoypadPressed
	ld a, [de]
	and START
	jr nz, .start
	ld a, [de]
	and SELECT
	jr nz, .select
	ld a, [de]
	and A_BUTTON
	jr nz, .a
	ld a, [de]
	and B_BUTTON
	jr nz, .b

	ld de, hJoyLast
	ld a, [de]
	and D_UP
	jr nz, .up
	ld a, [de]
	and D_DOWN
	jr nz, .down
	ld a, [de]
	and D_LEFT
	jr nz, .left
	ld a, [de]
	and D_RIGHT
	jr nz, .right

	ret

.a
	ld a, [wEZChatSortedSelection]
	cp EZCHAT_SORTED_ERASE
	jr c, .place
	sub EZCHAT_SORTED_ERASE
	jr z, .done
	dec a
	jr z, .mode
	jr .b ; cancel

.start
	ld hl, wEZChatSpritesMask
	set 0, [hl]
	ld a, EZCHAT_MAIN_OK
	ld [wEZChatSelection], a
.b
	ld a, EZCHAT_DRAW_CHAT_WORDS
	jr .load

.select
	ld a, [wEZChatCategoryMode]
	xor (1 << 0) + (1 << 7)
	ld [wEZChatCategoryMode], a
	ld a, EZCHAT_DRAW_CATEGORY_MENU
	jr .load

.place
	ld hl, wc6a8 ; $c68a + 30
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hl]
	and a
;	jr nz, .valid ; Removed to be more in line with Gen 3
;	ld de, SFX_WRONG
;	call PlaySFX
;	jp WaitSFX
	ret z
.valid
	ld a, EZCHAT_DRAW_WORD_SUBMENU
	jr .load

.mode
	ld a, EZCHAT_DRAW_SORT_BY_MENU
.load
	ld [wJumptableIndex], a
	ld hl, wEZChatSpritesMask
	set 2, [hl]
	call PlayClickSFX
	ret

.done
	ld a, [wEZChatSelection]
	call EZChatDraw_EraseWordsLoop
	call EZChatMenu_RerenderMessage
	call PlayClickSFX
	ret

.left
	inc hl
.down
	inc hl
.right
	inc hl
.up
	ld a, [hl]
	cp EZCHAT_SORTED_NULL
	ret z
	ld [wEZChatSortedSelection], a
	ret

.NeighboringCharacters: ; Sort Menu Letter tile values or coordinates?
	table_width 4, .NeighboringCharacters
; A
	;  Up                  Right               Down                  Left
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_B,      EZCHAT_SORTED_J,      EZCHAT_SORTED_NULL
; B
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_C,      EZCHAT_SORTED_K,      EZCHAT_SORTED_A
; C
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_D,      EZCHAT_SORTED_L,      EZCHAT_SORTED_B
; D
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_E,      EZCHAT_SORTED_M,      EZCHAT_SORTED_C
; E
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_F,      EZCHAT_SORTED_N,      EZCHAT_SORTED_D
; F
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_G,      EZCHAT_SORTED_O,      EZCHAT_SORTED_E
; G
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_H,      EZCHAT_SORTED_P,      EZCHAT_SORTED_F
; H
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_I,      EZCHAT_SORTED_Q,      EZCHAT_SORTED_G
; I
	db EZCHAT_SORTED_NULL, EZCHAT_SORTED_NULL,   EZCHAT_SORTED_R,      EZCHAT_SORTED_H
; J
	db EZCHAT_SORTED_A,    EZCHAT_SORTED_K,      EZCHAT_SORTED_S,      EZCHAT_SORTED_NULL
; K
	db EZCHAT_SORTED_B,    EZCHAT_SORTED_L,      EZCHAT_SORTED_T,      EZCHAT_SORTED_J
; L
	db EZCHAT_SORTED_C,    EZCHAT_SORTED_M,      EZCHAT_SORTED_U,      EZCHAT_SORTED_K
; M
	db EZCHAT_SORTED_D,    EZCHAT_SORTED_N,      EZCHAT_SORTED_V,      EZCHAT_SORTED_L
; N
	db EZCHAT_SORTED_E,    EZCHAT_SORTED_O,      EZCHAT_SORTED_W,      EZCHAT_SORTED_M
; O
	db EZCHAT_SORTED_F,    EZCHAT_SORTED_P,      EZCHAT_SORTED_X,      EZCHAT_SORTED_N
; P
	db EZCHAT_SORTED_G,    EZCHAT_SORTED_Q,      EZCHAT_SORTED_Y,      EZCHAT_SORTED_O
; Q
	db EZCHAT_SORTED_H,    EZCHAT_SORTED_R,      EZCHAT_SORTED_Z,      EZCHAT_SORTED_P
; R
	db EZCHAT_SORTED_I,    EZCHAT_SORTED_NULL,   EZCHAT_SORTED_CANCEL, EZCHAT_SORTED_Q
; S
	db EZCHAT_SORTED_J,    EZCHAT_SORTED_T,      EZCHAT_SORTED_ETC,    EZCHAT_SORTED_NULL
; T
	db EZCHAT_SORTED_K,    EZCHAT_SORTED_U,      EZCHAT_SORTED_ETC,    EZCHAT_SORTED_S
; U
	db EZCHAT_SORTED_L,    EZCHAT_SORTED_V,      EZCHAT_SORTED_ETC,    EZCHAT_SORTED_T
; V
	db EZCHAT_SORTED_M,    EZCHAT_SORTED_W,      EZCHAT_SORTED_MODE,   EZCHAT_SORTED_U
; W
	db EZCHAT_SORTED_N,    EZCHAT_SORTED_X,      EZCHAT_SORTED_MODE,   EZCHAT_SORTED_V
; X
	db EZCHAT_SORTED_O,    EZCHAT_SORTED_Y,      EZCHAT_SORTED_MODE,   EZCHAT_SORTED_W
; Y
	db EZCHAT_SORTED_P,    EZCHAT_SORTED_Z,      EZCHAT_SORTED_CANCEL, EZCHAT_SORTED_X
; Z
	db EZCHAT_SORTED_Q,    EZCHAT_SORTED_NULL,   EZCHAT_SORTED_CANCEL, EZCHAT_SORTED_Y
; ETC.
	db EZCHAT_SORTED_S,    EZCHAT_SORTED_NULL,   EZCHAT_SORTED_ERASE,  EZCHAT_SORTED_NULL
; ERASE
	db EZCHAT_SORTED_ETC,  EZCHAT_SORTED_MODE,   EZCHAT_SORTED_NULL,   EZCHAT_SORTED_NULL
; MODE
	db EZCHAT_SORTED_V,    EZCHAT_SORTED_CANCEL, EZCHAT_SORTED_NULL,   EZCHAT_SORTED_ERASE
; CANCEL
	db EZCHAT_SORTED_Y,    EZCHAT_SORTED_NULL,   EZCHAT_SORTED_NULL,   EZCHAT_SORTED_MODE
	assert_table_length NUM_EZCHAT_SORTED

EZChatScript_SortByCharacterTable:
	db   "A B C D E F G H I"
	next "J K L M N O P Q R"
	next "S T U V W X Y Z"
	next "altro"
	db   "@"

EZChat_IncreaseJumptable:
	ld hl, wJumptableIndex
	inc [hl]
	ret

EZChatBKG_ChatWords: ; EZChat Word Background
	db  0,  0 ; start coords
	db 20,  6 ; end coords

EZChatBKG_ChatExplanation: ; EZChat Explanation Background
	db  0, 14 ; start coords
	db 20,  4 ; end coords

EZChatBKG_WordSubmenu:
	db  0,  6 ; start coords
	db 20, 10 ; end coords

EZChatBKG_SortBy: ; Sort Menu
	db  0, 12 ; start coords
	db 20,  6 ; end coords

EZChatBKG_SortByConfirmation:
	db 15,  7 ; start coords
	db  5,  5 ; end coords

EZChat_Textbox:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [de]
	inc de
	push af
	ld a, [de]
	inc de
	and a
.add_n_times
	jr z, .done_add_n_times
	add hl, bc
	dec a
	jr .add_n_times
.done_add_n_times
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	push hl
	ld a, $79
	ld [hli], a
	ld a, [de]
	inc de
	dec a
	dec a
	jr z, .skip_fill
	ld c, a
	ld a, $7a
.fill_loop
	ld [hli], a
	dec c
	jr nz, .fill_loop
.skip_fill
	ld a, $7b
	ld [hl], a
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, [de]
	dec de
	dec a
	dec a
	jr z, .skip_section
	ld b, a
.loop
	push hl
	ld a, $7c
	ld [hli], a
	ld a, [de]
	dec a
	dec a
	jr z, .skip_row
	ld c, a
	ld a, $7f
.row_loop
	ld [hli], a
	dec c
	jr nz, .row_loop
.skip_row
	ld a, $7c
	ld [hl], a
	pop hl
	push bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
.skip_section
	ld a, $7d
	ld [hli], a
	ld a, [de]
	dec a
	dec a
	jr z, .skip_remainder
	ld c, a
	ld a, $7a
.final_loop
	ld [hli], a
	dec c
	jr nz, .final_loop
.skip_remainder
	ld a, $7e
	ld [hl], a
	ret

EZChat_Textbox2:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [de]
	inc de
	push af
	ld a, [de]
	inc de
	and a
.add_n_times
	jr z, .done_add_n_times
	add hl, bc
	dec a
	jr .add_n_times
.done_add_n_times
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	push hl
	ld a, $79
	ld [hl], a
	pop hl
	push hl
	ld a, [de]
	dec a
	inc de
	ld c, a
	add hl, bc
	ld a, $7b
	ld [hl], a
	call .AddNMinusOneTimes
	ld a, $7e
	ld [hl], a
	pop hl
	push hl
	call .AddNMinusOneTimes
	ld a, $7d
	ld [hl], a
	pop hl
	push hl
	inc hl
	push hl
	call .AddNMinusOneTimes
	pop bc
	dec de
	ld a, [de]
	cp $2
	jr z, .skip
	dec a
	dec a
.loop
	push af
	ld a, $7a
	ld [hli], a
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .loop
.skip
	pop hl
	ld bc, $14
	add hl, bc
	push hl
	ld a, [de]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	inc de
	ld a, [de]
	cp $2
	ret z
	push bc
	dec a
	dec a
	ld c, a
	ld b, a
	ld de, $14
.loop2
	ld a, $7c
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop2
	pop hl
.loop3
	ld a, $7c
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop3
	ret

.AddNMinusOneTimes:
	ld a, [de]
	dec a
	ld bc, SCREEN_WIDTH
.add_n_minus_one_times
	add hl, bc
	dec a
	jr nz, .add_n_minus_one_times
	ret

PrepareEZChatCustomBox:
	ld a, [wEZChatSelection]
	cp EZCHAT_MAIN_RESET
	ret nc
	ld hl, wMobileBoxSpriteLoadedIndex
	cp [hl]
	ret z
	ld [hl], a
	ld d, a
	call DelayFrame
	ld a, d
	call EZChatMenu_GetRealChosenWordSize
	ld hl, wMobileBoxSpriteBuffer
	ld c, a
	dec c
	cp EZCHAT_CUSTOM_BOX_BIG_SIZE
	jr c, .after_big_reshape
	ld a, (EZCHAT_CUSTOM_BOX_BIG_START * 2) - 1
	jr .done_reshape
.after_big_reshape
	ld a, d
	and 1
	ld a, d
	jr z, .after_reshape
	dec a
	dec a
.after_reshape
	inc a
	call EZChatMenu_GetRealChosenWordSize
	sub EZCHAT_CHARS_PER_LINE - ((EZCHAT_CHARS_PER_LINE - 1) / 2)
	ld c, a
	ld a, ((EZCHAT_CHARS_PER_LINE - 1) / 2)
	jr c, .prepare_for_resize
	dec a
	sub c
.prepare_for_resize
	ld c, a
	dec c

.done_reshape
	inc a
	sla a
	ld [hli], a
	ld de, $3000
	ld b, 0
	call .single_row
	ld de, $3308
.single_row
	push bc
	ld [hl], e
	inc hl
	ld [hl], b
	inc hl
	ld [hl], d
	inc hl
	inc d
	ld [hl], b
	inc hl
	ld a, c
	srl c
	sub c
	push bc
	ld c, a
	and a
	ld a, 8
	call nz, .line_loop
	pop bc
	sub a, 4
	ld [hl], a
	ld a, c
	and a
	ld a, [hl]
	call nz, .line_loop
	inc d
	ld [hl], e
	inc hl
	ld [hli], a
	ld [hl], d
	inc hl
	ld [hl], b
	inc hl
	pop bc
	ld a, c
	cp EZCHAT_CUSTOM_BOX_BIG_SIZE - 1
	ret c
	sub EZCHAT_CUSTOM_BOX_BIG_START - 2
	sla a
	sla a
	ld d, 0
	ld e, a
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, c
	sub (EZCHAT_CUSTOM_BOX_BIG_START * 2) - 2
	sla a
	sla a
	push hl
	ld e, a
	add hl, de
	pop de
	push bc
	ld c, EZCHAT_CUSTOM_BOX_BIG_START * 4
.resize_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .resize_loop
	pop bc
	ld h, d
	ld l, e
	ret

.line_loop
	ld [hl], e
	inc hl
	ld [hli], a
	add a, 8
	ld [hl], d
	inc hl
	ld [hl], b
	inc hl
	dec c
	jr nz, .line_loop
	ret

AnimateEZChatCursor: ; EZChat cursor drawing code, extends all the way down to roughly line 2958
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	jumptable .Jumptable, hl

.Jumptable:
	dw .zero   ; EZChat Message Menu
	dw .one    ; Category Menu
	dw .two    ; Sort By Letter Menu
	dw .three  ; Words Submenu
	dw .four   ; Yes/No Menu
	dw .five   ; Sort By Menu
	dw .six
	dw .seven
	dw .eight
	dw .nine
	dw .ten

.coords_null
	dbpixel  0,  20 ; A

.null_cursor_out
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_2
	call ReinitSpriteAnimFrame
	xor a
	ld hl, .coords_null
	jp .load

.zero ; EZChat Message Menu
; reinit sprite
	ld a, [wEZChatSelection]
	cp EZCHAT_MAIN_RESET
	jr c, .zero_check_word
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1
	jr .zero_sprite_anim_frame

.zero_check_word
	call EZChatMenu_GetChosenWordSize
	and a
	ret z
	push bc
	call PrepareEZChatCustomBox
	pop bc
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_CUSTOM_BOX
.zero_sprite_anim_frame
	call ReinitSpriteAnimFrame
	ld e, $1 ; Category Menu Index (?) (May be the priority of which the selection boxes appear (0 is highest))
	ld a, [wEZChatSelection]
	cp EZCHAT_MAIN_RESET
	jr nc, .use_base_coords
	ld hl, wMobileBoxSpritePositionData
	sla a
	jr .load

.use_base_coords
	sub EZCHAT_MAIN_RESET
	sla a
	ld hl, .Coords_Zero
	jr .load

.one ; Category Menu
	ld a, [wJumptableIndex]
	ld e, $2 ; Sort by Letter Menu Index (?)
	cp EZCHAT_DRAW_CATEGORY_MENU
	jr z, .continue_one
	cp EZCHAT_MENU_CATEGORY_MENU
	jr nz, .null_cursor_out
.continue_one
	ld a, [wEZChatCategorySelection]
	and $0f
	cp EZCHAT_CATEGORY_CANC
	push af
	jr c, .not_menu
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1
	call ReinitSpriteAnimFrame
	jr .got_sprite
.not_menu
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_2
	call ReinitSpriteAnimFrame
.got_sprite
	pop af
	sla a
	ld hl, .Coords_One
	ld e, $2 ; Sort by Letter Menu Index (?)
	jr .load

.two ; Sort By Letter Menu
	ld a, [wJumptableIndex]
	ld e, $4 ; Yes/No Menu Index (?)
	cp EZCHAT_DRAW_SORT_BY_CHARACTER
	jr z, .continue_two
	cp EZCHAT_MENU_SORT_BY_CHARACTER
	jr nz, .null_cursor_out
.continue_two
	ld hl, .FramesetsIDs_Two
	ld a, [wEZChatSortedSelection]
	ld e, a
	ld d, $0 ; Message Menu Index (?)
	add hl, de
	ld a, [hl]
	call ReinitSpriteAnimFrame

	ld a, [wEZChatSortedSelection]
	sla a
	ld hl, .Coords_Two
	ld e, $4 ; Yes/No Menu Index (?)
	jr .load

.three ; Words Submenu
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_2 ; $27
	call ReinitSpriteAnimFrame
	ld a, [wEZChatWordSelection]
	sla a
	ld hl, .Coords_Three
	ld e, $8
.load
	push de
	ld e, a
	ld d, $0 ; Message Menu Index (?)
	add hl, de
	push hl
	pop de
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	pop de
	ld a, e
	call .UpdateObjectFlags
	ret

.four ; Yes/No Menu
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_2 ; $27
	call ReinitSpriteAnimFrame
	ld a, [wcd2a]
	sla a
	ld hl, .Coords_Four
	ld e, $10
	jr .load

.five ; Sort By Menu
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_2 ; $27
	call ReinitSpriteAnimFrame
	ld a, [wcd2c]
	sla a
	ld hl, .Coords_Five
	ld e, $20
	jr .load

.six
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_5 ; $2a
	call ReinitSpriteAnimFrame
	ld a, [wcd4a] ; X = [wcd4a] * 8 + 24
	sla a
	sla a
	sla a
	add $18
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hli], a
	ld a, $30 ; Y = 48
	ld [hl], a

	ld a, $1
	ld e, a
	call .UpdateObjectFlags
	ret

.seven
	ld a, [wEZChatCursorYCoord]
	cp $4 ; Yes/No Menu Index (?)
	jr z, .cursor0
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3 ; $28
	jr .got_frameset
;test
.cursor0
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1 ; $26
.got_frameset
	call ReinitSpriteAnimFrame
	ld a, [wEZChatCursorYCoord]
	cp $4 ; Yes/No Menu Index (?)
	jr z, .asm_11d1b1
	ld a, [wEZChatCursorXCoord]	; X = [wEZChatCursorXCoord] * 8 + 32
	sla a
	sla a
	sla a
	add $20
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hli], a
	ld a, [wEZChatCursorYCoord]	; Y = [wEZChatCursorYCoord] * 16 + 72
	sla a
	sla a
	sla a
	sla a
	add $48
	ld [hl], a
	ld a, $2 ; Sort by Letter Menu Index (?)
	ld e, a
	call .UpdateObjectFlags
	ret

.asm_11d1b1
	ld a, [wEZChatCursorXCoord] ; X = [wEZChatCursorXCoord] * 40 + 24
	sla a
	sla a
	sla a
	ld e, a
	sla a
	sla a
	add e
	add $18
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hli], a
	ld a, $8a ; Y = 138
	ld [hl], a
	ld a, $2 ; Sort By Letter Menu Index (?)
	ld e, a
	call .UpdateObjectFlags
	ret

.nine
	ld d, -13 * 8
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_7 ; $2c
	jr .eight_nine_load

.eight
	ld d, 2 * 8
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_6 ; $2b
.eight_nine_load
	push de
	call ReinitSpriteAnimFrame
	ld a, [wcd4a]
	sla a
	sla a
	sla a
	ld e, a
	sla a
	add e
	add 8 * 8
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hld], a
	pop af
	ld [hl], a
	ld a, $4 ; Yes/No Menu Index (?)
	ld e, a
	call .UpdateObjectFlags
	ret

.ten
	ld a, SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1 ; $26
	call ReinitSpriteAnimFrame
	ld a, $8
	ld e, a
	call .UpdateObjectFlags
	ret

.Coords_Zero: ; EZChat Message Menu
	dbpixel  1, 17, 5, 2 ; RESET     - 04
	dbpixel  7, 17, 5, 2 ; QUIT      - 05
	dbpixel 13, 17, 5, 2 ; OK        - 06

.Coords_One: ; Category Menu
	dbpixel  0,  8, 8, 8 ; Category 1
	dbpixel 10,  8, 8, 8 ; Category 2
	dbpixel  0, 10, 8, 8 ; Category 3
	dbpixel 10, 10, 8, 8 ; Category 4
	dbpixel  0, 12, 8, 8 ; Category 5
	dbpixel 10, 12, 8, 8 ; Category 6
	dbpixel  0, 14, 8, 8 ; Category 7
	dbpixel 10, 14, 8, 8 ; Category 8
	dbpixel  0, 16, 8, 8 ; Category 9
	dbpixel 10, 16, 8, 8 ; Category 10
	dbpixel  1, 18, 5, 2 ; DEL
	dbpixel  7, 18, 5, 2 ; MODE
	dbpixel 13, 18, 5, 2 ; QUIT

.Coords_Two: ; Sort By Letter Menu
	table_width 2, .Coords_Two
	dbpixel  2,  9 ; A
	dbpixel  4,  9 ; B
	dbpixel  6,  9 ; C
	dbpixel  8,  9 ; D
	dbpixel 10,  9 ; E
	dbpixel 12,  9 ; F
	dbpixel 14,  9 ; G
	dbpixel 16,  9 ; H
	dbpixel 18,  9 ; I
	dbpixel  2, 11 ; J
	dbpixel  4, 11 ; K
	dbpixel  6, 11 ; L
	dbpixel  8, 11 ; M
	dbpixel 10, 11 ; N
	dbpixel 12, 11 ; O
	dbpixel 14, 11 ; P
	dbpixel 16, 11 ; Q
	dbpixel 18, 11 ; R
	dbpixel  2, 13 ; S
	dbpixel  4, 13 ; T
	dbpixel  6, 13 ; U
	dbpixel  8, 13 ; V
	dbpixel 10, 13 ; W
	dbpixel 12, 13 ; X
	dbpixel 14, 13 ; Y
	dbpixel 16, 13 ; Z
	dbpixel  2, 15 ; ETC.
	dbpixel  1, 18, 5, 2 ; ERASE
	dbpixel  7, 18, 5, 2 ; MODE
	dbpixel 13, 18, 5, 2 ; CANCEL
	assert_table_length NUM_EZCHAT_SORTED

.Coords_Three: ; Words Submenu Arrow Positions
	dbpixel  2, 10
	dbpixel  11, 10 ; 8, 10 MENU_WIDTH
	dbpixel  2, 12
	dbpixel  11, 12 ; 8, 12 MENU_WIDTH
	dbpixel  2, 14
	dbpixel  11, 14 ; 8, 14 MENU_WIDTH
	dbpixel  2, 16
	dbpixel  11, 16 ; 8, 16 MENU_WIDTH

.Coords_Four: ; Yes/No Box
	dbpixel 17, 10 ; YES
	dbpixel 17, 12 ; NO

.Coords_Five: ; Sort By Menu
	dbpixel  2, 10 ; Group Mode
	dbpixel  2, 12 ; ABC Mode

.FramesetsIDs_Two:
	table_width 1, .FramesetsIDs_Two
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 00 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 01 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 02 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 03 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 04 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 05 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 06 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 07 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 08 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 09 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0a (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0b (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0c (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0d (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0e (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 0f (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 10 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 11 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 12 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 13 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 14 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 15 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 16 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 17 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 18 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_3  ; 19 (Letter selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_10 ; 1a (Misc selection box for the sort by menu)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1  ; 1c (Bottom Menu Selection box?)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1  ; 1d (Bottom Menu Selection box?)
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1  ; 1e (Bottom Menu Selection box?)
	assert_table_length NUM_EZCHAT_SORTED

.UpdateObjectFlags:
	ld hl, wEZChatSpritesMask
	and [hl]
	jr nz, .update_y_offset
	ld a, e
	ld hl, wEZChatBlinkingMask
	and [hl]
	jr z, .reset_y_offset
	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	ld a, [hl]
	and a
	jr z, .flip_bit_0
	dec [hl]
	ret

.flip_bit_0
	ld a, $0
	ld [hld], a
	ld a, $1
	xor [hl]
	ld [hl], a
	and a
	jr nz, .update_y_offset
.reset_y_offset
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	xor a
	ld [hl], a
	ret

.update_y_offset
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, $b0
	sub [hl]
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

Function11d323:
	ldh a, [rSVBK]
	push af
	ld a, $5
	ldh [rSVBK], a
	ld hl, Palette_11d33a
	ld de, wBGPals1
	ld bc, 16 palettes
	call CopyBytes
	pop af
	ldh [rSVBK], a
	ret

Palette_11d33a:
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 16, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 23, 17, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

EZChat_GetSeenPokemonByKana:
; final placement of words in the sorted category, stored in 5:D800
	ldh a, [rSVBK]
	push af
	ld hl, wEZChatSortedWordPointers
	ld a, LOW(wEZChatSortedWords)
	ld [wcd2d], a
	ld [hli], a
	ld a, HIGH(wEZChatSortedWords)
	ld [wcd2e], a
	ld [hl], a

	ld a, LOW(EZChat_SortedPokemon)
	ld [wcd2f], a
	ld a, HIGH(EZChat_SortedPokemon)
	ld [wcd30], a

	ld a, LOW(wc6a8)
	ld [wcd31], a
	ld a, HIGH(wc6a8)
	ld [wcd32], a

	ld a, LOW(wc64a)
	ld [wcd33], a
	ld a, HIGH(wc64a)
	ld [wcd34], a

	ld hl, EZChat_SortedWords
	ld a, (EZChat_SortedWords.End - EZChat_SortedWords) / 4

.MasterLoop:
	push af
; read row
; offset
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; size
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
; bc == 0?
	or c

; save the pointer to the next row
	push hl
; add de to w3_d000
	ld hl, w3_d000
	add hl, de
; recover de from wcd2d (default: wEZChatSortedWords)
	ld a, [wcd2d]
	ld e, a
	ld a, [wcd2e]
	ld d, a
; save bc for later
	push bc
	jr z, .done_copying

.loop1
; copy 2*bc bytes from 3:hl to 5:de
	ld a, $3
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, $5
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de

	ld a, $3
	ldh [rSVBK], a
	ld a, [hli]
	push af
	ld a, $5
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de

	dec bc
	ld a, c
	or b
	jr nz, .loop1

.done_copying
; recover the pointer from wcd2f (default: EZChat_SortedPokemon)
	ld a, [wcd2f]
	ld l, a
	ld a, [wcd30]
	ld h, a
; copy the pointer from [hl] to bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
; store the pointer to the next pointer back in wcd2f
	ld a, l
	ld [wcd2f], a
	ld a, h
	ld [wcd30], a
	ld h, b
	ld l, c
	ld c, $0
.loop2
; Have you seen this Pokemon?
	ld a, [hl]
	cp $ff
	jr z, .done
	call .CheckSeenMon
	jr nz, .next
; If not, skip it.
	inc hl
	jr .loop2

.next
; If so, append it to the list at 5:de, and increase the count.
	ld a, [hli]
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	inc c
	jr .loop2

.done
; Remember the original value of bc from the table?
; Well, the stack remembers it, and it's popping it to hl.
	pop hl
; Add the number of seen Pokemon from the list.
	ld b, $0
	add hl, bc
; Push pop to bc.
	ld b, h
	ld c, l
; Load the pointer from [wcd31] (default: wc6a8)
	ld a, [wcd31]
	ld l, a
	ld a, [wcd32]
	ld h, a
; Save the quantity from bc to [hl]
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
; Save the new value of hl to [wcd31]
	ld a, l
	ld [wcd31], a
	ld a, h
	ld [wcd32], a
; Recover the pointer from [wcd33] (default: wc64a)
	ld a, [wcd33]
	ld l, a
	ld a, [wcd34]
	ld h, a
; Save the current value of de there
	ld a, e
	ld [wcd2d], a
	ld [hli], a
	ld a, d
	ld [wcd2e], a
; Save the new value of hl back to [wcd33]
	ld [hli], a
	ld a, l
	ld [wcd33], a
	ld a, h
	ld [wcd34], a
; Next row
	pop hl
	pop af
	dec a
	jr z, .ExitMasterLoop
	jp .MasterLoop

.ExitMasterLoop:
	pop af
	ldh [rSVBK], a
	ret

.CheckSeenMon:
	push hl
	push bc
	push de
	dec a
	ld hl, rSVBK
	ld e, $1
	ld [hl], e
	call CheckSeenMon
	ld hl, rSVBK
	ld e, $5
	ld [hl], e
	pop de
	pop bc
	pop hl
	ret

EZChat_GetCategoryWordsByKana:
; initial sort of words, stored in 3:D000
	ldh a, [rSVBK]
	push af
	ld a, BANK(w3_d000)
	ldh [rSVBK], a

	; load pointers
	ld hl, MobileEZChatCategoryPointers
	ld bc, MobileEZChatData_WordAndPageCounts

	; init WRAM registers
	xor a
	ld [wcd2d], a
	inc a
	ld [wcd2e], a

	; enter the first loop
	ld a, 14 ; number of categories
.loop1
	push af

	; load the pointer to the category
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl

	; skip to the attributes
	ld hl, EZCHAT_WORD_LENGTH
	add hl, de

	; get the number of words in the category
	ld a, [bc] ; number of entries to copy
	inc bc
	inc bc
	push bc

.loop2
	push af
	push hl

	; load word placement offset from [hl] -> de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a

	; add to w3_d000
	ld hl, w3_d000
	add hl, de

	; copy from wcd2d and increment [wcd2d] in place
	ld a, [wcd2d]
	ld [hli], a
	inc a
	ld [wcd2d], a

	; copy from wcd2e
	ld a, [wcd2e]
	ld [hl], a

	; next entry
	pop hl
	ld de, EZCHAT_WORD_LENGTH + 3
	add hl, de
	pop af
	dec a
	jr nz, .loop2

	; reset and go to next category
	ld hl, wcd2d
	xor a
	ld [hli], a
	inc [hl]
	pop bc
	pop hl
	pop af
	dec a
	jr nz, .loop1
	pop af
	ldh [rSVBK], a
	ret

INCLUDE "data/pokemon/ezchat_order.asm"

SelectStartGFX:
INCBIN "gfx/mobile/select_start.2bpp"

EZChatSlowpokeLZ:
INCBIN "gfx/pokedex/slowpoke_mobile.2bpp.lz"

MobileEZChatCategoryNames:
; Fixed message categories
	db "POKéMON@"	; 00 ; Pokemon		; "ポケモン@@" ; this could've also been rendered as <PK><MN> but it looks odd
	db "TIPI@"		; 01 ; Types		; "タイプ@@@"
	db "SALUTI@"	; 02 ; Greetings	; "あいさつ@@"
	db "AMICI@"		; 03 ; People		; "ひと@@@@"
	db "LOTTA@"		; 04 ; Battle		; "バトル@@@"
	db "VOCI@"		; 05 ; Voices		; "こえ@@@@"
	db "DISCORSO@"	; 06 ; Speech		; "かいわ@@@"
	db "EMOZIONI@"	; 07 ; Feelings		; "きもち@@@"
	db "VIRTÙ@"		; 08 ; Conditions	; "じょうたい@"
	db "VITA@"		; 09 ; Lifestyle	; "せいかつ@@"
	db "HOBBY@"		; 0a ; Hobbies		; "しゅみ@@@"
	db "VERBI@"		; 0b ; Actions		; "こうどう@@"
	db "TEMPO@"		; 0c ; Time			; "じかん@@@"
	db "GRAMM.@"	; 0d ; Endings		; "むすび@@@"
	db "ALTRO@"		; 0e ; Misc			; "あれこれ@@"
	db " @@@@@"		; 0f ; EMPTY

MobileEZChatCategoryPointers:
; entries correspond to EZCHAT_* constants
	dw .Types          ; 01
	dw .Greetings      ; 02
	dw .People         ; 03
	dw .Battle         ; 04
	dw .Exclamations   ; 05
	dw .Conversation   ; 06
	dw .Feelings       ; 07
	dw .Conditions     ; 08
	dw .Life           ; 09
	dw .Hobbies        ; 0a
	dw .Actions        ; 0b
	dw .Time           ; 0c
	dw .Farewells      ; 0d
	dw .ThisAndThat    ; 0e

MACRO ezchat_word
	db \1 ; word
	dw \2 ; where to put the word relative to the start of the sorted words array (must be divisible by 2)
	db 0 ; padding
ENDM

.Types:
        ezchat_word "BUIO@@@@", $0da
        ezchat_word "ROCCIA@@", $45a
        ezchat_word "PSICO@@@", $40c
        ezchat_word "LOTTA@@@", $2cc
        ezchat_word "ERBA@@@@", $1d0
        ezchat_word "SPETTRO@", $4dc
        ezchat_word "GHIACCIO", $23c
        ezchat_word "TERRA@@@", $514
        ezchat_word "TIPO@@@@", $522
        ezchat_word "ELETTRO@", $1ce
        ezchat_word "VELENO@@", $580
        ezchat_word "DRAGO@@@", $1ac
        ezchat_word "NORMALE@", $366
        ezchat_word "ACCIAIO@", $024
        ezchat_word "VOLANTE@", $5b6
        ezchat_word "FUOCO@@@", $232
        ezchat_word "ACQUA@@@", $026
        ezchat_word "COLEOT.@", $12a
.Greetings:
        ezchat_word "GRAZIE!@", $25e
        ezchat_word "GRAZIE@@", $25c
        ezchat_word "LUI È@@@", $2de
        ezchat_word "SU, SU!@", $4f4
        ezchat_word "AGISCI!@", $046
        ezchat_word "SÌÌÌ@@@@", $4ae
        ezchat_word "COME SEI", $132
        ezchat_word "BUONDÌ!@", $0de
        ezchat_word "EVVIVA!@", $1e6
        ezchat_word "SCUSA@@@", $48a
        ezchat_word "SCUSA!@@", $48c
        ezchat_word "COME VA@", $134
        ezchat_word "CIAO!@@@", $11e
        ezchat_word "SALVE@@@", $468
        ezchat_word "BYE-BYE@", $0e4
        ezchat_word "SALUTE!@", $464
        ezchat_word "SONO QUI", $4c4
        ezchat_word "MI SCUS@", $308
        ezchat_word "DISPIAC@", $18a
        ezchat_word "A DOPO@@", $018
        ezchat_word "YO!@@@@@", $5d0
        ezchat_word "BEH…@@@@", $0ca
        ezchat_word "GRATO@@@", $25a
        ezchat_word "CIAO@@@@", $11c
        ezchat_word "CIAOOO@@", $120
        ezchat_word "CERTO…@@", $0fc
        ezchat_word "ADDIO@@@", $028
        ezchat_word "EHI@@@@@", $1c6
        ezchat_word "A POI!@@", $01a
        ezchat_word "PRONTO?@", $404
        ezchat_word "IH IH I@", $278
        ezchat_word "AHÒ!@@@@", $054
        ezchat_word "VISITA@@", $5a6
        ezchat_word "SALUTI@@", $466
        ezchat_word "SCOPERT@", $482
        ezchat_word "AVANTI!@", $0b0
.People:
        ezchat_word "RIVALE@@", $456
        ezchat_word "NEVVERO@", $342
        ezchat_word "SARAI@@@", $474
        ezchat_word "IO E TE@", $2a0
        ezchat_word "FIGLIO@@", $210
        ezchat_word "TUE@@@@@", $53c
        ezchat_word "TU SEI@@", $538
        ezchat_word "TU HAI@@", $536
        ezchat_word "MAMMA@@@", $2f0
        ezchat_word "NONNO@@@", $362
        ezchat_word "ZIO@@@@@", $5d4
        ezchat_word "PAPÀ@@@@", $3a6
        ezchat_word "RAGAZZO@", $442
        ezchat_word "ADULTO@@", $040
        ezchat_word "FRATELLO", $228
        ezchat_word "SORELLA@", $4c8
        ezchat_word "NONNA@@@", $360
        ezchat_word "ZIA@@@@@", $5d2
        ezchat_word "INSIEME@", $290
        ezchat_word "BAMBINA@", $0be
        ezchat_word "TESORIN@", $516
        ezchat_word "FAMIGLIA", $1f4
        ezchat_word "QUELLI@@", $42a
        ezchat_word "NON È@@@", $356
        ezchat_word "ESSO@@@@", $1de
        ezchat_word "NON PUÒ@", $35a
        ezchat_word "FIGLIA@@", $20e
        ezchat_word "CONTACI@", $140
        ezchat_word "DAI SU!@", $15e
        ezchat_word "NON SON@", $35c
        ezchat_word "RAGAZZA@", $43c
        ezchat_word "FRATELLI", $226
        ezchat_word "BAMBINI@", $0c0
        ezchat_word "MEDESIM@", $2fa
        ezchat_word "IO ERO@@", $2a2
        ezchat_word "PER ME@@", $3bc
        ezchat_word "IL MIO@@", $27e
        ezchat_word "IO SONO@", $2a4
        ezchat_word "COPPIA@@", $146
        ezchat_word "CHI@@@@@", $10a
        ezchat_word "QUALCUN@", $418
        ezchat_word "CHE ERA@", $106
        ezchat_word "A CUI@@@", $016
        ezchat_word "AMICI@@@", $076
        ezchat_word "CHE È@@@", $104
        ezchat_word "ALLEATA@", $060
        ezchat_word "ALLEATO@", $062
        ezchat_word "AMICA@@@", $074
        ezchat_word "AMICO@@@", $07a
        ezchat_word "PERSONA@", $3d8
        ezchat_word "BAMBINO@", $0c2
        ezchat_word "ESSI@@@@", $1dc
        ezchat_word "D'AMORE@", $15a
        ezchat_word "PER LOR@", $3ba
        ezchat_word "IL LORO@", $27c
        ezchat_word "TI PREG@", $51c
        ezchat_word "VORREI@@", $5c0
        ezchat_word "DI CUORE", $180
        ezchat_word "LEGAME@@", $2b4
        ezchat_word "AMORE@@@", $07c
        ezchat_word "RAGAZZE@", $43e
        ezchat_word "AMICIZIA", $078
        ezchat_word "RAGAZZI@", $440
        ezchat_word "CUGINO@@", $156
        ezchat_word "CUGINA@@", $154
        ezchat_word "PER LEI@", $3b8
        ezchat_word "LA SUA@@", $2ac
        ezchat_word "SINTONIA", $4b6
        ezchat_word "ARMONIA@", $092
.Battle:
        ezchat_word "LEI È@@@", $2ba
        ezchat_word "VIA!@@@@", $58c
        ezchat_word "Nº 1@@@@", $348
        ezchat_word "CARICO!@", $0f4
        ezchat_word "SUCCESS@", $4f8
        ezchat_word "VINCE@@@", $592
        ezchat_word "VINCO@@@", $59e
        ezchat_word "VINTO@@@", $5a2
        ezchat_word "VINCERE@", $594
        ezchat_word "VINCERÒ@", $596
        ezchat_word "FLEBILE@", $21c
        ezchat_word "SE VINC@", $492
        ezchat_word "PERDERÒ@", $3c4
        ezchat_word "VINCI@@@", $59a
        ezchat_word "DECISO@@", $168
        ezchat_word "ASSO@@@@", $0a2
        ezchat_word "BATTERE@", $0c6
        ezchat_word "FORZA!@@", $224
        ezchat_word "ATTACCO@", $0a4
        ezchat_word "RESA@@@@", $44e
        ezchat_word "FEGATO@@", $200
        ezchat_word "MATCH@@@", $2f6
        ezchat_word "TATTICA@", $506
        ezchat_word "PERDETE@", $3c6
        ezchat_word "INCONTRO", $28a
        ezchat_word "VITTORIA", $5aa
        ezchat_word "ASSALTO@", $09e
        ezchat_word "GUSTO@@@", $266
        ezchat_word "CONTRO@@", $144
        ezchat_word "LOTTE@@@", $2d6
        ezchat_word "POTENZA@", $3f2
        ezchat_word "SFIDA@@@", $4a2
        ezchat_word "FORTE@@@", $220
        ezchat_word "FORTI@@@", $222
        ezchat_word "ADORATO@", $038
        ezchat_word "ORRIBIL@", $398
        ezchat_word "SQUADRA@", $4e2
        ezchat_word "NEMICO@@", $33e
        ezchat_word "PERDI@@@", $3c8
        ezchat_word "VINCIAMO", $59c
        ezchat_word "ALLEN.@@", $066
        ezchat_word "FUGA@@@@", $22e
        ezchat_word "MODESTO@", $318
        ezchat_word "VINCETE@", $598
        ezchat_word "SCOPO@@@", $484
        ezchat_word "DUELLO@@", $1ae
        ezchat_word "RECUPERO", $44a
        ezchat_word "PUNTI@@@", $410
        ezchat_word "POKéMON@", $3ee
        ezchat_word "PERDE@@@", $3c0
        ezchat_word "OH NO!@@", $382
        ezchat_word "DISFATT@", $188
        ezchat_word "PERDERE@", $3c2
        ezchat_word "PERSO@@@", $3d6
        ezchat_word "PERDO@@@", $3cc
        ezchat_word "DIFESA@@", $186
        ezchat_word "COMPAGNO", $136
        ezchat_word "NO, NO!@", $34a
        ezchat_word "PERDIAMO", $3ca
        ezchat_word "INVITTO@", $29c
        ezchat_word "AH-HA!@@", $04a
        ezchat_word "DEBOLI@@", $164
        ezchat_word "DEBOLE@@", $162
        ezchat_word "VINCONO@", $5a0
        ezchat_word "IN ERBA@", $286
        ezchat_word "CAPITAN@", $0ee
        ezchat_word "REGOLA@@", $44c
        ezchat_word "LIVELLO@", $2c4
        ezchat_word "MOSSA@@@", $31e
.Exclamations:
        ezchat_word "!!@@@@@@", $002
        ezchat_word "!@@@@@@@", $000
        ezchat_word ".@@@@@@@", $008
        ezchat_word "?!@@@@@@", $012
        ezchat_word "?@@@@@@@", $010
        ezchat_word "…!@@@@@@", $00c
        ezchat_word "………@@@@@", $00e
        ezchat_word "-@@@@@@@", $004
        ezchat_word "- - -@@@", $006
        ezchat_word "OH OH@@@", $386
        ezchat_word "OH NOOO@", $384
        ezchat_word "AHAHAHA@", $04e
        ezchat_word "OH?@@@@@", $38a
        ezchat_word "NOOO…@@@", $364
        ezchat_word "SÌ@@@@@@", $4a8
        ezchat_word "URGH@@@@", $55a
        ezchat_word "UHMM…@@@", $54c
        ezchat_word "EHI!!!@@", $1c8
        ezchat_word "AAAAAH!@", $01e
        ezchat_word "WOW@@@@@", $5ce
        ezchat_word "RISATIN@", $454
        ezchat_word "PANICO!@", $3a4
        ezchat_word "STRILLI@", $4ea
        ezchat_word "CAPITO?@", $0f0
        ezchat_word "EH?@@@@@", $1be
        ezchat_word "VERSO@@@", $586
        ezchat_word "EHEHE@@@", $1c2
        ezchat_word "ATTIMO!@", $0a6
        ezchat_word "OH SÌÌÌ@", $388
        ezchat_word "OOPS@@@@", $392
        ezchat_word "AIUTO!@@", $058
        ezchat_word "PUAH!@@@", $40e
        ezchat_word "GRAAAH@@", $256
        ezchat_word "EH EH E@", $1bc
        ezchat_word "DIAMINE!", $182
        ezchat_word "SOB SOB@", $4ba
        ezchat_word "BUF@@@@@", $0d8
        ezchat_word "EHEH@@@@", $1c0
        ezchat_word "NO@@@@@@", $346
        ezchat_word "SCUSA?@@", $48e
        ezchat_word "ESATTO!@", $1d6
        ezchat_word "AHAHAH@@", $04c
        ezchat_word "EVVIVA@@", $1e4
        ezchat_word "AHIMÈ@@@", $052
        ezchat_word "FUFUFU@@", $22c
        ezchat_word "SUSSURR@", $500
        ezchat_word "OHI!@@@@", $38c
        ezchat_word "UFFA@@@@", $546
        ezchat_word "AUF@@@@@", $0a8
        ezchat_word "EHEHEH@@", $1c4
        ezchat_word "UUUUH!@@", $56e
        ezchat_word "OHOHOH@@", $38e
        ezchat_word "UHUH@@@@", $54e
        ezchat_word "OH CIELO", $380
        ezchat_word "ARRGH!@@", $096
        ezchat_word "MUFU@@@@", $320
        ezchat_word "MUFUFU@@", $322
        ezchat_word "MMM…@@@@", $314
        ezchat_word "VA BE'@@", $572
        ezchat_word "OK@@@@@@", $390
        ezchat_word "LALALA@@", $2ae
        ezchat_word "URRÀ!@@@", $55c
        ezchat_word "UFFA!@@@", $548
        ezchat_word "MAH!@@@@", $2ea
        ezchat_word "GUAGUAH@", $264
        ezchat_word "AHAHAHAH", $050
.Conversation:
        ezchat_word "DI@@@@@@", $17e
        ezchat_word "DEL@@@@@", $16e
        ezchat_word "A@@@@@@@", $014
        ezchat_word "QUANDO@@", $420
        ezchat_word "CON@@@@@", $13a
        ezchat_word "EHILÀ@@@", $1cc
        ezchat_word "AI@@@@@@", $056
        ezchat_word "PER@@@@@", $3b6
        ezchat_word "TRA@@@@@", $528
        ezchat_word "DA@@@@@@", $15c
        ezchat_word "O@@@@@@@", $376
        ezchat_word "MA@@@@@@", $2e2
        ezchat_word "DEI@@@@@", $16c
        ezchat_word "NÉ@@@@@@", $32e
        ezchat_word "CHE@@@@@", $100
        ezchat_word "COME@@@@", $12c
        ezchat_word "PERCHÉ@@", $3be
        ezchat_word "QUANTI@@", $424
        ezchat_word "PRESTO@@", $3fc
        ezchat_word "AGLI@@@@", $048
        ezchat_word "UN PO'@@", $552
        ezchat_word "OTTIMO@@", $39a
        ezchat_word "TOTALE@@", $526
        ezchat_word "QUANTO@@", $426
        ezchat_word "E@@@@@@@", $1b0
        ezchat_word "SOLO@@@@", $4c0
        ezchat_word "COI@@@@@", $128
        ezchat_word "DELLA@@@", $172
        ezchat_word "SE@@@@@@", $490
        ezchat_word "MOLTO@@@", $31a
        ezchat_word "POCO@@@@", $3ec
        ezchat_word "ALLO@@@@", $068
        ezchat_word "QUASI@@@", $428
        ezchat_word "INTENDO@", $292
        ezchat_word "DOVE@@@@", $1a4
        ezchat_word "MAI@@@@@", $2ec
        ezchat_word "FORSE@@@", $21e
        ezchat_word "AVANTI@@", $0ae
        ezchat_word "QUANTE@@", $422
        ezchat_word "EHI?@@@@", $1ca
        ezchat_word "LÌ@@@@@@", $2c0
        ezchat_word "SIA@@@@@", $4aa
        ezchat_word "NELLA@@@", $338
        ezchat_word "NEL@@@@@", $334
        ezchat_word "PROPRIO@", $406
        ezchat_word "FISSO@@@", $21a
        ezchat_word "UGUALE@@", $54a
        ezchat_word "DEGLI@@@", $16a
        ezchat_word "NELL'@@@", $336
        ezchat_word "DELLO@@@", $174
        ezchat_word "SICURO@@", $4ac
        ezchat_word "ALL'@@@@", $05c
        ezchat_word "NEI@@@@@", $332
        ezchat_word "NON@@@@@", $354
        ezchat_word "DELL'@@@", $170
        ezchat_word "INVECE@@", $298
        ezchat_word "NULLA@@@", $374
        ezchat_word "GIÀ@@@@@", $23e
        ezchat_word "CIÒ È@@@", $124
        ezchat_word "ALLA@@@@", $05e
        ezchat_word "ANCORA@@", $080
        ezchat_word "IN@@@@@@", $284
        ezchat_word "NELLO@@@", $33c
        ezchat_word "AL@@@@@@", $05a
        ezchat_word "NELLE@@@", $33a
        ezchat_word "NEGLI@@@", $330
.Feelings:
        ezchat_word "GENTILE@", $238
        ezchat_word "GIOCARE@", $244
        ezchat_word "ANIMO@@@", $08e
        ezchat_word "MI PIACI", $306
        ezchat_word "FELICE@@", $202
        ezchat_word "FELICITÀ", $206
        ezchat_word "FELICI@@", $204
        ezchat_word "OBBLIGO@", $378
        ezchat_word "DIVERTE@", $190
        ezchat_word "TRISTI@@", $532
        ezchat_word "GENTILI@", $23a
        ezchat_word "FALLITO@", $1f0
        ezchat_word "TRISTE@@", $530
        ezchat_word "TENTATO@", $512
        ezchat_word "ASCOLTA@", $098
        ezchat_word "PENSA@@@", $3b4
        ezchat_word "ADORATA@", $032
        ezchat_word "NOIA@@@@", $34e
        ezchat_word "ERRORE@@", $1d4
        ezchat_word "AVVERSO@", $0b6
        ezchat_word "ADIRATO@", $02a
        ezchat_word "RABBIA@@", $438
        ezchat_word "ISOLATO@", $2a6
        ezchat_word "SBAGLIO@", $476
        ezchat_word "GIOIA@@@", $24a
        ezchat_word "PIACETE@", $3e0
        ezchat_word "GIAMMAI@", $240
        ezchat_word "PIACIUTO", $3e6
        ezchat_word "MESTO@@@", $302
        ezchat_word "PIACE@@@", $3dc
        ezchat_word "CHE NOI@", $108
        ezchat_word "NOIOSO@@", $350
        ezchat_word "IMPORTA@", $282
        ezchat_word "ADORARE@", $030
        ezchat_word "ADORO@@@", $03e
        ezchat_word "ADORI@@@", $03a
        ezchat_word "ADORA@@@", $02c
        ezchat_word "ADORIAMO", $03c
        ezchat_word "ESAUSTO@", $1d8
        ezchat_word "ADORATE@", $034
        ezchat_word "ADORANO@", $02e
        ezchat_word "ADORATI@", $036
        ezchat_word "FAVOLOS@", $1fc
        ezchat_word "SPASSO@@", $4d4
        ezchat_word "SORPRESI", $4ce
        ezchat_word "SORPRESA", $4ca
        ezchat_word "PAURA@@@", $3aa
        ezchat_word "GIGANTI@", $242
        ezchat_word "PIACIUTI", $3e4
        ezchat_word "CAPACE@@", $0ec
        ezchat_word "VELOCE@@", $582
        ezchat_word "ASPETTA@", $09c
        ezchat_word "CONTENT@", $142
        ezchat_word "SORPRESO", $4d0
        ezchat_word "RARO@@@@", $448
        ezchat_word "SIMILE@@", $4b0
        ezchat_word "SORPRESE", $4cc
        ezchat_word "FATTO@@@", $1fa
        ezchat_word "PERICOL@", $3d2
        ezchat_word "FINITO@@", $216
        ezchat_word "BATTUTO@", $0c8
        ezchat_word "SPECIALE", $4d8
        ezchat_word "CIOÈ@@@@", $126
        ezchat_word "QUELLO@@", $42c
        ezchat_word "AMOROSO@", $07e
        ezchat_word "DOMANDA@", $198
        ezchat_word "PIACIUTA", $3e2
        ezchat_word "PIACERE@", $3de
        ezchat_word "SIMILI@@", $4b2
.Conditions:
        ezchat_word "CALDO@@@", $0e6
        ezchat_word "VIRTÙ@@@", $5a4
        ezchat_word "BUONI@@@", $0e0
        ezchat_word "BUONA@@@", $0dc
        ezchat_word "STUPIRE@", $4f0
        ezchat_word "BUONO@@@", $0e2
        ezchat_word "È BRAVO@", $1b4
        ezchat_word "MEGA@@@@", $2fc
        ezchat_word "CARICA!@", $0f2
        ezchat_word "È BRAVA@", $1b2
        ezchat_word "STRANO@@", $4e8
        ezchat_word "OCCUPAT@", $37a
        ezchat_word "VIVACITÀ", $5ac
        ezchat_word "PIENO@@@", $3ea
        ezchat_word "ASSENTE@", $0a0
        ezchat_word "BONTÀ@@@", $0d4
        ezchat_word "CORTESIA", $14a
        ezchat_word "SAPIDA@@", $470
        ezchat_word "TALENTO@", $502
        ezchat_word "GRANDE@@", $258
        ezchat_word "EFFICACE", $1b8
        ezchat_word "EFFICACI", $1ba
        ezchat_word "SPASSOS@", $4d6
        ezchat_word "BELLO@@@", $0cc
        ezchat_word "ROBUSTO@", $458
        ezchat_word "GRAZIOSO", $260
        ezchat_word "PERFETT@", $3d0
        ezchat_word "AFFABILI", $042
        ezchat_word "SANO@@@@", $46c
        ezchat_word "PAUROSO!", $3ac
        ezchat_word "SUPERBO@", $4fe
        ezchat_word "FREDDO@@", $22a
        ezchat_word "ALLEGRO@", $064
        ezchat_word "NATURALI", $32a
        ezchat_word "TANTO@@@", $504
        ezchat_word "IMMENSO@", $280
        ezchat_word "FAVOLOSO", $1fe
        ezchat_word "SENNÒ@@@", $49e
        ezchat_word "BENINO@@", $0d0
        ezchat_word "COSTOSO@", $150
        ezchat_word "CORRETT@", $148
        ezchat_word "TENERO@@", $510
        ezchat_word "FENOMENO", $208
        ezchat_word "MUTEVOL@", $326
        ezchat_word "STANCO@@", $4e4
        ezchat_word "ABILITÀ@", $022
        ezchat_word "NON-STO@", $35e
        ezchat_word "NESSUNO@", $340
        ezchat_word "PERIODO@", $3d4
        ezchat_word "NATURALE", $328
        ezchat_word "DIVENTA@", $18e
        ezchat_word "RAPIDO@@", $446
        ezchat_word "SPLENDE@", $4de
        ezchat_word "MINIMO@@", $310
        ezchat_word "BRUTTO@@", $0d6
        ezchat_word "IN FORMA", $288
        ezchat_word "ANNOIAT@", $090
        ezchat_word "SIMPATIA", $4b4
        ezchat_word "GOFFO@@@", $254
        ezchat_word "FALLO@@@", $1f2
        ezchat_word "AFFINE@@", $044
        ezchat_word "SPESSO@@", $4da
        ezchat_word "FIACCAT@", $20c
        ezchat_word "SEMPLICE", $498
        ezchat_word "SEMPLICI", $49a
        ezchat_word "VALORE@@", $57c
.Life:
        ezchat_word "COMPITI@", $138
        ezchat_word "CASA@@@@", $0f8
        ezchat_word "SOLDI@@@", $4be
        ezchat_word "PAGHETTA", $39e
        ezchat_word "BAGNO@@@", $0ba
        ezchat_word "SCUOLA@@", $488
        ezchat_word "RICORDA@", $450
        ezchat_word "GRUPPO@@", $262
        ezchat_word "PRESO@@@", $3fa
        ezchat_word "SCAMBIO@", $478
        ezchat_word "LAVORO@@", $2b0
        ezchat_word "TRENO@@@", $52e
        ezchat_word "AULA@@@@", $0aa
        ezchat_word "LEZIONI@", $2bc
        ezchat_word "EVOLVERE", $1e2
        ezchat_word "QUADERN@", $416
        ezchat_word "VIVERE@@", $5ae
        ezchat_word "DOCENTE@", $194
        ezchat_word "CENTRO@@", $0fa
        ezchat_word "TORRE@@@", $524
        ezchat_word "LINK@@@@", $2c2
        ezchat_word "PALLONE@", $3a2
        ezchat_word "TV@@@@@@", $544
        ezchat_word "TELEFONO", $50c
        ezchat_word "OGGETTO@", $37c
        ezchat_word "BARATTO@", $0c4
        ezchat_word "NOME@@@@", $352
        ezchat_word "NOTIZIE@", $370
        ezchat_word "MAESTRA@", $2e8
        ezchat_word "FESTA@@@", $20a
        ezchat_word "STUDIO@@", $4ee
        ezchat_word "MACCHINA", $2e6
        ezchat_word "SCHEDA@@", $47c
        ezchat_word "AVVISO@@", $0b8
        ezchat_word "RINNOVO@", $452
        ezchat_word "SOGNO@@@", $4bc
        ezchat_word "ASILO@@@", $09a
        ezchat_word "RADIO@@@", $43a
        ezchat_word "MONDO@@@", $31c
.Hobbies:
        ezchat_word "IDOLO@@@", $274
        ezchat_word "ROCK@@@@", $45c
        ezchat_word "SCIARE@@", $47e
        ezchat_word "CINEMA@@", $122
        ezchat_word "DOLCI@@@", $196
        ezchat_word "CHAT@@@@", $0fe
        ezchat_word "GIOCHI@@", $246
        ezchat_word "MODELLO@", $316
        ezchat_word "MUSICA@@", $324
        ezchat_word "CARTE@@@", $0f6
        ezchat_word "SHOPPING", $4a4
        ezchat_word "CUCINARE", $152
        ezchat_word "GIOCO@@@", $248
        ezchat_word "MANGIARE", $2f2
        ezchat_word "VAGARE@@", $578
        ezchat_word "BICI@@@@", $0d2
        ezchat_word "HOBBY@@@", $272
        ezchat_word "SPORT@@@", $4e0
        ezchat_word "CANTARE@", $0ea
        ezchat_word "TESORO@@", $518
        ezchat_word "VISITAR@", $5a8
        ezchat_word "BALLARE@", $0bc
        ezchat_word "PESCARE@", $3da
        ezchat_word "SCONTRO@", $480
        ezchat_word "TRENINI@", $52c
        ezchat_word "PELUCHE@", $3b2
        ezchat_word "PC@@@@@@", $3ae
        ezchat_word "FIORI@@@", $218
        ezchat_word "EROE@@@@", $1d2
        ezchat_word "DORMIRE@", $1a0
        ezchat_word "CAMPION@", $0e8
        ezchat_word "VIAGGIO@", $58e
        ezchat_word "TAVOLA@@", $508
        ezchat_word "PALLA@@@", $3a0
        ezchat_word "LEGGERE@", $2b6
        ezchat_word "FUMETTO@", $230
        ezchat_word "PROMESSA", $402
        ezchat_word "OZIARE@@", $39c
        ezchat_word "PIANI@@@", $3e8
.Actions:
        ezchat_word "AVERE@@@", $0b2
        ezchat_word "ESSERE@@", $1da
        ezchat_word "FACCIO@@", $1ec
        ezchat_word "FAI@@@@@", $1ee
        ezchat_word "FA@@@@@@", $1e8
        ezchat_word "FACCIAMO", $1ea
        ezchat_word "FATE@@@@", $1f8
        ezchat_word "FANNO@@@", $1f6
        ezchat_word "VOGLIONO", $5b2
        ezchat_word "ANDATO@@", $08a
        ezchat_word "CONSENS@", $13e
        ezchat_word "LOTTI@@@", $2d8
        ezchat_word "LOTTIAMO", $2da
        ezchat_word "LOTTATE@", $2d2
        ezchat_word "LOTTANO@", $2ce
        ezchat_word "LOTTATO@", $2d4
        ezchat_word "POSSO@@@", $3f0
        ezchat_word "PUOI@@@@", $414
        ezchat_word "PUÒ@@@@@", $412
        ezchat_word "POTETE@@", $3f4
        ezchat_word "LOTTARE@", $2d0
        ezchat_word "VOGLIO@@", $5b0
        ezchat_word "VUOI@@@@", $5ca
        ezchat_word "VUOLE@@@", $5cc
        ezchat_word "VOLETE@@", $5ba
        ezchat_word "VOLUTO@@", $5be
        ezchat_word "TI VA@@@", $51e
        ezchat_word "SAPERE@@", $46e
        ezchat_word "VADO@@@@", $576
        ezchat_word "VAI@@@@@", $57a
        ezchat_word "VA@@@@@@", $570
        ezchat_word "ANDIAMO@", $08c
        ezchat_word "ANDATE@@", $086
        ezchat_word "VANNO@@@", $57e
        ezchat_word "CHIAMI@@", $116
        ezchat_word "ANDATA@@", $084
        ezchat_word "ANDATI@@", $088
        ezchat_word "USO@@@@@", $56c
        ezchat_word "USI@@@@@", $568
        ezchat_word "USA@@@@@", $55e
        ezchat_word "USIAMO@@", $56a
        ezchat_word "USATE@@@", $564
        ezchat_word "USANO@@@", $560
        ezchat_word "USATO@@@", $566
        ezchat_word "CHIAMO@@", $118
        ezchat_word "CHIAMA@@", $10c
        ezchat_word "DORMITO@", $1a2
        ezchat_word "CHIAMATE", $112
        ezchat_word "CHIAMANO", $10e
        ezchat_word "CHIAMATO", $114
        ezchat_word "CHIAMARE", $110
        ezchat_word "SO@@@@@@", $4b8
        ezchat_word "SAI@@@@@", $462
        ezchat_word "SA@@@@@@", $45e
        ezchat_word "SANNO@@@", $46a
        ezchat_word "SAPUTO@@", $472
        ezchat_word "DEVO@@@@", $17a
        ezchat_word "DEVE@@@@", $178
        ezchat_word "DOBBIAMO", $192
        ezchat_word "DOVETE@@", $1a8
        ezchat_word "DEVONO@@", $17c
        ezchat_word "DOVUTO@@", $1aa
        ezchat_word "DOVERE@@", $1a6
        ezchat_word "ANDARE@@", $082
        ezchat_word "SCORDARE", $486
        ezchat_word "VOLERE@@", $5b8
        ezchat_word "STUDIARE", $4ec
        ezchat_word "USARE@@@", $562
        ezchat_word "POTUTO@@", $3f6
.Time:
        ezchat_word "AUTUNNO@", $0ac
        ezchat_word "MATTINA@", $2f8
        ezchat_word "DOMANI@@", $19a
        ezchat_word "GIORNO@@", $24e
        ezchat_word "A VOLTE@", $01c
        ezchat_word "SEMPRE@@", $49c
        ezchat_word "PRESENT@", $3f8
        ezchat_word "PERENNE@", $3ce
        ezchat_word "GIORNI@@", $24c
        ezchat_word "FINE@@@@", $214
        ezchat_word "MARTEDÌ@", $2f4
        ezchat_word "IERI@@@@", $276
        ezchat_word "OGGI@@@@", $37e
        ezchat_word "VENERDÌ@", $584
        ezchat_word "LUNEDÌ@@", $2e0
        ezchat_word "DOPO@@@@", $19e
        ezchat_word "PRIMA@@@", $3fe
        ezchat_word "PROSSIMA", $408
        ezchat_word "VOLTA@@@", $5bc
        ezchat_word "DECENNI@", $166
        ezchat_word "MERC.DÌ@", $2fe
        ezchat_word "INIZIO@@", $28c
        ezchat_word "MESE@@@@", $300
        ezchat_word "STOP@@@@", $4e6
        ezchat_word "ORA@@@@@", $396
        ezchat_word "FINALE@@", $212
        ezchat_word "PROSSIMO", $40a
        ezchat_word "SABATO@@", $460
        ezchat_word "ESTATE@@", $1e0
        ezchat_word "DOMENICA", $19c
        ezchat_word "TEMPO@@@", $50e
        ezchat_word "PRIMAV.@", $400
        ezchat_word "DIURNO@@", $18c
        ezchat_word "INVERNO@", $29a
        ezchat_word "PASSATO@", $3a8
        ezchat_word "GIOVEDÌ@", $250
        ezchat_word "SERA@@@@", $4a0
        ezchat_word "NOTTE@@@", $372
        ezchat_word "FUTURO@@", $236
.Farewells:
        ezchat_word "HAI@@@@@", $26a
        ezchat_word "SEI@@@@@", $496
        ezchat_word "…@@@@@@@", $00a
        ezchat_word "HM?@@@@@", $26e
        ezchat_word "INTESI?@", $296
        ezchat_word "HO@@@@@@", $270
        ezchat_word "QUALI@@@", $41c
        ezchat_word "QUALE@@@", $41a
        ezchat_word "ABBIAMO@", $020
        ezchat_word "AVETE@@@", $0b4
        ezchat_word "HANNO@@@", $26c
        ezchat_word "È@@@@@@@", $1b6
        ezchat_word "IO@@@@@@", $29e
        ezchat_word "TU@@@@@@", $534
        ezchat_word "CUI@@@@@", $158
        ezchat_word "SONO@@@@", $4c2
        ezchat_word "QUEST'@@", $42e
        ezchat_word "CHE COSA", $102
        ezchat_word "LEI@@@@@", $2b8
        ezchat_word "LUI@@@@@", $2dc
        ezchat_word "NOI@@@@@", $34c
        ezchat_word "VOI@@@@@", $5b4
        ezchat_word "LORO@@@@", $2ca
        ezchat_word "COME SE@", $130
        ezchat_word "TE@@@@@@", $50a
        ezchat_word "SÉ@@@@@@", $494
        ezchat_word "MI@@@@@@", $304
        ezchat_word "TI@@@@@@", $51a
        ezchat_word "LO@@@@@@", $2c6
        ezchat_word "LA@@@@@@", $2aa
        ezchat_word "HA@@@@@@", $268
        ezchat_word "NON HA@@", $358
        ezchat_word "UN@@@@@@", $550
        ezchat_word "UN'@@@@@", $554
        ezchat_word "SUO@@@@@", $4fc
        ezchat_word "SI@@@@@@", $4a6
        ezchat_word "CI@@@@@@", $11a
        ezchat_word "VI@@@@@@", $588
        ezchat_word "LI@@@@@@", $2be
        ezchat_word "LE@@@@@@", $2b2
        ezchat_word "NE@@@@@@", $32c
        ezchat_word "IL@@@@@@", $27a
        ezchat_word "L'@@@@@@", $2a8
        ezchat_word "QUESTO@@", $436
        ezchat_word "QUESTA@@", $430
        ezchat_word "UNO@@@@@", $558
        ezchat_word "UNA@@@@@", $556
        ezchat_word "MIO@@@@@", $312
        ezchat_word "MIA@@@@@", $30a
        ezchat_word "TUO@@@@@", $53e
        ezchat_word "TUA@@@@@", $53a
        ezchat_word "SUA@@@@@", $4f6
        ezchat_word "NOSTRO@@", $36e
        ezchat_word "NOSTRA@@", $368
        ezchat_word "VOSTRO@@", $5c8
        ezchat_word "VOSTRA@@", $5c2
        ezchat_word "MIEI@@@@", $30e
        ezchat_word "MIE@@@@@", $30c
        ezchat_word "TUOI@@@@", $540
        ezchat_word "SUE@@@@@", $4fa
        ezchat_word "NOSTRI@@", $36c
        ezchat_word "NOSTRE@@", $36a
        ezchat_word "VOSTRI@@", $5c6
        ezchat_word "VOSTRE@@", $5c4
        ezchat_word "QUESTE@@", $432
        ezchat_word "QUESTI@@", $434
.ThisAndThat:
        ezchat_word "ALTI@@@@", $06a
        ezchat_word "DAVVERO@", $160
        ezchat_word "TIPI@@@@", $520
        ezchat_word "DIETRO@@", $184
        ezchat_word "COSE@@@@", $14e
        ezchat_word "COSA@@@@", $14c
        ezchat_word "SOTTO@@@", $4d2
        ezchat_word "SOPRA@@@", $4c6
        ezchat_word "TUTTO@@@", $542
        ezchat_word "FUORI@@@", $234
        ezchat_word "DENTRO@@", $176
        ezchat_word "INOLTRE@", $28e
        ezchat_word "ALTRE@@@", $06e
        ezchat_word "ALTRO@@@", $072
        ezchat_word "ALTRA@@@", $06c
        ezchat_word "ALTRI@@@", $070
        ezchat_word "GIÙ@@@@@", $252
        ezchat_word "TRANNE@@", $52a
        ezchat_word "BENE@@@@", $0ce
        ezchat_word "MALE@@@@", $2ee
        ezchat_word "MA CHI@@", $2e4
        ezchat_word "PEGGIO@@", $3b0
        ezchat_word "RAGIONE@", $444
        ezchat_word "SU@@@@@@", $4f2
        ezchat_word "SCELTA@@", $47a
        ezchat_word "LONTANO@", $2c8
        ezchat_word "VI VA@@@", $58a
        ezchat_word "VICINO@@", $590
        ezchat_word "QUALORA@", $41e
        ezchat_word "NIENTE@@", $344
        ezchat_word "ARNESE@@", $094
        ezchat_word "INTERO@@", $294
        ezchat_word "VACUO@@@", $574
        ezchat_word "COME MA@", $12e
        ezchat_word "CONFUSO@", $13c
        ezchat_word "OPPOSTO@", $394

MobileEZChatData_WordAndPageCounts:
MACRO macro_11f220
; parameter: number of words
	db \1
; 12 words per page (0-based indexing)
	DEF x = \1 / (EZCHAT_WORD_COUNT * 2) ; 12 MENU_WIDTH to 8
	if \1 % (EZCHAT_WORD_COUNT * 2) == 0 ; 12 MENU_WIDTH to 8
		DEF x = x + -1
	endc
	db x
ENDM
	macro_11f220 18 ; 01: Types
	macro_11f220 36 ; 02: Greetings
	macro_11f220 69 ; 03: People
	macro_11f220 69 ; 04: Battle
	macro_11f220 66 ; 05: Exclamations
	macro_11f220 66 ; 06: Conversation
	macro_11f220 69 ; 07: Feelings
	macro_11f220 66 ; 08: Conditions
	macro_11f220 39 ; 09: Life
	macro_11f220 39 ; 0a: Hobbies
	macro_11f220 69 ; 0b: Actions
	macro_11f220 39 ; 0c: Time
	macro_11f220 66 ; 0d: Farewells
	macro_11f220 36 ; 0e: ThisAndThat

EZChat_SortedWords:
; Addresses in WRAM bank 3 where EZChat words beginning
; with the given kana are sorted in memory, and the pre-
; allocated size for each.
; These arrays are expanded dynamically to accomodate
; any Pokemon you've seen that starts with each kana.
MACRO macro_11f23c
	dw x - w3_d000, \1
	DEF x = x + 2 * \1
ENDM
DEF x = $d014
	macro_11f23c  83 ; A
	macro_11f23c  22 ; B
	macro_11f23c  58 ; C
	macro_11f23c  43 ; D
	macro_11f23c  28 ; E
	macro_11f23c  40 ; F
	macro_11f23c  24 ; G
	macro_11f23c  6 ; H
	macro_11f23c  26 ; I
	macro_11f23c   0 ; J
	macro_11f23c   0 ; K
	macro_11f23c  29 ; L
	macro_11f23c  35 ; M
	macro_11f23c  39 ; N
	macro_11f23c  20 ; O
	macro_11f23c  60 ; P
	macro_11f23c  17 ; Q
	macro_11f23c  19 ; R
	macro_11f23c  82 ; S
	macro_11f23c  34 ; T
	macro_11f23c  21 ; U
	macro_11f23c  47 ; V
	macro_11f23c   1 ; W
	macro_11f23c   0 ; X
	macro_11f23c   1 ; Y
	macro_11f23c   2 ; Z
DEF x = $d000
	macro_11f23c  10 ; !?
.End
