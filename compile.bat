nasm -f bin stage1.asm
nasm -f bin stage2.asm
copy /b stage1+stage2 os.bin