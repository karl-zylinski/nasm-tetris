global _main
extern _ExitProcess@4
extern _xdisp_init
extern _xdisp_deinit
extern _xdisp_process_events
extern _xdisp_set
extern _xdisp_is_window_open
extern _xdisp_left_held
extern _xdisp_up_held
extern _xdisp_right_held
extern _xdisp_down_held
extern _xdisp_time
extern _xdisp_sleep

section .text

tick:
    push ebp
    mov ebp, esp

    ; clear piece
    push 0
    push 0
    push 0
    push dword [block_y + 0]
    push dword [block_x + 0]
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    push dword [block_y + 1*4]
    push dword [block_x + 1*4]
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    push dword [block_y + 2*4]
    push dword [block_x + 2*4]
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    push dword [block_y + 3*4]
    push dword [block_x + 3*4]
    call _xdisp_set
    add esp, 5*4

    ; move piece

    mov eax, [left_pressed]
    cmp eax, 1
    jne .right

    mov eax, [block_x + 0]
    sub eax, 1
    mov [block_x + 0], eax
    mov eax, [block_x + 1*4]
    sub eax, 1
    mov [block_x + 1*4], eax
    mov eax, [block_x + 2*4]
    sub eax, 1
    mov [block_x + 2*4], eax
    mov eax, [block_x + 3*4]
    sub eax, 1
    mov [block_x + 3*4], eax

    .right:
    mov eax, [right_pressed]
    cmp eax, 1
    jne .down

    mov eax, [block_x + 0]
    add eax, 1
    mov [block_x + 0], eax
    mov eax, [block_x + 1*4]
    add eax, 1
    mov [block_x + 1*4], eax
    mov eax, [block_x + 2*4]
    add eax, 1
    mov [block_x + 2*4], eax
    mov eax, [block_x + 3*4]
    add eax, 1
    mov [block_x + 3*4], eax
    
    .down:
    mov eax, [down_pressed]
    cmp eax, 1
    jne .up

    mov eax, [block_y + 0]
    add eax, 1
    mov [block_y + 0], eax
    mov eax, [block_y + 1*4]
    add eax, 1
    mov [block_y + 1*4], eax
    mov eax, [block_y + 2*4]
    add eax, 1
    mov [block_y + 2*4], eax
    mov eax, [block_y + 3*4]
    add eax, 1
    mov [block_y + 3*4], eax
    
    .up:
    ; ROTATE!!!

    ; gravity

    mov eax, [block_y + 0]
    add eax, 1
    mov [block_y + 0], eax
    mov eax, [block_y + 1*4]
    add eax, 1
    mov [block_y + 1*4], eax
    mov eax, [block_y + 2*4]
    add eax, 1
    mov [block_y + 2*4], eax
    mov eax, [block_y + 3*4]
    add eax, 1
    mov [block_y + 3*4], eax

    ; draw piece
    push dword [block_b]
    push dword [block_g]
    push dword [block_r]
    push dword [block_y + 0]
    push dword [block_x + 0]
    call _xdisp_set
    add esp, 5*4

    push dword [block_b]
    push dword [block_g]
    push dword [block_r]
    push dword [block_y + 1*4]
    push dword [block_x + 1*4]
    call _xdisp_set
    add esp, 5*4

    push dword [block_b]
    push dword [block_g]
    push dword [block_r]
    push dword [block_y + 2*4]
    push dword [block_x + 2*4]
    call _xdisp_set
    add esp, 5*4

    push dword [block_b]
    push dword [block_g]
    push dword [block_r]
    push dword [block_y + 3*4]
    push dword [block_x + 3*4]
    call _xdisp_set
    add esp, 5*4

    mov esp, ebp
    pop ebp
    ret

move_piece_to_map:
    push ebp
    mov ebp, esp

    ;index is pos y * board_width + x
    
    ;;movzx eax, byte [block_y]
    ;;movzx rbx, byte [board_width]
    ;;mul bl
    ;add al, byte [block_x]
    ;add al, 

    ;add eax, ecx


    mov esp, ebp
    pop ebp
    ret 

