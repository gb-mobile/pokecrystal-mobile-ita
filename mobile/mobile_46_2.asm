_MobileAdapterCommunication:
	ld a, [wc821]
	bit 1, a
	jr nz, .asm_1187af
	bit 2, a
	jr nz, .asm_1187d1
	bit 0, a
	jr nz, .asm_1187aa
	ld a, [wcd89]
	and $1
	jr z, .asm_1187a7
	ld a, $3
	ldh [rSVBK], a
.asm_1187a7
	farcall BattleTowerRoomMenu_IncrementJumptable
	ret
.asm_1187aa
	call Function118821
	ret c
	ret
.asm_1187af
	ld a, MOBILEAPI_00
	call MobileAPI
	ld [wMobileErrorCodeBuffer], a
	ld a, l
	ld [wMobileErrorCodeBuffer + 1], a
	ld a, h
	ld [wMobileErrorCodeBuffer + 2], a
	ld a, MOBILEAPI_05
	call MobileAPI
	ld a, [wc3f0]
	ld [wc319], a
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret
.asm_1187d1
	ld hl, wcd89
	bit 0, [hl]
	jr nz, .asm_118803
	set 0, [hl]
	ld a, BANK(w6_d000)
	ldh [rSVBK], a
	ld de, w6_d000
	ld bc, $1000
	ld a, [hl]
	sla a
	jr c, .asm_1187f9
	sla a
	jr c, .asm_1187fd
	sla a
	jr c, .asm_1187f5
	ld a, MOBILEAPI_12
	jr .asm_1187ff
.asm_1187f5
	ld a, MOBILEAPI_14
	jr .asm_1187ff
.asm_1187f9
	ld a, MOBILEAPI_15
	jr .asm_1187ff
.asm_1187fd
	ld a, MOBILEAPI_16
.asm_1187ff
	call MobileAPI
	ret
.asm_118803
	ld a, $d3
	farcall SetMobileErrorCode
	ret

Function118821:
	ld a, [wc319]
	cp $3
	jr c, .asm_11884a
	cp $4
	jr z, .asm_11884a
	ldh a, [hJoyDown]
	cp $5
	jr nz, .asm_11884a
	ld a, MOBILEAPI_05
	call MobileAPI
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	ld a, [wc3f0]
	ld [wc319], a
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	scf
	ret
.asm_11884a
	and a
	ret

Function11884c:
	ldh a, [hJoyDown]
	cp $5
	jr nz, .asm_118864
	ld a, MOBILEAPI_05
	call MobileAPI
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	scf
	ret

.asm_118864
	and a
	ret

_StopPichuMobileAnimation:
	ld a, [wc3f0]
	ld [wc319], a
	ld c, $1
	farcall Function115e18
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	farcall BattleTowerRoomMenu2
	farcall BattleTowerRoomMenu_IncrementJumptable
	ret

BattleTowerRoomMenu_InitRAM:
	di
	ldh a, [rIE]
	ld [wcd32], a
	call DoubleSpeed
	xor a
	ldh [rIF], a
	ld [wMobileErrorCodeBuffer], a
	ld [wMobileErrorCodeBuffer + 1], a
	ld [wMobileErrorCodeBuffer + 2], a
	ld [wcd80], a
	ld [wcd65], a
	ld [wcd66], a
	ld [wcd67], a
	ld [wcd68], a
	ld [wc31a], a
	ld [wcd89], a
	ld [wcd8a], a
	ld [wcd8b], a
	ld [wc3ec], a
	ld [wc3ed], a
	ld [wc3ee], a
	ld [wc3ef], a
	ld hl, wVramState
	ld a, [hl]
	ld [wcd7f], a
	set 1, [hl]
	ld a, (1 << SERIAL) | (1 << TIMER) | (1 << LCD_STAT) | (1 << VBLANK)
	ldh [rIE], a
	ld a, $1
	ldh [hMobileReceive], a
	ldh [hMobile], a
	ei
	farcall Stubbed_Function106462
	farcall Function106464
	farcall Function115d99
	farcall Function11615a
	ld a, BANK(s5_bfff)
	call OpenSRAM
	xor a
	ld [s5_bfff], a
	call CloseSRAM
	ret

Function118000:
	ld a, $1
	ld [wcd38], a
	jr asm_11800b

asm_11800b:
	call BattleTowerRoomMenu_InitRAM
	ld a, $18
	ld [wcd33], a
	ld a, $19
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.loop
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .skip
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.skip
	farcall Function1184a5
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call ReturnToMapFromSubmenu
BattleTowerRoomMenu_DoNothing:
	ret

; upload record
Function11805f:
	ld a, $1
	ld [wcd38], a
	call BattleTowerRoomMenu_InitRAM
	ld a, $18
	ld [wcd33], a
	ld a, $19
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_11807d
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .asm_118090
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118090
	farcall Function11857c
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_11807d
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call ReturnToMapFromSubmenu
	ret

Function1180b8:
	call BattleTowerRoomMenu_InitRAM
	ld a, $22
	ld [wcd33], a
	ld a, $23
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_1180d1
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $28
	jr c, .asm_1180e4
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_1180e4
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $10
	jr c, .asm_1180f2
	cp $16
	jr nc, .asm_1180f2
	farcall Function11884c

.asm_1180f2
	farcall Function1184ec
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_1180d1
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call ReturnToMapFromSubmenu
	ret

Function11811a:
	ld a, 1
	ld [wcd38], a
	jr Function118125

_BattleTowerRoomMenu:
	xor a
	ld [wcd38], a
Function118125: ; jr_046_4125
	call BattleTowerRoomMenu_InitRAM
	ld a, $23;$3
	ld [wcd33], a
	ld a, $2d;$d
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.loop
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $32 ;$f
	jr c, .skip
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
.skip
	farcall BattleTowerRoomMenu_Jumptable
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .loop
	xor a
	ld [w3_d000], a
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call Function118180
	call ReturnToMapFromSubmenu
	ret

; save honor roll data to sram
Function118180:
	ld a, [wScriptVar]
	and a
	ret nz
	ld a, [wcd38]
	and a
	ret z
	ld a, BANK(s5_a89c)
	call OpenSRAM
	ld hl, wcd69
	ld de, s5_a89c
	ld bc, $0016
	call CopyBytes

	ldh a, [rSVBK]
	push af
	ld a, BANK(w3_d202)
	ldh [rSVBK], a

	ld de, w3_d202
	ld c, HONOR_ROLL_DATA_LENGTH;$96
	farcall CheckStringForErrors_IgnoreTerminator
	jr c, .return_d3

	ld de, w3_d202
	lb bc, 1, HONOR_ROLL_DATA_LENGTH;$96
	farcall CheckStringContainsLessThanBNextCharacters
	jr c, .return_d3

	ld hl, w3_d202
	ld de, s5_a8b2
	ld bc, HONOR_ROLL_DATA_LENGTH;$0096
	call CopyBytes
.reset_banks
	pop af
	ldh [rSVBK], a
	call CloseSRAM
	ret

.return_d3
	ld a, $d3
	ld [wMobileErrorCodeBuffer], a
	ld [wScriptVar], a
	jr .reset_banks

Function1181da:
	call BattleTowerRoomMenu_InitRAM
	ld a, $2
	ld [wcd38], a
	ld a, $21
	ld [wcd33], a
	ld a, $22
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_1181f8
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $28
	jr c, .asm_11820b
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_11820b
	farcall Function1185c3
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_1181f8
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call ReturnToMapFromSubmenu
	ret

Function118233:
	call BattleTowerRoomMenu_InitRAM
	ld a, $1b
	ld [wcd33], a
	ld a, $1c
	ld [wcd34], a
	ld a, $6
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_11824c
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1e
	jr c, .asm_11825f
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_11825f
	farcall Function118624
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_11824c
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	ret

