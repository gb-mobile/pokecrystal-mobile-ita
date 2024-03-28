; display an error?
SetMobileErrorCode:
	ld [wMobileErrorCodeBuffer], a
	xor a
	ld [wMobileErrorCodeBuffer + 1], a
	ld [wMobileErrorCodeBuffer + 2], a
	ld a, MOBILEAPI_05
	call MobileAPI
	ld a, [wc3f0]
	ld [wc319], a
	ld a, [wcd34]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

Function118007:
	xor a
	ld [wcd38], a

Function118440:
	push af
	ld a, BANK(s5_bfff)
	call OpenSRAM
	ld a, [s5_bfff]
	inc a
	ld [s5_bfff], a
	call CloseSRAM
	pop af
	ret

Function1184a5:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886e
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetExchangeIndexFile
	dw MobileAdapterCommunication
	dw Function118d80
	dw DoHttpPostTradeRequestOrCancelRequest
	dw MobileAdapterCommunication
	dw Function118ded
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw DisplaySendToTradeCornerAnimation
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function1184ec:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886e
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw LoginToPop3Service
	dw MobileAdapterCommunication
	dw Function119973
	dw MobileAdapterCommunication
	dw Function119987
	dw MobileAdapterCommunication
	dw Function1199b4
	dw Function1199ca
	dw MobileAdapterCommunication
	dw Function1199e2
	dw Function119b0d
	dw MobileAdapterCommunication
	dw DecodeReceivedTradeCornerTrade
	dw DeleteTradeEmail
	dw MobileAdapterCommunication
	dw LogoutOfPop3Service
	dw MobileAdapterCommunication
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw DeleteInvalidTradeEmail
	dw MobileAdapterCommunication
	dw Function119ac9
	dw Function118e76

BattleTowerRoomMenu_Jumptable: ; Call_046_454d in jp crystal
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

; this jumptable defines all the steps in the process that starts when selecting challenge or the honor roll download in the battle tower menu
; wcd38 is commonly used here to differentiate between downloading challenge or honor roll data
; function BattleTowerRoomMenu_IncrementJumptable is commonly used to advance one step forward
; sometimes wcf66 is directly manipulated in order to jump to different steps
.Jumptable: ; offset 11855c in jp rom, 51 entries long
;	dw BattleTowerRoomMenu_PickLevelMessage
;	dw BattleTowerRoomMenu_PlacePickLevelMenu
;	dw BattleTowerRoomMenu_UpdatePickLevelMenu
;	dw BattleTowerRoomMenu_DoNothing
;	dw BattleTowerRoomMenu_PartyMonTopsThisLevelMessage
;	dw BattleTowerRoomMenu_WaitForMessage
;	dw BattleTowerRoomMenu_DelayRestartMenu
;	dw BattleTowerRoomMenu_QuitMessage
;	dw BattleTowerRoomMenu_PlaceYesNoMenu
;	dw BattleTowerRoomMenu_UpdateYesNoMenu
;	dw BattleTowerRoomMenu_UberRestrictionMessage
;	dw BattleTowerRoomMenu_WaitForMessage
;	dw BattleTowerRoomMenu_DelayRestartMenu
;	dw Function118e76 ; mobile
;	dw BattleTowerRoomMenu_CallRoomMenu2 ; mobile
;	dw Function118e76 ; mobile

	; the jumptable in the japanese version
	dw BattleTowerRoomMenu_PickLevelMessage ;6849
	dw BattleTowerRoomMenu_PlacePickLevelMenu ;7C49
	dw BattleTowerRoomMenu_UpdatePickLevelMenu ;C849
	dw RemovedFunction8 ;9A4A
	dw Function11886e ;B448
	dw InitMobileAdapter ;C648
	dw MobileAdapterCommunication ;D347
	dw ReadMobileAdapterEeprom ;F648
	dw MobileAdapterCommunication ;D347
	dw SetLoginId ;FE48
	dw MobileAdapterCommunication ;D347
	dw SetEmailAddress ;0649
	dw MobileAdapterCommunication ;D347
	dw LoginToIsp ;0E49
	dw MobileAdapterCommunication ;D347
	dw StopPichuMobileAnimation ;4949
	dw HttpGetBattleIndexFile ;4E4D
	dw MobileAdapterCommunication ;D347
	dw Function11891c ;6249
	dw Function118a54 ;3D4D
	dw MobileAdapterCommunication ;D347
	dw RemovedFunction ;A84A
	dw RemovedFunction2 ;D84A
	dw RemovedFunction3 ;244B
	dw RemovedFunction4 ;4D4C
	dw RemovedFunction5 ;D54C
	dw RemovedFunction6 ;DE4C
	dw RemovedFunction7 ;154D
	dw MobileAdapterCommunication ;D347
	dw ValidateBattleDownload ;5B50
	dw LogoutOfIsp ;9351
	dw MobileAdapterCommunication ;D347
	dw Function118e76 ;9C51
	dw Function118e7e ;A451
	dw MobileAdapterCommunication ;D347
	dw BattleTowerRoomMenu_DoNothing ;5E40
	dw BattleTowerRoomMenu_PartyMonTopsThisLevelMessage ;B260
	dw BattleTowerRoomMenu_WaitForMessage ;BB60
	dw BattleTowerRoomMenu_DelayRestartMenu ;C860
	dw BattleTowerRoomMenu_QuitMessage ;1261
	dw BattleTowerRoomMenu_PlaceYesNoMenu ;2E61
	dw BattleTowerRoomMenu_UpdateYesNoMenu ;3B61
	dw BattleTowerRoomMenu_UberRestrictionMessage ;A760
	dw BattleTowerRoomMenu_WaitForMessage ;BB60
	dw BattleTowerRoomMenu_DelayRestartMenu ;C860
	dw Function118e76 ;9C51
	dw BattleTowerRoomMenu_CallRoomMenu2;Function118e7e AD51
	dw RemovedFunction9 ;6060
	dw RemovedFunction10 ;6960
	dw RemovedFunction11 ;7660
	dw Function118e76 ;9C51

; register battle tower record
Function11857c:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886e
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetBattleIndexFile2
	dw MobileAdapterCommunication
	dw Function11891c
	dw Function1198ee
	dw Function1198f7
	dw MobileAdapterCommunication
	dw Function119937
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function1185c3:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886e
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetNewsIndexFile
	dw MobileAdapterCommunication
	dw Function118e92
	dw MobileAdapterCommunication
	dw Function118eb0
	dw Function118ec6
	dw Function118f0d
	dw Function118f14
	dw Function118f5e
	dw MobileAdapterCommunication
	dw Function118fc0
	dw MobileAdapterCommunication
	dw Function119054
	dw Function1190d0
	dw MobileAdapterCommunication
	dw Function1190ec
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw BattleTowerRoomMenu_QuitMessage
	dw BattleTowerRoomMenu_PlaceYesNoMenu
	dw BattleTowerRoomMenu_UpdateYesNoMenu
	dw Function11914e
	dw Function118e76

Function118624:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function118866
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetNewsIndexFile
	dw MobileAdapterCommunication
	dw Function118e92
	dw MobileAdapterCommunication
	dw Function11915d
	dw Function118f68
	dw MobileAdapterCommunication
	dw Function119009
	dw MobileAdapterCommunication
	dw Function119054
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function118671:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function118866
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Function119380
	dw Function119388
	dw Function1193a0
	dw MobileAdapterCommunication
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function1186b2:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function118866
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Function119380
	dw Function1193e3
	dw Function1193fb
	dw MobileAdapterCommunication
	dw Function119413
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function1186f5:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886a
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetStadiumGSIndexFile
	dw MobileAdapterCommunication
	dw Function119451
	dw Function1195f8
	dw Function119612
	dw Function119629
	dw Function119648
	dw MobileAdapterCommunication
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function11967d
	dw Function119685
	dw Function119665
	dw Function11966d
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

Function118746:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Function11886e
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw ReadMobileAdapterEeprom
	dw MobileAdapterCommunication
	dw SetLoginId
	dw MobileAdapterCommunication
	dw SetEmailAddress
	dw MobileAdapterCommunication
	dw LoginToIsp
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw HttpGetEggIndexFile
	dw MobileAdapterCommunication
	dw Function1196f2
	dw Function1197c9
	dw Function1197dc
	dw MobileAdapterCommunication
	dw LogoutOfIsp
	dw MobileAdapterCommunication
	dw Function119800
	dw Function118e76
	dw Function118e7e
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Function118e76
	dw BattleTowerRoomMenu_CallRoomMenu2
	dw Function118e76

StopPichuMobileAnimation:
	farcall _StopPichuMobileAnimation
	ret

MobileAdapterCommunication:
	farcall _MobileAdapterCommunication
	ret
	ret

Function118866:
	ld a, 2
	jr asm_11886f

Function11886a:
	ld a, 1
	jr asm_11886f

Function11886e:
	xor a

asm_11886f:
	ld [wBGMapPalBuffer], a
	ld a, $0
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	farcall BattleTowerRoomMenu_IncrementJumptable
	ld a, [wcd33]
	ld [wMobileInactivityTimerSeconds], a

InitMobileAdapter:
	call BattleTowerRoomMenu2
	ret c
	xor a
	ld [wcf64], a
	ld [wc807], a
	ld de, wcd81
	ld hl, $46
	ld a, MOBILEAPI_01
	jp Function119e2b

ReadMobileAdapterEeprom:
	ld de, wc346
	ld a, MOBILEAPI_06
	jp Function119e2b

SetLoginId:
	ld de, wc3ac
	ld a, MOBILEAPI_07
	jp Function119e2b

SetEmailAddress:
	ld de, wEmailAddress
	ld a, MOBILEAPI_08
	jp Function119e2b

LoginToIsp:
	ld a, $1
	ld [wcd65], a
	call Function1188e7
	ld hl, wc708
.asm_1188d3
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .asm_1188d3
	call Function119eb4
	call Function119ec2
	ld hl, wc708
	ld a, MOBILEAPI_03
	jp Function119e2b

Function1188e7:
	ld de, wc346
	ld a, BANK(s5_aa4a)
	call OpenSRAM
	ld a, [s5_aa4a]
	call CloseSRAM
	and a
	ret z
	sla a
	ld c, a
.asm_1188fa
	ld a, [de]
	inc de
	and a
	jr nz, .asm_1188fa
	dec c
	jr nz, .asm_1188fa
	ret

; parse downoaded battle tower index file
Function11891c:
	farcall Function118b42
	call BattleTowerRoomMenu_IncrementJumptable
	ret

BattleTowerRoomMenu_PickLevelMessage:
	ld a, [wcd38]
	and a
	jr nz, .asm_11892d
	ld hl, Text_WhatLevelDoYouWantToChallenge
	jr .asm_118930

.asm_11892d
	ld hl, Text_CheckBattleRoomListByMaxLevel

.asm_118930
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlacePickLevelMenu:
	ld a, [wc31a]
	and a
	ret nz
	ld hl, MenuHeader_119cf7
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 16, 8, wAttrmap
	ld a, $40
	or [hl]
	ld [hl], a
	call WaitBGMap2
	ld a, $1
	ld [wcd4f], a
	ld a, $1
	ldh [rSVBK], a
	ld a, [wStatusFlags]
	bit STATUSFLAGS_HALL_OF_FAME_F, a
	jr nz, .asm_11896b
	ld hl, Strings_Ll0ToL40 ; Address to list of strings with the choosable levels
	ld a, 5                 ; 4 levels to choose from, including 'Cancel'-option
	jr .asm_118970

.asm_11896b
	ld hl, Strings_L10ToL100 ; Address to list of strings with the choosable levels
	ld a, 11                 ; 10 levels to choose from, including 'Cancel'-option

.asm_118970
	ld [wcd4a], a
	ld a, l
	ld [wcd4b], a
	ld a, h
	ld [wcd4c], a
	ld a, $3
	ldh [rSVBK], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_UpdatePickLevelMenu:
	hlcoord 13, 8
	ld de, String_119d07
	call PlaceString
	hlcoord 13, 10
	ld de, String_119d07
	call PlaceString
	ld a, [wcd4b]
	ld l, a
	ld a, [wcd4c]
	ld h, a
	ld d, $0
	ld a, [wcd4f]
	dec a
	rlca
	rlca
	rlca
	ld e, a
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	ldh a, [rSVBK]
	push af
	ld a, $1
	ldh [rSVBK], a
	ld bc, wStringBuffer3
