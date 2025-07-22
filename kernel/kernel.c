void main() {
        char* vga = (char*)0xB8000;
        vga[0] = 'F';
        vga[1] = 0x0F;
        while (1);
}