Function118284:
	call BattleTowerRoomMenu_InitRAM
	ld a, $19
	ld [wcd33], a
	ld a, $1e
	ld [wcd34], a
	ld a, $5
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_11829d
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $20
	jr c, .asm_1182b0
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
.asm_1182b0
	farcall Function1186f5
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_11829d
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	ret

Function118329:
	call BattleTowerRoomMenu_InitRAM
	ld a, $15
	ld [wcd33], a
	ld a, $16
	ld [wcd34], a
	ld a, $6
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_118342
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $18
	jr c, .asm_118355
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118355
	farcall Function118671
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_118342
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	ret

Function1182d5:
	call BattleTowerRoomMenu_InitRAM
	ld a, $18
	ld [wcd33], a
	ld a, $19
	ld [wcd34], a
	ld a, $4
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_1182ee
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .asm_118301
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118301
	farcall Function118746
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_1182ee
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	call ReturnToMapFromSubmenu
	ret

Function11837a:
	call BattleTowerRoomMenu_InitRAM
	ld a, $16
	ld [wcd33], a
	ld a, $17
	ld [wcd34], a
	ld a, $6
	ld [wc3f0], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
.asm_118393
	call JoyTextDelay
	call Function118473
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $19
	jr c, .asm_1183a6
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_1183a6
	farcall Function1186b2
	call BattleTowerRoomMenu_WriteMessage
	farcall Function115dd3
	farcall Function11619d
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wcd33
	cp [hl]
	jr nz, .asm_118393
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_Cleanup
	ret

BattleTowerRoomMenu_Cleanup:
	di
	xor a
	ldh [hMobileReceive], a
	ldh [hMobile], a
	ldh [hVBlank], a
	call NormalSpeed
	xor a
	ldh [rIF], a
	ld a, [wcd32]
	ldh [rIE], a
	ei
	ld a, [wcd7f]
	ld [wVramState], a
	ld a, [wMobileErrorCodeBuffer]
	ld [wScriptVar], a
	ret

; time counter
Function118473:
	ld a, [wcd65]
	and a
	ret z
	ld a, [wcd66]
	inc a
	ld [wcd66], a
	cp 60
	ret nz
	xor a
	ld [wcd66], a
	ld a, [wcd67]
	inc a
	ld [wcd67], a
	cp 60
	ret nz
	ld a, [wcd68]
	inc a
	ld [wcd68], a
	cp 99
	jr z, .ninety_nine
	xor a
	ld [wcd67], a
	ret

.ninety_nine
	xor a
	ld [wcd65], a
	ret

BattleTowerRoomMenu_WriteMessage:
	jumptable .Jumptable, wc31a

.Jumptable:
	dw BattleTowerRoomMenu_WriteMessage_DoNothing
	dw Function11a90f
	dw Function11a971

Function11a90f:
	ld a, $1
	ldh [rSVBK], a
	call SpeechTextbox
	ld a, $50
	ld hl, wc320
	ld bc, $8c ; japanese version uses $26
	call ByteFill
	ld a, [wc31b]
	ld l, a
	ld a, [wc31c]
	ld h, a
	ld de, wc320
.asm_11a92c
	ld a, [hli]
	cp $57
	jr z, .asm_11a94f
	cp $0
	jr z, .asm_11a92c
	cp $50
	jr z, .asm_11a92c
	cp $1
	jr z, .asm_11a941
	ld [de], a
	inc de
	jr .asm_11a92c

.asm_11a941
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.asm_11a945
	ld a, [bc]
	inc bc
	cp $50
	jr z, .asm_11a92c
	ld [de], a
	inc de
	jr .asm_11a945

.asm_11a94f
	xor a
	ld [wc31f], a
	ld a, LOW(wc320)
	ld [wc31b], a
	ld a, HIGH(wc320)
	ld [wc31c], a
	hlcoord 1, 14
	ld a, l
	ld [wc31d], a
	ld a, h
	ld [wc31e], a
	ld hl, wc31a
	inc [hl]
	ld a, $3
	ldh [rSVBK], a

BattleTowerRoomMenu_WriteMessage_DoNothing:
	ret

Function11a971:
	ld hl, wc31f
	ldh a, [hJoyDown]
	and a
	jr nz, .asm_11a97f
	ld a, [hl]
	and a
	jr z, .asm_11a97f
	dec [hl]
	ret

.asm_11a97f
	ld a, [wOptions]
	and $7
	ld [hl], a
	ld hl, wcd8d
	ld a, [wc31b]
	ld e, a
	ld a, [wc31c]
	ld d, a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, e
	ld [wc31b], a
	ld a, d
	ld [wc31c], a
	ld a, $50
	ld [hl], a
	ld a, [wc31d]
	ld l, a
	ld a, [wc31e]
	ld h, a
	ld de, wcd8d
	call PlaceString
	ld a, c
	ld [wc31d], a
	ld a, b
	ld [wc31e], a
	ld a, [wcd8d]
	cp $50
	jr nz, .asm_11a9bf
	xor a
	ld [wc31a], a

.asm_11a9bf
	ret

; seems to parse a downloaded index file
Function118b42:
	ld hl, wd002
	ld a, l
	ld [wcd51], a
	ld a, h
	ld [wcd52], a
	call Function118b8c
	ld a, l
	ld [wcd55], a
	ld [wcd59], a
	ld a, h
	ld [wcd56], a
	ld [wcd5a], a
	call Function118b8c
	ld a, l
	ld [wcd53], a
	ld [wcd5d], a
	ld a, h
	ld [wcd54], a
	ld [wcd5e], a
	call Function118b8c
	ld a, l
	ld [wcd57], a
	ld [wcd5b], a
	ld a, h
	ld [wcd58], a
	ld [wcd5c], a
	call Function118b8c
	ld a, l
	ld [wcd5f], a
	ld a, h
	ld [wcd60], a
	ret

Function118b8c:
.asm_118b8c
	farcall Function118b9a
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118b8c
	dec hl
	xor a
	ld [hli], a
	ld [hli], a
	ret

; validates the length of the received battle room (1428 bytes) or honor roll data (150 bytes)
_ValidateBattleDownload:
	ld hl, wBT_DownloadBuffer
	ld a, [wcd38]
	and a
	jr nz, .asm_118d6e
	ld a, [hli]
	cp BATTLE_TOWER_STRUCT_LENGTH * BATTLETOWER_STREAK_LENGTH & $ff ;$94
	jr nz, .dataInvalid
	ld a, [hl]
	cp BATTLE_TOWER_STRUCT_LENGTH * BATTLETOWER_STREAK_LENGTH >> 8 ;$5
	jr nz, .dataInvalid
	ld a, [wcd4f]
	sla a
	ld b, a
	sla a
	sla a
	add b
	ld b, a
	ld a, BANK(s5_b2fb)
	call OpenSRAM
	ld a, b
	ld [s5_b2fb], a
	call CloseSRAM
	farcall Function170be4
	farcall Function1700c4 ; save battle room data to sram
	jr .asm_118d78

.asm_118d6e
	ld a, [hli]
	cp HONOR_ROLL_DATA_LENGTH & $ff;$96
	jr nz, .dataInvalid
	ld a, [hl]
	cp HONOR_ROLL_DATA_LENGTH >> 8;$0
	jr nz, .dataInvalid

.asm_118d78
	farcall BattleTowerRoomMenu_IncrementJumptable
	ret

.dataInvalid
	ld a, $d3
	farcall SetMobileErrorCode
	ret

Function119471:
	push af
	ld a, [hli]
	ld [wc608], a
	ld a, [hli]
	ld [wc608 + 3], a
	ld a, [hli]
	ld [wc608 + 1], a
	ld a, [hli]
	ld [wc608 + 2], a
	ld a, [hli]
	ld [wc608 + 4], a
	ld a, [hli]
	ld [wc608 + 5], a
	push hl
	ld a, [wc608]
	cp $ff
	jr z, .asm_1194a7
	ld a, [wc608 + 2]
	cp $ff
	jr z, .asm_1194a7
	ld a, [wc608 + 1]
	cp $ff
	jr nz, .asm_1194a7
	call Function119584
	jr c, .asm_11950c
	jr .asm_1194f0
