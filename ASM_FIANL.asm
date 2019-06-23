TITLE match                (match.ASM)

INCLUDE Irvine32.inc

main          EQU start@0

chosOne proto,pl: ptr BYTE,se: ptr BYTE
callmode proto,mo : ptr BYTE
showcard PROTO, line : ptr byte,xy : COORD
showGAME PROTO, RO: BYTE,CO: BYTE,xy : COORD
showCHOOSE PROTO,wd : ptr byte,xy : COORD
pattern PROTO, card: byte,xy : COORD
openc PROTO,card: byte,xyCHO : COORD
closec PROTO,card: byte,xyNOW : COORD
WinGame  PROTO, RO: BYTE,CO: BYTE,xy : COORD 

.data
consoleHandle    DWORD ?
xyInit COORD <0,0>
xyGO COORD <2,2>
xyCH COORD <2,1>
xyopen COORD <0,0>
xyPos COORD <0,23> 
xyPlay COORD <0,15>  
topic BYTE 	 " ******************************************************************************************************************* ", 0Dh,0Ah
      BYTE	 " *    M                   MM            A            TTTTTTTTTTTTTTTTTTTTT       CCCCCCCC     HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM                 MMM           AAA           TTTTTTTTTTTTTTTTTTTTT    CCCC     CCCC   HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MMM               MMMM          AA  A                  TTTTT           CCC          CC  HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM M             MM MM         AA    A                 TTTTT           CC               HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM  M           MM  MM        AA      A                TTTTT          CCC               HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM   M         MM   MM       AAAAAAAAAAA               TTTTT          CCC               HHHHHHHHHHHHHHHHH    * ", 0Dh,0Ah
      BYTE	 " *    MM    M       MM    MM      AAAAAAAAAAAAA              TTTTT          CCC               HHHHHHHHHHHHHHHHH    * ", 0Dh,0Ah
      BYTE	 " *    MM     M     MM     MM     AA            A             TTTTT           CC               HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM      M   MM      MM    AA              A            TTTTT           CCCC         C   HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM       M MM       MM   AA                A           TTTTT             CCCC     CCC   HH             HH    * ", 0Dh,0Ah
      BYTE	 " *    MM        MM        MM  AA                  A          TTTTT               CCCCCCCCC    HH             HH    * ", 0Dh,0Ah
      BYTE	 " *                                                                                                                 * ", 0Dh,0Ah
      BYTE	 " ******************************************************************************************************************* ", 0Dh,0Ah,0

playbu BYTE  "                                                                              ", 0Dh,0Ah
       BYTE	 "                                        PPPPPP  L           AA     Y       Y  ", 0Dh,0Ah
       BYTE	 "                                        P     P L          AA A     Y     Y   ", 0Dh,0Ah
       BYTE	 "                                        P     P L         AA   A      Y Y     ", 0Dh,0Ah
       BYTE	 "                                        PPPPPP  L        AAAAAAAA      Y      ", 0Dh,0Ah
       BYTE	 "                                        P       L        AA     A      Y      ", 0Dh,0Ah
       BYTE	 "                                        P       LLLLLLL AA       A     Y      ", 0Dh,0Ah
       BYTE	 "                                                                              ", 0Dh,0Ah,0
	   
playch BYTE  "                                     ┌───────────────────────────────────────┐                                     ", 0Dh,0Ah
       BYTE	 "                                     │  PPPPPP  L           AA     Y       Y │", 0Dh,0Ah                                                              
       BYTE	 "                                     │  P     P L          AA A     Y     Y  │", 0Dh,0Ah                                                                 
       BYTE	 "                                     │  P     P L         AA   A      Y Y    │", 0Dh,0Ah                                                              
       BYTE	 "                                     │  PPPPPP  L        AAAAAAAA      Y     │", 0Dh,0Ah                                                              
       BYTE	 "                                     │  P       L        AA     A      Y     │", 0Dh,0Ah                                                              
       BYTE	 "                                     │  P       LLLLLLL AA       A     Y     │", 0Dh,0Ah                                                              
       BYTE	 "                                     └───────────────────────────────────────┘                                     ", 0Dh,0Ah,0

