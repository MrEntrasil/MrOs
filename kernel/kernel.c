void print(const char* msg) {
        for (int i = 0; msg[i]; i++) {
                char* video = (char*)0xB8000;
                video[i * 2] = msg[i];
                video[i * 2 + 1] = 0x0F;
        }
}

void main() {
        print("Kernel succefull loaded!");

        while (1);
}
