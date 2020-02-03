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
    movzx eax, byte [block_y + 0]
    push eax
    movzx eax, byte [block_x + 0]
    push eax
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    movzx eax, byte [block_y + 1]
    push eax
    movzx eax, byte [block_x + 1]
    push eax
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    movzx eax, byte [block_y + 2]
    push eax
    movzx eax, byte [block_x + 2]
    push eax
    call _xdisp_set
    add esp, 5*4

    push 0
    push 0
    push 0
    movzx eax, byte [block_y + 3]
    push eax
    movzx eax, byte [block_x + 3]
    push eax
    call _xdisp_set
    add esp, 5*4

    ; move piece

    mov al, [left_pressed]
    cmp al, 1
    jne .right

    mov al, [block_x + 0]
    sub al, 1
    mov [block_x + 0], al
    mov al, [block_x + 1]
    sub al, 1
    mov [block_x + 1], al
    mov al, [block_x + 2]
    sub al, 1
    mov [block_x + 2], al
    mov al, [block_x + 3]
    sub al, 1
    mov [block_x + 3], al

    .right:
    mov al, [right_pressed]
    cmp al, 1
    jne .down

    mov al, [block_x + 0]
    add al, 1
    mov [block_x + 0], al
    mov al, [block_x + 1]
    add al, 1
    mov [block_x + 1], al
    mov al, [block_x + 2]
    add al, 1
    mov [block_x + 2], al
    mov al, [block_x + 3]
    add al, 1
    mov [block_x + 3], al
    
    .down:
    mov al, [down_pressed]
    cmp al, 1
    jne .up

    mov al, [block_y + 0]
    add al, 1
    mov [block_y + 0], al
    mov al, [block_y + 1]
    add al, 1
    mov [block_y + 1], al
    mov al, [block_y + 2]
    add al, 1
    mov [block_y + 2], al
    mov al, [block_y + 3]
    add al, 1
    mov [block_y + 3], al
    
    .up:
    ; ROTATE!!!

    ; gravity

    mov al, [block_y + 0]
    add al, 1
    mov [block_y + 0], al
    mov al, [block_y + 1]
    add al, 1
    mov [block_y + 1], al
    mov al, [block_y + 2]
    add al, 1
    mov [block_y + 2], al
    mov al, [block_y + 3]
    add al, 1
    mov [block_y + 3], al

    ; draw piece
    movzx eax, byte [block_b]
    push eax
    movzx eax, byte [block_g]
    push eax
    movzx eax, byte [block_r]
    push eax
    movzx eax, byte [block_y + 0]
    push eax
    movzx eax, byte [block_x + 0]
    push eax
    call _xdisp_set
    add esp, 5*4

    movzx eax, byte [block_b]
    push eax
    movzx eax, byte [block_g]
    push eax
    movzx eax, byte [block_r]
    push eax
    movzx eax, byte [block_y + 1]
    push eax
    movzx eax, byte [block_x + 1]
    push eax
    call _xdisp_set
    add esp, 5*4

    movzx eax, byte [block_b]
    push eax
    movzx eax, byte [block_g]
    push eax
    movzx eax, byte [block_r]
    push eax
    movzx eax, byte [block_y + 2]
    push eax
    movzx eax, byte [block_x + 2]
    push eax
    call _xdisp_set
    add esp, 5*4

    movzx eax, byte [block_b]
    push eax
    movzx eax, byte [block_g]
    push eax
    movzx eax, byte [block_r]
    push eax
    movzx eax, byte [block_y + 3]
    push eax
    movzx eax, byte [block_x + 3]
    push eax
    call _xdisp_set
    add esp, 5*4

    mov esp, ebp
    pop ebp
    ret