setbu  BYTE  "                                                                                                                   ", 0Dh,0Ah
       BYTE	 "                                                SSSSSS  EEEEEE TTTTTTT                                             ", 0Dh,0Ah
       BYTE	 "                                                SSSS    E         TT                                               ", 0Dh,0Ah
       BYTE	 "                                                  SSSS  EEEEEE    TT                                               ", 0Dh,0Ah
       BYTE	 "                                                     S  E         TT                                               ", 0Dh,0Ah
       BYTE	 "                                                SSSSSS  EEEEEE    TT                                               ", 0Dh,0Ah
       BYTE	 "                                                                                                                   ", 0Dh,0Ah,0
	   
setch  BYTE  "                                         ┌─────────────────────────────────┐                                       ", 0Dh,0Ah
       BYTE	 "                                         │      SSSSSS  EEEEEE TTTTTTT     │                                       ", 0Dh,0Ah
       BYTE	 "                                         │      SSSS    E         TT       │                                       ", 0Dh,0Ah
       BYTE	 "                                         │        SSSS  EEEEEE    TT       │                                       ", 0Dh,0Ah
       BYTE	 "                                         │           S  E         TT       │                                       ", 0Dh,0Ah
       BYTE	 "                                         │      SSSSSS  EEEEEE    TT       │                                       ", 0Dh,0Ah
       BYTE	 "                                         └─────────────────────────────────┘                                       ", 0Dh,0Ah,0


modeEA BYTE  "                                                                                                                  ", 0Dh,0Ah
       BYTE	 "                                              M   M   OOO   DDD   EEEE            EEEEE   AAA   SSSSS  Y   Y    ", 0Dh,0Ah
       BYTE	 "                                              MM MM  OO OO  D  D  E       O       E      A   A  SSS     Y Y    ", 0Dh,0Ah
       BYTE	 "                                              M M M  O   O  D  D  EEE          <- EEEE   AAAAA   SSS     Y    ->  ", 0Dh,0Ah
       BYTE	 "                                              M M M  OO OO  D  D  E       O       E     AA   AA    SS    Y     ", 0Dh,0Ah
       BYTE	 "                                              M M M   OOO   DDD   EEEE            EEEEE A     A SSSSS    Y      ", 0Dh,0Ah
       BYTE	 "                                                                                 ─────────────────────────────  ", 0Dh,0Ah,0
modeHA   BYTE  "                                                                                                             ", 0Dh,0Ah
       BYTE	 "                                              M   M   OOO   DDD   EEEE            H   H   AAA   RRRRR  DDDD     ", 0Dh,0Ah
       BYTE	 "                                              MM MM  OO OO  D  D  E       O       H   H  A   A  R    R D   D   ", 0Dh,0Ah
       BYTE	 "                                              M M M  O   O  D  D  EEE          <- HHHHH  AAAAA  RRRRR  D   D  ->", 0Dh,0Ah
       BYTE	 "                                              M M M  OO OO  D  D  E       O       H   H AA   AA RRRR   D   D   ", 0Dh,0Ah
       BYTE	 "                                              M M M   OOO   DDD   EEEE            H   H A     A R  RRR DDDD     ", 0Dh,0Ah
       BYTE	 "                                                                                 ─────────────────────────────  ", 0Dh,0Ah,0

word_A		byte " ┌──────────┐ ", 0
			byte " │     A    │ ", 0
			byte " │    A A   │ ", 0
			byte " │   A   A  │ ", 0
			byte " │  AAAAAAA │ ", 0
			byte " │ AA     AA│ ", 0
			byte " │ AA     AA│ ", 0
			byte " └──────────┘ ", 0

word_B		byte " ┌──────────┐ ", 0
			byte " │ BBBBBB   │ ", 0
			byte " │ BB    B  │ ", 0
			byte " │ BBBBBB   │ ", 0
			byte " │ BBBBBBB  │ ", 0
			byte " │ BB     B │ ", 0
			byte " │ BBBBBBB  │ ", 0
			byte " └──────────┘ ", 0

