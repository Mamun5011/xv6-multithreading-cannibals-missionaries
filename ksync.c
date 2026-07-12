#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

#define NKSYNC 64
struct kobj { int used, kind, value, owner; };
static struct spinlock ksync_lock;
static struct kobj objs[NKSYNC];
static int initialized;

static void ensureinit(void){ if(!initialized){ initlock(&ksync_lock, "ksync"); initialized=1; } }
static int create(int kind, int value){ int i; ensureinit(); acquire(&ksync_lock); for(i=0;i<NKSYNC;i++) if(!objs[i].used){ objs[i].used=1; objs[i].kind=kind; objs[i].value=value; objs[i].owner=0; release(&ksync_lock); return i; } release(&ksync_lock); return -1; }
int klock_create(void){ return create(1,1); }
int klock_acquire(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=1){ release(&ksync_lock); return -1; } while(objs[id].value==0){ if(myproc()->killed){ release(&ksync_lock); return -1; } sleep(&objs[id], &ksync_lock); } objs[id].value=0; objs[id].owner=myproc()->pid; release(&ksync_lock); return 0; }
int klock_release(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=1||objs[id].value!=0){ release(&ksync_lock); return -1; } objs[id].owner=0; objs[id].value=1; wakeup(&objs[id]); release(&ksync_lock); return 0; }
int ksem_create(int value){ }
int ksem_wait(int id){ }
int ksem_post(int id){ }