.asm_1194a7
	ld hl, wc608
	ld de, wc608 + 3
	ld c, $3
.asm_1194af
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr c, .asm_1194f3
	jr z, .asm_1194b9
	jr nc, .asm_1194bc
.asm_1194b9
	dec c
	jr nz, .asm_1194af
.asm_1194bc
	ld c, $3
	ld hl, wcd49
	ld de, wc608
.asm_1194c4
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_1194d1
	cp [hl]
	jr z, .asm_1194d1
	jr c, .asm_1194d5
	jr nc, .asm_1194f0
.asm_1194d1
	inc hl
	dec c
	jr nz, .asm_1194c4
.asm_1194d5
	ld c, $3
	ld hl, wcd49
	ld de, wc608 + 3
.asm_1194dd
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_1194ea
	cp [hl]
	jr c, .asm_1194f0
	jr z, .asm_1194ea
	jr nc, .asm_11950c
.asm_1194ea
	inc hl
	dec c
	jr nz, .asm_1194dd
	jr .asm_11950c
.asm_1194f0
	pop hl
	jr .asm_119557
.asm_1194f3
	ld c, $3
	ld hl, wcd49
	ld de, wc608
.asm_1194fb
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_119508
	cp [hl]
	jr c, .asm_11950c
	jr z, .asm_119508
	jr nc, .asm_1194d5
.asm_119508
	inc hl
	dec c
	jr nz, .asm_1194fb
.asm_11950c
	pop hl
	ld a, $1
	ld [wcd50], a
	ld a, l
	ld [wc608], a
	ld a, h
	ld [wc608 + 1], a
	ld de, wcd69
	ld c, $10
	ld b, $0
.asm_119521
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .asm_119528
	inc b
.asm_119528
	dec c
	jr nz, .asm_119521
	ld a, $10
	cp b
	jr z, .asm_119536
rept 4
	inc hl
endr
	jr .asm_11957a
.asm_119536
	ld a, [hli]
	cp $50
	jr nz, .asm_119552
	ld a, [hli]
	cp $33
	jr nz, .asm_119553
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [wcd83]
	cp c
	jr nz, .asm_119576
	ld a, [wcd84]
	cp b
	jr nz, .asm_119576
	jr .asm_11955b
.asm_119552
	inc hl
.asm_119553
	inc hl
	inc hl
	jr .asm_11955b
.asm_119557
	ld de, $14
	add hl, de
.asm_11955b
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	add hl, de
	pop af
	dec a
	jp nz, Function119471
	ld a, [wcd50]
	and a
	jr z, .asm_119571
	ld a, $1a
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret
.asm_119571
	ld a, $d8
	farcall SetMobileErrorCode
	ret
.asm_119576
	ld a, $10
	jr .asm_11957c
.asm_11957a
	ld a, $f
.asm_11957c
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	call Function1195c4
	ret

Function119584:
	ld a, [wc608]
	ld b, a
	ld a, [wc608 + 3]
	ld c, a
	cp b
	jr c, .asm_11959c
	ld a, [wcd49]
	cp b
	jr c, .asm_1195c2
.asm_119595
	cp c
	jr c, .asm_1195a2
	jr z, .asm_1195a2
	jr .asm_1195c2
.asm_11959c
	ld a, [wcd49]
	cp b
	jr c, .asm_119595
.asm_1195a2
	ld a, [wc608 + 2]
	ld b, a
	ld a, [wc608 + 5]
	ld c, a
	cp b
	jr c, .asm_1195ba
	ld a, [wcd4b]
	cp b
	jr c, .asm_1195c2
.asm_1195b3
	cp c
	jr c, .asm_1195c0
	jr z, .asm_1195c0
	jr .asm_1195c2
.asm_1195ba
	ld a, [wcd4b]
	cp b
	jr c, .asm_1195b3
.asm_1195c0
	scf
	ret
.asm_1195c2
	and a
	ret

Function1195c4:
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld de, $a5
	ld a, b
	cp d
	jr c, .asm_1195d9
	jr z, .asm_1195d3
	jr nc, .asm_1195f3
.asm_1195d3
	ld a, c
	cp e
	jr z, .asm_1195d9
	jr nc, .asm_1195f3
.asm_1195d9
	ld de, wcc60
	call CopyBytes
	xor a
	ld [de], a
	ld a, [wc608]
	ld l, a
	ld a, [wc608 + 1]
	ld h, a
	ld de, wcd69
	ld bc, $10
	call CopyBytes
	ret
.asm_1195f3
	ld a, $d8
	farcall SetMobileErrorCode
	ret

Function11b5e8:
	ld a, $0
	call OpenSRAM
	ld hl, wRTC
	ld de, wc608
	ld bc, 4
	call CopyBytes
	call CloseSRAM
	ld a, BANK(s5_b08c)
	call OpenSRAM
	ld hl, wc608
	ld de, s5_b08c
	ld bc, 4
	call CopyBytes
	ld a, $2
	ld [s5_a800], a
	ld a, [sOfferTrainerID]
	ld [wcd2a], a
	ld a, [sOfferTrainerID + 1]
	ld [wcd2b], a
	ld a, [sOfferTrainerID + 2]
	ld [wcd2c], a
	ld a, [sOfferTrainerID + 3]
	ld [wcd2d], a
	ld a, [sOfferGender]
	ld [wcd2e], a
	ld a, [sOfferSpecies]
	ld [wcd2f], a
	ld a, [sOfferReqGender]
	ld [wcd30], a
	ld a, [sOfferReqSpecies]
	ld [wcd31], a
	call CloseSRAM
	call Mobile46_InitJumptable
	call .loop
	ret

.loop
	call .RunJumptable
	call DelayFrame
	ld a, [wJumptableIndex]
	cp $1
	jr nz, .loop
	ret

.RunJumptable:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
	dw Function11b66d
	dw Function11b6b3

Function11b66d:
	call Function1180b8
	ld a, [wScriptVar]
	and a
	jr nz, .asm_11b6b0
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
	ld a, [w3_d090]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	and a
	jr z, .asm_11b691
	cp $1
	jr nz, .asm_11b6b0
	call Function11b6b4
	jr .asm_11b6b0

.asm_11b691
	farcall BattleTowerAction_17
	ld a, [wScriptVar]
	and a
	jr z, .asm_11b6b0
	xor a
	ld [wScriptVar], a
	ldh a, [rSVBK]
	push af
	ld a, $3
	ldh [rSVBK], a
	ld a, $2
	ld [w3_d090], a
	pop af
	ldh [rSVBK], a

.asm_11b6b0
	farcall MobileIncJumptableIndex
	ret

Function11b6b3:
	ret

Function11b6b4:
	ld a, $5
	call OpenSRAM
	ld a, [wcd30]
	ld [wc708], a
	ld a, [wcd31]
	ld [wc709], a

	ld a, LOW(wc708)
	ld [wMobileMonSpeciesPointer], a
	ld a, HIGH(wc708)
	ld [wMobileMonSpeciesPointer + 1], a

	ld a, LOW(wMobileMon)
	ld [wMobileMonStructPointer], a
	ld a, HIGH(wMobileMon)
	ld [wMobileMonStructPointer + 1], a

	ld a, LOW(wMobileMonOT)
	ld [wMobileMonOTPointer], a
	ld a, HIGH(wMobileMonOT)
	ld [wMobileMonOTPointer + 1], a

	ld a, LOW(wMobileMonNick)
	ld [wMobileMonNicknamePointer], a
	ld a, HIGH(wMobileMonNick)
	ld [wMobileMonNicknamePointer + 1], a

	ld a, LOW(wMobileMonMail)
	ld [wMobileMonMailPointer], a
	ld a, HIGH(wMobileMonMail)
	ld [wMobileMonMailPointer + 1], a

	ld a, BASE_HAPPINESS
	ld [wMobileMonHappiness], a

	ld de, wMobileMonOT
	ld c, PLAYER_NAME_LENGTH - 1
	farcall CheckStringForErrors
	jr nc, .length_check_OT
	farcall Mobile_CopyDefaultOTName