word_C		byte " ┌──────────┐ ", 0
			byte " │   CCCCCC │ ", 0
			byte " │  CC    CC│ ", 0
			byte " │ CC       │ ", 0
			byte " │ CC       │ ", 0
			byte " │  CC    CC│ ", 0
			byte " │   CCCCCC │ ", 0
			byte " └──────────┘ ",0

word_D	byte " ┌──────────┐ ",0
		byte " │ DDDDDDD  │ ",0
		byte " │ DD    DD │ ",0
		byte " │ DD     DD│ ",0
		byte " │ DD     DD│ ",0
		byte " │ DD    DD │ ",0
		byte " │ DDDDDDD  │ ",0
		byte " └──────────┘ ",0
		
word_E	byte " ┌──────────┐ ",0
		byte " │ EEEEEEEEE│ ",0
		byte " │ EE       │ ",0
		byte " │ EEEEEEE  │ ",0
		byte " │ EEEEEEE  │ ",0
		byte " │ EE       │ ",0
		byte " │ EEEEEEEEE│ ",0
		byte " └──────────┘ ",0

word_F	byte " ┌──────────┐ ", 0
		byte " │ FFFFFFFFF│ ", 0
		byte " │ FF       │ ", 0
		byte " │ FFFFFFF  │ ", 0
		byte " │ FFFFFFF  │ ", 0
		byte " │ FF       │ ", 0
		byte " │ FF       │ ", 0
		byte " └──────────┘ ",0

word_G	byte " ┌──────────┐ ", 0
		byte " │   GGGGGG │ ", 0
		byte " │  GG   GGG│ ", 0
		byte " │ GG       │ ", 0
		byte " │ GG  GGGGG│ ", 0
		byte " │  GG    GG│ ", 0
		byte " │   GGGGGG │ ", 0
		byte " └──────────┘ ",0

word_H	byte " ┌──────────┐ ",0
		byte " │ HH     HH│ ",0
		byte " │ HH     HH│ ",0
		byte " │ HHHHHHHHH│ ",0
		byte " │ HHHHHHHHH│ ",0
		byte " │ HH     HH│ ",0
		byte " │ HH     HH│ ",0
		byte " └──────────┘ ",0

word_I	byte " ┌──────────┐ ", 0
		byte " │ IIIIIIIII│ ", 0
		byte " │    III   │ ", 0
		byte " │    III   │ ", 0
		byte " │    III   │ ", 0
		byte " │    III   │ ", 0
		byte " │ IIIIIIIII│ ", 0
		byte " └──────────┘ ",0
		
word_J	byte " ┌──────────┐ ", 0
		byte " │ JJJJJJJJJ│ ", 0
		byte " │       JJ │ ", 0
		byte " │       JJ │ ", 0
		byte " │ JJ    JJ │ ", 0
		byte " │  JJ   JJ │ ", 0
		byte " │    JJJ   │ ", 0
		byte " └──────────┘ ",0

word_K	byte " ┌──────────┐ ", 0
		byte " │ KK   KK  │ ", 0
		byte " │ KK  KK   │ ", 0
		byte " │ KKKKK    │ ", 0
		byte " │ KK KK    │ ", 0
		byte " │ KK  KKK  │ ", 0
		byte " │ KK    KKK│ ", 0
		byte " └──────────┘ ",0

word_L	byte " ┌──────────┐ ", 0
		byte " │ LL       │ ", 0
		byte " │ LL       │ ", 0
		byte " │ LL       │ ", 0
		byte " │ LL       │ ", 0
		byte " │ LL       │ ", 0
		byte " │ LLLLLLLL │ ", 0
		byte " └──────────┘ ",0

		

word_mark		byte " ┌──────────┐ ", 0
			byte " │   ????   │ ", 0
			byte " │ ??    ?? │ ", 0
			byte " │     ??   │ ", 0
			byte " │    ??    │ ", 0
			byte " │          │ ", 0
			byte " │    ??    │ ", 0
			byte " └──────────┘ ",0