; save the current selection to wStringBuffer3 for later display in a textbox (never happens in the english version)
; this no longer works properly in the english version without a slight adjustment due to there being a space in the beginning of the strings displayed
.asm_1189b5
	ld a, [hli]
	cp $50
	jr z, .asm_1189c4
	cp $7f
	jr z, .asm_1189b5;.asm_1189c2 ; skip space instead of finishing string
	ld [bc], a
	inc bc
	jr .asm_1189b5

.asm_1189c2
	ld a, $50

.asm_1189c4
	ld [bc], a
	pop af
	ldh [rSVBK], a
	hlcoord 13, 9
	call PlaceString
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .b_button
	ld a, [hl]
	and A_BUTTON
	jr nz, .a_button
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
	ld a, [hl]
	and D_UP
	jr nz, .d_up
.asm_1189e5
	ret

.d_down
	ld hl, wcd4f
	dec [hl]
	jr nz, .asm_1189e5
	ld a, [wcd4a]
	ld [hl], a
	jr .asm_1189e5

.d_up
	ld a, [wcd4a]
	ld hl, wcd4f
	inc [hl]
	cp [hl]
	jr nc, .asm_1189e5
	ld a, $1
	ld [hl], a
	jr .asm_1189e5

.a_button
	call PlayClickSFX
	ld a, [wcd4f]
	ld hl, wcd4a
	cp [hl]
	jr z, .asm_118a3c
	dec a
	and $fe
	srl a
	ld [wcf65], a
	ldh a, [rSVBK]
	push af
	ld a, $1
	ldh [rSVBK], a
	call CloseWindow
	pop af
	ldh [rSVBK], a
	ld a, [wcd38]
	and a
	jr nz, .asm_118a30
	call BattleTower_LevelCheck
	ret c
	call BattleTower_UbersCheck
	ret c

.asm_118a30
;	ld a, [wcd4f]
;	ld [w3_d800], a

	ld hl, Text_LinkingWithCenter;$621a
	call BattleTowerRoomMenu_SetMessage

	jp BattleTowerRoomMenu_IncrementJumptable

.b_button
	call PlayClickSFX

.asm_118a3c
	ldh a, [rSVBK]
	push af
	ld a, $1
	ldh [rSVBK], a
	call CloseWindow
	pop af
	ldh [rSVBK], a
	ld a, 39 ;BattleTowerRoomMenu_QuitMessage;$7
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $0
	ld [wMobileInactivityTimerFrames], a
	ret

RemovedFunction8: ; 4A9A
	ld a, [$c31a];$c340
	and a
	ret nz

	ld a, [wcd4f];$cd43
	ld [$cd61], a ;$cd55
	jp BattleTowerRoomMenu_IncrementJumptable

; sort of validation of the battle room number
RemovedFunction:
	ld a, [wcd89];$cd7d
	bit 0, a
	jr nz, jr_046_4aba

	ld hl, wc3ee
	ld a, [hl+]
	or [hl]
	jr z, jr_046_4abf

	cp $0a
	jr nc, jr_046_4ac4

jr_046_4aba:
	ld a, $d3
	jp SetMobileErrorCode;Jump_046_484b


jr_046_4abf:
	ld a, $d4
	jp SetMobileErrorCode;Jump_046_484b


jr_046_4ac4:
	ld a, [wcd38];$cd2c
	and a
	jr nz, jr_046_4acf

	ld hl, Text_EnterWhichBattleRoom;$627b
	jr jr_046_4ad2

jr_046_4acf:
	ld hl, Text_WhichBattleRoom;$6293

jr_046_4ad2:
	call BattleTowerRoomMenu_SetMessage;Call_046_6ef1
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

; initialize the menu for picking the battle room
; similar to the menu for picking the level (BattleTowerRoomMenu_PlacePickLevelMenu)
RemovedFunction2:
	ld a, [$c31a];$c340
	and a
	ret nz

	ld hl, MenuData_119cff;$6189
	call LoadMenuHeader;$1d00
	call MenuBox;$1c86
	call MenuBoxCoord2Tile;$1cc8
	call ApplyTilemap;$31e8
	;hlcoord 17, 8, wAttrmap ; flip the upper arrow tile
	hlcoord 16, 8, wAttrmap
	ld a, $40
	or [hl]
	ld [hl], a
	call WaitBGMap2;$31cc
	ld a, $01
	ld [wcd4b], a;$cd3f
	xor a
	ld [wcd4c], a;$cd40
	ld a, [$c3ee]
	ldh [hDividend + 0], a;ldh [$b3], a
	ld a, [$c3ef]
	ldh [hDividend + 1], a;ldh [$b4], a
	ld a, $0a
	ldh [hDivisor], a;ldh [$b7], a
	ld b, $02
	call Divide;$30f0
	and a
	ldh a, [hQuotient + 3];ldh a, [$b6]
	add $01
	ld [wcd4d], a;$cd41
	ldh a, [hQuotient + 2];ldh a, [$b5]
	adc $00
	ld [wcd4e], a;$cd42
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

; run the menu
RemovedFunction3:
	ld hl, $c54f;$c550
	ld de, String_119d07 + 2;$6193
	call PlaceString;$1057
	ld hl, $c577;$c578
	ld de, String_119d07 + 2;$6193
	call PlaceString;$1057
	ld a, [wcd4b];$cd3f
	ld hl, wcd4d;$cd41
	cp [hl]
	jr nz, jr_046_4b51

	ld a, [wcd4c];$cd40
	inc hl
	cp [hl]
	jr nz, jr_046_4b51

	ld hl, $c561;$c564
	ld de, BattleTowerCancelString ;$6216
	call PlaceString;$1057
	jr jr_046_4b79

jr_046_4b51:
	;;;; blank the cancel text might have been displayed before
	ld hl, $c561
	ld de, String_blank
	call PlaceString
	;;;;

	ld hl, $c563;$c564
	push hl
	ld de, wcd4b;$cd3f
	ld bc, $8103
	call PrintNum;$3164
	pop hl
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld de, wStringBuffer4;$d07c
	ld a, $03
; save the current selection to wStringBuffer4 for later display in a textbox
jr_046_4b6b:
	push af
	ld a, [hl+]
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, jr_046_4b6b

	ld a, $50
	ld [de], a
	pop af
	ldh [rSVBK], a

jr_046_4b79: ; keys pressed checks
	ld hl, hJoyPressed;$ffa7
	ld a, [hl]
	and $01
	jp nz, Jump_046_4c02

	ld a, [hl]
	and $80
	jr nz, jr_046_4ba0

	ld a, [hl]
	and $40
	jr nz, jr_046_4bcc

	ld a, [hl]
	and $20
	jr nz, jr_046_4ba0

	ld a, [hl]
	and $10
	jr nz, jr_046_4bcc

	ld a, [hl]
	and $02
	jp nz, Jump_046_4c2d

	call Function11a9f0;Call_046_6f21

jr_046_4b9f:
	ret


jr_046_4ba0:
	xor a
	ld [wcd8a], a;$cd7e
	ld [wcd8b], a;$cd7f
	ld a, [wcd4b];$cd3f
	ld l, a
	ld a, [wcd4c];$cd40
	ld h, a
	ld de, $ffff
	add hl, de
	ld a, h
	ld [wcd4c], a;$cd40
	ld a, l
	ld [wcd4b], a;$cd3f
	or h
	jr nz, jr_046_4b9f

	ld a, [wcd4d];$cd41
	ld [wcd4b], a;$cd3f
	ld a, [wcd4e];$cd42
	ld [wcd4c], a;$cd40
	jr jr_046_4b9f

jr_046_4bcc:
	xor a
	ld [wcd8a], a;$cd7e
	ld [wcd8b], a;$cd7f
	ld a, [wcd4b];$cd3f
	ld l, a
	ld a, [wcd4c];$cd40
	ld h, a
	ld de, $0001
	add hl, de
	ld a, l
	ld [wcd4b], a;$cd3f
	ld a, h
	ld [wcd4c], a;$cd40
	ld a, [wcd4e];$cd42
	ld hl, wcd4c;$cd40
	cp [hl]
	jr nz, jr_046_4b9f

	dec hl
	ld a, [wcd4d];$cd41
	cp [hl]
	jr nc, jr_046_4b9f

	ld a, $01
	ld [wcd4b], a;$cd3f
	xor a
	ld [wcd4c], a;$cd40
	jr jr_046_4b9f

; selection made
Jump_046_4c02:
	xor a
	ld [wcd8a], a;$cd7e
	ld [wcd8b], a;$cd7f
	call PlayClickSFX;$1fcc
	ld a, [wcd4b];$cd3f
	ld hl, wcd4d;$cd41
	cp [hl]
	jr nz, jr_046_4c1c

	inc hl
	ld a, [wcd4c];$cd40
	cp [hl]
	jr z, jr_046_4c30

jr_046_4c1c:
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [rSVBK], a
	call CloseWindow;$1be2
	pop af
	ldh [rSVBK], a
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f
	ret


Jump_046_4c2d:
	call PlayClickSFX;$1fcc

jr_046_4c30:
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [rSVBK], a
	call CloseWindow;$1be2
	pop af
	ldh [rSVBK], a
	ld a, $27
	ld [wcf66], a;$cf5a
	ld a, $15
	ld [wMobileInactivityTimerFrames], a;$cd3a
	ld a, $1e
	ld [wcd47], a;$cd3b
	ret

RemovedFunction4:
	xor a
	ld b, a
	ld c, a
	ld a, [wcd4f];$$cd43
	cp $0a
	jr nz, jr_046_4c5a

	ld c, $01
	xor a

jr_046_4c5a:
	ld [$cd61], a;$cd55
	ld a, [wcd4b];$cd3f
	ld l, a
	ld a, [wcd4c];$cd40
	ld h, a
	ld de, $ffff
	add hl, bc
	add hl, de
	ld a, l
	and $0f
	ldh [hDividend + 0], a;$b3
	ld a, l
	and $f0
	swap a
	ldh [hDividend + 1], a;$b4
	ld a, h
	and $0f
	ldh [hDividend + 2], a;$b5
	call Function11a80c;Call_046_6d3d
	call RemovedFunction12;Call_046_4e2b
	ret c

	ld a, [wcd38];$cd2c
	and a
	jr nz, jr_046_4c92

	ld a, [wcd5b];$cd4f
	ld l, a
	ld a, [wcd5c];$cd50
	ld h, a
	jr jr_046_4cae

jr_046_4c92:
	ld a, $01
	ldh [rSVBK], a
	ld hl, wStringBuffer3;$d071
	ld de, wcd69;$cd5d
	ld bc, $0016
	call CopyBytes;$2ff2
	ld a, $03
	ldh [rSVBK], a
	ld a, [wcd5f];$cd53
	ld l, a
	ld a, [wcd60];$cd54
	ld h, a

jr_046_4cae:
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld de, $cd61;$cd55
	ld a, $04

jr_046_4cba:
	push af
	ld a, [de]
	inc de
	add $30
	ld [hl-], a
	pop af
	dec a
	jr nz, jr_046_4cba

	ld hl, $dffc
	ld de, wcd64;$cd58
	ld c, $04

jr_046_4ccc:
	ld a, [de]
	dec de
	ld [hl+], a
	dec c
	jr nz, jr_046_4ccc

	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

RemovedFunction5:
	ld hl, Text_ThisBattleRoomPleaseWait;$62a3
	call BattleTowerRoomMenu_SetMessage;Call_046_6ef1
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

RemovedFunction6:
	ld a, [$c31a];$c340
	and a
	ret nz

	ld a, [wcd38];$cd2c
	and a
	jr nz, jr_046_4cf3

	ld a, [wcd53];$cd47
	ld l, a
	ld a, [wcd54];$cd48
	ld h, a
	jr jr_046_4cfb

jr_046_4cf3:
	ld a, [wcd57];$cd4b
	ld l, a
	ld a, [wcd58];$cd4c
	ld h, a

jr_046_4cfb:
	call Function118e39;Call_046_515f
	ld a, $09
	ld [wBattleTowerRoomMenu2JumptableIndex], a;$cd30
	ld a, $27
	ld [wMobileInactivityTimerSeconds], a;$cd39
	ld a, $15
	ld [wMobileInactivityTimerFrames], a;$cd3a
	ld a, $1e
	ld [wcd47], a;$cd3b
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