.length_check_OT
	ld de, wMobileMonOT
	lb bc, 1, PLAYER_NAME_LENGTH - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .error_check_nick
	farcall Mobile_CopyDefaultOTName

.error_check_nick
	ld de, wMobileMonNick
	ld c, MON_NAME_LENGTH - 1
	farcall CheckStringForErrors
	jr nc, .length_check_nick
	farcall Mobile_CopyDefaultNickname

.length_check_nick
	ld de, wMobileMonNick
	lb bc, 1, MON_NAME_LENGTH - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .error_check_mail
	farcall Mobile_CopyDefaultNickname

.error_check_mail
	ld de, wMobileMonMail
	ld c, MAIL_MSG_LENGTH + 1
	farcall CheckStringForErrors
	jr nc, .length_check_mail
	farcall Mobile_CopyDefaultMail

.length_check_mail
	ld de, wMobileMonMail
	lb bc, 2, MAIL_MSG_LENGTH + 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr c, .fix_mail
	ld a, b
	cp $2
	jr nz, .mail_ok

.fix_mail
	farcall Mobile_CopyDefaultMail

.mail_ok
	ld de, wMobileMonMailAuthor
	ld c, PLAYER_NAME_LENGTH - 1
	farcall CheckStringForErrors
	jr nc, .length_check_author
	farcall Mobile_CopyDefaultMailAuthor

.length_check_author
	ld de, wMobileMonMailAuthor
	lb bc, 1, PLAYER_NAME_LENGTH - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .author_okay
	farcall Mobile_CopyDefaultMailAuthor

.author_okay
	ld a, [$c60e]
	cp -1
	jr nz, .item_okay
	xor a
	ld [$c60e], a

.item_okay
	ld a, [wcd31]
	ld [$c60d], a
	ld [wCurSpecies], a
	call GetBaseData

	ld hl, wMobileMonLevel
	ld a, [hl]
	cp MIN_LEVEL
	ld a, MIN_LEVEL
	jr c, .replace_level
	ld a, [hl]
	cp MAX_LEVEL
	jr c, .done_level
	ld a, MAX_LEVEL
.replace_level
	ld [hl], a
.done_level
	ld [wCurPartyLevel], a

	ld hl, wMobileMonExp + 2
	ld de, wMobileMonMaxHP
	ld b, TRUE
	predef CalcMonStats
	ld de, wMobileMonMaxHP
	ld hl, wMobileMonHP
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	call AddMobileMonToParty
	ret

Function11b314:
	call Function11b31b
	call Function11b3d9
	ret

Function11b31b:
	ld hl, .Coords
	ld a, [wJumptableIndex]
	cp 2
	jr c, .tilemap_1
	ld a, [wc7d1]
	cp 1 ;4
	jr nc, .tilemap_3
	cp 0 ;3
	jr c, .tilemap_1
	ld a, [wJumptableIndex]
	cp 2
	jr z, .tilemap_1
	cp 3
	jr z, .tilemap_1
	cp 6
	jr z, .tilemap_1

	ld bc, .Tilemap2
	jr .load_sprites

.tilemap_3
	ld bc, .Tilemap3
	jr .load_sprites

.tilemap_1
	ld bc, .Tilemap1

.load_sprites
	call Function11b397
	ret

.Coords:
	dbpixel  9,  7, 2, 6 ;  0
	dbpixel  9,  8, 2, 6 ;  1
	dbpixel  9,  9, 2, 6 ;  2
	dbpixel  9, 15, 2, 9 ;  3
	dbpixel  9, 16, 2, 6 ;  4
	dbpixel  9, 17, 2, 6 ;  5
	dbpixel  9, 18, 2, 1 ;  6
	dbpixel 10,  7, 2, 6 ;  7
	dbpixel 10,  8, 2, 6 ;  8
	dbpixel 10,  9, 2, 6 ;  9
	dbpixel 10, 15, 2, 9 ; 10
	dbpixel 10, 16, 2, 6 ; 11
	dbpixel 10, 17, 2, 6 ; 12
	dbpixel 10, 18, 2, 1 ; 13
	db -1

.Tilemap1: ; vtiles
	db $30 ;  0
	db $31 ;  1
	db $31 ;  2
	db $31 ;  3
	db $31 ;  4
	db $31 ;  5
	db $32 ;  6
	db $40 ;  7
	db $41 ;  8
	db $41 ;  9
	db $41 ; 10
	db $41 ; 11
	db $41 ; 12
	db $42 ; 13

.Tilemap2: ; vtiles
	db $30 ;  0
	db $31 ;  1
	db $31 ;  2
	db $39 ;  3
	db $39 ;  4
	db $39 ;  5
	db $39 ;  6
	db $40 ;  7
	db $41 ;  8
	db $41 ;  9
	db $39 ; 10
	db $39 ; 11
	db $39 ; 12
	db $39 ; 13

.Tilemap3: ; vtiles
	db $39 ;  0
	db $39 ;  1
	db $39 ;  2
	db $39 ;  3
	db $39 ;  4
	db $39 ;  5
	db $39 ;  6
	db $39 ;  7
	db $39 ;  8
	db $39 ;  9
	db $39 ; 10
	db $39 ; 11
	db $39 ; 12
	db $39 ; 13

Function11b397:
	ld de, wShadowOAMSprite00
.loop
	ld a, [hl]
	cp $ff
	ret z
	ld a, [wc7d1]
	and $7
	swap a
	add [hl]
	inc hl
	ld [de], a ; y
	inc de

	ld a, [hli]
	ld [de], a ; x
	inc de

	ld a, [bc]
	inc bc
	ld [de], a ; tile id
	inc de
	ld a, $5
	ld [de], a ; attributes
	inc de
	jr .loop

Function11b3d9:
	ld de, wShadowOAMSprite28
	push de
	ld a, [wc7d2]
	dec a
	ld e, a
	ld a, [wc7d1]
	ld hl, wc7d0
	add [hl]
	cp e
	jr z, .skip
	ld hl, 0
	ld bc, $70
	call AddNTimes
	ld e, l
	ld d, h
	ld b, 0
	ld a, d
	or e
	jr z, .load_sprites
	ld a, [wc7d2]
	ld c, a
.loop1
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	jr c, .load_sprites
	inc b
	jr .loop1

.skip
	ld b, 14 * 8

.load_sprites
	ld a, 2 * 8 + 5
	add b
	pop hl
	ld [hli], a
	cp $41
	jr c, .version1
	ld a, [wJumptableIndex]
	cp 4
	jr z, .version2
	cp 5
	jr z, .version2
	cp 7
	jr z, .version2
	cp 8
	jr z, .version2

.version1
	ld a, 19 * 8 + 3
	ld [hli], a
	ld a, [wcd4c]
	add $3c
	ld [hli], a
	ld a, [wcd4c]
	add $1
	ld [hl], a
	ret

.version2
	ld a, 19 * 8 + 3
	ld [hli], a
	ld a, $39
	ld [hli], a
	xor a
	ld [hl], a
	ret

TradeCornerHoldMon:
; special
	call Mobile46_InitJumptable
	call TradeCornerHoldMon_RunJumptable
	ret

Mobile46_InitJumptable:
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	call UpdateTime
	ret

TradeCornerHoldMon_RunJumptable:
.loop
	call .IterateJumptable
	call DelayFrame
	ld a, [wJumptableIndex]
	cp 4
	jr nz, .loop
	ret