word_boom		byte " ┌──────────┐ ", 0
			byte " │     ***  │ ", 0
			byte " │     *    │ ", 0
			byte " │   *****  │ ", 0
			byte " │  *     * │ ", 0
			byte " │  *     * │ ", 0
			byte " │   *****  │ ", 0
			byte " └──────────┘ ",0

word_white		byte " ┌──────────┐ ", 0
			byte " │          │ ", 0
			byte " │          │ ", 0
			byte " │          │ ", 0
			byte " │          │ ", 0
			byte " │          │ ", 0
			byte " │          │ ", 0
			byte " └──────────┘ ",0
			
word_choose		byte "┌", 0	
			byte "┐", 0
			byte "┘", 0
			byte "└", 0
		
word_choose_NO		byte "  ", 0	
			byte "  ", 0
			byte "  ", 0
			byte "  ", 0
		
list 		byte 1,1,2,2,13
			byte 3,3,4,4,7
			byte 5,5,6,6,7
			byte 8,8,9,9,10
			byte 10,11,11,13,13

list_ch 		byte 0,0,0,0,0
				byte 0,0,0,0,0
				byte 0,0,0,0,0
				byte 0,0,0,0,0
				byte 0,0,0,0,0				
choose1 BYTE 0

				
colsize word 15
rowsize word 10
row byte 0
col byte 0
MODE bYTE 0
right_bound byte 0
down_bound byte 0

cardch byte 0
cardfirstCH byte 99

STARTIME DWORD 0

ScorePrompt BYTE "Score : ", 0
TimePrompt BYTE "Time : ", 0
ComboPrompt BYTE "Combo : ", 0
TimeDis BYTE "         ", 0
GameOverPrompt BYTE "GAMEOVER...    QQ  QQ  QQ..",0
WinGamePrompt BYTE "YOU WIN!!!    YA  YA  YA!! ",0
SpaceNotice BYTE "Press Space to Continue.",0
attributes WORD 0Fh, 0Eh, 0Dh, 0Ch, 0Fh, 0Ah, 0Bh, 0Ch, 0Eh, 0Fh, 0Ah, 0Bh
Score DWORD 0h
xyTime COORD<10,0>
xyScore COORD<20,0>
xyCombo COORD<31,0>
SpacePosition COORD <18, 16>; position to print time
ScorePosition COORD <18,13 >; position to print score
ScorePromptPosition COORD <11, 0>; position to print Score: 
GameOverPromptPosition COORD <18, 10>
currentPosition COORD <,>

combo BYTE 1
match BYTE 0

.code
main PROC,argc : byte ,argv : ptr byte
INVOKE  GetStdHandle, STD_OUTPUT_HANDLE
mov consoleHandle,eax

FACE1:
		 
	mov edx , OFFSET topic
	call WriteString
	call Crlf
	mov edx , OFFSET playch
	
	call WriteString
	mov edx , OFFSET setbu
	call WriteString


  START:
  invoke SetConsoleCursorPosition ,consoleHandle,xyInit   
call ReadChar

	.IF ax == 4800h && choose1 <= 1;UP
		mov choose1,0
		invoke chosOne,addr playch,addr setbu
		jmp START
	.ELSEIF ax == 5000h && choose1 <=1 ;DOWN
		mov choose1,1
		invoke chosOne,addr playbu,addr setch
		jmp START
	.ELSEIF ax == 4B00h && choose1 > 1;UP
		mov choose1,2
		invoke callmode ,addr modeEA
		jmp START
	.ELSEIF ax == 4D00h && choose1 > 1 ;DOWN
		mov choose1,3
				invoke callmode ,addr modeHA
		jmp START
	.ELSEIF ax == 011Bh ;ESC
		jmp END_FUNC
	.ELSEIF ax == 3920h && choose1 == 0 ;play 
		call clrscr
		jmp FACE2
	.ELSEIF ax == 3920h && choose1 == 1 ;set
		mov choose1,2
		.IF MODE==0
		invoke callmode ,addr modeEA
		.ELSE
		invoke callmode ,addr modeHA
		.ENDIF
		jmp START
	.ELSEIF ax == 3920h && choose1 == 2;space  ;essay
	mov MODE,0
			mov choose1,1
		invoke chosOne,addr playbu,addr setch
		jmp START
	.ELSEIF ax == 3920h && choose1 == 3;space ;difficult
	mov MODE,1
			mov choose1,1
		invoke chosOne,addr playbu,addr setch
		jmp START
	.ELSE
		jmp START
	.ENDIF



