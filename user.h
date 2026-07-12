struct stat;
struct rtcdate;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int clone(void (*)(void*), void*, void*);
int join(int, void**);
int thread_exit(void) __attribute__((noreturn));
int randconfig(uint, int);
int yield(void);
int lock_create(void);
int lock_acquire(int);
int lock_release(int);
int sem_create(int);
int sem_wait(int);
int sem_post(int);

// Small POSIX-like teaching API.
typedef int pthread_t;
typedef int pthread_mutex_t;
typedef int sem_t;
int pthread_create(pthread_t*, void*, void *(*)(void*), void*);
int pthread_join(pthread_t, void**);
void pthread_exit(void*) __attribute__((noreturn));
int pthread_mutex_init(pthread_mutex_t*, void*);
int pthread_mutex_lock(pthread_mutex_t*);
int pthread_mutex_unlock(pthread_mutex_t*);
int sem_init(sem_t*, int, unsigned);
int sem_wait_u(sem_t*);
int sem_post_u(sem_t*);
void stochastic_schedule(uint seed, int percent);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
