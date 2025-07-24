#include "task.h"

void task_a() {
        while (1) {
                volatile char* vga = (char*)0xB8000;
                vga[0] = 'b';
                vga[1] = 0x0F;
                for (volatile int i = 0;i < 1000000;i++);
                yield_task();
        }
}

void task_b() {
        while (1) {
                volatile char* vga = (char*)0xB8000;
                vga[2] = 'a';
                vga[3] = 0x0F;
                for (volatile int i = 0;i < 1000000;i++);
                yield_task();
        }
}

void main() {
        init_tasks();
        create_task(task_a);
        create_task(task_b);

        while (1) {
                yield_task();
        };
}