FACE2:

call INITAILIZE

.IF MODE==0
mov row,3
mov col,5
mov down_bound,20
mov right_bound,60
.ELSEIF MODE==1
mov row,5
mov col,5
mov down_bound,40
mov right_bound,90
.ENDIF


	INVOKE showGAME,row,col,xyGO
	INVOKE showCHOOSE,addr word_choose ,xyCH
	


	call   GetMseconds
	mov STARTIME,eax
START2:	

	call   GetMseconds
TIMELOOP:
	sub eax,STARTIME
	.IF eax>1000
	
	call printTime
	shr eax,10
	.IF MODE==0
	mov ebx,50
	.ELSEIF MODE ==1
	mov ebx,99
	.ENDIF
	
	.IF eax<ebx
	sub eax,ebx

	neg eax
	call WriteDec
	mov al,' '
	call writechar
	.ELSE
	call printTime
	mov eax,0
	call writedec
	mov al,' '
	call writechar
			mov eax,1000
			call delay
	invoke SetConsoleCursorPosition ,consoleHandle,xyTime
	mov edx,OFFSET TimeDis
	call writestring
			mov eax,1000
			call delay
	call printTime
	mov eax,0
	call writedec
	mov al,' '
	call writechar
			mov eax,1000
			call delay
	invoke SetConsoleCursorPosition ,consoleHandle,xyTime
	mov edx,OFFSET TimeDis
	call writestring
			mov eax,1000
			call delay
	call printTime
	mov eax,0
	call writedec
	mov al,' '
	call writechar
			mov eax,1000
			call delay
	invoke SetConsoleCursorPosition ,consoleHandle,xyTime
	mov edx,OFFSET TimeDis
	call writestring
			mov eax,1000
			call delay
	call printTime
	mov eax,0
	call writedec
	mov al,' '
	call writechar
			mov eax,1000
			call delay
	call GameOver
	.ENDIF
	call printScore
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit 
	.ENDIF
	call readchar
	.IF	ax == 4800h ||ax == 5000h ||ax == 4B00h || ax == 4D00h || ax == 3920h
JMP DOTHINGS
	.ENDIF
JMP TIMELOOP
	
