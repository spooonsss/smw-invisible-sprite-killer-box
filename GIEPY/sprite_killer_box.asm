;;
;
; Sprite killer box
;
; This invisible sprite will kill any sprite is comes in contact with.
;
;;

print	"MAIN ", pc           
                    PHB                     ; \
                    PHK                     ;  | main sprite function, just calls local subroutine
                    PLB                     ;  |
                    JSR KillSpr_Start		;  |
                    PLB                     ;  |
print	"INIT ", pc	
                    RTL                     ; /
					
;;;;;;;;;;;;;;

Skip:
	RTS

KillSpr_Start:
		LDA !14C8,x
		EOR #$08
		ORA $9D	; Lock Flag
		BNE Skip
	; [$9D EQ #$00]
		;LDA #$00	
		JSL SubOffScreen ;SubOffScreenYadda
		BCS Skip
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		JSL	$03B69F	; Get Sprite Clipping A.
		
		LDX #!SprSize
	---
		DEX
		BMI +++
		
		CPX $15E9|!base2
		BEQ ---
		
		LDA !14C8,x
		CMP #$08
		BCC ---
		
		JSL $03B6E5 ; Get Sprite Clipping B.
		
		JSL $03B72B	; Check for contact.
		BCC --- 	; No Contact, go back.
		
		LDA $02
		LSR
		CLC
		ADC $00
		STA $0C
		LDA $08
		ADC #$00
		STA $0D
		
		LDA $03
		LSR
		CLC
		ADC $01
		STA $0E
		LDA $09
		ADC #$00
		STA $0F
		
		LDY $1863|!base2	; Get smoke sprite index.
		
		LDA #$01
		STA $17C0|!base2,y	; Smoke sprite type (smoke)
		LDA $0C
		SEC
		SBC #$08
		STA $17C8|!base2,y	; Smoke X position
		LDA $0E
		SEC
		SBC #$08
		STA $17C4|!base2,y	; Y position
		LDA #20
		STA $17CC|!base2,y	; Timer
		
		LDA #$25
		STA $1DFC|!base2	; Sound effect (Yoshi stomps)
		
		;LDA #$00
		STZ !14C8,x
		BRA ---
+++
		LDX $15E9|!base2
		RTS