.IterateJumptable:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
	dw TradeCornerHoldMon_PrepareForUpload
	dw Function11b570
	dw TradeCornerHoldMon_RemoveFromParty
	dw TradeCornerHoldMon_Success
	dw TradeCornerHoldMon_Noop ; unused

TradeCornerHoldMon_PrepareForUpload:
	call .InitRAM
	ld hl, wPlayerName
	ld a, PLAYER_NAME_LENGTH - 1
.get_char
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .get_char

	ld de, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Species
	ld a, [wcd82]
	dec a
	push af

.get_next_party_mon
	and a
	jr z, .got_selected_mon
	add hl, de
	dec a
	jr .get_next_party_mon

.got_selected_mon
	push bc
	ld a, PARTYMON_STRUCT_LENGTH
.copy_mon_byte
	; copies wPartyMon to bc.
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .copy_mon_byte

	pop de ; pushed from bc
	push bc
	ld a, [de]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, MON_LEVEL
	add hl, de
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld hl, MON_MAXHP
	add hl, de
	push hl
	ld hl, MON_STAT_EXP - 1
	add hl, de
	pop de
	push de
	ld b, TRUE
	predef CalcMonStats
	pop de
	ld h, d
	ld l, e
	dec hl
	dec hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop bc
	ld de, NAME_LENGTH
	ld hl, wPartyMonOTs
	pop af
	push af
.loop4
	and a
	jr z, .okay2
	add hl, de
	dec a
	jr .loop4

.okay2
	ld a, PLAYER_NAME_LENGTH - 1
.loop5
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .loop5
	ld de, MON_NAME_LENGTH
	ld hl, wPartyMonNicknames
	pop af
	push af
.loop6
	and a
	jr z, .okay3
	add hl, de
	dec a
	jr .loop6

.okay3
	ld a, MON_NAME_LENGTH - 1
.loop7
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .loop7
	ld de, MAIL_STRUCT_LENGTH
	ld hl, sPartyMail
	pop af
.loop8
	and a
	jr z, .okay4
	add hl, de
	dec a
	jr .loop8

.okay4
	ld a, BANK(sPartyMail)
	call OpenSRAM
	ld a, MAIL_STRUCT_LENGTH
.loop9
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .loop9
	call CloseSRAM
	farcall MobileIncJumptableIndex
	ret

.InitRAM:
	ld bc, wOfferTrainerID
	ld a, [wPlayerID]
	ld [wcd2a], a
	ld [bc], a
	inc bc

	ld a, [wPlayerID + 1]
	ld [wcd2b], a
	ld [bc], a
	inc bc

	ld a, [wSecretID]
	ld [wcd2c], a
	ld [bc], a
	inc bc

	ld a, [wSecretID + 1]
	ld [wcd2d], a
	ld [bc], a
	inc bc

	ld a, [wcd2e] ; offer gender
	ld [bc], a
	inc bc

	ld a, [wcd2f] ; offer species
	ld [bc], a
	inc bc

	ld a, [wcd30] ; req gender
	ld [bc], a
	inc bc

	ld a, [wd265] ; req species
	ld [bc], a
	inc bc
	ret

Function11b570:
	call Function118007
	ld a, [wScriptVar]
	and a
	jr nz, .exit
	call .SaveData
	farcall MobileIncJumptableIndex
	ret

.exit
	ld a, $4
	ld [wJumptableIndex], a
	ret

.SaveData:
	ld a, $3
	ldh [rSVBK], a

	ld hl, w3_d800
	ld de, wc608
	ld bc, w3_d88f - w3_d800 + 2 + 2 + 5 + 5
	call CopyBytes

	ld a, $1
	ldh [rSVBK], a
	ld a, BANK(s5_a800)
	call OpenSRAM

	ld de, s5_a800
	ld a, $1
	ld [de], a
	inc de
	ld hl, wc608
	ld bc, w3_d88f - w3_d800 + 2 + 2 + 5 + 5
	call CopyBytes

	push de
	pop hl

	ldh a, [hRTCMinutes]
	ld [hli], a
	ldh a, [hRTCHours]
	ld [hli], a
	ldh a, [hRTCDayLo]
	ld [hli], a
	ldh a, [hRTCDayHi]
	ld [hl], a

	call CloseSRAM
	ret

TradeCornerHoldMon_RemoveFromParty:
	ld a, [wcd82]
	dec a
	ld [wCurPartyMon], a
	xor a ; REMOVE_PARTY
	ld [wPokemonWithdrawDepositParameter], a
	farcall RemoveMonFromPartyOrBox
	farcall BattleTowerAction_16
	farcall SaveAfterLinkTrade
	farcall MobileIncJumptableIndex
	ret

TradeCornerHoldMon_Success:
	xor a
	ld [wScriptVar], a
	farcall MobileIncJumptableIndex
	ret

TradeCornerHoldMon_Noop:
	ret

Function11b7e5:
	ld a, [wMobileMonSpecies]
	ld [wOTTrademonSpecies], a
	ld [wCurPartySpecies], a
	ld a, [wcd81]
	ld [wc74e], a
	ld hl, wMobileMonOT ; OT
	ld de, wOTTrademonOTName
	ld bc, PLAYER_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a
	ld a, [wMobileMonID]
	ld [wOTTrademonID], a
	ld a, [wMobileMonID + 1]
	ld [wOTTrademonID + 1], a
	ld hl, wMobileMonDVs
	ld a, [hli]
	ld [wOTTrademonDVs], a
	ld a, [hl]
	ld [wOTTrademonDVs + 1], a
	ld bc, wMobileMon ; pokemon_data_start
	farcall GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	call SpeechTextbox
	call FadeToMenu
	farcall MobileTradeAnimation_ReceiveGetmonFromGTS
	farcall Function17d1f1
	ld a, $1
	ld [wForceEvolution], a
	ld a, LINK_TRADECENTER
	ld [wLinkMode], a
	farcall EvolvePokemon
	xor a
	ld [wLinkMode], a
	farcall SaveAfterLinkTrade
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, $5
	ld [s5_a800], a
	call CloseSRAM
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetMapSceneID
	ld a, d
	or e
	jr z, .asm_11b872
	ld a, $1
	ld [de], a

.asm_11b872
	call CloseSubmenu
	call RestartMapMusic
	ret

Function11b879:
	farcall BattleTower_CheckSaveFileExistsAndIsYours
	ld a, [wScriptVar]
	and a
	ret z
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, [s5_a800]
	ld [wScriptVar], a
	ld a, [s5_a890]
	ld [wcd49], a
	ld a, [s5_a890 + 1]
	ld [wcd4a], a
	ld a, [s5_a890 + 2]
	ld [wcd4b], a
	ld a, [s5_a890 + 3]
	ld [wcd4c], a
	call CloseSRAM
	ld a, [wScriptVar]
	and a
	ret z
	ld hl, wcd4c
	ldh a, [hRTCDayHi]
	cp [hl]
	ret nz
	dec hl
	ldh a, [hRTCDayLo]
	cp [hl]
	ret nz
	ld hl, wcd4a
	ldh a, [hRTCHours]
	cp [hl]
	jr nc, .asm_11b8d8
	ld a, $18
	sub [hl]
	ld hl, hRTCHours
	add [hl]
	ld [wcd4c], a
	ldh a, [hRTCMinutes]
	ld [wcd4b], a
	xor a
	ld [wcd4a], a
	jr .asm_11b8e2

.asm_11b8d8
	ldh a, [hRTCMinutes]
	ld [wcd4b], a
	ldh a, [hRTCHours]
	ld [wcd4c], a