DOTHINGS:


	movzx bx,down_bound
	movzx cx,right_bound
	.IF ax == 4800h && xyCH.y >9;UP
		INVOKE showCHOOSE,addr word_choose_NO ,xyCH
		sub xyCH.y,10
		sub cardch,5
		INVOKE showCHOOSE,addr word_choose ,xyCH
		
		jmp START2
	.ELSEIF ax == 5000h && xyCH.y < bx ;DOWN
		INVOKE showCHOOSE,addr word_choose_NO ,xyCH
		add xyCH.y,10
		add cardch,5
		INVOKE showCHOOSE,addr word_choose ,xyCH
	
		jmp START2
	.ELSEIF ax == 4B00h && xyCH.x>15;LEFT
			INVOKE showCHOOSE,addr word_choose_NO ,xyCH
				sub xyCH.x,15
				sub cardch,1
				INVOKE showCHOOSE,addr word_choose ,xyCH
		jmp START2
	.ELSEIF ax == 4D00h && xyCH.x < cx;RIGHT
				INVOKE showCHOOSE,addr word_choose_NO ,xyCH
				add xyCH.x,15
				add cardch,1
				INVOKE showCHOOSE,addr word_choose ,xyCH
		JMP START2
	.ELSEIF ax == 3920h
		movzx ebx,cardch
			.IF list[ebx] == 13	
			INVOKE openc,cardch,xyCH
			mov eax,1000
			call delay
			INVOKE pattern,14,xyopen
			mov eax,1000
			call delay
			INVOKE pattern,13,xyopen
			mov eax,1000
			call delay
			INVOKE pattern,14,xyopen
			mov eax,1000
			call delay
			INVOKE pattern,13,xyopen
			mov eax,1000
			call delay
			INVOKE pattern,14,xyopen
			mov eax,1000
			call delay
			INVOKE pattern,13,xyopen
			mov eax,1000
			call delay
			
			call GameOver
			.ELSEIF cardfirstCH == 99				 ;還沒選過卡
				INVOKE openc,cardch,xyCH
			.ELSEIF cardfirstCH != bl && list_ch[ebx] !=1 	 ;選過卡而且不重複選 還有這個卡是蓋著的
			
			movzx eax,list[ebx]
			movzx ebx,cardfirstCH
				.IF list[ebx] == al								;如果翻到了同樣圖案的
					
					mov eax,Score
					movzx ecx,combo
					COM:
					add eax,5
					loop COM
					mov Score,eax
					movzx eax,combo
					inc eax
					mov combo,al
					movzx eax,match
					inc eax
					mov match,al
					INVOKE openc,cardch,xyCH
					.IF MODE==0 && match ==7
					INVOKE WinGame,row,col,xyGO
					.ELSEIF MODE ==1 && match==11
					INVOKE WinGame,row,col,xyGO
					.ENDIF
					mov cardfirstCH,99
				.ELSE											;不同圖案
				inc xyCH.y
				mov combo,1
				movzx ebx,cardch
				INVOKE pattern,list[ebx],xyCH
				dec xyCH.y	
				mov eax,1000
				call delay
				INVOKE closec,cardch,xyCH
				.ENDIF
			.ENDIF
		jmp START2
	.ELSE
	JMP START2
	.ENDIF
	
	
END_FUNC:
	exit
main ENDP

chosOne PROC,pl: ptr BYTE,se: ptr BYTE
	invoke SetConsoleCursorPosition ,consoleHandle,xyPlay

	mov edx , pl
	call WriteString
	mov edx , se
	call WriteString
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit   
ret
chosOne ENDP

callmode PROC,mo: ptr BYTE
	invoke SetConsoleCursorPosition ,consoleHandle,xyPos
	mov edx , mo
	call WriteString
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit   
ret
callmode ENDP

	INITAILIZE PROC uses eax ebx ecx edx

	call   Randomize
	mov ecx,50
L1:
	.IF ecx <=25
	dec ecx
	mov ebx,ecx
	inc ecx
	mov list_ch[ebx],0
	.ENDIF	
	.IF MODE==0
	mov eax,15
	.ELSE
	mov eax,25
	.ENDIF

	call RandomRange
	mov edx,eax	;edx number1


	.IF MODE==0
	mov eax,15
	.ELSE
	mov eax,25
	.ENDIF

	call RandomRange


	mov ebx,eax ;eax number2
	movzx ebx,list[ebx]
	push ebx ;eax的值後出來

	mov ebx,edx
	movzx ebx,list[ebx]
	push ebx ;edx的值先出來


	mov ebx,eax
	pop eax
	mov list[ebx],al

	mov ebx,edx
	pop edx
	mov list[ebx],dl

LOOP L1

ret
INITAILIZE ENDP

showcard PROC uses ecx edx, line : ptr byte,xy : COORD
	invoke SetConsoleCursorPosition ,consoleHandle,xy
	mov edx, line
	call WriteString
	
	inc xy.y
	push edx
	invoke SetConsoleCursorPosition ,consoleHandle,xy
	pop edx
	add edx, 27
	call WriteString

	mov ecx, 6
L1:

		inc xy.y
		push ecx
		push edx
	invoke SetConsoleCursorPosition ,consoleHandle,xy
		pop edx
		pop ecx

		add edx, 17
		call WriteString
LOOP L1	

	invoke SetConsoleCursorPosition ,consoleHandle,xyInit
ret
showcard ENDP

showGAME PROC uses ecx ebx eax edx, RO: BYTE,CO: BYTE,xy : COORD

OPEN:
	movzx ecx,RO
	mov ebx,0
ROO:
	push ecx
	movzx ecx,CO