RemovedFunction7:
	call BattleTowerRoomMenu2;Call_046_6409
	ret c

	call DelayFrame;$045a
	ld a, [wcd38];$cd2c
	and a
	jr nz, jr_046_4d2c

	ld a, [wcd53];$cd47
	ld l, a
	ld a, [wcd54];$cd48
	ld h, a
	jr jr_046_4d34

jr_046_4d2c:
	ld a, [wcd57];$cd4b
	ld l, a
	ld a, [wcd58];$cd4c
	ld h, a

jr_046_4d34:
	ld de, wBT_DownloadBuffer
	ld bc, $0e00
	jp HttpGet;Jump_046_4dcd

; download number of available battle rooms using the 2nd URL in the index file
Function118a54: ; unreferenced
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wc3ec
	ld bc, $0004
	jp HttpGet

; download battle tower index file
HttpGetBattleIndexFile:
	ld hl, BattleDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	; these set up a buffer for the received data to be written too
	; if the received data is too big, the game will display an error
	ld de, w3_d000 ; location
	ld bc, $1000 ; size
	jp HttpGetIndexFile

HttpGetBattleIndexFile2:
	ld hl, BattleDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jp HttpGetIndexFile

HttpGetExchangeIndexFile:
	ld hl, ExchangeDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jp HttpGetIndexFile

HttpGetNewsIndexFile:
	ld hl, NewsDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld a, $5
	ldh [rSVBK], a
	ld de, w3_d100
	ld bc, $e00
	jr HttpGetIndexFile

HttpGetStadiumGSIndexFile:
	ld hl, StadiumDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jr HttpGetIndexFile

HttpGetEggIndexFile:
	ld hl, OddEggDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jr HttpGetIndexFile

; download data from server
HttpGet:
	push bc
	push de
	push hl
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	pop hl
	ld c, $0
	ld de, wcc60
.asm_118af5
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr z, .asm_118b06
	inc c
	ld a, c
	cp $a6
	jr c, .asm_118af5
	ld a, $da
	jp SetMobileErrorCode

.asm_118b06
	call Function118b24
	pop de
	pop bc
	ld a, MOBILEAPI_15
	jp Function119e2b

; download data from server
HttpGetIndexFile:
	push de
	push bc
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	call Function118b24
	pop bc
	pop de
	ld a, MOBILEAPI_15
	jp Function119e2b

Function118b24:
	ld hl, wc346
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $80
	ld [wcd89], a
	ld hl, wc346
	ret

RemovedFunction12:
	ld a, [wcd38];$cd2c
	and a
	ret nz

	ld a, BANK(s5_aa5d)
	call OpenSRAM;$2f9d
	ld a, [s5_aa5d]
	and a
	jr z, jr_046_4e63

	ld c, a
	ld hl, s5_aa5d + 1

jr_046_4e3f:
	push hl
	ld de, wcd64;$cd58
	ld b, $04

jr_046_4e45:
	ld a, [de]
	dec de
	cp [hl]
	jr nz, jr_046_4e59

	inc hl
	dec b
	jr nz, jr_046_4e45

	pop hl
	call CloseSRAM;$2fad
	ld a, $2f
	ld [wcf66], a;$cf5a
	scf
	ret


jr_046_4e59:
	pop hl
	push bc
	ld bc, $0004
	add hl, bc
	pop bc
	dec c
	jr nz, jr_046_4e3f

jr_046_4e63:
	call CloseSRAM;$2fad
	and a
	ret

Function118b9a:
	ld a, h
	cp $e0
	ret c
	ld a, $d3
	call SetMobileErrorCode
	and a
	ret

pushc
setcharmap ascii

ExchangeDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTI/exchange/index.txt", 0
BattleDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTI/battle/index.txt", 0
NewsDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTI/news/index.txt", 0
StadiumDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTI/POKESTA/menu.cgb", 0
OddEggDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTI/tamago/index.txt", 0

popc

; validates the length of the received battle room (1428 bytes) or honor roll data (150 bytes)
ValidateBattleDownload:
	farcall _ValidateBattleDownload

Function118d80:
	call Function118e06
	ld a, [wcd38]
	and a
	jr z, .asm_118d8e
	call BattleTowerRoomMenu_IncrementJumptable
	jr asm_118d9f

.asm_118d8e
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $12
	ld [wMobileInactivityTimerSeconds], a
	call BattleTowerRoomMenu_IncrementJumptable

DoHttpPostTradeRequestOrCancelRequest:
	call BattleTowerRoomMenu2
	ret c

asm_118d9f:
	ld hl, wc608
	call Function119940
	ld a, [wcd38]
	and a
	jr nz, .asm_118db2
	ld a, TRADE_CORNER_TRADE_REQUEST_LENGTH
	ld [wcd3b], a
	jr .asm_118db7

.asm_118db2
	ld a, TRADE_CORNER_CANCEL_REQUEST_LENGTH
	ld [wcd3b], a

.asm_118db7
	ld hl, w3_d800
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd3b]
	ld [hli], a
	xor a
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, [wcd39]
	ld [hli], a
	ld a, [wcd3a]
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $40
	ld [wcd89], a
	ld hl, w3_d800
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_16
	jp Function119e2b

Function118ded:
	ld a, [wcd38]
	and a
	jr z, .asm_118e03
	ldh a, [rSVBK]
	push af
	ld a, $1
	ldh [rSVBK], a
	farcall Function11b93b
	pop af
	ldh [rSVBK], a

.asm_118e03
	jp BattleTowerRoomMenu_IncrementJumptable

Function118e06:
	ld hl, wd002
	ld a, [wcd38]
	and a
	jr z, .asm_118e1d
.asm_118e0f
	call Function118b9a
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118e0f
	ld a, [hli]
	cp $a
	jr nz, .asm_118e0f

.asm_118e1d
	ld a, l
	ld [wcd39], a
	ld a, h
	ld [wcd3a], a
.asm_118e25
	call Function118b9a
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118e25
	ld a, [hli]
	cp $a
	jr nz, .asm_118e25
	dec hl
	xor a
	ld [hld], a
	ld [hl], a
	jr asm_118e3e

Function118e39:
	ld a, [hli]
	and a
	jr nz, Function118e39
	dec hl

asm_118e3e:
	ld a, [hld]
	cp $2f
	jr nz, asm_118e3e
	inc hl
	inc hl
	ld de, wcd85
	ld c, $4
.asm_118e4a
	ld a, [hli]
	cp $2e
	jr z, .asm_118e63
	cp $30
	jr c, .asm_118e67
	cp $3a
	jr nc, .asm_118e67
	sub $30
	add $f6
	ld [de], a
	inc de
	dec c
	jr nz, .asm_118e4a
	ld de, wcd85
.asm_118e63
	ld a, $50
	ld [de], a
	ret
.asm_118e67
	ld a, $f3
	ld [de], a
	inc de
	jr .asm_118e63

LogoutOfIsp:
	xor a
	ld [wcd65], a
	ld a, MOBILEAPI_05
	jp Function119e2b

Function118e76:
	; Call $c in BattleTowerRoomMenu2
	ld a, $c
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function118e7e:
	call BattleTowerRoomMenu2
	ret c
	ld a, MOBILEAPI_1B
	jp Function119e2b

BattleTowerRoomMenu_CallRoomMenu2:
	call BattleTowerRoomMenu2
	ret c
	ld a, [wcd33]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

Function118e92:
	call Function118440
	call Function1191d3
	ld a, [wcd53]
	ld l, a
	ld a, [wcd54]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld de, w3_d800
	ld bc, $0800
	jp HttpGetIndexFile

Function118eb0:
	call Function118440
	ld hl, w3_d802
	ld de, wBGMapBuffer
	ld bc, $000c
	call CopyBytes
	call Function1192cc
	ret c
	jp BattleTowerRoomMenu_IncrementJumptable

Function118ec6:
	call Function118440
	call SpeechTextbox
	ld hl, w3_d80e
	ld de, wc320
	ld bc, $0026
	call CopyBytes
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
	ld a, $2
	ld [wc31a], a
	ld a, $1d
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $24
	ld [wMobileInactivityTimerSeconds], a
	ld a, $11
	ld [wMobileInactivityTimerFrames], a
	ld a, $1c
	ld [wcd47], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function118f0d:
	call BattleTowerRoomMenu2
	ret c
	call Function118440

Function118f14:
	call Function118440
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld a, [wcc60]
	and a
	jr z, .DontSendSaveFile
	ld hl, Text_SaveFileWillBeSent
	call BattleTowerRoomMenu_SetMessage

.DontSendSaveFile:
	ld a, [wcd57]
	ld l, a
	ld a, [wcd58]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld hl, wcc60
	call Function118e39
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $24
	ld [wMobileInactivityTimerSeconds], a
	ld a, $13
	ld [wMobileInactivityTimerFrames], a
	ld a, $1c
	ld [wcd47], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function118f5e:
	call BattleTowerRoomMenu2
	ret c
	call Function118440
	call DelayFrame

Function118f68:
	call Function119223
	ret c
	call Function118440
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118fba
	ld hl, wc346
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd4b]
	ld [hli], a
	ld a, [wcd4c]
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $40
	ld [wcd89], a
	ld hl, wc346
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_16
	jp Function119e2b

.asm_118fba
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu_IncrementJumptable

Function118fc0:
	call Function118440
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118ffa
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118ff2
	ld hl, Text_SentSaveFileReadingNews
	jr .asm_118ff5

.asm_118ff2
	ld hl, Text_ReadingNews

.asm_118ff5
	call BattleTowerRoomMenu_SetMessage
	jr Function119009

.asm_118ffa
	ld hl, Text_ReadingNews
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu_IncrementJumptable

Function119009:
	call Function118440
	call Function119300
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld hl, wc346
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd4b]
	ld [hli], a
	ld a, [wcd4c]
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $40
	ld [wcd89], a
	ld hl, wc346
	ld de, w3_d000
	ld bc, $1000
	ld a, MOBILEAPI_16
	jp Function119e2b

Function119054:
	ld a, $6
	call OpenSRAM
	ld hl, wd002
	ld a, [wcd4f]
	ld e, a
	ld a, [wcd50]
	ld d, a
	ld a, [w3_d000]
	ld c, a
	ld a, [w3_d000 + 1]
	ld b, a
	call Function119192
	ret c
	ld a, [wcd89]
	and $1
	jr z, .asm_11908a
	ld a, $6
	ldh [rSVBK], a
	ld hl, wd002
	ld a, [w3_d000]
	ld c, a
	ld a, [w3_d000 + 1]
	ld b, a
	call Function119192
	ret c

.asm_11908a
	call CloseSRAM
	ld a, $3 ; ???
	ldh [rSVBK], a
	ld a, BANK(s5_b1b3) ; aka BANK(s5_b1b4) and BANK(s5_aa7f) and BANK(sDownloadedContentPrefectureAndZipcode) and BANK(s5_b2f4)
	call OpenSRAM
	ld a, [wcd4f]
	ld [s5_b1b3], a
	ld a, [wcd50]
	ld [s5_b1b3 + 1], a
	ld hl, wcd20
	ld de, s5_aa7f
	ld bc, 12
	call CopyBytes
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPrefecture) ; aka BANK(wZipCode)
	ldh [rSVBK], a
	ld a, [wPrefecture]
	ld [sDownloadedContentPrefectureAndZipcode], a
	ld hl, wZipCode
	ld de, sDownloadedContentPrefectureAndZipcode + 1
	ld bc, ZIPCODE_LENGTH
	call CopyBytes
	pop af
	ldh [rSVBK], a
	call CloseSRAM
	jp BattleTowerRoomMenu_IncrementJumptable

Function1190d0:
	ld a, BANK(w3_d000)
	ldh [rSVBK], a
	ld a, [wcd57]
	ld l, a
	ld a, [wcd58]
	ld h, a
	ld de, wcc60
	call Function1191ad
	ret c
	ld de, w3_d000
	ld bc, $1000
	jp HttpGetIndexFile

