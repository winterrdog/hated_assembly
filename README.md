# hated_assembly
My practice assembly shell spawning scripts i wrote while learning reverse shells in assembly.
They(These scripts) don't have too much touch to them so u can modify them to your content if u wish. I used Intel syntax in them. 
They're for IA32/x86/i386 arch. It's also specific to the linux KERNEL.

Complied with `nasm` and then linked with `ld` because i was using a linux system. these are the commands i used in the process:
  
  `nasm -f elf32 -o filename.o filename.asm`
  
  `ld -o filename filename.o`

REF:
    
    SYSCALLS: https://syscalls.w3challs.com/?arch=x86_64