COO:
	
	INVOKE pattern, list[ebx],xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO
	pop ecx
	mov dx,xyGO.x
	mov xy.x,dx
	mov dx,rowsize
	add xy.y,dx

LOOP ROO	


WAITPERIOD:
	.IF MODE==0
	mov ecx,10
	.ELSEIF MODE==1
	mov ecx,30
	.ENDIF
wL:
	push ecx
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit
	mov ebx,ecx
	
	call printTime
	pop eax
	call  WriteDec
	push eax
	mov al,' '
	call writechar
	mov eax,1000
	call delay
	pop ecx
loop wL
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit
	call printTime
	mov al,' '
	call writechar

CLOSE:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO2:
	push ecx
	movzx ecx,CO
COO2:
	
	INVOKE showcard,addr word_mark,xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO2
pop ecx
mov dx,xyGO.x
mov xy.x,dx
mov dx,rowsize
add xy.y,dx

LOOP ROO2	


ret
showGAME ENDP

showCHOOSE PROC,wd : ptr byte,xy : COORD
	invoke SetConsoleCursorPosition ,consoleHandle,xy
	mov edx,wd
	call writestring
	
		push edx
		add xy.x,13
	invoke SetConsoleCursorPosition ,consoleHandle,xy
		pop edx
	add edx,3
	call writestring
	
			push edx
			add xy.y,9
	invoke SetConsoleCursorPosition ,consoleHandle,xy
		pop edx
	add edx,3
	call writestring
	
				push edx
		sub xy.x,13
	invoke SetConsoleCursorPosition ,consoleHandle,xy
		pop edx
	add edx,3
	call writestring
	
	invoke SetConsoleCursorPosition ,consoleHandle,xyInit
ret
showCHOOSE ENDP

pattern proc, card: byte,xy: COORD

.IF card==0
	INVOKE showcard,addr word_A,xy
.ELSEIF card==1
	INVOKE showcard,addr word_B,xy
.ELSEIF card==2
	INVOKE showcard,addr word_C,xy
.ELSEIF card==3
	INVOKE showcard,addr word_D,xy
.ELSEIF card==4
	INVOKE showcard,addr word_E,xy
.ELSEIF card==5
	INVOKE showcard,addr word_F,xy
.ELSEIF card==6
	INVOKE showcard,addr word_G,xy
.ELSEIF card==7
	INVOKE showcard,addr word_H,xy
.ELSEIF card==8
	INVOKE showcard,addr word_I,xy
.ELSEIF card==9
	INVOKE showcard,addr word_J,xy
.ELSEIF card==10
	INVOKE showcard,addr word_K,xy
.ELSEIF card==11
	INVOKE showcard,addr word_L,xy
.ELSEIF card==12
	INVOKE showcard,addr word_mark,xy
.ELSEIF card==13
	INVOKE showcard,addr word_boom,xy
.ELSEIF card==14
	INVOKE showcard,addr word_white,xy
.ELSE

.ENDIF

	ret
pattern ENDP

openc PROC uses ebx,card: byte,xyCHO : COORD

				movzx ebx,card
				.IF list_ch[ebx]==0
				mov cardfirstCH,bl
				mov list_ch[ebx],1
				mov dx,xyCH.x
				mov xyopen.x,dx
				mov dx,xyCH.y
				mov xyopen.y,dx
				inc xyopen.y
				INVOKE pattern,list[ebx],xyopen
				.ENDIF
ret
openc ENDP

closec PROC uses ebx,card: byte,xyNOW : COORD
				inc xyNOW.y

				movzx ebx,card
				mov list_ch[ebx],0

				movzx ebx,cardfirstCH
				mov list_ch[ebx],0

				mov cardfirstCH,99

				INVOKE pattern,12,xyopen
				INVOKE pattern,12,xyNOW

ret
closec ENDP

printScore PROC uses edx eax

		invoke SetConsoleCursorPosition ,consoleHandle,xyScore
		mov edx,OFFSET ScorePrompt
		call writestring
		mov eax,Score
		call WriteDec
		invoke SetConsoleCursorPosition ,consoleHandle,xyCombo
		mov edx,OFFSET ComboPrompt
		call writestring
		movzx eax,combo
		dec eax
		call WriteDec
		mov al,' '
		call writechar
		invoke SetConsoleCursorPosition ,consoleHandle,xyInit
	ret