.asm_11b8e2
	xor a
	ld l, a
	ld h, a
	ld b, a
	ld d, a
	ld a, [wcd4b]
	ld e, a
	ld a, [wcd4c]
	ld c, $3c
	call AddNTimes
	add hl, de
	push hl
	xor a
	ld l, a
	ld h, a
	ld b, a
	ld d, a
	ld a, [wcd49]
	ld e, a
	ld a, [wcd4a]
	ld c, $3c
	call AddNTimes
	add hl, de
	ld a, l
	cpl
	add $1
	ld e, a
	ld a, h
	cpl
	adc 0
	ld d, a
	pop hl
	add hl, de
	ld de, $ff88
	add hl, de
	bit 7, h
	ret z
	ld a, $2
	ld [wScriptVar], a
	ret

Function11b920:
	call Mobile46_InitJumptable
	ld a, BANK(sOfferTrainerID)
	call OpenSRAM
	ld hl, sOfferTrainerID
	ld de, wOfferTrainerID
	ld bc, 8
	call CopyBytes
	call CloseSRAM
	farcall Function118000
	ret

Function11b93b:
	ld a, BANK(s5_a800)
	call OpenSRAM
	xor a
	ld [s5_a800], a
	ld hl, sOfferGender
	ld de, wc608
	ld bc, TRADE_CORNER_TRADE_REQUEST_LENGTH
	call CopyBytes
	call CloseSRAM

	ld a, LOW(wUnknownGender)
	ld [wMobileMonSpeciesPointer], a
	ld a, HIGH(wUnknownGender)
	ld [wMobileMonSpeciesPointer + 1], a

	ld a, LOW(wUnknownMon)
	ld [wMobileMonStructPointer], a
	ld a, HIGH(wUnknownMon)
	ld [wMobileMonStructPointer + 1], a

	ld a, LOW(wUnknownMonOT)
	ld [wMobileMonOTPointer], a
	ld a, HIGH(wUnknownMonOT)
	ld [wMobileMonOTPointer + 1], a

	ld a, LOW(wUnknownMonNick)
	ld [wMobileMonNicknamePointer], a
	ld a, HIGH(wUnknownMonNick)
	ld [wMobileMonNicknamePointer + 1], a

	ld a, LOW(wUnknownMonMail)
	ld [wMobileMonMailPointer], a
	ld a, HIGH(wUnknownMonMail)
	ld [wMobileMonMailPointer + 1], a
	call AddMobileMonToParty
	farcall SaveAfterLinkTrade
	ret

AddMobileMonToParty:
	ld hl, wPartyCount
	ld a, [hl]
	ld e, a
	inc [hl]

	ld a, [wMobileMonSpeciesPointer]
	ld l, a
	ld a, [wMobileMonSpeciesPointer + 1]
	ld h, a
	inc hl
	ld bc, wPartySpecies
	ld d, e
.loop1
	inc bc
	dec d
	jr nz, .loop1
	ld a, e
	ld [wCurPartyMon], a
	ld a, [hl]
	ld [bc], a
	inc bc
	ld a, -1
	ld [bc], a

	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, e
	ld [wMobileMonIndex], a
.loop2
	add hl, bc
	dec a
	and a
	jr nz, .loop2
	ld e, l
	ld d, h
	ld a, [wMobileMonStructPointer]
	ld l, a
	ld a, [wMobileMonStructPointer + 1]
	ld h, a
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes

	ld hl, wPartyMonOTs
	ld bc, NAME_LENGTH
	ld a, [wMobileMonIndex]
.loop3
	add hl, bc
	dec a
	and a
	jr nz, .loop3
	ld e, l
	ld d, h
	ld a, [wMobileMonOTPointer]
	ld l, a
	ld a, [wMobileMonOTPointer + 1]
	ld h, a
	ld bc, PLAYER_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a

	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	ld a, [wMobileMonIndex]
.loop4
	add hl, bc
	dec a
	and a
	jr nz, .loop4
	ld e, l
	ld d, h
	ld a, [wMobileMonNicknamePointer]
	ld l, a
	ld a, [wMobileMonNicknamePointer + 1]
	ld h, a
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a

	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	ld a, [wMobileMonIndex]
.loop5
	add hl, bc
	dec a
	and a
	jr nz, .loop5
	ld a, BANK(sPartyMail)
	call OpenSRAM
	ld e, l
	ld d, h
	ld a, [wMobileMonMailPointer]
	ld l, a
	ld a, [wMobileMonMailPointer + 1]
	ld h, a
	ld bc, MAIL_STRUCT_LENGTH
	call CopyBytes

	call CloseSRAM
	ret

Function11ba38:
	farcall CheckCurPartyMonFainted
	ret c
	xor a
	ld [wScriptVar], a
	ret

_DecodeReceivedTradeCornerTrade:
	ld a, [w3_d090]
	cp $1
	jr z, .asm_119b75
	farcall BattleTowerRoomMenu_IncrementJumptable
	ret

.asm_119b75
	ld a, [w3_d100]
	ld b, a
	ld a, [w3_d100 + 1]
	or b
	jr z, .dataInvalid
	ld hl, w3_d800
	ld de, w3_d100 + 2
.asm_119b85
	ld a, [de]
	inc de
	cp $d
	jr nz, .asm_119b85
	inc de
	ld a, [de]
	cp $d
	jr nz, .asm_119b85
	inc de
	inc de
.asm_119b93
	ld a, [de]
	inc de
	cp $d
	jr z, .asm_119bfa
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hl], a
	push de
	ld d, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	sla b
	sla b
	sla b
	rla
	sla b
	rla
	ld [hli], a
	ld [hl], b
	inc hl
	rrc c
	rrc c
	ld [hl], c
	dec hl
	ld a, $f
	and c
	or [hl]
	ld [hli], a
	ld a, [hli]
	and $c0
	or [hl]
	dec hl
	ld [hld], a
	dec hl
	pop de
	inc hl
	inc hl
	inc hl
	ld a, h
	cp $e0
	jr c, .asm_119b93

.dataInvalid
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, $1
	ld [s5_a800], a
	call CloseSRAM
	xor a
	ld [w3_d090], a
	ret

.asm_119bfa
	inc de
	ld a, [de]
	cp $d
	jr nz, .asm_119b93
	ld a, l

	cp LOW(w3_d800 + TRADE_CORNER_RECEIVE_TRADE_LENGTH + 1) ; base64 encoding adds a filler byte
	jr nz, .dataInvalid
	ld a, h
	cp HIGH(w3_d800 + TRADE_CORNER_RECEIVE_TRADE_LENGTH + 1)
	jr nz, .dataInvalid
	ld a, BANK(s5_b090) ; aka BANK(s5_b091) and BANK(s5_b023)
	call OpenSRAM
	ld a, [wcf64]
	ld [s5_b090], a
	ld a, [wcf65]
	ld [s5_b090 + 1], a
	ld hl, w3_d800
	ld de, s5_b023
	ld bc, TRADE_CORNER_RECEIVE_TRADE_LENGTH
	call CopyBytes
	ld a, $3
	ld [s5_a800], a
	call CloseSRAM
	ld hl, w3_d800
	ld de, wc608
	ld bc, TRADE_CORNER_RECEIVE_TRADE_LENGTH
	call CopyBytes
	farcall BattleTowerRoomMenu_IncrementJumptable
	ret

pushc
setcharmap ascii

.decodeBase64Character
	cp "+"
	jr c, .asm_119c68
	jr z, .asm_119c80
	cp "/"
	jr c, .asm_119c68
	jr z, .asm_119c84
	cp "0"
	jr c, .asm_119c68
	cp "9" + 1
	jr c, .asm_119c88
	cp "="
	jr c, .asm_119c68
	jr z, .asm_119c8c
	cp "A"
	jr c, .asm_119c68
	cp "Z" + 1
	jr c, .asm_119c8f
	cp "a"
	jr c, .asm_119c68
	cp "z" + 1
	jr c, .asm_119c93

popc

.asm_119c68
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, $1
	ld [s5_a800], a
	call CloseSRAM
	xor a
	ld [w3_d090], a
	scf
	ret

.asm_119c80
	ld a, $3e
	and a
	ret

