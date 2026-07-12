# xv6 User Threads and Stochastic Synchronization Environment

This instructor solution extends the classic xv6/x86 tree with kernel-scheduled
user threads, blocking mutexes and semaphores, deterministic stochastic yields,
and a complete missionaries-and-cannibals solution.

## Build and run

```sh
make clean
make
make qemu-nox
```

At the xv6 shell:

```sh
missionaries 1 35
missionaries 42 60
missionaries 999 90
```

The first argument is the deterministic random seed. The second is the percent
chance (0-100) of yielding at each safe syscall boundary. `write` is excluded,
so one xv6 `printf` call is not interrupted in the middle of its underlying
write syscall. Different seeds produce different repeatable schedules.

Expected final line:

```
PASS: all 12 passengers crossed in four safe full boats
```

Every `ROW` line must show one of these legal combinations:

* M=3 C=0
* M=0 C=3
* M=2 C=1

The forbidden M=1 C=2 combination must never occur.

## Added interfaces

### Kernel thread syscalls

* `clone(fn, arg, page_aligned_stack)`
* `join(tid, &stack)`
* `thread_exit()`
* `yield()`
* `randconfig(seed, probability_percent)`

Threads are represented by xv6 `struct proc` entries and share a page table.
Each thread has its own kernel stack, user stack, trap frame, and scheduler
state. `join` reaps a specified thread.

### POSIX-like user API

Declared in `user.h` and implemented in `pthread.c`:

* `pthread_create`
* `pthread_join`
* `pthread_exit`
* `pthread_mutex_init`, `pthread_mutex_lock`, `pthread_mutex_unlock`
* `sem_init`, `sem_wait_u`, `sem_post_u`
* `stochastic_schedule`

The semaphore wait/post names use `_u` because xv6 already exposes syscall
stubs named `sem_wait` and `sem_post`.

### Blocking kernel synchronization objects

`ksync.c` provides fixed-size kernel tables for mutexes and counting
semaphores. Waiting threads sleep on kernel channels; there is no busy waiting.
The mutex syscall is intentionally a blocking teaching mutex rather than an
actual user-exposed kernel spinlock. Sleeping while holding a spinlock would be
incorrect.

## Main changed files

* `proc.h`, `proc.c`, `defs.h`: thread metadata, clone/join/exit, PRNG policy
* `syscall.h`, `syscall.c`, `sysproc.c`, `usys.S`: new system calls
* `ksync.c`: mutex and semaphore kernel objects
* `pthread.c`, `user.h`: POSIX-like user-facing wrapper
* `missionaries.c`: solved synchronization problem
* `Makefile`: builds the new kernel object, library, and user program

## Scheduling calibration

Stochastic switching occurs after completed syscalls except `write`, explicit
`yield`, and terminating syscalls. This gives frequent adversarial schedules
around synchronization operations while preserving each individual output
line. Use 20-40% for ordinary grading and 70-95% for stress testing.

## Scope and teaching constraints

This is a compact xv6 teaching implementation, not a complete Linux pthreads
implementation. Programs should create all threads before the main thread
exits, join every thread, and avoid concurrent calls to xv6's original user
heap allocator unless protected by a mutex. The included wrapper allocates
thread stacks before execution and intentionally does not reclaim those small
allocations during the short-lived test process.