spawn_piece:
    push ebp
    mov ebp, esp

    rdtsc ; use clock as 'random number'
    and eax, 0x5
    mov [block_type], al
    cmp al, 0
    je .I
    cmp al, 1
    je .inv_L
    cmp al, 2
    je .L
    cmp al, 3
    je .Z

    .inv_Z:
    mov [block_r], byte 255
    mov [block_g], byte 255
    mov [block_b], byte 255

    mov [block_x + 0], byte 3
    mov [block_y + 0], byte 1
    mov [block_x + 1], byte 4
    mov [block_y + 1], byte 1
    mov [block_x + 2], byte 2
    mov [block_y + 2], byte 2
    mov [block_x + 3], byte 3
    mov [block_y + 3], byte 2

    jmp .e

    .I:
    mov [block_r], byte 255
    mov [block_g], byte 0
    mov [block_b], byte 0
    mov [block_x + 0], byte 3
    mov [block_y + 0], byte 1
    mov [block_x + 1], byte 4
    mov [block_y + 1], byte 1
    mov [block_x + 2], byte 1
    mov [block_y + 2], byte 2
    mov [block_x + 3], byte 1
    mov [block_y + 3], byte 2
    jmp .e

    .inv_L:
    mov [block_r], byte 0
    mov [block_g], byte 255
    mov [block_b], byte 0
    mov [block_x + 0], byte 4
    mov [block_y + 0], byte 1
    mov [block_x + 1], byte 3
    mov [block_y + 1], byte 1
    mov [block_x + 2], byte 3
    mov [block_y + 2], byte 2
    mov [block_x + 3], byte 3
    mov [block_x + 3], byte 3
    jmp .e

    .L:
    mov [block_r], byte 0
    mov [block_g], byte 0
    mov [block_b], byte 255
    mov [block_x + 0], byte 3
    mov [block_y + 0], byte 1
    mov [block_x + 1], byte 3
    mov [block_y + 1], byte 2
    mov [block_x + 2], byte 3
    mov [block_y + 2], byte 4
    mov [block_x + 3], byte 4
    mov [block_y + 3], byte 3
    jmp .e

    .Z:
    mov [block_r], byte 255
    mov [block_g], byte 255
    mov [block_b], byte 0
    mov [block_x + 0], byte 2
    mov [block_y + 0], byte 1
    mov [block_x + 1], byte 3
    mov [block_y + 1], byte 1
    mov [block_x + 2], byte 3
    mov [block_y + 2], byte 2
    mov [block_x + 3], byte 4
    mov [block_y + 3], byte 2

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
        mov [left_pressed], byte 1

        .right:
        mov cl, [right_held]
        call _xdisp_right_held
        mov [right_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .down ; no change
        cmp cl, 0 ; did we hold before?
        jne .down
        mov [right_pressed], byte 1

        .down:
        mov cl, [down_held]
        call _xdisp_down_held
        mov [down_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .up ; no change
        cmp cl, 0 ; did we hold before?
        jne .up
        mov [down_pressed], byte 1

        .up:
        mov cl, [up_held]
        call _xdisp_up_held
        mov [up_held], al
        xor al, cl ; eax 1 held status changed
        cmp al, 0 
        je .input_end ; no change
        cmp cl, 0 ; did we hold before?
        jne .input_end
        mov [up_pressed], byte 1

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
        mov [up_pressed], byte 0
        mov [down_pressed], byte 0
        mov [left_pressed], byte 0
        mov [right_pressed], byte 0

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
left_held: db 0
right_held: db 0
up_held: db 0
down_held: db 0
left_pressed: db 0
right_pressed: db 0
up_pressed: db 0
down_pressed: db 0

; window info
window_title: db "Tetris!", 0

; frame state
frame_start: dd 0.0
cur_time: dd 0.0
time_per_frame: dd 0.5

; gfx info
board_width equ 10
board_height equ 24
tile_size equ 32
tile_spacing equ 2

; game state
block_x: times 4 db 0
block_y: times 4 db 0
block_type: db 0 ; 0 = I, 1 = inv L, 2 = L, 3 = Z, 4 = inv Z, 5 = T
block_r: db 0
block_g: db 0
block_b: db 0
map: times board_width*board_height db 0 ; index is pos x * board_width + y