.asm_119c84
	ld a, $3f
	and a
	ret

.asm_119c88
	add $4
	and a
	ret

.asm_119c8c
	xor a
	and a
	ret

.asm_119c8f
	sub $41
	and a
	ret

.asm_119c93
	sub $47
	and a
	ret

_Function1199e2:
	ld c, $c
	ld de, XGameCodePrefix
	call Function119e4f
	jp c, Function119ac9
	ld a, c
	cp $1
	jp nz, Function119ac9
	ld hl, w3_d880
	ld bc, XGameCode
.loop
	ld a, [bc]
	and a
	jr z, .game_result_prefix
	cp [hl]
	jp nz, Function119ac9
	inc bc
	inc hl
	jr .loop

.game_result_prefix
	ld c, $17
	ld de, XGameResultPrefix
	call Function119e4f
	jp c, .asm_119aa7
	ld a, c
	cp $1
	jp nz, .asm_119aa7
	ld a, [w3_d880]
	cp $31
	jp nz, .asm_119aa7
	ld a, [w3_d881]
	cp $20
	jp nz, .asm_119aa7
	ld a, [w3_d88a]
	cp $20
	jp nz, .asm_119aa7
	ld a, [w3_d894]
	cp $20
	jp nz, .asm_119aa7
	xor a
	ld [w3_d8a0], a
	ld [w3_d8a1], a
	ld [w3_d8a2], a
	ld [w3_d8a3], a
	ld hl, w3_d8a0
	ld bc, w3_d889
	call Function119e98
	call Function119e98
	ld hl, w3_d8a0
	ld a, [wcd2d]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wcd2c]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wcd2b]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wcd2a]
	cp [hl]
	jr nz, Function119ac9
	xor a
	ld [w3_d8a0], a
	ld [w3_d8a1], a
	ld [w3_d8a2], a
	ld [w3_d8a3], a
	ld hl, w3_d8a0
	ld bc, w3_d88e
	call Function119e98
	ld bc, w3_d893
	call Function119e98
	ld hl, w3_d8a0
	ld a, [wcd2f]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wcd2e]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wcd31]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wcd30]
	cp [hl]
	jr z, .asm_119aaf

.asm_119aa7
	ld a, $25
	ld [wBattleTowerRoomMenuJumptableIndex], a
	farcall DeleteInvalidTradeEmail
	ret

.asm_119aaf
	ld a, [w3_d090]
	and a
	jr nz, .asm_119aa7
	ld a, [w3_d895]
	sub $30
	ld [w3_d090], a
	ld a, [wcf64]
	ld [w3_d090 + 1], a
	ld a, [wcf65]
	ld [w3_d090 + 2], a

Function119ac9:
	ld a, [w3_d000]
	ld l, a
	ld a, [w3_d000 + 1]
	ld h, a
	dec hl
	ld a, l
	ld [w3_d000], a
	ld a, h
	ld [w3_d000 + 1], a
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	inc hl
	ld a, l
	ld [wcf64], a
	ld a, h
	ld [wcf65], a
	ld a, $10
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret
	
XGameCode:
INCBIN "data/mobile/x-game-code.txt"

XGameResult:
INCBIN "data/mobile/x-game-result.txt"

pushc
setcharmap ascii

XGameCodePrefix:
	db "X-Game-code:\n"

XGameResultPrefix:
	db "X-Game-result:\n"

popc

Function119e4f:
	push bc
	ld hl, w3_d100
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.loop
	ld a, [de]
	cp [hl]
	jr z, .found_equality
.next
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
.return_carry
	pop bc
	scf
	ret

.found_equality
	push de
.loop2
	ld a, [de]
	inc de
pushc
setcharmap ascii
	cp "\n"
popc
	jr z, .newline
	cp [hl]
	jr nz, .unequal
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop2
	pop de
	jr .return_carry

.unequal
	pop de
	jr .next

.newline
	pop de
	pop bc
	inc hl
	ld de, w3_d880
.loop3
	ld a, [hli]
	ld [de], a
	inc de
pushc
setcharmap ascii
	cp "\r"
popc
	jr z, .finish
	dec c
	jr nz, .loop3
	scf
	ret

.finish
	and a
	ret

Function119e8e:
	cp $60
	jr c, .less_than_0x60
	sub $57
	ret

.less_than_0x60
	sub $30
	ret

Function119e98:
	ld a, $2
.loop
	push af
	ld a, [bc]
	dec bc
	call Function119e8e
	or [hl]
	ld [hl], a
	ld a, [bc]
	dec bc
	call Function119e8e
	rlca
	rlca
	rlca
	rlca
	or [hl]
	ld [hl], a
	inc hl
	pop af
	dec a
	and a
	jr nz, .loop
	ret

_Function119f98:
	farcall Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_119fef
	call ExitMenu
	farcall Function11a63c
	xor a
	ld [wScriptVar], a
	call Function11a00e
	ld a, [wScriptVar]
	and a
	jr z, .asm_119fd4
	call ExitMenu
	farcall ReloadMapPart
	farcall Function115dc3
	ld a, [wcd33]
	ld [wcf66], a
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

.asm_119fd4
	hlcoord 4, 2
	ld de, String_11a692
	call PlaceString
	ld a, $1
	ld [wc30d], a
	ld a, $1
	ld [wc314], a
	farcall ReloadMapPart
	and a
	ret

.asm_119fef
	call ExitMenu
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerSeconds]
	ld [wcf66], a
	farcall Function115dc3
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

Function11a00e:
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	ld a, [sMobileLoginPassword]
	and a
	jr z, .asm_11a02a
	ld a, [sMobileLoginPassword + 1]
	call CloseSRAM
	and a
	ret nz
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPassword], a

.asm_11a02a
	call CloseSRAM
	ld a, [wBGMapPalBuffer]
	and a
	jr z, .asm_11a039
	dec a
	jr z, .asm_11a081
	farcall Function11a0ca

.asm_11a039
	ld a, BANK(w3_d800)
	ldh [rSVBK], a
	ld hl, wc608
	ld de, w3_d800
	ld bc, 246
	call CopyBytes
	ld a, $1
	ldh [rSVBK], a
	call FadeToMenu
	farcall Function11765d
	farcall Function11a9ce
	ld a, BANK(w3_d800)
	ldh [rSVBK], a
	ld hl, w3_d800
	ld de, wc608
	ld bc, 246
	call CopyBytes
	ld a, $1
	ldh [rSVBK], a
	farcall Function115d99
	ld c, $0
	farcall Function115e18
	ld a, $1
	ld [wc305], a
	ret

.asm_11a081
	xor a
	ld [wMenuBorderLeftCoord], a
	ld [wMenuBorderTopCoord], a
	ld a, $13
	ld [wMenuBorderRightCoord], a
	ld a, $5
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	farcall Function11765d
	farcall Function117ab4
	farcall Stubbed_Function106462
	farcall Function106464
	call ExitMenu
	farcall ReloadMapPart
	farcall Function115d99
	ld c, $0
	farcall Function115e18
	ld a, $1
	ld [wc305], a
	ret

Function11acb7: ; mobile phone animation?
	ld hl, TilemapPack_11ba44
	ld a, [wcd49]
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	decoord 5, 12 ;6, 6
	ld a, [hli]
	ld [de], a
	decoord 4, 6 ;0, 7
	;ld bc, 7
	;call CopyBytes

	; vertical
	ld a, [hli]
	ld [de], a
	decoord 4, 7
	ld a, [hli]
	ld [de], a
	decoord 4, 8
	ld a, [hli]
	ld [de], a
	decoord 4, 9
	ld a, [hli]
	ld [de], a
	decoord 4, 10
	ld a, [hli]
	ld [de], a
	decoord 4, 11
	ld a, [hli]
	ld [de], a
	decoord 4, 12
	ld a, [hli]
	ld [de], a


	ld a, [wcd49]
	inc a
	ld [wcd49], a
	ld a, [hl]
	cp $ff
	jr nz, .get_the_other
	xor a
	ld [wcd49], a