Function1190ec:
	ld a, BANK(s5_aa73)
	call OpenSRAM
	ld hl, wBGMapBuffer
	ld de, s5_aa73
	ld bc, 12
	call CopyBytes
	call CloseSRAM
	ld a, BANK(s5_aa72)
	call OpenSRAM
	ld a, $1
	ld [s5_aa72], a
	call CloseSRAM
	ld a, BANK(s6_a000)
	call OpenSRAM
	ld a, [w3_d000]
	ld c, a
	ld a, [w3_d000 + 1]
	ld b, a
	ld hl, wd002
	ld de, s6_a000
	call Function119192
	ret c
	ld a, [wcd89]
	and $1
	jr z, .asm_11913e
	ld a, BANK(w6_d000)
	ldh [rSVBK], a
	ld a, [w3_d000]
	ld c, a
	ld a, [w3_d000 + 1]
	ld b, a
	ld hl, wd002
	call Function119192
	ret c

.asm_11913e
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	call CloseSRAM
	ld hl, Text_ReceivedNews
	call BattleTowerRoomMenu_SetMessage
	jp BattleTowerRoomMenu_IncrementJumptable

Function11914e:
	call BattleTowerRoomMenu2
	ret c
	ld a, $1c
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	ret

Function11915d:
	ld hl, w3_d802
	ld de, wcd20
	ld bc, 12
	call CopyBytes
	ld a, BANK(s5_aa7f)
	call OpenSRAM
	ld hl, wBGMapBuffer
	ld de, s5_aa7f
	ld c, 12
.asm_119176
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_119184
	inc hl
	dec c
	jr nz, .asm_119176
	call BattleTowerRoomMenu_IncrementJumptable
	jr .asm_11918e

.asm_119184
	ld a, $16
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $b
	ld [wMobileErrorCodeBuffer], a

.asm_11918e
	call CloseSRAM
	ret

Function119192:
	inc b
	inc c
	jr .asm_11919e

.asm_119196
	ld a, [hli]
	ld [de], a
	inc de
	ld a, $bf
	cp d
	jr c, .asm_1191a6

.asm_11919e
	dec c
	jr nz, .asm_119196
	dec b
	jr nz, .asm_119196
	and a
	ret

.asm_1191a6
	ld a, $d3
	call SetMobileErrorCode
	scf
	ret

Function1191ad:
	push bc
	ld c, $0
	ld a, $5
	ldh [rSVBK], a
.asm_1191b4
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr z, .asm_1191cc
	inc c
	ld a, c
	cp $a6
	jr c, .asm_1191b4
	ld a, $da
	call SetMobileErrorCode
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	pop bc
	scf
	ret

.asm_1191cc
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	pop bc
	and a
	ret

; seems to parse a downloaded index file
Function1191d3:
	ld hl, w3_d100 + 2
	ld a, l
	ld [wcd53], a
	ld a, h
	ld [wcd54], a
	call Function11920f
	ld a, l
	ld [wcd51], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd52], a
	call Function11920f
	ld a, l
	ld [wcd55], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd56], a
	call Function11920f
	ld a, [wcd49]
	ld a, l
	ld [wcd57], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd58], a
	call Function11920f
	ret

; find CRLF line endings
Function11920f:
.asm_11920f
	call Function118b9a
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_11920f
	ld a, [hli]
	cp $a
	jr nz, .asm_11920f
	dec hl
	xor a
	ld [hld], a
	ld [hli], a
	inc hl
	ret

Function119223:
	xor a
	ld [wcd4b], a
	ld [wcd4c], a
	ld a, BANK(s5_b092) ; aka BANK(s5_b1b1) and BANK(s5_b1b2) and BANK(s5_b1d3)
	call OpenSRAM
	ld hl, wEmailAddress
	ld de, s5_b092
	ld bc, 31
	call CopyBytes
	dec de
	xor a
	ld [de], a
	ld hl, w3_d810
.asm_119241
	ld a, [hli]
	cp $50
	jr nz, .asm_119241
	ld a, [hli]
	ld [wcd4f], a
	ld a, [hli]
	ld [wcd50], a
	ld a, [hli]
	ld [s5_b1b1], a
	ld c, a
	ld a, [hli]
	ld [s5_b1b1 + 1], a
	ld b, a
	ld de, s5_b1d3
	call CopyBytes
	call CloseSRAM
	ld e, l
	ld d, h
	ld hl, wc608
.asm_119266
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_1192c2
	cp $fe
	jr z, .asm_1192a5
	call OpenSRAM
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	push de
	push af
	ld a, [wcd4b]
	ld e, a
	ld a, [wcd4c]
	ld d, a
	pop af
.asm_119286
	push af
	ld a, [bc]
	inc bc
	ld [hli], a
	inc de
	pop af
	dec a
	jr nz, .asm_119286
	call CloseSRAM
	ld a, e
	ld [wcd4b], a
	ld a, d
	ld [wcd4c], a
	pop de
.asm_11929b
	and a
	jr z, .asm_119266
	ld a, $d3
	call SetMobileErrorCode
	scf
	ret

.asm_1192a5
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
	ld a, [de]
	inc de
.asm_1192af
	push af
	ld a, [de]
	inc de
	ld [hli], a
	inc bc
	pop af
	dec a
	jr nz, .asm_1192af
	ld a, c
	ld [wcd4b], a
	ld a, b
	ld [wcd4c], a
	jr .asm_11929b

.asm_1192c2
	ld a, e
	ld [wcd4d], a
	ld a, d
	ld [wcd4e], a
	and a
	ret

Function1192cc:
	ld a, BANK(s5_aa73)
	call OpenSRAM
	ld hl, s5_aa73
	ld de, wc608
	ld bc, 12
	call CopyBytes
	call CloseSRAM
	ld hl, wc608
	ld de, wcd20
	ld c, $c
.asm_1192e8
	ld a, [de]
	inc de
	ld b, a
	ld a, [hli]
	cp b
	jr nz, .asm_1192fe
	dec c
	jr nz, .asm_1192e8
	ld a, $1f
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $27
	ld [wBattleTowerRoomMenuJumptableIndex], a
	scf
	ret

.asm_1192fe
	and a
	ret

Function119300:
	xor a
	ld [wcd4b], a
	ld [wcd4c], a
	ld a, [wcd4d]
	ld e, a
	ld a, [wcd4e]
	ld d, a
	ld hl, wc608
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
.asm_11931a
	ld a, [de]
	inc de
	cp $50
	jr z, .asm_119324
	ld [hli], a
	inc bc
	jr .asm_11931a

.asm_119324
	ld a, $3d
	ld [hli], a
	inc bc
	ld a, c
	ld [wcd4b], a
	ld a, b
	ld [wcd4c], a
	ld a, [de]
	inc de
	call OpenSRAM
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	push de
	push af
	ld a, [wcd4b]
	ld e, a
	ld a, [wcd4c]
	ld d, a
	pop af
.asm_119348
	push af
	ld a, [bc]
	and $f0
	swap a
	call Function1197bf
	ld [hli], a
	inc de
	ld a, [bc]
	inc bc
	and $f
	call Function1197bf
	ld [hli], a
	inc de
	pop af
	dec a
	jr nz, .asm_119348
	call CloseSRAM
	ld a, e
	ld [wcd4b], a
	ld a, d
	ld [wcd4c], a
	pop de
	ld a, [de]
	cp $50
	jr z, .asm_11937f
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
	ld a, $26
	ld [hli], a
	inc bc
	jr .asm_11931a

.asm_11937f
	ret

Function119380:
	ld a, $80
	ld [wcd49], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function119388:
	ld hl, wcd49
	dec [hl]
	ret nz
	ld hl, wcc60
	call Function118e39
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $10
	ld [wMobileInactivityTimerSeconds], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1193a0:
	call BattleTowerRoomMenu2
	ret c
	call DelayFrame
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	ld hl, wc346
	ld a, LOW(w3_d000)
	ld [hli], a
	ld a, HIGH(w3_d000)
	ld [hli], a
	ld a, [wcd3b]
	ld [hli], a
	xor a
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $40
	ld [wcd89], a
	ld hl, wc346
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_16
	jp Function119e2b

Function1193e3:
	ld hl, wcd49
	dec [hl]
	ret nz
	ld hl, wcc60
	call Function118e39
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $11
	ld [wMobileInactivityTimerSeconds], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1193fb:
	call BattleTowerRoomMenu2
	ret c
	call DelayFrame
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	ld de, w3_d000
	ld bc, $1000
	jp HttpGetIndexFile

Function119413:
	ld a, $6 ; ???
	call OpenSRAM
	ld a, [w3_d000]
	ld c, a
	ld a, [w3_d000 + 1]
	ld b, a
	dec bc
	dec bc
	ld hl, wd002
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call Function119192
	ret c
	ld a, [wcd89]
	and $1
	jr z, .asm_119447
	ld a, BANK(w6_d000)
	ldh [rSVBK], a
	ld a, [w6_d000]
	ld c, a
	ld a, [w6_d000 + 1]
	ld b, a
	ld hl, w6_d000 + 2
	call Function119192
	ret c

.asm_119447
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	call CloseSRAM
	jp BattleTowerRoomMenu_IncrementJumptable

Function119451:
	ld a, [wcd89]
	and $1
	jr z, .asm_11945d
	ld a, $d3
	jp SetMobileErrorCode
.asm_11945d
	xor a
	ld [wcd50], a
	call Function119694
	ld a, b
	ld [wcd49], a
	call Function1196cd
	ld a, [wd002]
	ld hl, wd003

Function1195f8:
	ld a, $11
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $1c
	ld [wMobileInactivityTimerSeconds], a
	ld a, $f
	ld [wMobileInactivityTimerFrames], a
	ld a, $14
	ld [wcd47], a
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu_IncrementJumptable

Function119612:
	ld a, $14
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $1c
	ld [wMobileInactivityTimerSeconds], a
	ld a, $10
	ld [wMobileInactivityTimerFrames], a
	ld a, $14
	ld [wcd47], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function119629:
	call BattleTowerRoomMenu2
	ret c
	ld a, LOW(wcc60)
	ld l, a
	ld a, HIGH(wcc60)
	ld h, a
	call Function118e39
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $1c
	ld [wMobileInactivityTimerSeconds], a
	ld a, $14
	ld [wcd47], a
	call BattleTowerRoomMenu_IncrementJumptable

Function119648:
	call BattleTowerRoomMenu2
	ret c
	call DelayFrame
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	call Function118b24
	ld de, w3_d000
	ld bc, $1000
	ld a, MOBILEAPI_15
	jp Function119e2b

Function119665:
	ld a, $1a
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu_IncrementJumptable

Function11966d:
	call BattleTowerRoomMenu2
	ret c
	ld a, [wcd47]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	ret

Function11967d:
	ld a, $18
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu_IncrementJumptable

Function119685:
	call BattleTowerRoomMenu2
	ret c
	ld a, $14
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	ret

Function119694:
	ld b, 0
	ld hl, Unknown_1196b8
.asm_119699
	ld de, wc708
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .asm_1196af
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .asm_1196b0
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .asm_1196b1
	ret
.asm_1196af
	inc hl
.asm_1196b0
	inc hl
.asm_1196b1
	inc b
	ld a, b
	cp $7
	jr nz, .asm_119699
	ret

pushc
setcharmap ascii

Unknown_1196b8:
	db "Lun"
	db "Mar"
	db "Mer"
	db "Gio"
	db "Ven"
	db "Sab"
	db "Dom"

popc

Function1196cd:
	ld de, wc719
	call Function1196de
	ld [wcd4a], a
	inc de
	call Function1196de
	ld [wcd4b], a
	ret

Function1196de:
	ld a, [de]
	inc de
	; b = ([de] - 48) * 2
	; c = ([de] - 48) * 10
	sub $30
	sla a
	ld b, a
	sla a
	sla a
	add b
	ld c, a
	add hl, bc
	ld a, [de]
	inc de
	sub $30
	add c
	ret

Function1196f2:
	ld hl, wd002
.asm_1196f5
	call Function118b9a
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_1196f5
	ld a, [hl]
	cp $a
	jr nz, .asm_1196f5
	xor a
	ld [hld], a
	ld [hli], a
	ld a, l
	ld [wcd5b], a
	ld a, h
	ld [wcd5c], a
	inc hl
	ld e, l
	ld d, h
	ld a, [de]
	inc de
	cp $d
	jr nz, .asm_119722
	ld a, [de]
	inc de
	cp $a
	jr nz, .asm_119722
	ld a, $b
	jp SetMobileErrorCode

.asm_119722
	call Random
	ld c, $0
	ld b, c
