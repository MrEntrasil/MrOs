#include "task.h"
#include <stddef.h>

task_t tasks[MAX_TASKS];
int current_task = 0;
int task_count = 1;
static uint8_t stacks[MAX_TASKS][4096];

void init_tasks(void) {
        tasks[0].active = TASK_RUNNING;

        asm volatile ("mov %%esp, %0" : "=r"(tasks[0].esp));
        asm volatile ("mov %%ebp, %0" : "=r"(tasks[0].ebp));

        tasks[0].eip = (uint32_t)&&resume_here;
        return;

resume_here:
        return;
}

__attribute__((noreturn))
void task_trampoline(void (*func)(void)) {
        func();

        tasks[current_task].active = TASK_BLOCKED;
        yield_task();

        while (1);
}

void create_task(void (*func)(void)) {
        if (task_count >= MAX_TASKS) return;

        task_t* t = &tasks[task_count];

        uint32_t* stack = (uint32_t*)&stacks[task_count][4096];

        *(--stack) = 0;
        *(--stack) = (uint32_t)func;

        t->esp = (uint32_t)stack;
        t->ebp = 0;
        t->eip = (uint32_t)task_trampoline;
        t->active = TASK_READY;

        task_count++;
}

void switch_task(task_t* old, task_t* new) {
        asm volatile (
                "mov %%esp, %0\n"
                "mov %%ebp, %1\n"
                : "=r"(old->esp), "=r"(old->ebp)
        );

        asm volatile (
                "mov %0, %%esp\n"
                "mov %1, %%ebp\n"
                :
                : "r"(new->esp), "r"(new->ebp)
        );

        asm volatile (
                "jmp *%0\n"
                :
                : "r"(new->eip)
        );
}

void yield_task(void) {
        if (task_count <= 1) return;
        int previous = current_task;
        int next = previous;

        do {
                next = (next + 1) % task_count;
                if (tasks[next].active == TASK_READY) break;
        } while (next != previous);

        if (next == previous) return;

        current_task = next;
        switch_task(&tasks[previous], &tasks[next]);
}