.get_the_other
	ld hl, TilemapPack_11bb7d
	ld a, [wcd4a]
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	decoord 2, 8 ;3, 9 ; wanted pokemon animation coordinates
	;ld bc, 7
	;call CopyBytes

	; vertical
	ld a, [hli]
	ld [de], a
	decoord 2, 9
	ld a, [hli]
	ld [de], a
	decoord 2, 10
	ld a, [hli]
	ld [de], a
	decoord 2, 11
	ld a, [hli]
	ld [de], a
	decoord 2, 12
	ld a, [hli]
	ld [de], a
	decoord 2, 13
	ld a, [hli]
	ld [de], a
	decoord 2, 14
	ld a, [hli]
	ld [de], a


	ld a, [wcd4a]
	inc a
	ld [wcd4a], a
	inc hl
	ld a, [hl]
	cp $ff
	ret nz
	xor a
	ld [wcd4a], a
	ret
	
TilemapPack_11ba44:
	db $47, $30, $0a, $0a, $0a, $0a, $0a, $56 ; 00
	db $46, $2f, $0a, $0a, $0a, $0a, $0a, $55 ; 01
	db $45, $3d, $0a, $0a, $0a, $0a, $0a, $54 ; 02
	db $44, $30, $0a, $0a, $0a, $0a, $0a, $53 ; 03
	db $43, $2f, $0a, $0a, $0a, $0a, $0a, $52 ; 04
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $51 ; 05
	db $4a, $30, $0a, $0a, $0a, $0a, $0a, $50 ; 06
	db $4a, $2f, $0a, $0a, $0a, $0a, $0a, $4f ; 07
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $4e ; 08
	db $4a, $30, $0a, $0a, $0a, $0a, $4d, $42 ; 09
	db $4a, $2f, $0a, $0a, $0a, $0a, $6b, $58 ; 0a
	db $4a, $3d, $0a, $0a, $0a, $0a, $6a, $58 ; 0b
	db $4a, $30, $0a, $0a, $0a, $0a, $69, $58 ; 0c
	db $4a, $2f, $0a, $0a, $0a, $0a, $68, $58 ; 0d
	db $4a, $3d, $0a, $0a, $0a, $66, $67, $58 ; 0e
	db $4a, $30, $0a, $0a, $0a, $65, $0a, $58 ; 0f
	db $4a, $2f, $0a, $0a, $0a, $64, $0a, $58 ; 10
	db $4a, $3d, $0a, $0a, $0a, $63, $0a, $58 ; 11
	db $4a, $30, $0a, $0a, $61, $62, $0a, $58 ; 12
	db $4a, $2f, $0a, $0a, $5f, $60, $0a, $58 ; 13
	db $4a, $3d, $0a, $61, $62, $0a, $0a, $58 ; 14
	db $4a, $30, $0a, $63, $0a, $0a, $0a, $58 ; 15
	db $4a, $2f, $69, $0a, $0a, $0a, $0a, $58 ; 16
	db $4a, $3d, $81, $0a, $0a, $0a, $0a, $58 ; 17
	db $4a, $30, $80, $0a, $0a, $0a, $0a, $58 ; 18
	db $4a, $2f, $7f, $0a, $0a, $0a, $0a, $58 ; 19
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $58 ; 1a
	db $4a, $30, $0a, $0a, $0a, $0a, $0a, $58 ; 1b
	db $4a, $2f, $68, $87, $88, $89, $0a, $58 ; 1c
	db $4a, $3d, $6e, $6f, $70, $75, $76, $58 ; 1d
	db $4a, $30, $75, $76, $5c, $5d, $5e, $58 ; 1e
	db $4a, $2f, $71, $72, $73, $74, $6d, $58 ; 1f
	db $4a, $3d, $75, $76, $77, $8a, $8b, $58 ; 20
	db $4a, $30, $66, $67, $65, $0a, $6a, $58 ; 21
	db $4a, $2f, $83, $84, $0a, $83, $84, $58 ; 22
	db $4a, $3d, $0a, $85, $82, $84, $0a, $58 ; 23
	db $4a, $30, $41, $80, $40, $0a, $0a, $58 ; 24
	db $4a, $2f, $83, $0a, $0a, $0a, $0a, $58 ; 25
	db $4a, $3d, $40, $0a, $0a, $0a, $0a, $58 ; 26
	db -1

TilemapPack_11bb7d:
	db $0a, $0a, $0a, $0a, $0a, $0a, $16, $00 ; 00
	db $78, $0a, $0a, $0a, $0a, $0a, $8c, $00 ; 01
	db $79, $0a, $0a, $0a, $0a, $0a, $8d, $00 ; 02
	db $7a, $0a, $0a, $0a, $0a, $0a, $8e, $00 ; 03
	db $7b, $0a, $0a, $0a, $0a, $0a, $8c, $00 ; 04
	db $7c, $0a, $0a, $0a, $0a, $0a, $8d, $00 ; 05
	db $7d, $0a, $0a, $0a, $0a, $0a, $8e, $00 ; 06
	db $2e, $7e, $0a, $0a, $0a, $0a, $8c, $00 ; 07
	db $2e, $80, $0a, $0a, $0a, $0a, $8d, $00 ; 08
	db $2e, $81, $0a, $0a, $0a, $0a, $8e, $00 ; 09
	db $2e, $82, $0a, $0a, $0a, $0a, $8c, $00 ; 0a
	db $2e, $69, $0a, $0a, $0a, $0a, $8d, $00 ; 0b
	db $2e, $6a, $0a, $0a, $0a, $0a, $8e, $00 ; 0c
	db $2e, $6b, $0a, $0a, $0a, $0a, $8c, $00 ; 0d
	db $2e, $0a, $68, $0a, $0a, $0a, $8d, $00 ; 0e
	db $2e, $0a, $69, $0a, $0a, $0a, $8e, $00 ; 0f
	db $2e, $0a, $0a, $6a, $0a, $0a, $8c, $00 ; 10
	db $2e, $0a, $0a, $6b, $0a, $0a, $8d, $00 ; 11
	db $2e, $0a, $0a, $0a, $80, $0a, $8e, $00 ; 12
	db $2e, $0a, $0a, $0a, $82, $0a, $8c, $00 ; 13
	db $2e, $0a, $0a, $0a, $6c, $0a, $8d, $00 ; 14
	db $2e, $0a, $0a, $0a, $0a, $83, $8e, $00 ; 15
	db $2e, $0a, $6b, $0a, $0a, $0a, $8c, $00 ; 16
	db $2e, $0a, $0a, $69, $0a, $0a, $8d, $00 ; 17
	db $2e, $0a, $0a, $6a, $0a, $0a, $8e, $00 ; 18
	db $2e, $0a, $0a, $0a, $68, $0a, $8c, $00 ; 19
	db $2e, $0a, $0a, $0a, $63, $0a, $8d, $00 ; 1a
	db $2e, $0a, $0a, $61, $62, $0a, $8e, $00 ; 1b
	db $2e, $0a, $0a, $0a, $5f, $60, $8c, $00 ; 1c
	db $2e, $0a, $0a, $0a, $63, $0a, $8d, $00 ; 1d
	db $2e, $0a, $0a, $0a, $0a, $69, $8c, $00 ; 1e
	db $2e, $0a, $0a, $0a, $0a, $6b, $8d, $00 ; 1f
	db $2e, $0a, $0a, $0a, $0a, $83, $8e, $00 ; 20
	db $2e, $0a, $0a, $0a, $0a, $86, $8c, $00 ; 21
	db $2e, $0a, $85, $0a, $0a, $0a, $8d, $00 ; 22
	db $2e, $0a, $0a, $84, $0a, $0a, $8e, $00 ; 23
	db -1