.asm_119728
	call Function119798
	ld a, d
	cp $ff
	jr nz, .asm_119735
	ld a, e
	cp $ff
	jr z, .asm_11974c

.asm_119735
	ldh a, [hRandomSub]
	cp d
	jr c, .asm_11974c
	jr z, .asm_11973e
	jr .asm_119745

.asm_11973e
	ldh a, [hRandomAdd]
	cp e
	jr c, .asm_11974c
	jr z, .asm_11974c

.asm_119745
	inc bc
	ld a, c
	or b
	jr z, .asm_119770
	jr .asm_119728

.asm_11974c
	ld a, [wcd5b]
	ld l, a
	ld a, [wcd5c]
	ld h, a
.asm_119754
	ld a, [hld]
	cp $58
	jr nz, .asm_119754
	ld d, $0
.asm_11975b
	inc d
	ld a, [hld]
	cp $58
	jr z, .asm_11975b
	inc hl
	inc hl
	ld a, d
	dec a
	jr z, .asm_11978e
	dec a
	jr z, .asm_119785
	dec a
	jr z, .asm_11977e
	dec a
	jr z, .asm_119775

.asm_119770
	ld a, $d3
	jp SetMobileErrorCode

.asm_119775
	ld a, b
	and $f0
	swap a
	call Function1197bf
	ld [hli], a

.asm_11977e
	ld a, b
	and $f
	call Function1197bf
	ld [hli], a

.asm_119785
	ld a, c
	and $f0
	swap a
	call Function1197bf
	ld [hli], a

.asm_11978e
	ld a, c
	and $f
	call Function1197bf
	ld [hli], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function119798:
	ld d, $0
	ld e, d
	call Function1197b4
	swap a
	or d
	ld d, a
	call Function1197b4
	or d
	ld d, a
	call Function1197b4
	swap a
	or e
	ld e, a
	call Function1197b4
	or e
	ld e, a
	ret

Function1197b4:
	ld a, [hli]
	cp $61
	jr nc, .asm_1197bc
	sub $30
	ret

.asm_1197bc
	sub $57
	ret

Function1197bf:
	cp $a
	jr nc, .asm_1197c6
	add $30
	ret

.asm_1197c6
	add $57
	ret

Function1197c9:
	ld hl, wd002
	call Function118e39
	ld a, $9
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	ld a, $12
	ld [wMobileInactivityTimerSeconds], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1197dc:
	call BattleTowerRoomMenu2
	ret c
	call DelayFrame
	ld hl, wd002
	ld de, wcc60
	ld bc, $0080
	call CopyBytes
	dec de
	xor a
	ld [de], a
	call Function118b24
	ld de, w3_d000
	ld bc, $1000
	ld a, MOBILEAPI_15
	jp Function119e2b

Function119800:
	ld a, $fd
	ld [wc6d0], a
	ld [wOTTrademonSpecies], a
	ld a, [wcd81]
	ld [wc74e], a
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rSVBK], a
	call FadeToMenu
	farcall Function10803d
	call Function11a9ce
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall Function115dc3
	jp BattleTowerRoomMenu_IncrementJumptable

DisplaySendToTradeCornerAnimation:
	ld a, [wcd80]
	and a
	jr nz, .asm_1198a0
	ld a, [wcd38]
	and a
	jr nz, .asm_1198a8
	farcall Function170000
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rSVBK], a
	call FadeToMenu
	farcall MobileTradeAnimation_SendGivemonToGTS
	call Function11a9ce
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall Function115dc3
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_1198a0
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_1198a8
	farcall Function17005a
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rSVBK], a
	call FadeToMenu
	farcall MobileTradeAnimation_RetrieveGivemonFromGTS
	call Function11a9ce
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rSVBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall Function115dc3
	jp BattleTowerRoomMenu_IncrementJumptable

Function1198ee:
	ld hl, Text_RegisteringRecord
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

; battle tower data post
Function1198f7:
	ld a, [wc31a]
	and a
	ret nz

	; insert email address into data to post
	ld hl, wc608 + 2
	call Function119940

	; configuration for post
	ld hl, w3_d800
	ld a, LOW(wc608) ; memory location of data to post
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, LOW(BATTLE_TOWER_DATA_UPLOAD_LENGTH)
	ld [hli], a
	ld a, HIGH(BATTLE_TOWER_DATA_UPLOAD_LENGTH)
	ld [hli], a
	ld a, LOW(wc708) ; memory location of login information
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, [wcd51] ; memory location of url
	ld [hli], a
	ld a, [wcd52]
	ld [hli], a
	call Function119eb4
	call Function119ec2
	ld a, $40
	ld [wcd89], a
	ld hl, w3_d800 ; memory location of configuration for post
	ld de, w3_de00 ; buffer location
	ld bc, $200 ; buffer size
	ld a, MOBILEAPI_16
	jp Function119e2b

Function119937:
	farcall BattleTowerAction_06
	jp BattleTowerRoomMenu_IncrementJumptable

Function119940:
	ld de, wEmailAddress
	ld c, MOBILE_EMAIL_LENGTH
.asm_119945
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr z, .asm_119953
	and a
	jr nz, .asm_119945
	xor a
.asm_11994f
	ld [hli], a
	dec c
	jr nz, .asm_11994f

.asm_119953
	ret

LoginToPop3Service:
	ld a, $1c
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	ld hl, wc608
	ld de, wEmailAddress
.asm_119962
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .asm_119962
	call Function119ec2
	ld hl, wc608
	ld a, MOBILEAPI_0F
	jp Function119e2b

Function119973:
	ld a, $1
	ld [wcf64], a
	xor a
	ld [wcf65], a
	ld [w3_d090], a
	ld de, w3_d000
	ld a, MOBILEAPI_10
	jp Function119e2b

Function119987:
	ld hl, w3_d000 + 1
	ld a, [w3_d000]
	or [hl]
	jr z, .asm_1199a0
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	ld de, wBGPals2
	ld a, MOBILEAPI_11
	jp Function119e2b

.asm_1199a0
	ld a, [w3_d090]
	and a
	jr z, .asm_1199ae
	ld a, $16
	ld [wBattleTowerRoomMenuJumptableIndex], a
	jp Function119b0d

.asm_1199ae
	ld a, $1b
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

Function1199b4:
	ld a, [w3_d081 + 1]
	and a
	jr nz, .asm_1199c7
	ld a, [w3_d081]
	cp $7
	jr nc, .asm_1199c7
	call BattleTowerRoomMenu_IncrementJumptable
	jp Function1199ca

.asm_1199c7
	jp Function119ac9

Function1199ca:
	ld a, $20
	ld [wcd89], a
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	ld de, w3_d100
	ld bc, $0700
	ld a, MOBILEAPI_14
	jp Function119e2b

Function1199e2:
	farcall _Function1199e2

Function119b0d:
	ld a, $8
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu2
	ld a, [w3_d090]
	cp $1
	jr z, .asm_119b23
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	jr DeleteTradeEmail

.asm_119b23
	ld a, $10
	ld [wcd89], a
	ld a, [w3_d090 + 1]
	ld l, a
	ld a, [w3_d090 + 2]
	ld h, a
	ld de, w3_d100
	ld bc, $0700
	ld a, MOBILEAPI_12
	jp Function119e2b

DeleteTradeEmail:
	ld a, [w3_d090 + 1]
	ld l, a
	ld a, [w3_d090 + 2]
	ld h, a
	jr asm_119b4d

DeleteInvalidTradeEmail:
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a

asm_119b4d:
	ld a, MOBILEAPI_13
	jp Function119e2b

LogoutOfPop3Service:
	ld a, [w3_d090]
	cp $1
	jr nz, .asm_119b66
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, $4
	ld [s5_a800], a
	call CloseSRAM

.asm_119b66
	ld a, MOBILEAPI_0E
	jp Function119e2b

DecodeReceivedTradeCornerTrade:
	farcall _DecodeReceivedTradeCornerTrade

RemovedFunction9:
	ld hl, Text_BattleRoomVisitLimit;$6081
	call BattleTowerRoomMenu_SetMessage;Call_046_6ef1
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

RemovedFunction10:
	ld a, [$c31a];$c340
	and a
	ret nz

	ld a, $80
	ld [wcd50], a;$cd44
	call BattleTowerRoomMenu_IncrementJumptable;Call_046_635f

RemovedFunction11:
	ld hl, wcd50;$cd44
	dec [hl]
	ret nz

	ld a, $15
	ld [wcf66], a;$cf5a
	ret

BattleTowerRoomMenu_UberRestrictionMessage:
	ld hl, Text_UberRestriction
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable
	jr BattleTowerRoomMenu_WaitForMessage

BattleTowerRoomMenu_PartyMonTopsThisLevelMessage:
	ld hl, Text_PartyMonTopsThisLevel
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_WaitForMessage:
	ld a, [wc31a]
	and a
	ret nz
	ld a, $80
	ld [wcd50], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_DelayRestartMenu:
	; Loops while (--[wcd50] != 0),
	;   to create some sort of "delay" after the message is written on the screen,
	;   before starting the menu again.
	ld hl, wcd50
	dec [hl]
	ret nz
	ld a, $0
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

BattleTowerRoomMenu_QuitMessage:
	ld a, [wcd38]
	and a
	jr z, .asm_119cd1
	dec a
	jr z, .asm_119cd6
	ld hl, Text_QuitReadingNews
	jr .asm_119cd9

.asm_119cd1
	ld hl, Text_CancelBattleRoomChallenge
	jr .asm_119cd9

.asm_119cd6
	ld hl, Text_ExitGymLeaderHonorRoll

.asm_119cd9
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlaceYesNoMenu:
	ld a, [wc31a]
	and a
	ret nz
	ld a, $f
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_UpdateYesNoMenu:
	; Only ever called when [wBattleTowerRoomMenu2JumptableIndex] is $10
	call BattleTowerRoomMenu2
	ret c
	ld a, [wMobileInactivityTimerFrames]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

MenuHeader_119cf7:
MenuData_119cff:
	db MENU_BACKUP_TILES ; flags
	menu_coords 12, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

; this is the japanese version of the room number select menu
; the english version needs to be larger for the cancel option, so the data from above can just be reused
;MenuData_119cff:
;	db MENU_BACKUP_TILES ; flags
;	menu_coords 15, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
;	dw NULL
;	db 0 ; default option

String_119d07:
	db "   ▼@"

Strings_L10ToL100:
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db " L:50 @@"
	db " L:60 @@"
	db " L:70 @@"
	db " L:80 @@"
	db " L:90 @@"
	db " L:100@@"
	db "ESCI@@"

Strings_Ll0ToL40:
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db "ESCI@@"

BattleTowerCancelString:
	db "ESCI@"

; to clear the cancel text, japanese version does not require this
String_blank:
	db "      @"

BattleTower_LevelCheck:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPartyMons)
	ldh [rSVBK], a
	ld a, [wcd4f]
	ld c, 10
	call SimpleMultiply
	ld hl, wcd50
	ld [hl], a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartyMon1Level
	ld a, [wPartyCount]
.party_loop
	push af
	ld a, [de]
	push hl
	push de
	pop hl
	add hl, bc
	push hl
	pop de
	pop hl
	cp [hl]
	jr z, .equal
	jr nc, .exceeds
.equal
	pop af
	dec a
	jr nz, .party_loop
	pop af
	ldh [rSVBK], a
	and a
	ret

.exceeds
	pop af
	ld a, 36 ;BattleTowerRoomMenu_PartyMonTopsThisLevelMessage;$4
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ldh [rSVBK], a
	scf
	ret

BattleTower_UbersCheck:
	ldh a, [rSVBK]
	push af
	ld a, [wcd4f]
	cp 70 / 10
	jr nc, .level_70_or_more
	ld a, BANK(wPartyMons)
	ldh [rSVBK], a
	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartySpecies
	ld a, [wPartyCount]
.loop
	push af
	ld a, [de]
	cp MEWTWO
	jr z, .uber
	cp MEW
	jr z, .uber
	cp LUGIA
	jr c, .next
	cp NUM_POKEMON + 1
	jr nc, .next
.uber
	ld a, [hl]
	cp 70
	jr c, .uber_under_70
.next
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
.level_70_or_more
	pop af
	ldh [rSVBK], a
	and a
	ret