spawn_piece:
    push ebp
    mov ebp, esp

    ; the different block_types, the names are approximiations of their shapes:
    ; 0 nothing
    ; 1 pink      I
    ; 2 red       T
    ; 3 white     Z
    ; 4 yellow    inv_Z
    ; 5 blue      L
    ; 6 green     inv_L

    rdtsc ; use clock as 'random number'
    mov edx, 0
    mov ecx, 5
    div ecx ; remainder in edx / dl
    add edx, 1
    mov [block_type], edx
    cmp edx, 1
    je .pink_I
    cmp edx, 2
    je .red_T
    cmp edx, 3
    je .white_Z
    cmp edx, 4
    je .yellow_inv_Z
    cmp edx, 5
    je .blue_L
    cmp edx, 6
    je .green_inv_L

    .pink_I:
    mov [block_r], dword 255
    mov [block_g], dword 0
    mov [block_b], dword 255
    mov [block_x + 0], dword 3
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 4
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 5
    mov [block_y + 2*4], dword 0
    mov [block_x + 3*4], dword 6
    mov [block_y + 3*4], dword 0
    jmp .e

    .red_T:
    mov [block_r], dword 255
    mov [block_g], dword 0
    mov [block_b], dword 0
    mov [block_x + 0], dword 4
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 5
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 6
    mov [block_y + 2*4], dword 0
    mov [block_x + 3*4], dword 5
    mov [block_y + 3*4], dword 1
    jmp .e

    .white_Z:
    mov [block_r], dword 255
    mov [block_g], dword 255
    mov [block_b], dword 255
    mov [block_x + 0], dword 3
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 4
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 4
    mov [block_y + 2*4], dword 1
    mov [block_x + 3*4], dword 5
    mov [block_y + 3*4], dword 1
    jmp .e

    .yellow_inv_Z:
    mov [block_r], dword 255
    mov [block_g], dword 255
    mov [block_b], dword 0
    mov [block_x + 0], dword 4
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 5
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 3
    mov [block_y + 2*4], dword 1
    mov [block_x + 3*4], dword 4
    mov [block_y + 3*4], dword 1
    jmp .e

    .blue_L:
    mov [block_r], dword 0
    mov [block_g], dword 0
    mov [block_b], dword 255
    mov [block_x + 0], dword 4
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 5
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 6
    mov [block_y + 2*4], dword 0
    mov [block_x + 3*4], dword 4
    mov [block_y + 3*4], dword 1
    jmp .e

    .green_inv_L:
    mov [block_r], dword 0
    mov [block_g], dword 255
    mov [block_b], dword 0
    mov [block_x + 0], dword 4
    mov [block_y + 0], dword 0
    mov [block_x + 1*4], dword 5
    mov [block_y + 1*4], dword 0
    mov [block_x + 2*4], dword 6
    mov [block_y + 2*4], dword 0
    mov [block_x + 3*4], dword 6
    mov [block_y + 3*4], dword 1

    .e:

    mov esp, ebp
    pop ebp
    ret

_main:
    sub esp, 4

    push tile_spacing
    push tile_size
    push board_height
    push board_width
    push window_title
    call _xdisp_init
    add esp, 5*4

    call spawn_piece

    call _xdisp_time
    fstp dword [ebp-4]
    movss xmm0, dword [ebp-4]
    movss dword [frame_start], xmm0

    .window_loop:
        mov cl, [left_held]
        call _xdisp_left_held
        mov [left_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .right ; no change
        cmp cl, 0 ; did we hold before?
        jne .right
        mov [left_pressed], dword 1

        .right:
        mov cl, [right_held]
        call _xdisp_right_held
        mov [right_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .down ; no change
        cmp cl, 0 ; did we hold before?
        jne .down
        mov [right_pressed], dword 1

        .down:
        mov cl, [down_held]
        call _xdisp_down_held
        mov [down_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .up ; no change
        cmp cl, 0 ; did we hold before?
        jne .up
        mov [down_pressed], dword 1

        .up:
        mov cl, [up_held]
        call _xdisp_up_held
        mov [up_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .input_end ; no change
        cmp cl, 0 ; did we hold before?
        jne .input_end
        mov [up_pressed], dword 1

        .input_end:

        call _xdisp_time
        fstp dword [ebp-4]
        movss xmm0, dword [ebp-4]
        movss dword [cur_time], xmm0
        subss xmm0, dword [frame_start]
        comiss xmm0, dword [time_per_frame]
        jb .cont
        movss xmm0, dword [cur_time]
        movss dword [frame_start], xmm0

        call tick
        mov [up_pressed], dword 0
        mov [down_pressed], dword 0
        mov [left_pressed], dword 0
        mov [right_pressed], dword 0

        .cont:
        push 1
        call _xdisp_sleep
        add esp, 4
        call _xdisp_process_events
        call _xdisp_is_window_open
        cmp eax, 0
        jne .window_loop

    quit: mov eax, 0
    push 0
    call _ExitProcess@4
    ret

section .data

;input state
left_held: dd 0
right_held: dd 0
up_held: dd 0
down_held: dd 0
left_pressed: dd 0
right_pressed: dd 0
up_pressed: dd 0
down_pressed: dd 0

; window info
window_title: db "Tetris!", 0

; frame state
frame_start: dd 0.0
cur_time: dd 0.0
time_per_frame: dd 0.25

; gfx info
board_width equ 10
board_height equ 24
tile_size equ 32
tile_spacing equ 2

; game state
block_x: times 4 dd 0
block_y: times 4 dd 0
block_type: dd 0 ; see comment in 'spawn_piece'
block_r: dd 0
block_g: dd 0
block_b: dd 0
map: times board_width*board_height dd 0 ; index is pos y * board_width + x
