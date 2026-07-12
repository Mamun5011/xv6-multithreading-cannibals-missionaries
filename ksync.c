#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

#define NKSYNC 64

struct kobj {  //process
  int used;
  int kind;
  int value;  //count for the process
  int owner;
};

static struct spinlock ksync_lock;
static struct kobj objs[NKSYNC];
static int initialized;

static void
ensureinit(void)
{
  if(!initialized){
    initlock(&ksync_lock, "ksync");
    initialized = 1;
  }
}

static int
create(int kind, int value)
{
  int i;

  ensureinit();
  acquire(&ksync_lock);

  for(i = 0; i < NKSYNC; i++){
    if(!objs[i].used){
      objs[i].used = 1;
      objs[i].kind = kind;
      objs[i].value = value;
      objs[i].owner = 0;

      release(&ksync_lock);
      return i;
    }
  }

  release(&ksync_lock);
  return -1;
}

int
ksem_create(int value)
{
/**
1. if initial_count is invalid: (Reject a negative initial value by returning -1)
       return error
2. return allocate object(kind = SEMAPHORE, value = initial_count)
     - Allocate one object-table slot using the existing internal create helper
     - Mark the object as a semaphore by passing kind 2 and value as initial count.

**/
  
}

int
ksem_wait(int id)
{

/**
1.initialize subsystem if needed
2.validate id range (Reject identifiers outside the range between 0 to NKSYNC-1) otherwise, return error
3. acquire global synchronization-object lock by  acquire(&lock_instance);
4. release the lock and return error (-1) if slot is not allocated and is  not a semaphore 
5. while value is 0:
       if caller has been killed:
          release lock (release(&lock_instance))
          return error
       sleep on this object's address, atomically releasing the lock
       // lock is held again after sleep returns (sleep(&currentProcess, &lock_instance);
6.decrement count
7.release lock
8.return success (0)
**/

}

int
ksem_post(int id)
{

/**
1. initialize subsystem if needed
2. validate id range (Reject identifiers outside the range between 0 to NKSYNC-1) otherwise, return error
3. acquire global synchronization-object lock by  acquire(&lock_instance);
4. release the lock and return error (-1) if slot is not allocated and is  not a semaphore 
5. increment count against the on this object
6.  
   * Wake threads sleeping on this semaphore.
   * All awakened threads recheck the while condition,
   * so only a thread that observes value > 0 proceeds. 
   hints: use wakeup(&&currentProcess)
7. release lock
8. return success
**/
 
}