.uber_under_70
	pop af
	ld a, [de]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wcd49
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld a, 42 ;BattleTowerRoomMenu_UberRestrictionMessage;$a
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ldh [rSVBK], a
	scf
	ret

; seems to be for interacting with the mobile adapter
Function119e2b:
	call MobileAPI

BattleTowerRoomMenu_IncrementJumptable:
	ld hl, wBattleTowerRoomMenuJumptableIndex
	inc [hl]
	ret

Function119eb4:
	xor a
	ld [wc3cc], a
	ld de, wc3ac
.loop
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .loop
	ret

Function119ec2:
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPassword + MOBILE_LOGIN_PASSWORD_LENGTH], a
	ld de, sMobileLoginPassword + 1
.loop
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .loop
	call CloseSRAM
	ret

BattleTowerRoomMenu2:
	ldh a, [rSVBK]
	ld [wcd8c], a
	ld a, $1
	ldh [rSVBK], a

	call .RunJumptable

	ld a, [wcd8c]
	ldh [rSVBK], a
	ld a, $1
	ldh [hBGMapMode], a
	ret

.RunJumptable:
	jumptable .Jumptable, wBattleTowerRoomMenu2JumptableIndex

.Jumptable:
	dw Function119f3f
	dw Function119f45
	dw Function119f56
	dw Function119f76
	dw Function119f98
	dw Function11a113
	dw Function11a129
	dw Function11a131
	dw Function11a13d
	dw Function11a14b
	dw Function11a16d
	dw Function11a192
	dw Function11a2e6
	dw Function11a302
	dw Function11a33a
	dw BattleTowerRoomMenu2_PlaceYesNoMenu
	dw BattleTowerRoomMenu2_UpdateYesNoMenu
	dw Function11a357
	dw Function11a36b
	dw Function11a38d
	dw Function11a3c5
	dw Function11a3d9
	dw Function11a3f9
	dw Function11a41b
	dw Function11a452
	dw Function11a47a
	dw Function11a488
	dw Function11a49e
	dw Function11a4db
	dw Function11a4e8
	dw Function11a4fe
	dw Function11a466
	dw Function11a47a

Function119f3f:
	call Function11a5b9
	jp BattleTowerRoomMenu2_IncrementJumptable

Function119f45:
	hlcoord 4, 2
	ld de, String_11a661
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function119f56:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_119f62
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_119f62
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6aa
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function119f76:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_119f82
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_119f82
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a679
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function119f98:
	farcall _Function119f98

Function11a113:
	call Function11a63c
	ld c, $1
	farcall Function115e18
	hlcoord 4, 2
	ld de, String_11a6c8
	call PlaceString
	and a
	ret

Function11a129:
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a131:
	ld hl, wMobileInactivityTimerMinutes
	dec [hl]
	ret nz
	ld a, [wBattleTowerRoomMenu2JumptableIndex]
	inc a
	ld [wBattleTowerRoomMenu2JumptableIndex], a

Function11a13d:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	and a
	ret

Function11a14b:
	ld hl, wcd85
	ld a, [hl]
	cp $f3
	jr nz, .asm_11a155
	and a
	ret

.asm_11a155
	call Function11a1d6
	ret c
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6f1
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a16d:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a179
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a179
	call Function11a63c
	call Function11a1e6
	hlcoord 4, 2
	ld de, wc346
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a192:
	call Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a1b6
	call ExitMenu
	farcall ReloadMapPart
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	and a
	ret

.asm_11a1b6
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerSeconds]
	ld [wcf66], a
	ld [wcd80], a
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	scf
	ret

Function11a1d6:
	ld a, [wcd85]
	cp $50
	jr nz, .asm_11a1e4
	ld a, $d3
	call SetMobileErrorCode
	scf
	ret

.asm_11a1e4
	and a
	ret

Function11a1e6:
	ld hl, String_11a706
	ld de, wc346
	call Function11a1ff
	ld hl, wcd85
	call Function11a1ff
	farcall WriteCurrencyName ; Copies the currency string at the end of the current string pointed by address stored into DE.
	ld a, $50
	ld [de], a
	ret

Function11a1ff:
.asm_11a1ff
	ld a, [hli]
	cp $50
	ret z
	ld [de], a
	inc de
	jr .asm_11a1ff

BattleTowerRoomMenu2_PlaceYesNoMenu:
	ld hl, MenuHeader_11a2de
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 17, 8
	ld de, String_11a2cf
	call PlaceString
	hlcoord 17, 10
	ld de, String_11a2d3
	call PlaceString
	hlcoord 16, 8
	ld a, $ed
	ld [hl], a
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

BattleTowerRoomMenu2_UpdateYesNoMenu:
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON
	jr nz, .a_button
	ld a, [hl]
	and B_BUTTON
	jr nz, .b_button
	ld a, [hl]
	and D_UP
	jr nz, .d_up
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
.asm_11a24c
	call Function11a9f0
	scf
	ret

.d_up
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a24c
	xor a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 16, 8
	ld a, $ed
	ld [hl], a
	hlcoord 16, 10
	ld a, $7f
	ld [hl], a
	jr .asm_11a24c

.d_down
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a24c
	inc a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 16, 8
	ld a, $7f
	ld [hl], a
	hlcoord 16, 10
	ld a, $ed
	ld [hl], a
	jr .asm_11a24c

.a_button
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .exit_no_carry
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerFrames]
	cp $0
	jr z, .asm_11a2b4
	ld a, [wcd47]
	jr .exit_carry

.asm_11a2b4
	ld a, [wcd33]

.exit_carry
	ld [wcf66], a
	ld a, $a
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

.b_button
	call PlayClickSFX

.exit_no_carry
	call ExitMenu
	farcall ReloadMapPart
	and a
	ret

String_11a2cf:
	db "SÌ@"

String_11a2d3:
	db "NO@"

MenuHeader_11a2d6: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 15, 6, SCREEN_WIDTH - 1, 10
	dw NULL
	db 0 ; default option

MenuHeader_11a2de:
	db MENU_BACKUP_TILES ; flags
	menu_coords 15, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

Function11a2e6:
	call Function11a63c
	ld c, $2
	farcall Function115e18
	hlcoord 4, 2
	ld de, String_11a71e
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a302:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a30e
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a30e
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a72a
	call PlaceString
	hlcoord 4, 4;9, 4
	ld de, wcd68
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	hlcoord 12, 4;14, 4
	ld de, wcd67
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a33a:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a346
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a346
	call ExitMenu
	farcall ReloadMapPart
	farcall Function115dc3
	and a
	ret

Function11a357:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a743
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a36b:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a377
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a377
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a755
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a38d:
	call Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a3b1
	call ExitMenu
	farcall ReloadMapPart
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	and a
	ret

.asm_11a3b1
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerSeconds]
	ld [wcf66], a
	ld [wcd80], a
	scf
	ret

Function11a3c5:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a762
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a3d9:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a3e5
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a3e5
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a779
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a3f9:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a405
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a405
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a755
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a41b:
	call Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a43f
	call ExitMenu
	farcall ReloadMapPart
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	and a
	ret

.asm_11a43f
	call ExitMenu
	farcall ReloadMapPart
	ld a, $1c
	ld [wcf66], a
	ld [wcd80], a
	scf
	ret

Function11a452:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a791
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a466:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a7c1
	call PlaceString
	ld a, $80
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a47a:
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a486
	dec a
	ld [wMobileInactivityTimerMinutes], a
	scf
	ret

.asm_11a486
	and a
	ret

Function11a488:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a7ac
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a49e:
	call Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a4c7
	call ExitMenu
	farcall ReloadMapPart
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	ld a, $14
	ld [wcf66], a
	and a
	ret

.asm_11a4c7
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerFrames]
	ld [wcf66], a
	ld [wcd80], a
	scf
	ret

Function11a4db:
	call Function11a63c
	ld de, String_11a6db
	hlcoord 4, 2
	call PlaceString
	ret

Function11a4e8:
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a7d7
	call PlaceString
	call Function11a5f5
	xor a
	ld [wMobileInactivityTimerMinutes], a
	jp BattleTowerRoomMenu2_IncrementJumptable

Function11a4fe:
	call Function11a536
	ret c
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a522
	call ExitMenu
	farcall ReloadMapPart
	call Function11a63c
	hlcoord 4, 2
	ld de, String_11a6d2
	call PlaceString
	and a
	ret

.asm_11a522
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerSeconds]
	ld [wcf66], a
	ld [wcd80], a
	scf
	ret

Function11a536:
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON
	jr nz, .asm_11a5a7
	ld a, [hl]
	and B_BUTTON
	jr nz, .asm_11a5a2
	ld a, [hl]
	and D_UP
	jr nz, .asm_11a564
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_11a583
.asm_11a54d
	ld a, [wBattleTowerRoomMenu2JumptableIndex]
	cp $4
	jr z, .asm_11a562
	call Function11a9f0
	jr nz, .asm_11a562
	call ExitMenu
	farcall ReloadMapPart

.asm_11a562
	scf
	ret

.asm_11a564
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a54d
	xor a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 16, 7
	ld a, $ed
	ld [hl], a
	hlcoord 16, 9
	ld a, $7f
	ld [hl], a
	jr .asm_11a54d

.asm_11a583
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a54d
	inc a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 16, 7
	ld a, $7f
	ld [hl], a
	hlcoord 16, 9
	ld a, $ed
	ld [hl], a
	jr .asm_11a54d

.asm_11a5a2
	ld a, $1
	ld [wMobileInactivityTimerMinutes], a

.asm_11a5a7
	xor a
	ld [wcd8a], a
	ld [wcd8b], a
	and a
	ret

BattleTowerRoomMenu2_IncrementJumptable:
	ld a, [wBattleTowerRoomMenu2JumptableIndex]
	inc a
	ld [wBattleTowerRoomMenu2JumptableIndex], a
	scf
	ret

Function11a5b9:
	xor a
	ld [wMenuBorderLeftCoord], a
	ld [wMenuBorderTopCoord], a
	ld a, $13
	ld [wMenuBorderRightCoord], a
	ld a, $5
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	hlcoord 0, 0, wAttrmap
	ld b, $6
	ld c, $14
	hlcoord 0, 0
	ld b, $4
	ld c, $12
	call Function3eea
	farcall ReloadMapPart
	call UpdateSprites
	ld c, $0
	farcall Function115e18
	ld a, $1
	ld [wc305], a
	ret

Function11a5f5:
	ld a, $f
	ld [wMenuBorderLeftCoord], a
	ld a, $13
	ld [wMenuBorderRightCoord], a
	ld a, $6
	ld [wMenuBorderTopCoord], a
	ld a, $a
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	hlcoord 15, 6, wAttrmap
	ld b, $5
	ld c, $6
	hlcoord 15, 6
	ld b, $3
	ld c, $3
	call Function3eea
	hlcoord 17, 7
	ld de, String_11a2cf
	call PlaceString
	hlcoord 17, 9
	ld de, String_11a2d3
	call PlaceString
	hlcoord 16, 7
	ld a, $ed
	ld [hl], a
	farcall ReloadMapPart
	ret

Function11a63c:
	hlcoord 4, 1
	ld de, String_11a7f4
	call PlaceString
	hlcoord 4, 2
	ld de, String_11a7f4
	call PlaceString
	hlcoord 4, 3
	ld de, String_11a7f4
	call PlaceString
	hlcoord 4, 4
	ld de, String_11a7f4
	call PlaceString
	ret

String_11a661:
	db   "Chiamata al"
	next "CENTRO MOBILE…@"

String_11a679:
	db   "L'ADATTATORE"
	next "MOB. è pronto?@"

String_11a692:
	db   "Attendere,"
	next "prego…@"

String_11a6aa:
	db   "Previsti costi"
	next "aggiuntivi.@"

String_11a6c8:
	db   "Connesso.@";"せつぞく　しました@"

String_11a6d2:
	db   "Comunicazione…@";"つうしん　ちゅう@"

String_11a6db:
	db   "Comunicazione";"つうしん　ちゅう"
	next "annullato.@";"セレクト　エーでちゅうし@"

String_11a6f1:
	db   "Questo servizio";"この　サービスには"
	next "è a pagamento.@";"つうわりょう<NO>ほかに@"

String_11a706:
	db   "Prezza:@";"おかね<GA>@"

String_11a71e:
	db   "Comunicazione";"つうしん　しゅうりょう@" ; ???
	next "interrotta.@"

