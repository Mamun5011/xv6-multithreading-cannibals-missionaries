#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_clone(void){ int f,a,s; if(argint(0,&f)<0||argint(1,&a)<0||argint(2,&s)<0) return -1; return clone((void(*)(void*))f,(void*)a,(void*)s); }
int sys_join(void){ int wanted; char **p; if(argint(0,&wanted)<0 || argptr(1,(char**)&p,sizeof(void*))<0) return -1; return join(wanted,(void**)p); }
int sys_thread_exit(void){ thread_exit(); return 0; }
int sys_randconfig(void){ int seed,pct; if(argint(0,&seed)<0||argint(1,&pct)<0) return -1; random_config(seed,pct); return 0; }
int sys_yield(void){ yield(); return 0; }
int sys_lock_create(void){ return klock_create(); }
int sys_lock_acquire(void){ int id; if(argint(0,&id)<0) return -1; return klock_acquire(id); }
int sys_lock_release(void){ int id; if(argint(0,&id)<0) return -1; return klock_release(id); }
int sys_sem_create(void){ int v; if(argint(0,&v)<0) return -1; return ksem_create(v); }
int sys_sem_wait(void){ int id; if(argint(0,&id)<0) return -1; return ksem_wait(id); }
int sys_sem_post(void){ int id; if(argint(0,&id)<0) return -1; return ksem_post(id); }
