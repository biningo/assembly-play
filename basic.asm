assume cs:codesg
codesg segment
    mov ax,18          ; ax=0012H
    mov ah,78          ; ah=4eH
    mov ax,4E20H
    mov bx,1000H
    mov ax,bx          ; ax=bx
codesg ends

; 问题2.1
codesg segment
    mov ax,001AH      ; ax=001AH
    mov bx,0026H   ; bx=0026H
    add al,bl      ; ax=0040H
    add ah,bl      ; ax=2640H
    add bh,al      ; bx=4026H
    mov ah,0       ; ax=0040H
    add al,85H     ; ax=00C5H
codesg ends

; jmp
codesg segment
    jmp 2AE3H:3H   ; CS=2AE3H IP=003H;
    mov ax,1000H
    jmp ax         ; IP=1000H
    jmp ax:0       ; CS=1000H IP=0000H
codesg ends

; ds []
codesg segment
    mov bx,1000H
    mov ds,ax      ; ds=1000H
    mov al,[0]     ; al=[1000H]
    mov ah,[1]     ; ah=[1001H]
    mov ax,[0]     ; ax=[1000H~1001H]
codesg ends

; 问题3.3
codesg segment
    mov ax,1000H
    mov ds,ax
    mov ax,[0]       ; ax=[1000~1001H]
    mov bx,[2]       ; bx=[1002H~1003H]
    mov cx,[1]       ; cx=[1001H~1002H]
    add bx,[1]       ; bx=[1001H~1002H]
codesg ends
; 问题3.4
codesg segment
    mov ax,1000H
    mov ds,ax
    mov ax,11316     ; ax=2C34H
    mov [0],ax       ; [1000H]=2C34H
    mov bx,[0]       ; bx=2C34H
    sub bx,[2]       ; bx=bx-[1002H~1003H]=1B12H
    mov [2],bx       ; [1002H~1003H]=1B12H
codesg ends


; ss sp栈
; 问题3.7
codesg segment
    mov ax,1000H
    mov ss,ax
    mov sp,0010H
    push ax
    push bx
    push ds
codesg ends
; 问题3.8
codesg segment
    mov ax,1000H
    mov ss,ax
    mov sp,0010H

    mov ax,001AH
    mov bx,001BH

    push ax
    push bx
    mov ax,0      ; 清空
    mov bx,0      ; 清空
    pop bx        ; 注意顺序
    pop ax
codesg ends

; 2^3
abc segment
    mov ax,2
    add ax,ax
    add ax,ax
abc ends

; [bx] loop () [bx+2] ...
codesg segment
    mov ax,1000H
    mov ds,ax
    mov bx,0001H

    ; (ax)=((ds)*16+(bx))
    mov ax,[bx]         ; ax=[1000H~1001H] ;偏移地址用bx寄存器的内容
codesg ends

; 问题5.1
codesg segment
    mov ax,2000H
    mov ds,ax
    mov bx,1000H
    mov ax,[bx]         ; ax=(ds)*16+(bx)
; 偏移2字节
    inc bx
    inc bx
    mov [bx],ax         ; (ds)*16+(bx)=ax
codesg ends


; 2^12
codesg segment
    mov ax,2
    mov cx,11         ; cx存放循环次数 每次loop时都会减1 cx值为0则结束循环直接往下执行
s:  add ax,ax         ; s只是一个伪指令 代表这行指令的地址
    loop s            ; cx=cx-1  (if cx=0 不跳转)
codesg ends


; 123*236 加法计算
codesg segment
    mov ax,0
    mov cx,236
s:  add ax,123
    loop s
codesg ends


; 段前缀
codesg segment
    mov ax,cs:[0]     ; 将 cs:[0] 这段内存地址中的内容送到ax
    mov ax,ds:[bx]    ; 同理 只不过偏移地址在bx中
    mov ax,ds:[1]
codesg ends


; dw db
codesg segment
    dw 0123H,0456H,0789H,0ABCH,0DEFH，0FEDH，0CBAH,0987H  ; 定义8个字(8个2字节数据) 存放在cs:0~F中
start:  mov bx,0                                        ; 入口地址
        mov ax,0
        mov cx,8

s:      add ax,cs:[bx]
        add bx,2                                        ; 每次偏移2字节 循环8次
        loop s

        mov ax,4C00H
        int 21H

codesg ends

end start                                               ; 结束

codesg segment
    db 'abc' ;相当于 db 97,98,99
ends


; 程序6.3 栈和字
codesg segment
    dw 0123H,0456H,0789H,0ABCH,0DEFH，0FEDH，0CBAH,0987H  ; 定义8个字  IP=0010H=16
    dw 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0                 ; 定义16个字 此时IP=0030H=48
start:  mov ax,cs
        mov ss,ax
        mov sp,30H         ; 注意栈是向下的
        mov bx,0           ; 偏移量
        mov cx,8           ; 循环次数
    s:  push cs:[bx]
        add bx,2           ; 偏移一个字
        loop s

        mov bx,0
        mov cx,8
    s0: pop cs:[bx]
        add bx,2
        loop s0
codesg ends


; 分段管理
data segment
    dw 0123H,0456H,0789H,0ABCH,0DEFH，0FEDH，0CBAH,0987H          ; 定义8个字  IP=0010H=16
data ends

stack segment
    dw 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0  ; 定义16个字 此时IP=0030H=48
stack ends

code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,20H                       ; 设置栈段

        mov ax,data                      ; 设置数据段
        mov ds,ax

        mov bx,0                         ; 偏移量
        mov cx,8                         ; 循环次数
    s:  push [bx]
        add bx,2                         ; 偏移一个字
        loop s

        mov bx,0
        mov cx,8
    s0: pop [bx]
        add bx,2
        loop s0
code ends

; and or
codesg segment
    mov al,00011100B
    and al,11011011B             ; al=00011000B
    or  al,11111101B
codesg ends


;word byte
codesg segment
    mov word ptr ds:[0],1 ; 传输字
    mov byte ptr ds:[0],1 ;传输字节
codesg ends

;call ret
;ret:(IP)=(ss)*16+(sp) (sp)=(sp)+2
;call: (sp)=(sp)-2 ((ss)*16+(sp))=(IP) 将当前IP值入栈 转到标号处执行
code segment
    start: mov ax,1
           mov cx,3
           call s
           mov bx,ax ;将计算完毕之后的值保存到此处
           mov ax,4c00h
           int 21H
        s: add ax,ax ;循环3次  ax=ax*3
           loop s
           ret  
code ends


;标识寄存器 PSW 16位 存储相关指令的结果 控制CPU工作方式等


;shr shl 位移指令
code segment
    mov al,00000001B
    shl al,1 ;左移
    shr al,1 ;右移
code ends


; in out 操作外设寄存器
; int 调用中断程序