String_11a72a:
	db   "DURATA TEL.";"つないだ　じかん"
	next "   min.    sec.@"

String_11a743:
	db   "Non ci sono";"もっていない　データが"
	next "dati salvati!@";"あります！@"
	
String_11a755:
	db   "Leggere i";"データ<WO>よみこみますか？@"
	next "dati?@"
	
String_11a762:
	db   "Leggere gli";"おなじ　データ<WO>よみこんだ"
	next "stessi dati.@";"こと<GA>ありますが@"
	
String_11a779:
	db   "I dati sono";"そのデータ<WA>なくなっているか"
	next "corrotti.@";"こわれて　います@"
	
String_11a791:
	db   "Dati già";"もっている　データと"
	next "presenti!@";"おなじデータしか　ありません！@"
	
String_11a7ac:
	db   "Stop lettura";"データの よみこみを"
	next "dati?@";"ちゅうし しますか？""

String_11a7c1:
	db   "Non ci sono"
	next "altre NOTIZIE.@"

String_11a7d7:
	db   "Ricevere le"
	next "ultime NOTIZIE?@"

String_11a7f4:
	db   "　　　　　　　　　　　　　　　@"

MenuHeader_11a804: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, SCREEN_WIDTH - 1, 5
	dw NULL
	db 0 ; default option
	
Function11a88c:
	ld a, [bc]
	sla a
	ld c, a
	xor a
	ld b, a
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ret

Function11a80c:
	ld de, hDivisor
	ld bc, hDividend
	ld hl, Unknown_11a89a
	call Function11a88c
	ld bc, hQuotient + 1
	ld hl, Unknown_11a8ba
	call Function11a88c
	ld bc, hPrintNumBuffer + 2
	ld hl, Unknown_11a8da
	call Function11a88c
	xor a
	ld b, a
	ldh a, [hDivisor]
	and $f
	ld e, a
	ldh a, [hPrintNumBuffer + 6]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 8]
	and $f
	call Function11a884
	ld [wcd62], a
	ld e, b
	xor a
	ld b, a
	ldh a, [hDivisor]
	and $f0
	swap a
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 6]
	and $f0
	swap a
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 8]
	and $f0
	swap a
	call Function11a884
	ld [wcd63], a
	ld e, b
	xor a
	ld b, a
	ldh a, [hMathBuffer]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 7]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 9]
	and $f
	call Function11a884
	ld [wcd64], a
	ret

Function11a884:
	add e
	cp $a
	ret c
	sub $a
	inc b
	ret

Unknown_11a89a:
for x, 16
	bcd x % 100, x / 100
endr

Unknown_11a8ba:
for x, 0, 16**2, 16
	bcd x % 100, x / 100
endr

Unknown_11a8da:
for x, 0, 16**3, 16**2
	bcd x % 100, x / 100
endr

BattleTowerRoomMenu_SetMessage:
	ld a, l
	ld [wc31b], a
	ld a, h
	ld [wc31c], a
	ld a, $1
	ld [wc31a], a
	ret

Function11a9ce:
	call ClearBGPalettes
	call ReloadTilesetAndPalettes
	call Call_ExitMenu
	farcall Stubbed_Function106462
	farcall Function106464
	call GSReloadPalettes
	farcall FinishExitMenu
	call UpdateSprites
	ret

Function11a9f0:
	ld a, $1
	and a
	ret

Function11a9f4: ; unreferenced
	ld a, [wcd8a]
	ld l, a
	ld a, [wcd8b]
	ld h, a
	inc hl
	ld a, l
	ld [wcd8a], a
	ld a, h
	ld [wcd8b], a
	ld de, $d5d0
	add hl, de
	bit 7, h
	ret nz
	ld a, $d6
	call SetMobileErrorCode
	and a
	ret

Text_SaveFileWillBeSent:
	text "Il SALVATAGGIO"
	line "verrà inviato."
	done

Text_SentSaveFileReadingNews:
	text "SALVAT. inviato."
	line "Lettura NOTIZIE…"
	done

Text_ReadingNews:
	text "Lettura NOTIZIE…"
	done

Text_ReceivedNews:
	text "NOTIZIE ricevute!"
	done

Text_QuitReadingNews:
	text "Smetti di leggere"
	line "le NOTIZIE?"
	done

Text_CanceledSendingSaveFile: ; unreferenced
	text "Invio SALVATAGGIO"
	line "annullato."
	done

Text_ReceivedOddEgg: ; unreferenced
	text "Ricevuto"
	line "UOVO STRANO!"
	done

Text_RegisteringRecord:
	text "Registrazione"
	line "record…"
	done

Text_BattleRoomVisitLimit: ; unreferenced
	text "Puoi entrare una"
	line "sola volta al"

	para "giorno nella"
	line "stessa SALA LOTTA."
	done

Text_PartyMonTopsThisLevel:
	text "Uno o più #MON"
	line "in squadra"
	cont "superano il"
	cont "livello massimo."
	done

Text_UberRestriction:
	text_ram wcd49
	text " può"
	line "solo entrare in"

	para "SALE LOTTA di"
	line "Liv.70 o maggiore."
	done

Text_CancelBattleRoomChallenge:
	text "Annulli la sfida"
	line "nella SALA LOTTA?"
	done

Text_ExitGymLeaderHonorRoll:
	text "Esci dall'ALBO"
	line "D'ORO dei"
	cont "CAPOPALESTRA?"
	done

Text_LinkingWithCenter: ; unreferenced
	text "Collegamento con"
	line "il CENTRO…"
	done

Text_WhatLevelDoYouWantToChallenge:
	text "I #MON di quale"
	line "livello vuoi"
	cont "sfidare?"
	done

Text_CheckBattleRoomListByMaxLevel:
	text "Vuoi vedere la"
	line "lista delle SALE"

	para "LOTTA partendo"
	line "dal livello più"
	cont "alto?"
	done

Text_EnterWhichBattleRoom: ; unreferenced
	text "In quale SALA"
	line "LOTTA vuoi"
	cont "entrare?"
	done

Text_WhichBattleRoom: ; unreferenced
	text "Quale SALA LOTTA?"
	done

Text_ThisBattleRoomPleaseWait:
	text "La SALA@"
	text_ram wStringBuffer4
	text_start
	line "di @"
	text_ram wStringBuffer3
	text "?"
	cont "Attendere, prego…"
	done

Function11ac3e:
	call SpeechTextbox
	call FadeToMenu
	callfar ClearSpriteAnims2
	call Function11ac51
	call CloseSubmenu
	ret

Function11ac51:
	xor a
	ldh [hBGMapMode], a
	ld hl, wOptions
	ld a, [hl]
	push af
	set 4, [hl]
	ld a, [wVramState]
	push af
	xor a
	ld [wVramState], a
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	xor a
	ldh [hMapAnims], a
	ld [wcd49], a
	ld [wcd4a], a
	ld [wcd4c], a
	ld [wcd4d], a
	ld [wcd4e], a
	call Function11ad1b
	call DelayFrame
.loop
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .asm_11aca8
	call Function11b314
	farcall Function11acb7
	call Function11ad6e
	ld a, 30 * SPRITEOAMSTRUCT_LENGTH
	ld [wCurSpriteOAMAddr], a
	farcall DoNextFrameForAllSprites
	farcall ReloadMapPart
	jr .loop

.asm_11aca8
	call ClearSprites
	pop af
	ldh [hInMenu], a
	pop af
	ld [wVramState], a
	pop af
	ld [wOptions], a
	ret

Function11ad1b:
	call ClearBGPalettes
	call ClearSprites
	call ClearTilemap
	farcall Function17c000
	ld a, [wMenuCursorY]
	ld [wcd82], a
	dec a
	ldh [hObjectStructIndex], a
	ld a, $10
	ld [wCurIconTile], a
	ld hl, LoadMenuMonIcon
	ld a, BANK(LoadMenuMonIcon)
	ld e, MONICON_MOBILE1
	rst FarCall
	ld hl, LoadMenuMonIcon
	ld a, BANK(LoadMenuMonIcon)
	ld e, MONICON_MOBILE2
	rst FarCall
	ld hl, wPokedexOrder
	ld bc, $0115
	xor a
	call ByteFill
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	ld [wcd30], a
	ld a, DEXMODE_ABC
	ld [wCurDexMode], a
	farcall Pokedex_OrderMonsByMode
	ret

Function11ad6e:
	ld a, [wJumptableIndex]
	ld hl, Jumptable_11ad78
	call Function11b239
	jp hl

Jumptable_11ad78:
	dw Function11b082
	dw Function11b0ff
	dw Function11ad95
	dw Function11adc4
	dw Function11ae4e
	dw Function11ae98
	dw Function11ad8f
	dw Function11af04
	dw Function11af4e

MobileIncJumptableIndex:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Function11ad8f:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

Function11ad95:
	ld hl, MenuHeader_11ae38
	call LoadMenuHeader
	call MenuBox
	hlcoord 9, 12 ;12, 12
	ld de, String_11ae40
	call PlaceString
	hlcoord 7, 10, wAttrmap ;10, 10, wAttrmap
	lb bc, 8, 12 ;8
	call Function11afd6
	farcall ReloadMapPart
	call MobileIncJumptableIndex
	ld a, $1
	ld [wMenuCursorY], a
	ld hl, Unknown_11afcc
	call Function11afb7

Function11adc4:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and D_UP
	jr nz, .asm_11ade6
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_11aded
	ld a, [hl]
	and A_BUTTON
	jr nz, .asm_11ae06
	ld a, [hl]
	and B_BUTTON
	ret z
	call PlayClickSFX
	xor a
	ld [wJumptableIndex], a
	jr .asm_11ae2e

.asm_11ade6
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11adf4

.asm_11aded
	ld a, [wMenuCursorY]
	inc a
	cp $4
	ret z

.asm_11adf4
	push af
	ld hl, Unknown_11afcc
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afcc
	call Function11afb7
	ret

.asm_11ae06
	call PlayClickSFX
	ld a, [wMenuCursorY]
	dec a
	ld hl, wcd30
	ld [hl], a
	and a
	jr z, .asm_11ae28
	hlcoord 6, 4 ; 2, 14 ; Changed from 7, 4 ; Gender symbol location on Mobile Trade screen
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11ae23
	call Function11b272
	jr .asm_11ae2b

.asm_11ae23
	call Function11b267
	jr .asm_11ae2b

.asm_11ae28
	ld a, $3
	ld [hl], a

.asm_11ae2b
	call MobileIncJumptableIndex

.asm_11ae2e
	call ExitMenu
	farcall ReloadMapPart
	ret

MenuHeader_11ae38:
	db MENU_BACKUP_TILES ; flags
	menu_coords  7, 10, 18, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

String_11ae40:
	db   "QUALSIASI"
	next "♂MASCHIO" ; male
	next "♀FEMMINA" ; female
	db   "@"

Function11ae4e:
	ld hl, MenuHeader_11afe8
	call LoadMenuHeader
	call MenuBox
	hlcoord 7, 14 ;10, 14
	ld de, String_11aff0
	call PlaceString
	ld hl, MenuHeader_11b013
	call LoadMenuHeader
	call MenuBox
	hlcoord 17, 8
	ld de, String_11b01b
	call PlaceString
	hlcoord 14, 7, wAttrmap
	lb bc, 5, 6
	call Function11afd6
	hlcoord 6, 12, wAttrmap ;9, 12, wAttrmap
	lb bc, 6, 14 ;11
	call Function11afd6
	farcall ReloadMapPart
	call MobileIncJumptableIndex
	ld a, $1
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7

Function11ae98:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and D_UP
	jr nz, .asm_11aec1
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_11aec8
	ld a, [hl]
	and A_BUTTON
	jr nz, .asm_11aee1
	ld a, [hl]
	and B_BUTTON
	ret z
	call PlayClickSFX
.asm_11aeb4
	hlcoord 6, 4 ;2, 14 ; Changed from 7, 4 ; Gender symbol location on Mobile Trade screen
	ld a, $7f
	ld [hl], a
	ld a, $1
	ld [wJumptableIndex], a
	jr .asm_11aef7

.asm_11aec1
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11aecf

.asm_11aec8
	ld a, [wMenuCursorY]
	inc a
	cp $3
	ret z

.asm_11aecf
	push af
	ld hl, Unknown_11afd2
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7
	ret