printScore ENDP 
		
printTime PROC uses eax ebx ecx edx
		invoke SetConsoleCursorPosition ,consoleHandle,xyTime
		mov edx,OFFSET TimePrompt
		call writeString
	ret
printTime ENDP

GameOver PROC 
	call clrscr
	INVOKE SetConsoleCursorPosition, consoleHandle, GameOverPromptPosition
	mov edx, OFFSET GameOverPrompt
	call writeString
	INVOKE SetConsoleCursorPosition, consoleHandle,ScorePosition
	mov edx, OFFSET ScorePrompt
	call writeString
	mov eax,Score
	call writedec
	INVOKE SetConsoleCursorPosition, consoleHandle,SpacePosition
	mov edx,OFFSET SpaceNotice
	call writeString
SPC:
	call readchar
	.IF ax==3920h
	exit
	.ELSE
JMP SPC
	.ENDIF
GameOver ENDP

WinGame  PROC uses ecx ebx eax edx, RO: BYTE,CO: BYTE,xy : COORD 

mov eax,500
call delay

CLOSE1:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO1:
	push ecx
	movzx ecx,CO
COO1:
	
	INVOKE showcard,addr word_white,xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO1
pop ecx
mov dx,xyGO.x
mov xy.x,dx
mov dx,rowsize
add xy.y,dx

LOOP ROO1	

mov eax,500
call delay

OPEN2:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO2:
	push ecx
	movzx ecx,CO
COO2:
	
	INVOKE pattern, list[ebx],xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO2
	pop ecx
	mov dx,xyGO.x
	mov xy.x,dx
	mov dx,rowsize
	add xy.y,dx

LOOP ROO2	

mov eax,500
call delay

CLOSE3:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO3:
	push ecx
	movzx ecx,CO
COO3:
	
	INVOKE showcard,addr word_white,xy
	inc ebx
	mov dx,colsize
	add xy.x,dx
	
LOOP COO3
pop ecx
mov dx,xyGO.x
mov xy.x,dx
mov dx,rowsize
add xy.y,dx

LOOP ROO3	

mov eax,500
call delay

OPEN4:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO4:
	push ecx
	movzx ecx,CO
COO4:
	
	INVOKE pattern, list[ebx],xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO4
	pop ecx
	mov dx,xyGO.x
	mov xy.x,dx
	mov dx,rowsize
	add xy.y,dx

LOOP ROO4	

mov eax,500
call delay

CLOSE5:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO5:
	push ecx
	movzx ecx,CO
COO5:
	
	INVOKE showcard,addr word_white,xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO5
pop ecx
mov dx,xyGO.x
mov xy.x,dx
mov dx,rowsize
add xy.y,dx

LOOP ROO5	

mov eax,500
call delay

OPEN6:
	mov eax,xyGO
	mov xy,eax
	movzx ecx,RO
	mov ebx,0
ROO6:
	push ecx
	movzx ecx,CO
COO6:
	
	INVOKE pattern, list[ebx],xy
	inc ebx
	mov dx,colsize
	add xy.x,dx


LOOP COO6
	pop ecx
	mov dx,xyGO.x
	mov xy.x,dx
	mov dx,rowsize
	add xy.y,dx

LOOP ROO6

mov eax,1000
call delay


	call clrscr
	INVOKE SetConsoleCursorPosition, consoleHandle, GameOverPromptPosition
	mov edx, OFFSET WinGamePrompt
	call writeString
	INVOKE SetConsoleCursorPosition, consoleHandle,ScorePosition
	mov edx, OFFSET ScorePrompt
	call writeString
	mov eax,Score
	call writedec
	INVOKE SetConsoleCursorPosition, consoleHandle,SpacePosition
	mov edx,OFFSET SpaceNotice
	call writeString
SPC:
	call readchar
	.IF ax==3920h
	exit
	.ELSE
JMP SPC
	.ENDIF
WinGame ENDP

END main