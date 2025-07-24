#ifndef TASK_H
#define TASK_H

#include <stdint.h>

#define MAX_TASKS    4
#define TASK_READY   0
#define TASK_RUNNING 1
#define TASK_BLOCKED 2

typedef struct {
        uint32_t esp;
        uint32_t ebp;
        uint32_t eip;
        uint8_t active;
} task_t;

void init_tasks(void);
void create_task(void (*func)(void));
void yield_task(void);

extern int current_task;
extern int task_count;

#endif
