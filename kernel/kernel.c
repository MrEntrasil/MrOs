void main() {
        char* video = (char*)0xb8000;
        const char* msg = "Kernel control";
        for (int i = 0;msg[i];i++) {
                video[i * 2] = msg[i];
                video[i * 2 + 1] = 0x0F;
        }

        while (1) {}
}