.asm_11aee1
	call PlayClickSFX
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11aeb4
	ld a, [wcd4b]
	ld [wScriptVar], a
	call Function11b022
	call MobileIncJumptableIndex

.asm_11aef7
	call ExitMenu
	call ExitMenu
	farcall ReloadMapPart
	ret

Function11af04:
	ld hl, MenuHeader_11afe8
	call LoadMenuHeader
	call MenuBox
	hlcoord 7, 14 ;10, 14
	ld de, String_11b003
	call PlaceString
	ld hl, MenuHeader_11b013
	call LoadMenuHeader
	call MenuBox
	hlcoord 17, 8
	ld de, String_11b01b
	call PlaceString
	hlcoord 14, 7, wAttrmap
	lb bc, 5, 6
	call Function11afd6
	hlcoord 6, 12, wAttrmap ;9, 12, wAttrmap
	lb bc, 6, 14 ;11
	call Function11afd6
	farcall ReloadMapPart
	call MobileIncJumptableIndex
	ld a, $2
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7

Function11af4e:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and D_UP
	jr nz, .asm_11af77
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_11af7e
	ld a, [hl]
	and A_BUTTON
	jr nz, .asm_11af97
	ld a, [hl]
	and B_BUTTON
	ret z
	call PlayClickSFX
.asm_11af6a
	hlcoord 6, 4 ;2, 14 ; Changed from 7, 4 ; Gender symbol location on Mobile Trade screen
	ld a, $7f
	ld [hl], a
	ld a, $1
	ld [wJumptableIndex], a
	jr .asm_11afaa

.asm_11af77
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11af85

.asm_11af7e
	ld a, [wMenuCursorY]
	inc a
	cp $3
	ret z

.asm_11af85
	push af
	ld hl, Unknown_11afd2
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7
	ret

.asm_11af97
	call PlayClickSFX
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11af6a
	ld a, $6
	ld [wJumptableIndex], a
	xor a
	ld [wScriptVar], a

.asm_11afaa
	call ExitMenu
	call ExitMenu
	farcall ReloadMapPart
	ret

Function11afb7:
	ld e, $ed
	jr asm_11afbd

Function11afbb:
	ld e, $7f

asm_11afbd:
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, e
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld [de], a
	ret

Unknown_11afcc:
	dwcoord 8, 12 ;11, 12
	dwcoord 8, 14 ;11, 14
	dwcoord 8, 16 ;11, 16

Unknown_11afd2:
	dwcoord 16,  8
	dwcoord 16, 10

Function11afd6:
	ld de, SCREEN_WIDTH
	ld a, $3
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .row
	ret

MenuHeader_11afe8:
	db MENU_BACKUP_TILES ; flags
	menu_coords 6, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

String_11aff0:
	db   "Va bene?@"
	;next ""

String_11b003:
	db   "Annullare lo"
	next "scambio?@"

MenuHeader_11b013:
	db MENU_BACKUP_TILES ; flags
	menu_coords 15, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 1 ; default option

String_11b01b:
	db "SÌ"
	next "NO@"

Function11b022:
	ld a, [wcd2e]
	and a
	jr z, .asm_11b02e
	ld hl, wStringBuffer3
	call Function11b03d

.asm_11b02e
	ld a, [wcd30]
	and a
	ret z
	cp $3
	ret z
	ld hl, wStringBuffer4
	call Function11b03d
	ret

Function11b03d:
	push af
	ld c, $1
.loop
	ld a, [hli]
	cp "♂"
	jr z, .done
	cp "♀"
	jr z, .done
	cp "@"
	jr z, .done
	inc c
	jr .loop

.done
	dec hl
	ld e, l
	ld d, h
	pop af
	dec a
	ld hl, .FemaleString
	jr nz, .got_string
	ld hl, .MaleString
.got_string
	ld bc, 2 ; string length
	jp CopyBytes

.MaleString: db "♂@"
.FemaleString: db "♀@"

Function11b082:
	call Function11b242
	ld a, $4 ;7 menu height
	ld [wc7d3], a
	call Function11b099
	call Function11b295
	call Function11b275
	call SetPalettes
	jp MobileIncJumptableIndex

Function11b099:
	ld c, $B ;6 menu width
	hlcoord 7, 7;11, 1
	ld a, [wc7d3]
	add a
	ld b, a
	xor a
	call Function11b236
	ld a, [wc7d0]
	ld e, a
	ld d, 0
	ld hl, wPokedexOrder
	add hl, de
	ld e, l
	ld d, h
	hlcoord 7, 8;11, 2
	ld a, [wc7d3]
.loop
	push af
	ld a, [de]
	ld [wTempSpecies], a
	push de
	push hl
	call .PlaceMonNameOrPlaceholderString
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

.PlaceMonNameOrPlaceholderString:
	and a
	ret z

	call .CheckSeenFlag
	ret c

	call .SetCaughtFlag
	push hl
	call GetPokemonName
	pop hl
	call PlaceString
	ret

.SetCaughtFlag:
	call CheckCaughtMemMon
	jr nz, .okay
	inc hl
	ret

.okay
	ld a, $1
	ld [hli], a
	ret

.CheckSeenFlag:
	call CheckSeenMemMon
	ret nz

	inc hl
	ld de, .EmptySlot
	call PlaceString
	scf
	ret

.EmptySlot:
	db "ーーーーー@"

Function11b0ff:
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .asm_11b141
	ld a, [hl]
	and A_BUTTON
	jr nz, .asm_11b131
	call Function11b175
	jr nc, .asm_11b125
	ld a, [wcd4c]
	inc a
	and $3
	ld [wcd4c], a
	xor a
	ldh [hBGMapMode], a
	call Function11b099
	ld a, $1
	ldh [hBGMapMode], a
	ret

.asm_11b125
	ld a, [wcd4c]
	and a
	ret z
	inc a
	and $3
	ld [wcd4c], a
	ret

.asm_11b131
	call Function11b20b
	call CheckSeenMemMon
	jr z, .asm_11b13d
	ld a, $1
	jr .asm_11b148

.asm_11b13d
	ld a, $2
	jr .asm_11b148

.asm_11b141
	ld hl, wJumptableIndex
	ld a, $7
	ld [hl], a
	ret

.asm_11b148
	call PlayClickSFX
	ld [wcd4b], a
	and a
	jr z, .asm_11b16c
	ld a, [wcf65]
	cp $0
	jr z, .asm_11b163
	cp $fe
	jr z, .asm_11b167
	cp $ff
	jr z, .asm_11b16b
	jp MobileIncJumptableIndex

.asm_11b163
	ld a, $1
	jr .asm_11b16c

.asm_11b167
	ld a, $2
	jr .asm_11b16c

.asm_11b16b
	xor a

.asm_11b16c
	ld [wcd30], a
	ld a, $4
	ld [wJumptableIndex], a
	ret

Function11b175:
	ld a, [wc7d3]
	ld d, a
	ld a, [wc7d2]
	ld e, a
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .asm_11b19a
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_11b1ae
	ld a, d
	cp e
	jr nc, .asm_11b1ed
	ld a, [hl]
	and D_LEFT
	jr nz, .asm_11b1c6
	ld a, [hl]
	and D_RIGHT
	jr nz, .asm_11b1d8
	jr .asm_11b1ed

.asm_11b19a
	ld hl, wc7d1
	ld a, [hl]
	and a
	jr z, .asm_11b1a4
	dec [hl]
	jr .asm_11b1ef

.asm_11b1a4
	ld hl, wc7d0
	ld a, [hl]
	and a
	jr z, .asm_11b1ed
	dec [hl]
	jr .asm_11b1ef

.asm_11b1ae
	ld hl, wc7d1
	ld a, [hl]
	inc a
	cp e
	jr nc, .asm_11b1ed
	cp d
	jr nc, .asm_11b1bc
	inc [hl]
	jr .asm_11b1ef

.asm_11b1bc
	ld hl, wc7d0
	add [hl]
	cp e
	jr nc, .asm_11b1ed
	inc [hl]
	jr .asm_11b1ef

.asm_11b1c6
	ld hl, wc7d0
	ld a, [hl]
	and a
	jr z, .asm_11b1ed
	cp d
	jr nc, .asm_11b1d4
	xor a
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1d4
	sub d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1d8
	ld hl, wc7d0
	ld a, d
	add a
	add [hl]
	jr c, .asm_11b1e3
	cp e
	jr c, .asm_11b1e8

.asm_11b1e3
	ld a, e
	sub d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1e8
	ld a, [hl]
	add d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1ed
	and a
	ret

.asm_11b1ef
	call Function11b295
	call Function11b275
	scf
	ret

FillScreenWithTile32: ; unreferenced
	hlcoord 0, 0
	ld a, $32
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	ret

CopyDataUntilFF: ; unreferenced
.loop
	ld a, [de]
	cp $ff
	ret z
	inc de
	ld [hli], a
	jr .loop

Function11b20b:
	ld a, [wc7d1]
	ld hl, wc7d0
	add [hl]
	ld e, a
	ld d, 0
	ld hl, wc6d0
	add hl, de
	ld a, [hl]
	ld [wTempSpecies], a
	ret

CheckCaughtMemMon:
	push de
	push hl
	ld a, [wTempSpecies]
	dec a
	call CheckCaughtMon
	pop hl
	pop de
	ret

CheckSeenMemMon:
	push de
	push hl
	ld a, [wTempSpecies]
	dec a
	call CheckSeenMon
	pop hl
	pop de
	ret

Function11b236:
	jp FillBoxWithByte

Function11b239:
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Function11b242: ; pokemon to trade
	hlcoord 8, 2 ;3, 4
	ld de, wStringBuffer3
	call PlaceString
	xor a
	ld [wMonType], a
	farcall GetGender
	hlcoord 6, 2 ; 1, 4 ; Changed from 7, 2
	ld a, [wCurPartySpecies]
	ld bc, wcd2f
	ld [bc], a
	dec bc
	jr c, asm_11b26a
	jr z, asm_11b26f
	ld a, $1
	ld [bc], a

Function11b267:
	ld [hl], $ef
	ret

asm_11b26a:
	xor a
	ld [bc], a
	ld [hl], $7f
	ret

asm_11b26f:
	ld a, $2
	ld [bc], a

Function11b272:
	ld [hl], $f5
	ret

Function11b275:
	call Function11b279
	ret

Function11b279:
	ld a, [wTempSpecies]
	ld [wCurSpecies], a
	call CheckSeenMemMon
	jr z, .asm_11b28f
	call GetBaseData
	ld a, [wBaseGender]
	ld [wcf65], a
	jr .asm_11b294

.asm_11b28f
	ld a, $ff
	ld [wcf65], a

.asm_11b294
	ret

Function11b295: ; pokemon to receive
	;hlcoord 8, 3 ;4, 13
	;ld de, String_11b308
	;call PlaceString
	hlcoord 8, 4 ;4, 14
	ld de, String_11b308
	call PlaceString
	call Function11b20b
	call CheckSeenMemMon
	jr z, .asm_11b2d1
	ld a, [wc608]
	ld c, a
	ld a, [wc608 + 1]
	ld b, a
	ld hl, $0007
	add hl, bc
	xor a
	ld [hl], a
	ld hl, $0003
	add hl, bc
	ld e, [hl]
	farcall FlyFunction_GetMonIcon
	hlcoord 8, 4 ;4, 14
	push hl
	call GetPokemonName
	jr .asm_11b2e7

.asm_11b2d1
	ld a, [wc608]
	ld c, a
	ld a, [wc608 + 1]
	ld b, a
	ld hl, $0007
	add hl, bc
	ld a, $60 ;$50 move pokemon icon off screen
	ld [hl], a
	hlcoord 8, 4 ;4, 13
	push hl
	ld de, String_11b30e

.asm_11b2e7
	ld a, MON_NAME_LENGTH ;6 crash fix
	ld bc, wStringBuffer4
.asm_11b2ec
	push af
	ld a, [de]
	ld [bc], a
	inc de
	inc bc
	pop af
	dec a
	and a
	jr nz, .asm_11b2ec
	pop hl
	ld de, wStringBuffer4
	call PlaceString
	ret

; bank space, these are unused anyway
;String_11b2fe: ; unreferenced
;	db "あげる#@"

;String_11b303: ; unreferenced
;	db "ほしい#@"

String_11b308:
	db "　　　　　　　　　　@"

String_11b30e:
	db "?????@" ;"みはっけん@"
