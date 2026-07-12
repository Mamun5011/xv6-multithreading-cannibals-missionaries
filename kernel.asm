
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 7e 11 80       	mov    $0x80117e60,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e1 3c 10 80       	mov    $0x80103ce1,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 04 90 10 80       	push   $0x80109004
80100042:	68 c0 c5 10 80       	push   $0x8010c5c0
80100047:	e8 96 59 00 00       	call   801059e2 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100056:	0c 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100060:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 f4 c5 10 80 	movl   $0x8010c5f4,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 10 0d 11 80    	mov    0x80110d10,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 0b 90 10 80       	push   $0x8010900b
80100090:	50                   	push   %eax
80100091:	e8 c9 57 00 00       	call   8010585f <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 10 0d 11 80       	mov    %eax,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
  }
}
801000bd:	90                   	nop
801000be:	90                   	nop
801000bf:	c9                   	leave
801000c0:	c3                   	ret

801000c1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c1:	55                   	push   %ebp
801000c2:	89 e5                	mov    %esp,%ebp
801000c4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c7:	83 ec 0c             	sub    $0xc,%esp
801000ca:	68 c0 c5 10 80       	push   $0x8010c5c0
801000cf:	e8 30 59 00 00       	call   80105a04 <acquire>
801000d4:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d7:	a1 10 0d 11 80       	mov    0x80110d10,%eax
801000dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000df:	eb 58                	jmp    80100139 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e4:	8b 40 04             	mov    0x4(%eax),%eax
801000e7:	39 45 08             	cmp    %eax,0x8(%ebp)
801000ea:	75 44                	jne    80100130 <bget+0x6f>
801000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ef:	8b 40 08             	mov    0x8(%eax),%eax
801000f2:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000f5:	75 39                	jne    80100130 <bget+0x6f>
      b->refcnt++;
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fd:	8d 50 01             	lea    0x1(%eax),%edx
80100100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100103:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100106:	83 ec 0c             	sub    $0xc,%esp
80100109:	68 c0 c5 10 80       	push   $0x8010c5c0
8010010e:	e8 5f 59 00 00       	call   80105a72 <release>
80100113:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100119:	83 c0 0c             	add    $0xc,%eax
8010011c:	83 ec 0c             	sub    $0xc,%esp
8010011f:	50                   	push   %eax
80100120:	e8 76 57 00 00       	call   8010589b <acquiresleep>
80100125:	83 c4 10             	add    $0x10,%esp
      return b;
80100128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012b:	e9 9d 00 00 00       	jmp    801001cd <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	8b 40 54             	mov    0x54(%eax),%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	81 7d f4 bc 0c 11 80 	cmpl   $0x80110cbc,-0xc(%ebp)
80100140:	75 9f                	jne    801000e1 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100142:	a1 0c 0d 11 80       	mov    0x80110d0c,%eax
80100147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014a:	eb 6b                	jmp    801001b7 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014f:	8b 40 4c             	mov    0x4c(%eax),%eax
80100152:	85 c0                	test   %eax,%eax
80100154:	75 58                	jne    801001ae <bget+0xed>
80100156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100159:	8b 00                	mov    (%eax),%eax
8010015b:	83 e0 04             	and    $0x4,%eax
8010015e:	85 c0                	test   %eax,%eax
80100160:	75 4c                	jne    801001ae <bget+0xed>
      b->dev = dev;
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 55 08             	mov    0x8(%ebp),%edx
80100168:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016e:	8b 55 0c             	mov    0xc(%ebp),%edx
80100171:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100180:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100187:	83 ec 0c             	sub    $0xc,%esp
8010018a:	68 c0 c5 10 80       	push   $0x8010c5c0
8010018f:	e8 de 58 00 00       	call   80105a72 <release>
80100194:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010019a:	83 c0 0c             	add    $0xc,%eax
8010019d:	83 ec 0c             	sub    $0xc,%esp
801001a0:	50                   	push   %eax
801001a1:	e8 f5 56 00 00       	call   8010589b <acquiresleep>
801001a6:	83 c4 10             	add    $0x10,%esp
      return b;
801001a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ac:	eb 1f                	jmp    801001cd <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b1:	8b 40 50             	mov    0x50(%eax),%eax
801001b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b7:	81 7d f4 bc 0c 11 80 	cmpl   $0x80110cbc,-0xc(%ebp)
801001be:	75 8c                	jne    8010014c <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001c0:	83 ec 0c             	sub    $0xc,%esp
801001c3:	68 12 90 10 80       	push   $0x80109012
801001c8:	e8 e6 03 00 00       	call   801005b3 <panic>
}
801001cd:	c9                   	leave
801001ce:	c3                   	ret

801001cf <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001cf:	55                   	push   %ebp
801001d0:	89 e5                	mov    %esp,%ebp
801001d2:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d5:	83 ec 08             	sub    $0x8,%esp
801001d8:	ff 75 0c             	push   0xc(%ebp)
801001db:	ff 75 08             	push   0x8(%ebp)
801001de:	e8 de fe ff ff       	call   801000c1 <bget>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ec:	8b 00                	mov    (%eax),%eax
801001ee:	83 e0 02             	and    $0x2,%eax
801001f1:	85 c0                	test   %eax,%eax
801001f3:	75 0e                	jne    80100203 <bread+0x34>
    iderw(b);
801001f5:	83 ec 0c             	sub    $0xc,%esp
801001f8:	ff 75 f4             	push   -0xc(%ebp)
801001fb:	e8 5b 27 00 00       	call   8010295b <iderw>
80100200:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100203:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100206:	c9                   	leave
80100207:	c3                   	ret

80100208 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100208:	55                   	push   %ebp
80100209:	89 e5                	mov    %esp,%ebp
8010020b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	83 c0 0c             	add    $0xc,%eax
80100214:	83 ec 0c             	sub    $0xc,%esp
80100217:	50                   	push   %eax
80100218:	e8 30 57 00 00       	call   8010594d <holdingsleep>
8010021d:	83 c4 10             	add    $0x10,%esp
80100220:	85 c0                	test   %eax,%eax
80100222:	75 0d                	jne    80100231 <bwrite+0x29>
    panic("bwrite");
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	68 23 90 10 80       	push   $0x80109023
8010022c:	e8 82 03 00 00       	call   801005b3 <panic>
  b->flags |= B_DIRTY;
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 c8 04             	or     $0x4,%eax
80100239:	89 c2                	mov    %eax,%edx
8010023b:	8b 45 08             	mov    0x8(%ebp),%eax
8010023e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	ff 75 08             	push   0x8(%ebp)
80100246:	e8 10 27 00 00       	call   8010295b <iderw>
8010024b:	83 c4 10             	add    $0x10,%esp
}
8010024e:	90                   	nop
8010024f:	c9                   	leave
80100250:	c3                   	ret

80100251 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100251:	55                   	push   %ebp
80100252:	89 e5                	mov    %esp,%ebp
80100254:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100257:	8b 45 08             	mov    0x8(%ebp),%eax
8010025a:	83 c0 0c             	add    $0xc,%eax
8010025d:	83 ec 0c             	sub    $0xc,%esp
80100260:	50                   	push   %eax
80100261:	e8 e7 56 00 00       	call   8010594d <holdingsleep>
80100266:	83 c4 10             	add    $0x10,%esp
80100269:	85 c0                	test   %eax,%eax
8010026b:	75 0d                	jne    8010027a <brelse+0x29>
    panic("brelse");
8010026d:	83 ec 0c             	sub    $0xc,%esp
80100270:	68 2a 90 10 80       	push   $0x8010902a
80100275:	e8 39 03 00 00       	call   801005b3 <panic>

  releasesleep(&b->lock);
8010027a:	8b 45 08             	mov    0x8(%ebp),%eax
8010027d:	83 c0 0c             	add    $0xc,%eax
80100280:	83 ec 0c             	sub    $0xc,%esp
80100283:	50                   	push   %eax
80100284:	e8 76 56 00 00       	call   801058ff <releasesleep>
80100289:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028c:	83 ec 0c             	sub    $0xc,%esp
8010028f:	68 c0 c5 10 80       	push   $0x8010c5c0
80100294:	e8 6b 57 00 00       	call   80105a04 <acquire>
80100299:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a5:	8b 45 08             	mov    0x8(%ebp),%eax
801002a8:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 47                	jne    801002fc <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b5:	8b 45 08             	mov    0x8(%ebp),%eax
801002b8:	8b 40 54             	mov    0x54(%eax),%eax
801002bb:	8b 55 08             	mov    0x8(%ebp),%edx
801002be:	8b 52 50             	mov    0x50(%edx),%edx
801002c1:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c4:	8b 45 08             	mov    0x8(%ebp),%eax
801002c7:	8b 40 50             	mov    0x50(%eax),%eax
801002ca:	8b 55 08             	mov    0x8(%ebp),%edx
801002cd:	8b 52 54             	mov    0x54(%edx),%edx
801002d0:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d3:	8b 15 10 0d 11 80    	mov    0x80110d10,%edx
801002d9:	8b 45 08             	mov    0x8(%ebp),%eax
801002dc:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002df:	8b 45 08             	mov    0x8(%ebp),%eax
801002e2:	c7 40 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%eax)
    bcache.head.next->prev = b;
801002e9:	a1 10 0d 11 80       	mov    0x80110d10,%eax
801002ee:	8b 55 08             	mov    0x8(%ebp),%edx
801002f1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f4:	8b 45 08             	mov    0x8(%ebp),%eax
801002f7:	a3 10 0d 11 80       	mov    %eax,0x80110d10
  }
  
  release(&bcache.lock);
801002fc:	83 ec 0c             	sub    $0xc,%esp
801002ff:	68 c0 c5 10 80       	push   $0x8010c5c0
80100304:	e8 69 57 00 00       	call   80105a72 <release>
80100309:	83 c4 10             	add    $0x10,%esp
}
8010030c:	90                   	nop
8010030d:	c9                   	leave
8010030e:	c3                   	ret

8010030f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030f:	55                   	push   %ebp
80100310:	89 e5                	mov    %esp,%ebp
80100312:	83 ec 14             	sub    $0x14,%esp
80100315:	8b 45 08             	mov    0x8(%ebp),%eax
80100318:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100320:	89 c2                	mov    %eax,%edx
80100322:	ec                   	in     (%dx),%al
80100323:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100326:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010032a:	c9                   	leave
8010032b:	c3                   	ret

8010032c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032c:	55                   	push   %ebp
8010032d:	89 e5                	mov    %esp,%ebp
8010032f:	83 ec 08             	sub    $0x8,%esp
80100332:	8b 55 08             	mov    0x8(%ebp),%edx
80100335:	8b 45 0c             	mov    0xc(%ebp),%eax
80100338:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100343:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100347:	ee                   	out    %al,(%dx)
}
80100348:	90                   	nop
80100349:	c9                   	leave
8010034a:	c3                   	ret

8010034b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034b:	55                   	push   %ebp
8010034c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034e:	fa                   	cli
}
8010034f:	90                   	nop
80100350:	5d                   	pop    %ebp
80100351:	c3                   	ret

80100352 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100352:	55                   	push   %ebp
80100353:	89 e5                	mov    %esp,%ebp
80100355:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035c:	74 1c                	je     8010037a <printint+0x28>
8010035e:	8b 45 08             	mov    0x8(%ebp),%eax
80100361:	c1 e8 1f             	shr    $0x1f,%eax
80100364:	0f b6 c0             	movzbl %al,%eax
80100367:	89 45 10             	mov    %eax,0x10(%ebp)
8010036a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036e:	74 0a                	je     8010037a <printint+0x28>
    x = -xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	f7 d8                	neg    %eax
80100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100378:	eb 06                	jmp    80100380 <printint+0x2e>
  else
    x = xx;
8010037a:	8b 45 08             	mov    0x8(%ebp),%eax
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010038a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010038d:	ba 00 00 00 00       	mov    $0x0,%edx
80100392:	f7 f1                	div    %ecx
80100394:	89 d1                	mov    %edx,%ecx
80100396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100399:	8d 50 01             	lea    0x1(%eax),%edx
8010039c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010039f:	0f b6 91 04 a0 10 80 	movzbl -0x7fef5ffc(%ecx),%edx
801003a6:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b0:	ba 00 00 00 00       	mov    $0x0,%edx
801003b5:	f7 f1                	div    %ecx
801003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003be:	75 c7                	jne    80100387 <printint+0x35>

  if(sign)
801003c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c4:	74 2a                	je     801003f0 <printint+0x9e>
    buf[i++] = '-';
801003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c9:	8d 50 01             	lea    0x1(%eax),%edx
801003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003cf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d4:	eb 1a                	jmp    801003f0 <printint+0x9e>
    consputc(buf[i]);
801003d6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003dc:	01 d0                	add    %edx,%eax
801003de:	0f b6 00             	movzbl (%eax),%eax
801003e1:	0f be c0             	movsbl %al,%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 f4 03 00 00       	call   801007e1 <consputc>
801003ed:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f8:	79 dc                	jns    801003d6 <printint+0x84>
}
801003fa:	90                   	nop
801003fb:	90                   	nop
801003fc:	c9                   	leave
801003fd:	c3                   	ret

801003fe <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003fe:	55                   	push   %ebp
801003ff:	89 e5                	mov    %esp,%ebp
80100401:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100404:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
80100409:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100410:	74 10                	je     80100422 <cprintf+0x24>
    acquire(&cons.lock);
80100412:	83 ec 0c             	sub    $0xc,%esp
80100415:	68 c0 0f 11 80       	push   $0x80110fc0
8010041a:	e8 e5 55 00 00       	call   80105a04 <acquire>
8010041f:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100422:	8b 45 08             	mov    0x8(%ebp),%eax
80100425:	85 c0                	test   %eax,%eax
80100427:	75 0d                	jne    80100436 <cprintf+0x38>
    panic("null fmt");
80100429:	83 ec 0c             	sub    $0xc,%esp
8010042c:	68 31 90 10 80       	push   $0x80109031
80100431:	e8 7d 01 00 00       	call   801005b3 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100436:	8d 45 0c             	lea    0xc(%ebp),%eax
80100439:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100443:	e9 2f 01 00 00       	jmp    80100577 <cprintf+0x179>
    if(c != '%'){
80100448:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044c:	74 13                	je     80100461 <cprintf+0x63>
      consputc(c);
8010044e:	83 ec 0c             	sub    $0xc,%esp
80100451:	ff 75 e4             	push   -0x1c(%ebp)
80100454:	e8 88 03 00 00       	call   801007e1 <consputc>
80100459:	83 c4 10             	add    $0x10,%esp
      continue;
8010045c:	e9 12 01 00 00       	jmp    80100573 <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100461:	8b 55 08             	mov    0x8(%ebp),%edx
80100464:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010046b:	01 d0                	add    %edx,%eax
8010046d:	0f b6 00             	movzbl (%eax),%eax
80100470:	0f be c0             	movsbl %al,%eax
80100473:	25 ff 00 00 00       	and    $0xff,%eax
80100478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010047b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010047f:	0f 84 14 01 00 00    	je     80100599 <cprintf+0x19b>
      break;
    switch(c){
80100485:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100489:	74 5e                	je     801004e9 <cprintf+0xeb>
8010048b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010048f:	0f 8f c2 00 00 00    	jg     80100557 <cprintf+0x159>
80100495:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100499:	74 6b                	je     80100506 <cprintf+0x108>
8010049b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010049f:	0f 8f b2 00 00 00    	jg     80100557 <cprintf+0x159>
801004a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a9:	74 3e                	je     801004e9 <cprintf+0xeb>
801004ab:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004af:	0f 8f a2 00 00 00    	jg     80100557 <cprintf+0x159>
801004b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004b9:	0f 84 89 00 00 00    	je     80100548 <cprintf+0x14a>
801004bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004c3:	0f 85 8e 00 00 00    	jne    80100557 <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
801004c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004cc:	8d 50 04             	lea    0x4(%eax),%edx
801004cf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d2:	8b 00                	mov    (%eax),%eax
801004d4:	83 ec 04             	sub    $0x4,%esp
801004d7:	6a 01                	push   $0x1
801004d9:	6a 0a                	push   $0xa
801004db:	50                   	push   %eax
801004dc:	e8 71 fe ff ff       	call   80100352 <printint>
801004e1:	83 c4 10             	add    $0x10,%esp
      break;
801004e4:	e9 8a 00 00 00       	jmp    80100573 <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ec:	8d 50 04             	lea    0x4(%eax),%edx
801004ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f2:	8b 00                	mov    (%eax),%eax
801004f4:	83 ec 04             	sub    $0x4,%esp
801004f7:	6a 00                	push   $0x0
801004f9:	6a 10                	push   $0x10
801004fb:	50                   	push   %eax
801004fc:	e8 51 fe ff ff       	call   80100352 <printint>
80100501:	83 c4 10             	add    $0x10,%esp
      break;
80100504:	eb 6d                	jmp    80100573 <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
80100506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100509:	8d 50 04             	lea    0x4(%eax),%edx
8010050c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010050f:	8b 00                	mov    (%eax),%eax
80100511:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100518:	75 22                	jne    8010053c <cprintf+0x13e>
        s = "(null)";
8010051a:	c7 45 ec 3a 90 10 80 	movl   $0x8010903a,-0x14(%ebp)
      for(; *s; s++)
80100521:	eb 19                	jmp    8010053c <cprintf+0x13e>
        consputc(*s);
80100523:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100526:	0f b6 00             	movzbl (%eax),%eax
80100529:	0f be c0             	movsbl %al,%eax
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	50                   	push   %eax
80100530:	e8 ac 02 00 00       	call   801007e1 <consputc>
80100535:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100538:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010053f:	0f b6 00             	movzbl (%eax),%eax
80100542:	84 c0                	test   %al,%al
80100544:	75 dd                	jne    80100523 <cprintf+0x125>
      break;
80100546:	eb 2b                	jmp    80100573 <cprintf+0x175>
    case '%':
      consputc('%');
80100548:	83 ec 0c             	sub    $0xc,%esp
8010054b:	6a 25                	push   $0x25
8010054d:	e8 8f 02 00 00       	call   801007e1 <consputc>
80100552:	83 c4 10             	add    $0x10,%esp
      break;
80100555:	eb 1c                	jmp    80100573 <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100557:	83 ec 0c             	sub    $0xc,%esp
8010055a:	6a 25                	push   $0x25
8010055c:	e8 80 02 00 00       	call   801007e1 <consputc>
80100561:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100564:	83 ec 0c             	sub    $0xc,%esp
80100567:	ff 75 e4             	push   -0x1c(%ebp)
8010056a:	e8 72 02 00 00       	call   801007e1 <consputc>
8010056f:	83 c4 10             	add    $0x10,%esp
      break;
80100572:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100573:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100577:	8b 55 08             	mov    0x8(%ebp),%edx
8010057a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010057d:	01 d0                	add    %edx,%eax
8010057f:	0f b6 00             	movzbl (%eax),%eax
80100582:	0f be c0             	movsbl %al,%eax
80100585:	25 ff 00 00 00       	and    $0xff,%eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100591:	0f 85 b1 fe ff ff    	jne    80100448 <cprintf+0x4a>
80100597:	eb 01                	jmp    8010059a <cprintf+0x19c>
      break;
80100599:	90                   	nop
    }
  }

  if(locking)
8010059a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010059e:	74 10                	je     801005b0 <cprintf+0x1b2>
    release(&cons.lock);
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 c0 0f 11 80       	push   $0x80110fc0
801005a8:	e8 c5 54 00 00       	call   80105a72 <release>
801005ad:	83 c4 10             	add    $0x10,%esp
}
801005b0:	90                   	nop
801005b1:	c9                   	leave
801005b2:	c3                   	ret

801005b3 <panic>:

void
panic(char *s)
{
801005b3:	55                   	push   %ebp
801005b4:	89 e5                	mov    %esp,%ebp
801005b6:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005b9:	e8 8d fd ff ff       	call   8010034b <cli>
  cons.locking = 0;
801005be:	c7 05 f4 0f 11 80 00 	movl   $0x0,0x80110ff4
801005c5:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005c8:	e8 a9 2e 00 00       	call   80103476 <lapicid>
801005cd:	83 ec 08             	sub    $0x8,%esp
801005d0:	50                   	push   %eax
801005d1:	68 41 90 10 80       	push   $0x80109041
801005d6:	e8 23 fe ff ff       	call   801003fe <cprintf>
801005db:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005de:	8b 45 08             	mov    0x8(%ebp),%eax
801005e1:	83 ec 0c             	sub    $0xc,%esp
801005e4:	50                   	push   %eax
801005e5:	e8 14 fe ff ff       	call   801003fe <cprintf>
801005ea:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005ed:	83 ec 0c             	sub    $0xc,%esp
801005f0:	68 55 90 10 80       	push   $0x80109055
801005f5:	e8 04 fe ff ff       	call   801003fe <cprintf>
801005fa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005fd:	83 ec 08             	sub    $0x8,%esp
80100600:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100603:	50                   	push   %eax
80100604:	8d 45 08             	lea    0x8(%ebp),%eax
80100607:	50                   	push   %eax
80100608:	e8 b7 54 00 00       	call   80105ac4 <getcallerpcs>
8010060d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100610:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100617:	eb 1c                	jmp    80100635 <panic+0x82>
    cprintf(" %p", pcs[i]);
80100619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010061c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100620:	83 ec 08             	sub    $0x8,%esp
80100623:	50                   	push   %eax
80100624:	68 57 90 10 80       	push   $0x80109057
80100629:	e8 d0 fd ff ff       	call   801003fe <cprintf>
8010062e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100631:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100635:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100639:	7e de                	jle    80100619 <panic+0x66>
  panicked = 1; // freeze other CPU
8010063b:	c7 05 ac 0f 11 80 01 	movl   $0x1,0x80110fac
80100642:	00 00 00 
  for(;;)
80100645:	90                   	nop
80100646:	eb fd                	jmp    80100645 <panic+0x92>

80100648 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100648:	55                   	push   %ebp
80100649:	89 e5                	mov    %esp,%ebp
8010064b:	53                   	push   %ebx
8010064c:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010064f:	6a 0e                	push   $0xe
80100651:	68 d4 03 00 00       	push   $0x3d4
80100656:	e8 d1 fc ff ff       	call   8010032c <outb>
8010065b:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010065e:	68 d5 03 00 00       	push   $0x3d5
80100663:	e8 a7 fc ff ff       	call   8010030f <inb>
80100668:	83 c4 04             	add    $0x4,%esp
8010066b:	0f b6 c0             	movzbl %al,%eax
8010066e:	c1 e0 08             	shl    $0x8,%eax
80100671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100674:	6a 0f                	push   $0xf
80100676:	68 d4 03 00 00       	push   $0x3d4
8010067b:	e8 ac fc ff ff       	call   8010032c <outb>
80100680:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100683:	68 d5 03 00 00       	push   $0x3d5
80100688:	e8 82 fc ff ff       	call   8010030f <inb>
8010068d:	83 c4 04             	add    $0x4,%esp
80100690:	0f b6 c0             	movzbl %al,%eax
80100693:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100696:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010069a:	75 30                	jne    801006cc <cgaputc+0x84>
    pos += 80 - pos%80;
8010069c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010069f:	ba 67 66 66 66       	mov    $0x66666667,%edx
801006a4:	89 c8                	mov    %ecx,%eax
801006a6:	f7 ea                	imul   %edx
801006a8:	c1 fa 05             	sar    $0x5,%edx
801006ab:	89 c8                	mov    %ecx,%eax
801006ad:	c1 f8 1f             	sar    $0x1f,%eax
801006b0:	29 c2                	sub    %eax,%edx
801006b2:	89 d0                	mov    %edx,%eax
801006b4:	c1 e0 02             	shl    $0x2,%eax
801006b7:	01 d0                	add    %edx,%eax
801006b9:	c1 e0 04             	shl    $0x4,%eax
801006bc:	29 c1                	sub    %eax,%ecx
801006be:	89 ca                	mov    %ecx,%edx
801006c0:	b8 50 00 00 00       	mov    $0x50,%eax
801006c5:	29 d0                	sub    %edx,%eax
801006c7:	01 45 f4             	add    %eax,-0xc(%ebp)
801006ca:	eb 38                	jmp    80100704 <cgaputc+0xbc>
  else if(c == BACKSPACE){
801006cc:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006d3:	75 0c                	jne    801006e1 <cgaputc+0x99>
    if(pos > 0) --pos;
801006d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006d9:	7e 29                	jle    80100704 <cgaputc+0xbc>
801006db:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006df:	eb 23                	jmp    80100704 <cgaputc+0xbc>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006e1:	8b 45 08             	mov    0x8(%ebp),%eax
801006e4:	0f b6 c0             	movzbl %al,%eax
801006e7:	80 cc 07             	or     $0x7,%ah
801006ea:	89 c3                	mov    %eax,%ebx
801006ec:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006f5:	8d 50 01             	lea    0x1(%eax),%edx
801006f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006fb:	01 c0                	add    %eax,%eax
801006fd:	01 c8                	add    %ecx,%eax
801006ff:	89 da                	mov    %ebx,%edx
80100701:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100708:	78 09                	js     80100713 <cgaputc+0xcb>
8010070a:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100711:	7e 0d                	jle    80100720 <cgaputc+0xd8>
    panic("pos under/overflow");
80100713:	83 ec 0c             	sub    $0xc,%esp
80100716:	68 5b 90 10 80       	push   $0x8010905b
8010071b:	e8 93 fe ff ff       	call   801005b3 <panic>

  if((pos/80) >= 24){  // Scroll up.
80100720:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100727:	7e 4c                	jle    80100775 <cgaputc+0x12d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100729:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010072e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100734:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100739:	83 ec 04             	sub    $0x4,%esp
8010073c:	68 60 0e 00 00       	push   $0xe60
80100741:	52                   	push   %edx
80100742:	50                   	push   %eax
80100743:	e8 01 56 00 00       	call   80105d49 <memmove>
80100748:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010074b:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010074f:	b8 80 07 00 00       	mov    $0x780,%eax
80100754:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100757:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010075a:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010075f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100762:	01 c9                	add    %ecx,%ecx
80100764:	01 c8                	add    %ecx,%eax
80100766:	83 ec 04             	sub    $0x4,%esp
80100769:	52                   	push   %edx
8010076a:	6a 00                	push   $0x0
8010076c:	50                   	push   %eax
8010076d:	e8 18 55 00 00       	call   80105c8a <memset>
80100772:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
80100775:	83 ec 08             	sub    $0x8,%esp
80100778:	6a 0e                	push   $0xe
8010077a:	68 d4 03 00 00       	push   $0x3d4
8010077f:	e8 a8 fb ff ff       	call   8010032c <outb>
80100784:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078a:	c1 f8 08             	sar    $0x8,%eax
8010078d:	0f b6 c0             	movzbl %al,%eax
80100790:	83 ec 08             	sub    $0x8,%esp
80100793:	50                   	push   %eax
80100794:	68 d5 03 00 00       	push   $0x3d5
80100799:	e8 8e fb ff ff       	call   8010032c <outb>
8010079e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007a1:	83 ec 08             	sub    $0x8,%esp
801007a4:	6a 0f                	push   $0xf
801007a6:	68 d4 03 00 00       	push   $0x3d4
801007ab:	e8 7c fb ff ff       	call   8010032c <outb>
801007b0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007b6:	0f b6 c0             	movzbl %al,%eax
801007b9:	83 ec 08             	sub    $0x8,%esp
801007bc:	50                   	push   %eax
801007bd:	68 d5 03 00 00       	push   $0x3d5
801007c2:	e8 65 fb ff ff       	call   8010032c <outb>
801007c7:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007ca:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007d2:	01 d2                	add    %edx,%edx
801007d4:	01 d0                	add    %edx,%eax
801007d6:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007db:	90                   	nop
801007dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007df:	c9                   	leave
801007e0:	c3                   	ret

801007e1 <consputc>:

void
consputc(int c)
{
801007e1:	55                   	push   %ebp
801007e2:	89 e5                	mov    %esp,%ebp
801007e4:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007e7:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
801007ec:	85 c0                	test   %eax,%eax
801007ee:	74 08                	je     801007f8 <consputc+0x17>
    cli();
801007f0:	e8 56 fb ff ff       	call   8010034b <cli>
    for(;;)
801007f5:	90                   	nop
801007f6:	eb fd                	jmp    801007f5 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007f8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007ff:	75 29                	jne    8010082a <consputc+0x49>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100801:	83 ec 0c             	sub    $0xc,%esp
80100804:	6a 08                	push   $0x8
80100806:	e8 aa 6f 00 00       	call   801077b5 <uartputc>
8010080b:	83 c4 10             	add    $0x10,%esp
8010080e:	83 ec 0c             	sub    $0xc,%esp
80100811:	6a 20                	push   $0x20
80100813:	e8 9d 6f 00 00       	call   801077b5 <uartputc>
80100818:	83 c4 10             	add    $0x10,%esp
8010081b:	83 ec 0c             	sub    $0xc,%esp
8010081e:	6a 08                	push   $0x8
80100820:	e8 90 6f 00 00       	call   801077b5 <uartputc>
80100825:	83 c4 10             	add    $0x10,%esp
80100828:	eb 0e                	jmp    80100838 <consputc+0x57>
  } else
    uartputc(c);
8010082a:	83 ec 0c             	sub    $0xc,%esp
8010082d:	ff 75 08             	push   0x8(%ebp)
80100830:	e8 80 6f 00 00       	call   801077b5 <uartputc>
80100835:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100838:	83 ec 0c             	sub    $0xc,%esp
8010083b:	ff 75 08             	push   0x8(%ebp)
8010083e:	e8 05 fe ff ff       	call   80100648 <cgaputc>
80100843:	83 c4 10             	add    $0x10,%esp
}
80100846:	90                   	nop
80100847:	c9                   	leave
80100848:	c3                   	ret

80100849 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100849:	55                   	push   %ebp
8010084a:	89 e5                	mov    %esp,%ebp
8010084c:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010084f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100856:	83 ec 0c             	sub    $0xc,%esp
80100859:	68 c0 0f 11 80       	push   $0x80110fc0
8010085e:	e8 a1 51 00 00       	call   80105a04 <acquire>
80100863:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100866:	e9 58 01 00 00       	jmp    801009c3 <consoleintr+0x17a>
    switch(c){
8010086b:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010086f:	0f 84 81 00 00 00    	je     801008f6 <consoleintr+0xad>
80100875:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100879:	0f 8f ac 00 00 00    	jg     8010092b <consoleintr+0xe2>
8010087f:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100883:	74 43                	je     801008c8 <consoleintr+0x7f>
80100885:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100889:	0f 8f 9c 00 00 00    	jg     8010092b <consoleintr+0xe2>
8010088f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100893:	74 61                	je     801008f6 <consoleintr+0xad>
80100895:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100899:	0f 85 8c 00 00 00    	jne    8010092b <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010089f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801008a6:	e9 18 01 00 00       	jmp    801009c3 <consoleintr+0x17a>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008ab:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 1c ff ff ff       	call   801007e1 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008c8:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
801008ce:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
801008d3:	39 c2                	cmp    %eax,%edx
801008d5:	0f 84 e1 00 00 00    	je     801009bc <consoleintr+0x173>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008db:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008e0:	83 e8 01             	sub    $0x1,%eax
801008e3:	83 e0 7f             	and    $0x7f,%eax
801008e6:	0f b6 80 20 0f 11 80 	movzbl -0x7feef0e0(%eax),%eax
      while(input.e != input.w &&
801008ed:	3c 0a                	cmp    $0xa,%al
801008ef:	75 ba                	jne    801008ab <consoleintr+0x62>
      }
      break;
801008f1:	e9 c6 00 00 00       	jmp    801009bc <consoleintr+0x173>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008f6:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
801008fc:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
80100901:	39 c2                	cmp    %eax,%edx
80100903:	0f 84 b6 00 00 00    	je     801009bf <consoleintr+0x176>
        input.e--;
80100909:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090e:	83 e8 01             	sub    $0x1,%eax
80100911:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100916:	83 ec 0c             	sub    $0xc,%esp
80100919:	68 00 01 00 00       	push   $0x100
8010091e:	e8 be fe ff ff       	call   801007e1 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100926:	e9 94 00 00 00       	jmp    801009bf <consoleintr+0x176>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010092b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010092f:	0f 84 8d 00 00 00    	je     801009c2 <consoleintr+0x179>
80100935:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
8010093b:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100940:	29 c2                	sub    %eax,%edx
80100942:	83 fa 7f             	cmp    $0x7f,%edx
80100945:	77 7b                	ja     801009c2 <consoleintr+0x179>
        c = (c == '\r') ? '\n' : c;
80100947:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010094b:	74 05                	je     80100952 <consoleintr+0x109>
8010094d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100950:	eb 05                	jmp    80100957 <consoleintr+0x10e>
80100952:	b8 0a 00 00 00       	mov    $0xa,%eax
80100957:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010095a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010095f:	8d 50 01             	lea    0x1(%eax),%edx
80100962:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
80100968:	83 e0 7f             	and    $0x7f,%eax
8010096b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010096e:	88 90 20 0f 11 80    	mov    %dl,-0x7feef0e0(%eax)
        consputc(c);
80100974:	83 ec 0c             	sub    $0xc,%esp
80100977:	ff 75 f0             	push   -0x10(%ebp)
8010097a:	e8 62 fe ff ff       	call   801007e1 <consputc>
8010097f:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100982:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100986:	74 18                	je     801009a0 <consoleintr+0x157>
80100988:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010098c:	74 12                	je     801009a0 <consoleintr+0x157>
8010098e:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80100994:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100999:	83 e8 80             	sub    $0xffffff80,%eax
8010099c:	39 c2                	cmp    %eax,%edx
8010099e:	75 22                	jne    801009c2 <consoleintr+0x179>
          input.w = input.e;
801009a0:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009a5:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801009aa:	83 ec 0c             	sub    $0xc,%esp
801009ad:	68 a0 0f 11 80       	push   $0x80110fa0
801009b2:	e8 ed 4c 00 00       	call   801056a4 <wakeup>
801009b7:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009ba:	eb 06                	jmp    801009c2 <consoleintr+0x179>
      break;
801009bc:	90                   	nop
801009bd:	eb 04                	jmp    801009c3 <consoleintr+0x17a>
      break;
801009bf:	90                   	nop
801009c0:	eb 01                	jmp    801009c3 <consoleintr+0x17a>
      break;
801009c2:	90                   	nop
  while((c = getc()) >= 0){
801009c3:	8b 45 08             	mov    0x8(%ebp),%eax
801009c6:	ff d0                	call   *%eax
801009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009cf:	0f 89 96 fe ff ff    	jns    8010086b <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009d5:	83 ec 0c             	sub    $0xc,%esp
801009d8:	68 c0 0f 11 80       	push   $0x80110fc0
801009dd:	e8 90 50 00 00       	call   80105a72 <release>
801009e2:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009e9:	74 05                	je     801009f0 <consoleintr+0x1a7>
    procdump();  // now call procdump() wo. cons.lock held
801009eb:	e8 72 4d 00 00       	call   80105762 <procdump>
  }
}
801009f0:	90                   	nop
801009f1:	c9                   	leave
801009f2:	c3                   	ret

801009f3 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009f3:	55                   	push   %ebp
801009f4:	89 e5                	mov    %esp,%ebp
801009f6:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009f9:	83 ec 0c             	sub    $0xc,%esp
801009fc:	ff 75 08             	push   0x8(%ebp)
801009ff:	e8 2b 11 00 00       	call   80101b2f <iunlock>
80100a04:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a07:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a0d:	83 ec 0c             	sub    $0xc,%esp
80100a10:	68 c0 0f 11 80       	push   $0x80110fc0
80100a15:	e8 ea 4f 00 00       	call   80105a04 <acquire>
80100a1a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a1d:	e9 ab 00 00 00       	jmp    80100acd <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
80100a22:	e8 f4 3c 00 00       	call   8010471b <myproc>
80100a27:	8b 40 24             	mov    0x24(%eax),%eax
80100a2a:	85 c0                	test   %eax,%eax
80100a2c:	74 28                	je     80100a56 <consoleread+0x63>
        release(&cons.lock);
80100a2e:	83 ec 0c             	sub    $0xc,%esp
80100a31:	68 c0 0f 11 80       	push   $0x80110fc0
80100a36:	e8 37 50 00 00       	call   80105a72 <release>
80100a3b:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	ff 75 08             	push   0x8(%ebp)
80100a44:	e8 d3 0f 00 00       	call   80101a1c <ilock>
80100a49:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a51:	e9 ab 00 00 00       	jmp    80100b01 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a56:	83 ec 08             	sub    $0x8,%esp
80100a59:	68 c0 0f 11 80       	push   $0x80110fc0
80100a5e:	68 a0 0f 11 80       	push   $0x80110fa0
80100a63:	e8 52 4b 00 00       	call   801055ba <sleep>
80100a68:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a6b:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
80100a71:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
80100a76:	39 c2                	cmp    %eax,%edx
80100a78:	74 a8                	je     80100a22 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a7a:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100a7f:	8d 50 01             	lea    0x1(%eax),%edx
80100a82:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100a88:	83 e0 7f             	and    $0x7f,%eax
80100a8b:	0f b6 80 20 0f 11 80 	movzbl -0x7feef0e0(%eax),%eax
80100a92:	0f be c0             	movsbl %al,%eax
80100a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a98:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a9c:	75 17                	jne    80100ab5 <consoleread+0xc2>
      if(n < target){
80100a9e:	8b 45 10             	mov    0x10(%ebp),%eax
80100aa1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aa4:	73 2f                	jae    80100ad5 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aa6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100aab:	83 e8 01             	sub    $0x1,%eax
80100aae:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
      }
      break;
80100ab3:	eb 20                	jmp    80100ad5 <consoleread+0xe2>
    }
    *dst++ = c;
80100ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab8:	8d 50 01             	lea    0x1(%eax),%edx
80100abb:	89 55 0c             	mov    %edx,0xc(%ebp)
80100abe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100ac1:	88 10                	mov    %dl,(%eax)
    --n;
80100ac3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100ac7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100acb:	74 0b                	je     80100ad8 <consoleread+0xe5>
  while(n > 0){
80100acd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ad1:	7f 98                	jg     80100a6b <consoleread+0x78>
80100ad3:	eb 04                	jmp    80100ad9 <consoleread+0xe6>
      break;
80100ad5:	90                   	nop
80100ad6:	eb 01                	jmp    80100ad9 <consoleread+0xe6>
      break;
80100ad8:	90                   	nop
  }
  release(&cons.lock);
80100ad9:	83 ec 0c             	sub    $0xc,%esp
80100adc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ae1:	e8 8c 4f 00 00       	call   80105a72 <release>
80100ae6:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ae9:	83 ec 0c             	sub    $0xc,%esp
80100aec:	ff 75 08             	push   0x8(%ebp)
80100aef:	e8 28 0f 00 00       	call   80101a1c <ilock>
80100af4:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100af7:	8b 45 10             	mov    0x10(%ebp),%eax
80100afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100afd:	29 c2                	sub    %eax,%edx
80100aff:	89 d0                	mov    %edx,%eax
}
80100b01:	c9                   	leave
80100b02:	c3                   	ret

80100b03 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b03:	55                   	push   %ebp
80100b04:	89 e5                	mov    %esp,%ebp
80100b06:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b09:	83 ec 0c             	sub    $0xc,%esp
80100b0c:	ff 75 08             	push   0x8(%ebp)
80100b0f:	e8 1b 10 00 00       	call   80101b2f <iunlock>
80100b14:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b17:	83 ec 0c             	sub    $0xc,%esp
80100b1a:	68 c0 0f 11 80       	push   $0x80110fc0
80100b1f:	e8 e0 4e 00 00       	call   80105a04 <acquire>
80100b24:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b2e:	eb 21                	jmp    80100b51 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b33:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b36:	01 d0                	add    %edx,%eax
80100b38:	0f b6 00             	movzbl (%eax),%eax
80100b3b:	0f be c0             	movsbl %al,%eax
80100b3e:	0f b6 c0             	movzbl %al,%eax
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	50                   	push   %eax
80100b45:	e8 97 fc ff ff       	call   801007e1 <consputc>
80100b4a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b54:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b57:	7c d7                	jl     80100b30 <consolewrite+0x2d>
  release(&cons.lock);
80100b59:	83 ec 0c             	sub    $0xc,%esp
80100b5c:	68 c0 0f 11 80       	push   $0x80110fc0
80100b61:	e8 0c 4f 00 00       	call   80105a72 <release>
80100b66:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff 75 08             	push   0x8(%ebp)
80100b6f:	e8 a8 0e 00 00       	call   80101a1c <ilock>
80100b74:	83 c4 10             	add    $0x10,%esp

  return n;
80100b77:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b7a:	c9                   	leave
80100b7b:	c3                   	ret

80100b7c <consoleinit>:

void
consoleinit(void)
{
80100b7c:	55                   	push   %ebp
80100b7d:	89 e5                	mov    %esp,%ebp
80100b7f:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b82:	83 ec 08             	sub    $0x8,%esp
80100b85:	68 6e 90 10 80       	push   $0x8010906e
80100b8a:	68 c0 0f 11 80       	push   $0x80110fc0
80100b8f:	e8 4e 4e 00 00       	call   801059e2 <initlock>
80100b94:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b97:	c7 05 0c 10 11 80 03 	movl   $0x80100b03,0x8011100c
80100b9e:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba1:	c7 05 08 10 11 80 f3 	movl   $0x801009f3,0x80111008
80100ba8:	09 10 80 
  cons.locking = 1;
80100bab:	c7 05 f4 0f 11 80 01 	movl   $0x1,0x80110ff4
80100bb2:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100bb5:	83 ec 08             	sub    $0x8,%esp
80100bb8:	6a 00                	push   $0x0
80100bba:	6a 01                	push   $0x1
80100bbc:	e8 63 1f 00 00       	call   80102b24 <ioapicenable>
80100bc1:	83 c4 10             	add    $0x10,%esp
}
80100bc4:	90                   	nop
80100bc5:	c9                   	leave
80100bc6:	c3                   	ret

80100bc7 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bc7:	55                   	push   %ebp
80100bc8:	89 e5                	mov    %esp,%ebp
80100bca:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bd0:	e8 46 3b 00 00       	call   8010471b <myproc>
80100bd5:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bd8:	e8 db 2d 00 00       	call   801039b8 <begin_op>

  if((ip = namei(path)) == 0){
80100bdd:	83 ec 0c             	sub    $0xc,%esp
80100be0:	ff 75 08             	push   0x8(%ebp)
80100be3:	e8 67 19 00 00       	call   8010254f <namei>
80100be8:	83 c4 10             	add    $0x10,%esp
80100beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bf2:	75 1f                	jne    80100c13 <exec+0x4c>
    end_op();
80100bf4:	e8 4b 2e 00 00       	call   80103a44 <end_op>
    cprintf("exec: fail\n");
80100bf9:	83 ec 0c             	sub    $0xc,%esp
80100bfc:	68 76 90 10 80       	push   $0x80109076
80100c01:	e8 f8 f7 ff ff       	call   801003fe <cprintf>
80100c06:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0e:	e9 f1 03 00 00       	jmp    80101004 <exec+0x43d>
  }
  ilock(ip);
80100c13:	83 ec 0c             	sub    $0xc,%esp
80100c16:	ff 75 d8             	push   -0x28(%ebp)
80100c19:	e8 fe 0d 00 00       	call   80101a1c <ilock>
80100c1e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c28:	6a 34                	push   $0x34
80100c2a:	6a 00                	push   $0x0
80100c2c:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c32:	50                   	push   %eax
80100c33:	ff 75 d8             	push   -0x28(%ebp)
80100c36:	e8 cd 12 00 00       	call   80101f08 <readi>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	83 f8 34             	cmp    $0x34,%eax
80100c41:	0f 85 66 03 00 00    	jne    80100fad <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c47:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c4d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c52:	0f 85 58 03 00 00    	jne    80100fb0 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c58:	e8 54 7b 00 00       	call   801087b1 <setupkvm>
80100c5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c60:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c64:	0f 84 49 03 00 00    	je     80100fb3 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c78:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c81:	e9 de 00 00 00       	jmp    80100d64 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c89:	6a 20                	push   $0x20
80100c8b:	50                   	push   %eax
80100c8c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c92:	50                   	push   %eax
80100c93:	ff 75 d8             	push   -0x28(%ebp)
80100c96:	e8 6d 12 00 00       	call   80101f08 <readi>
80100c9b:	83 c4 10             	add    $0x10,%esp
80100c9e:	83 f8 20             	cmp    $0x20,%eax
80100ca1:	0f 85 0f 03 00 00    	jne    80100fb6 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ca7:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100cad:	83 f8 01             	cmp    $0x1,%eax
80100cb0:	0f 85 a0 00 00 00    	jne    80100d56 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100cb6:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cbc:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cc2:	39 c2                	cmp    %eax,%edx
80100cc4:	0f 82 ef 02 00 00    	jb     80100fb9 <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cd0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cd6:	01 c2                	add    %eax,%edx
80100cd8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cde:	39 c2                	cmp    %eax,%edx
80100ce0:	0f 82 d6 02 00 00    	jb     80100fbc <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ce6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cf2:	01 d0                	add    %edx,%eax
80100cf4:	83 ec 04             	sub    $0x4,%esp
80100cf7:	50                   	push   %eax
80100cf8:	ff 75 e0             	push   -0x20(%ebp)
80100cfb:	ff 75 d4             	push   -0x2c(%ebp)
80100cfe:	e8 54 7e 00 00       	call   80108b57 <allocuvm>
80100d03:	83 c4 10             	add    $0x10,%esp
80100d06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d0d:	0f 84 ac 02 00 00    	je     80100fbf <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d13:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d19:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d1e:	85 c0                	test   %eax,%eax
80100d20:	0f 85 9c 02 00 00    	jne    80100fc2 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d26:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d2c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d32:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d38:	83 ec 0c             	sub    $0xc,%esp
80100d3b:	52                   	push   %edx
80100d3c:	50                   	push   %eax
80100d3d:	ff 75 d8             	push   -0x28(%ebp)
80100d40:	51                   	push   %ecx
80100d41:	ff 75 d4             	push   -0x2c(%ebp)
80100d44:	e8 41 7d 00 00       	call   80108a8a <loaduvm>
80100d49:	83 c4 20             	add    $0x20,%esp
80100d4c:	85 c0                	test   %eax,%eax
80100d4e:	0f 88 71 02 00 00    	js     80100fc5 <exec+0x3fe>
80100d54:	eb 01                	jmp    80100d57 <exec+0x190>
      continue;
80100d56:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d57:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d5e:	83 c0 20             	add    $0x20,%eax
80100d61:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d64:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d6b:	0f b7 c0             	movzwl %ax,%eax
80100d6e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d71:	0f 8c 0f ff ff ff    	jl     80100c86 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	ff 75 d8             	push   -0x28(%ebp)
80100d7d:	e8 cb 0e 00 00       	call   80101c4d <iunlockput>
80100d82:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d85:	e8 ba 2c 00 00       	call   80103a44 <end_op>
  ip = 0;
80100d8a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d94:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da4:	05 00 20 00 00       	add    $0x2000,%eax
80100da9:	83 ec 04             	sub    $0x4,%esp
80100dac:	50                   	push   %eax
80100dad:	ff 75 e0             	push   -0x20(%ebp)
80100db0:	ff 75 d4             	push   -0x2c(%ebp)
80100db3:	e8 9f 7d 00 00       	call   80108b57 <allocuvm>
80100db8:	83 c4 10             	add    $0x10,%esp
80100dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dc2:	0f 84 00 02 00 00    	je     80100fc8 <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dcb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dd0:	83 ec 08             	sub    $0x8,%esp
80100dd3:	50                   	push   %eax
80100dd4:	ff 75 d4             	push   -0x2c(%ebp)
80100dd7:	e8 dd 7f 00 00       	call   80108db9 <clearpteu>
80100ddc:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100de2:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dec:	e9 96 00 00 00       	jmp    80100e87 <exec+0x2c0>
    if(argc >= MAXARG)
80100df1:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df5:	0f 87 d0 01 00 00    	ja     80100fcb <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e08:	01 d0                	add    %edx,%eax
80100e0a:	8b 00                	mov    (%eax),%eax
80100e0c:	83 ec 0c             	sub    $0xc,%esp
80100e0f:	50                   	push   %eax
80100e10:	e8 c3 50 00 00       	call   80105ed8 <strlen>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	89 c2                	mov    %eax,%edx
80100e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1d:	29 d0                	sub    %edx,%eax
80100e1f:	83 e8 01             	sub    $0x1,%eax
80100e22:	83 e0 fc             	and    $0xfffffffc,%eax
80100e25:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e32:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e35:	01 d0                	add    %edx,%eax
80100e37:	8b 00                	mov    (%eax),%eax
80100e39:	83 ec 0c             	sub    $0xc,%esp
80100e3c:	50                   	push   %eax
80100e3d:	e8 96 50 00 00       	call   80105ed8 <strlen>
80100e42:	83 c4 10             	add    $0x10,%esp
80100e45:	83 c0 01             	add    $0x1,%eax
80100e48:	89 c1                	mov    %eax,%ecx
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e57:	01 d0                	add    %edx,%eax
80100e59:	8b 00                	mov    (%eax),%eax
80100e5b:	51                   	push   %ecx
80100e5c:	50                   	push   %eax
80100e5d:	ff 75 dc             	push   -0x24(%ebp)
80100e60:	ff 75 d4             	push   -0x2c(%ebp)
80100e63:	e8 fd 80 00 00       	call   80108f65 <copyout>
80100e68:	83 c4 10             	add    $0x10,%esp
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	0f 88 5b 01 00 00    	js     80100fce <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e76:	8d 50 03             	lea    0x3(%eax),%edx
80100e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e7c:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e83:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e94:	01 d0                	add    %edx,%eax
80100e96:	8b 00                	mov    (%eax),%eax
80100e98:	85 c0                	test   %eax,%eax
80100e9a:	0f 85 51 ff ff ff    	jne    80100df1 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea3:	83 c0 03             	add    $0x3,%eax
80100ea6:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100ead:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eb1:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100eb8:	ff ff ff 
  ustack[1] = argc;
80100ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebe:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec7:	83 c0 01             	add    $0x1,%eax
80100eca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed4:	29 d0                	sub    %edx,%eax
80100ed6:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edf:	83 c0 04             	add    $0x4,%eax
80100ee2:	c1 e0 02             	shl    $0x2,%eax
80100ee5:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eeb:	83 c0 04             	add    $0x4,%eax
80100eee:	c1 e0 02             	shl    $0x2,%eax
80100ef1:	50                   	push   %eax
80100ef2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ef8:	50                   	push   %eax
80100ef9:	ff 75 dc             	push   -0x24(%ebp)
80100efc:	ff 75 d4             	push   -0x2c(%ebp)
80100eff:	e8 61 80 00 00       	call   80108f65 <copyout>
80100f04:	83 c4 10             	add    $0x10,%esp
80100f07:	85 c0                	test   %eax,%eax
80100f09:	0f 88 c2 00 00 00    	js     80100fd1 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f1b:	eb 17                	jmp    80100f34 <exec+0x36d>
    if(*s == '/')
80100f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f20:	0f b6 00             	movzbl (%eax),%eax
80100f23:	3c 2f                	cmp    $0x2f,%al
80100f25:	75 09                	jne    80100f30 <exec+0x369>
      last = s+1;
80100f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f2a:	83 c0 01             	add    $0x1,%eax
80100f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f37:	0f b6 00             	movzbl (%eax),%eax
80100f3a:	84 c0                	test   %al,%al
80100f3c:	75 df                	jne    80100f1d <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f41:	83 c0 6c             	add    $0x6c,%eax
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	6a 10                	push   $0x10
80100f49:	ff 75 f0             	push   -0x10(%ebp)
80100f4c:	50                   	push   %eax
80100f4d:	e8 3b 4f 00 00       	call   80105e8d <safestrcpy>
80100f52:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f55:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f58:	8b 40 04             	mov    0x4(%eax),%eax
80100f5b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f64:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f67:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f6d:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f72:	8b 40 18             	mov    0x18(%eax),%eax
80100f75:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f7b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f81:	8b 40 18             	mov    0x18(%eax),%eax
80100f84:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f87:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	ff 75 d0             	push   -0x30(%ebp)
80100f90:	e8 e6 78 00 00       	call   8010887b <switchuvm>
80100f95:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 75 cc             	push   -0x34(%ebp)
80100f9e:	e8 7d 7d 00 00       	call   80108d20 <freevm>
80100fa3:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80100fab:	eb 57                	jmp    80101004 <exec+0x43d>
    goto bad;
80100fad:	90                   	nop
80100fae:	eb 22                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fb0:	90                   	nop
80100fb1:	eb 1f                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fb3:	90                   	nop
80100fb4:	eb 1c                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fb6:	90                   	nop
80100fb7:	eb 19                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fb9:	90                   	nop
80100fba:	eb 16                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fbc:	90                   	nop
80100fbd:	eb 13                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fbf:	90                   	nop
80100fc0:	eb 10                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fc2:	90                   	nop
80100fc3:	eb 0d                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fc5:	90                   	nop
80100fc6:	eb 0a                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fc8:	90                   	nop
80100fc9:	eb 07                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fcb:	90                   	nop
80100fcc:	eb 04                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fce:	90                   	nop
80100fcf:	eb 01                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fd1:	90                   	nop

 bad:
  if(pgdir)
80100fd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fd6:	74 0e                	je     80100fe6 <exec+0x41f>
    freevm(pgdir);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 75 d4             	push   -0x2c(%ebp)
80100fde:	e8 3d 7d 00 00       	call   80108d20 <freevm>
80100fe3:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fe6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fea:	74 13                	je     80100fff <exec+0x438>
    iunlockput(ip);
80100fec:	83 ec 0c             	sub    $0xc,%esp
80100fef:	ff 75 d8             	push   -0x28(%ebp)
80100ff2:	e8 56 0c 00 00       	call   80101c4d <iunlockput>
80100ff7:	83 c4 10             	add    $0x10,%esp
    end_op();
80100ffa:	e8 45 2a 00 00       	call   80103a44 <end_op>
  }
  return -1;
80100fff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101004:	c9                   	leave
80101005:	c3                   	ret

80101006 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101006:	55                   	push   %ebp
80101007:	89 e5                	mov    %esp,%ebp
80101009:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010100c:	83 ec 08             	sub    $0x8,%esp
8010100f:	68 82 90 10 80       	push   $0x80109082
80101014:	68 60 10 11 80       	push   $0x80111060
80101019:	e8 c4 49 00 00       	call   801059e2 <initlock>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	90                   	nop
80101022:	c9                   	leave
80101023:	c3                   	ret

80101024 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	68 60 10 11 80       	push   $0x80111060
80101032:	e8 cd 49 00 00       	call   80105a04 <acquire>
80101037:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103a:	c7 45 f4 94 10 11 80 	movl   $0x80111094,-0xc(%ebp)
80101041:	eb 2d                	jmp    80101070 <filealloc+0x4c>
    if(f->ref == 0){
80101043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101046:	8b 40 04             	mov    0x4(%eax),%eax
80101049:	85 c0                	test   %eax,%eax
8010104b:	75 1f                	jne    8010106c <filealloc+0x48>
      f->ref = 1;
8010104d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101050:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	68 60 10 11 80       	push   $0x80111060
8010105f:	e8 0e 4a 00 00       	call   80105a72 <release>
80101064:	83 c4 10             	add    $0x10,%esp
      return f;
80101067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010106a:	eb 23                	jmp    8010108f <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010106c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101070:	b8 f4 19 11 80       	mov    $0x801119f4,%eax
80101075:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101078:	72 c9                	jb     80101043 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010107a:	83 ec 0c             	sub    $0xc,%esp
8010107d:	68 60 10 11 80       	push   $0x80111060
80101082:	e8 eb 49 00 00       	call   80105a72 <release>
80101087:	83 c4 10             	add    $0x10,%esp
  return 0;
8010108a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010108f:	c9                   	leave
80101090:	c3                   	ret

80101091 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101091:	55                   	push   %ebp
80101092:	89 e5                	mov    %esp,%ebp
80101094:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 60 10 11 80       	push   $0x80111060
8010109f:	e8 60 49 00 00       	call   80105a04 <acquire>
801010a4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	8b 40 04             	mov    0x4(%eax),%eax
801010ad:	85 c0                	test   %eax,%eax
801010af:	7f 0d                	jg     801010be <filedup+0x2d>
    panic("filedup");
801010b1:	83 ec 0c             	sub    $0xc,%esp
801010b4:	68 89 90 10 80       	push   $0x80109089
801010b9:	e8 f5 f4 ff ff       	call   801005b3 <panic>
  f->ref++;
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
801010c1:	8b 40 04             	mov    0x4(%eax),%eax
801010c4:	8d 50 01             	lea    0x1(%eax),%edx
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	68 60 10 11 80       	push   $0x80111060
801010d5:	e8 98 49 00 00       	call   80105a72 <release>
801010da:	83 c4 10             	add    $0x10,%esp
  return f;
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010e0:	c9                   	leave
801010e1:	c3                   	ret

801010e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e2:	55                   	push   %ebp
801010e3:	89 e5                	mov    %esp,%ebp
801010e5:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	68 60 10 11 80       	push   $0x80111060
801010f0:	e8 0f 49 00 00       	call   80105a04 <acquire>
801010f5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	8b 40 04             	mov    0x4(%eax),%eax
801010fe:	85 c0                	test   %eax,%eax
80101100:	7f 0d                	jg     8010110f <fileclose+0x2d>
    panic("fileclose");
80101102:	83 ec 0c             	sub    $0xc,%esp
80101105:	68 91 90 10 80       	push   $0x80109091
8010110a:	e8 a4 f4 ff ff       	call   801005b3 <panic>
  if(--f->ref > 0){
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	8b 40 04             	mov    0x4(%eax),%eax
80101115:	8d 50 ff             	lea    -0x1(%eax),%edx
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	89 50 04             	mov    %edx,0x4(%eax)
8010111e:	8b 45 08             	mov    0x8(%ebp),%eax
80101121:	8b 40 04             	mov    0x4(%eax),%eax
80101124:	85 c0                	test   %eax,%eax
80101126:	7e 15                	jle    8010113d <fileclose+0x5b>
    release(&ftable.lock);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	68 60 10 11 80       	push   $0x80111060
80101130:	e8 3d 49 00 00       	call   80105a72 <release>
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	e9 8b 00 00 00       	jmp    801011c8 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010113d:	8b 45 08             	mov    0x8(%ebp),%eax
80101140:	8b 10                	mov    (%eax),%edx
80101142:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101145:	8b 50 04             	mov    0x4(%eax),%edx
80101148:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010114b:	8b 50 08             	mov    0x8(%eax),%edx
8010114e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101151:	8b 50 0c             	mov    0xc(%eax),%edx
80101154:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101157:	8b 50 10             	mov    0x10(%eax),%edx
8010115a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010115d:	8b 40 14             	mov    0x14(%eax),%eax
80101160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	68 60 10 11 80       	push   $0x80111060
8010117e:	e8 ef 48 00 00       	call   80105a72 <release>
80101183:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101186:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101189:	83 f8 01             	cmp    $0x1,%eax
8010118c:	75 19                	jne    801011a7 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010118e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101192:	0f be d0             	movsbl %al,%edx
80101195:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101198:	83 ec 08             	sub    $0x8,%esp
8010119b:	52                   	push   %edx
8010119c:	50                   	push   %eax
8010119d:	e8 08 32 00 00       	call   801043aa <pipeclose>
801011a2:	83 c4 10             	add    $0x10,%esp
801011a5:	eb 21                	jmp    801011c8 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011aa:	83 f8 02             	cmp    $0x2,%eax
801011ad:	75 19                	jne    801011c8 <fileclose+0xe6>
    begin_op();
801011af:	e8 04 28 00 00       	call   801039b8 <begin_op>
    iput(ff.ip);
801011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011b7:	83 ec 0c             	sub    $0xc,%esp
801011ba:	50                   	push   %eax
801011bb:	e8 bd 09 00 00       	call   80101b7d <iput>
801011c0:	83 c4 10             	add    $0x10,%esp
    end_op();
801011c3:	e8 7c 28 00 00       	call   80103a44 <end_op>
  }
}
801011c8:	c9                   	leave
801011c9:	c3                   	ret

801011ca <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011ca:	55                   	push   %ebp
801011cb:	89 e5                	mov    %esp,%ebp
801011cd:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011d0:	8b 45 08             	mov    0x8(%ebp),%eax
801011d3:	8b 00                	mov    (%eax),%eax
801011d5:	83 f8 02             	cmp    $0x2,%eax
801011d8:	75 40                	jne    8010121a <filestat+0x50>
    ilock(f->ip);
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 40 10             	mov    0x10(%eax),%eax
801011e0:	83 ec 0c             	sub    $0xc,%esp
801011e3:	50                   	push   %eax
801011e4:	e8 33 08 00 00       	call   80101a1c <ilock>
801011e9:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 40 10             	mov    0x10(%eax),%eax
801011f2:	83 ec 08             	sub    $0x8,%esp
801011f5:	ff 75 0c             	push   0xc(%ebp)
801011f8:	50                   	push   %eax
801011f9:	e8 c4 0c 00 00       	call   80101ec2 <stati>
801011fe:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	8b 40 10             	mov    0x10(%eax),%eax
80101207:	83 ec 0c             	sub    $0xc,%esp
8010120a:	50                   	push   %eax
8010120b:	e8 1f 09 00 00       	call   80101b2f <iunlock>
80101210:	83 c4 10             	add    $0x10,%esp
    return 0;
80101213:	b8 00 00 00 00       	mov    $0x0,%eax
80101218:	eb 05                	jmp    8010121f <filestat+0x55>
  }
  return -1;
8010121a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010121f:	c9                   	leave
80101220:	c3                   	ret

80101221 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101221:	55                   	push   %ebp
80101222:	89 e5                	mov    %esp,%ebp
80101224:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010122e:	84 c0                	test   %al,%al
80101230:	75 0a                	jne    8010123c <fileread+0x1b>
    return -1;
80101232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101237:	e9 9b 00 00 00       	jmp    801012d7 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010123c:	8b 45 08             	mov    0x8(%ebp),%eax
8010123f:	8b 00                	mov    (%eax),%eax
80101241:	83 f8 01             	cmp    $0x1,%eax
80101244:	75 1a                	jne    80101260 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101246:	8b 45 08             	mov    0x8(%ebp),%eax
80101249:	8b 40 0c             	mov    0xc(%eax),%eax
8010124c:	83 ec 04             	sub    $0x4,%esp
8010124f:	ff 75 10             	push   0x10(%ebp)
80101252:	ff 75 0c             	push   0xc(%ebp)
80101255:	50                   	push   %eax
80101256:	e8 fc 32 00 00       	call   80104557 <piperead>
8010125b:	83 c4 10             	add    $0x10,%esp
8010125e:	eb 77                	jmp    801012d7 <fileread+0xb6>
  if(f->type == FD_INODE){
80101260:	8b 45 08             	mov    0x8(%ebp),%eax
80101263:	8b 00                	mov    (%eax),%eax
80101265:	83 f8 02             	cmp    $0x2,%eax
80101268:	75 60                	jne    801012ca <fileread+0xa9>
    ilock(f->ip);
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 40 10             	mov    0x10(%eax),%eax
80101270:	83 ec 0c             	sub    $0xc,%esp
80101273:	50                   	push   %eax
80101274:	e8 a3 07 00 00       	call   80101a1c <ilock>
80101279:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010127c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 50 14             	mov    0x14(%eax),%edx
80101285:	8b 45 08             	mov    0x8(%ebp),%eax
80101288:	8b 40 10             	mov    0x10(%eax),%eax
8010128b:	51                   	push   %ecx
8010128c:	52                   	push   %edx
8010128d:	ff 75 0c             	push   0xc(%ebp)
80101290:	50                   	push   %eax
80101291:	e8 72 0c 00 00       	call   80101f08 <readi>
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010129c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012a0:	7e 11                	jle    801012b3 <fileread+0x92>
      f->off += r;
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 50 14             	mov    0x14(%eax),%edx
801012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ab:	01 c2                	add    %eax,%edx
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 40 10             	mov    0x10(%eax),%eax
801012b9:	83 ec 0c             	sub    $0xc,%esp
801012bc:	50                   	push   %eax
801012bd:	e8 6d 08 00 00       	call   80101b2f <iunlock>
801012c2:	83 c4 10             	add    $0x10,%esp
    return r;
801012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c8:	eb 0d                	jmp    801012d7 <fileread+0xb6>
  }
  panic("fileread");
801012ca:	83 ec 0c             	sub    $0xc,%esp
801012cd:	68 9b 90 10 80       	push   $0x8010909b
801012d2:	e8 dc f2 ff ff       	call   801005b3 <panic>
}
801012d7:	c9                   	leave
801012d8:	c3                   	ret

801012d9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012d9:	55                   	push   %ebp
801012da:	89 e5                	mov    %esp,%ebp
801012dc:	53                   	push   %ebx
801012dd:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012e0:	8b 45 08             	mov    0x8(%ebp),%eax
801012e3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012e7:	84 c0                	test   %al,%al
801012e9:	75 0a                	jne    801012f5 <filewrite+0x1c>
    return -1;
801012eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f0:	e9 1b 01 00 00       	jmp    80101410 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012f5:	8b 45 08             	mov    0x8(%ebp),%eax
801012f8:	8b 00                	mov    (%eax),%eax
801012fa:	83 f8 01             	cmp    $0x1,%eax
801012fd:	75 1d                	jne    8010131c <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101302:	8b 40 0c             	mov    0xc(%eax),%eax
80101305:	83 ec 04             	sub    $0x4,%esp
80101308:	ff 75 10             	push   0x10(%ebp)
8010130b:	ff 75 0c             	push   0xc(%ebp)
8010130e:	50                   	push   %eax
8010130f:	e8 41 31 00 00       	call   80104455 <pipewrite>
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	e9 f4 00 00 00       	jmp    80101410 <filewrite+0x137>
  if(f->type == FD_INODE){
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 00                	mov    (%eax),%eax
80101321:	83 f8 02             	cmp    $0x2,%eax
80101324:	0f 85 d9 00 00 00    	jne    80101403 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
8010132a:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101338:	e9 a3 00 00 00       	jmp    801013e0 <filewrite+0x107>
      int n1 = n - i;
8010133d:	8b 45 10             	mov    0x10(%ebp),%eax
80101340:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101343:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101349:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010134c:	7e 06                	jle    80101354 <filewrite+0x7b>
        n1 = max;
8010134e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101351:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101354:	e8 5f 26 00 00       	call   801039b8 <begin_op>
      ilock(f->ip);
80101359:	8b 45 08             	mov    0x8(%ebp),%eax
8010135c:	8b 40 10             	mov    0x10(%eax),%eax
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	50                   	push   %eax
80101363:	e8 b4 06 00 00       	call   80101a1c <ilock>
80101368:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010136b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 50 14             	mov    0x14(%eax),%edx
80101374:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101377:	8b 45 0c             	mov    0xc(%ebp),%eax
8010137a:	01 c3                	add    %eax,%ebx
8010137c:	8b 45 08             	mov    0x8(%ebp),%eax
8010137f:	8b 40 10             	mov    0x10(%eax),%eax
80101382:	51                   	push   %ecx
80101383:	52                   	push   %edx
80101384:	53                   	push   %ebx
80101385:	50                   	push   %eax
80101386:	e8 d2 0c 00 00       	call   8010205d <writei>
8010138b:	83 c4 10             	add    $0x10,%esp
8010138e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101391:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101395:	7e 11                	jle    801013a8 <filewrite+0xcf>
        f->off += r;
80101397:	8b 45 08             	mov    0x8(%ebp),%eax
8010139a:	8b 50 14             	mov    0x14(%eax),%edx
8010139d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013a0:	01 c2                	add    %eax,%edx
801013a2:	8b 45 08             	mov    0x8(%ebp),%eax
801013a5:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	8b 40 10             	mov    0x10(%eax),%eax
801013ae:	83 ec 0c             	sub    $0xc,%esp
801013b1:	50                   	push   %eax
801013b2:	e8 78 07 00 00       	call   80101b2f <iunlock>
801013b7:	83 c4 10             	add    $0x10,%esp
      end_op();
801013ba:	e8 85 26 00 00       	call   80103a44 <end_op>

      if(r < 0)
801013bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013c3:	78 29                	js     801013ee <filewrite+0x115>
        break;
      if(r != n1)
801013c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013cb:	74 0d                	je     801013da <filewrite+0x101>
        panic("short filewrite");
801013cd:	83 ec 0c             	sub    $0xc,%esp
801013d0:	68 a4 90 10 80       	push   $0x801090a4
801013d5:	e8 d9 f1 ff ff       	call   801005b3 <panic>
      i += r;
801013da:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013dd:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e3:	3b 45 10             	cmp    0x10(%ebp),%eax
801013e6:	0f 8c 51 ff ff ff    	jl     8010133d <filewrite+0x64>
801013ec:	eb 01                	jmp    801013ef <filewrite+0x116>
        break;
801013ee:	90                   	nop
    }
    return i == n ? n : -1;
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f5:	75 05                	jne    801013fc <filewrite+0x123>
801013f7:	8b 45 10             	mov    0x10(%ebp),%eax
801013fa:	eb 14                	jmp    80101410 <filewrite+0x137>
801013fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101401:	eb 0d                	jmp    80101410 <filewrite+0x137>
  }
  panic("filewrite");
80101403:	83 ec 0c             	sub    $0xc,%esp
80101406:	68 b4 90 10 80       	push   $0x801090b4
8010140b:	e8 a3 f1 ff ff       	call   801005b3 <panic>
}
80101410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101413:	c9                   	leave
80101414:	c3                   	ret

80101415 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101415:	55                   	push   %ebp
80101416:	89 e5                	mov    %esp,%ebp
80101418:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010141b:	8b 45 08             	mov    0x8(%ebp),%eax
8010141e:	83 ec 08             	sub    $0x8,%esp
80101421:	6a 01                	push   $0x1
80101423:	50                   	push   %eax
80101424:	e8 a6 ed ff ff       	call   801001cf <bread>
80101429:	83 c4 10             	add    $0x10,%esp
8010142c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101432:	83 c0 5c             	add    $0x5c,%eax
80101435:	83 ec 04             	sub    $0x4,%esp
80101438:	6a 1c                	push   $0x1c
8010143a:	50                   	push   %eax
8010143b:	ff 75 0c             	push   0xc(%ebp)
8010143e:	e8 06 49 00 00       	call   80105d49 <memmove>
80101443:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101446:	83 ec 0c             	sub    $0xc,%esp
80101449:	ff 75 f4             	push   -0xc(%ebp)
8010144c:	e8 00 ee ff ff       	call   80100251 <brelse>
80101451:	83 c4 10             	add    $0x10,%esp
}
80101454:	90                   	nop
80101455:	c9                   	leave
80101456:	c3                   	ret

80101457 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101457:	55                   	push   %ebp
80101458:	89 e5                	mov    %esp,%ebp
8010145a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010145d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101460:	8b 45 08             	mov    0x8(%ebp),%eax
80101463:	83 ec 08             	sub    $0x8,%esp
80101466:	52                   	push   %edx
80101467:	50                   	push   %eax
80101468:	e8 62 ed ff ff       	call   801001cf <bread>
8010146d:	83 c4 10             	add    $0x10,%esp
80101470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101476:	83 c0 5c             	add    $0x5c,%eax
80101479:	83 ec 04             	sub    $0x4,%esp
8010147c:	68 00 02 00 00       	push   $0x200
80101481:	6a 00                	push   $0x0
80101483:	50                   	push   %eax
80101484:	e8 01 48 00 00       	call   80105c8a <memset>
80101489:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	ff 75 f4             	push   -0xc(%ebp)
80101492:	e8 5a 27 00 00       	call   80103bf1 <log_write>
80101497:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010149a:	83 ec 0c             	sub    $0xc,%esp
8010149d:	ff 75 f4             	push   -0xc(%ebp)
801014a0:	e8 ac ed ff ff       	call   80100251 <brelse>
801014a5:	83 c4 10             	add    $0x10,%esp
}
801014a8:	90                   	nop
801014a9:	c9                   	leave
801014aa:	c3                   	ret

801014ab <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014ab:	55                   	push   %ebp
801014ac:	89 e5                	mov    %esp,%ebp
801014ae:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014bf:	e9 0b 01 00 00       	jmp    801015cf <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
801014c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014c7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014cd:	85 c0                	test   %eax,%eax
801014cf:	0f 48 c2             	cmovs  %edx,%eax
801014d2:	c1 f8 0c             	sar    $0xc,%eax
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	a1 18 1a 11 80       	mov    0x80111a18,%eax
801014dc:	01 d0                	add    %edx,%eax
801014de:	83 ec 08             	sub    $0x8,%esp
801014e1:	50                   	push   %eax
801014e2:	ff 75 08             	push   0x8(%ebp)
801014e5:	e8 e5 ec ff ff       	call   801001cf <bread>
801014ea:	83 c4 10             	add    $0x10,%esp
801014ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014f7:	e9 9e 00 00 00       	jmp    8010159a <balloc+0xef>
      m = 1 << (bi % 8);
801014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ff:	83 e0 07             	and    $0x7,%eax
80101502:	ba 01 00 00 00       	mov    $0x1,%edx
80101507:	89 c1                	mov    %eax,%ecx
80101509:	d3 e2                	shl    %cl,%edx
8010150b:	89 d0                	mov    %edx,%eax
8010150d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101513:	8d 50 07             	lea    0x7(%eax),%edx
80101516:	85 c0                	test   %eax,%eax
80101518:	0f 48 c2             	cmovs  %edx,%eax
8010151b:	c1 f8 03             	sar    $0x3,%eax
8010151e:	89 c2                	mov    %eax,%edx
80101520:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101523:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101528:	0f b6 c0             	movzbl %al,%eax
8010152b:	23 45 e8             	and    -0x18(%ebp),%eax
8010152e:	85 c0                	test   %eax,%eax
80101530:	75 64                	jne    80101596 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
80101532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101535:	8d 50 07             	lea    0x7(%eax),%edx
80101538:	85 c0                	test   %eax,%eax
8010153a:	0f 48 c2             	cmovs  %edx,%eax
8010153d:	c1 f8 03             	sar    $0x3,%eax
80101540:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101543:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101548:	89 d1                	mov    %edx,%ecx
8010154a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010154d:	09 ca                	or     %ecx,%edx
8010154f:	89 d1                	mov    %edx,%ecx
80101551:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101554:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	ff 75 ec             	push   -0x14(%ebp)
8010155e:	e8 8e 26 00 00       	call   80103bf1 <log_write>
80101563:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101566:	83 ec 0c             	sub    $0xc,%esp
80101569:	ff 75 ec             	push   -0x14(%ebp)
8010156c:	e8 e0 ec ff ff       	call   80100251 <brelse>
80101571:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101574:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157a:	01 c2                	add    %eax,%edx
8010157c:	8b 45 08             	mov    0x8(%ebp),%eax
8010157f:	83 ec 08             	sub    $0x8,%esp
80101582:	52                   	push   %edx
80101583:	50                   	push   %eax
80101584:	e8 ce fe ff ff       	call   80101457 <bzero>
80101589:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101592:	01 d0                	add    %edx,%eax
80101594:	eb 56                	jmp    801015ec <balloc+0x141>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101596:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010159a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015a1:	7f 17                	jg     801015ba <balloc+0x10f>
801015a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	01 d0                	add    %edx,%eax
801015ab:	89 c2                	mov    %eax,%edx
801015ad:	a1 00 1a 11 80       	mov    0x80111a00,%eax
801015b2:	39 c2                	cmp    %eax,%edx
801015b4:	0f 82 42 ff ff ff    	jb     801014fc <balloc+0x51>
      }
    }
    brelse(bp);
801015ba:	83 ec 0c             	sub    $0xc,%esp
801015bd:	ff 75 ec             	push   -0x14(%ebp)
801015c0:	e8 8c ec ff ff       	call   80100251 <brelse>
801015c5:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015c8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015cf:	a1 00 1a 11 80       	mov    0x80111a00,%eax
801015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d7:	39 c2                	cmp    %eax,%edx
801015d9:	0f 82 e5 fe ff ff    	jb     801014c4 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	68 c0 90 10 80       	push   $0x801090c0
801015e7:	e8 c7 ef ff ff       	call   801005b3 <panic>
}
801015ec:	c9                   	leave
801015ed:	c3                   	ret

801015ee <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015ee:	55                   	push   %ebp
801015ef:	89 e5                	mov    %esp,%ebp
801015f1:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f7:	c1 e8 0c             	shr    $0xc,%eax
801015fa:	89 c2                	mov    %eax,%edx
801015fc:	a1 18 1a 11 80       	mov    0x80111a18,%eax
80101601:	01 c2                	add    %eax,%edx
80101603:	8b 45 08             	mov    0x8(%ebp),%eax
80101606:	83 ec 08             	sub    $0x8,%esp
80101609:	52                   	push   %edx
8010160a:	50                   	push   %eax
8010160b:	e8 bf eb ff ff       	call   801001cf <bread>
80101610:	83 c4 10             	add    $0x10,%esp
80101613:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101616:	8b 45 0c             	mov    0xc(%ebp),%eax
80101619:	25 ff 0f 00 00       	and    $0xfff,%eax
8010161e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101624:	83 e0 07             	and    $0x7,%eax
80101627:	ba 01 00 00 00       	mov    $0x1,%edx
8010162c:	89 c1                	mov    %eax,%ecx
8010162e:	d3 e2                	shl    %cl,%edx
80101630:	89 d0                	mov    %edx,%eax
80101632:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101635:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101638:	8d 50 07             	lea    0x7(%eax),%edx
8010163b:	85 c0                	test   %eax,%eax
8010163d:	0f 48 c2             	cmovs  %edx,%eax
80101640:	c1 f8 03             	sar    $0x3,%eax
80101643:	89 c2                	mov    %eax,%edx
80101645:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101648:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010164d:	0f b6 c0             	movzbl %al,%eax
80101650:	23 45 ec             	and    -0x14(%ebp),%eax
80101653:	85 c0                	test   %eax,%eax
80101655:	75 0d                	jne    80101664 <bfree+0x76>
    panic("freeing free block");
80101657:	83 ec 0c             	sub    $0xc,%esp
8010165a:	68 d6 90 10 80       	push   $0x801090d6
8010165f:	e8 4f ef ff ff       	call   801005b3 <panic>
  bp->data[bi/8] &= ~m;
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	8d 50 07             	lea    0x7(%eax),%edx
8010166a:	85 c0                	test   %eax,%eax
8010166c:	0f 48 c2             	cmovs  %edx,%eax
8010166f:	c1 f8 03             	sar    $0x3,%eax
80101672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101675:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010167a:	89 d1                	mov    %edx,%ecx
8010167c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010167f:	f7 d2                	not    %edx
80101681:	21 ca                	and    %ecx,%edx
80101683:	89 d1                	mov    %edx,%ecx
80101685:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101688:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010168c:	83 ec 0c             	sub    $0xc,%esp
8010168f:	ff 75 f4             	push   -0xc(%ebp)
80101692:	e8 5a 25 00 00       	call   80103bf1 <log_write>
80101697:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010169a:	83 ec 0c             	sub    $0xc,%esp
8010169d:	ff 75 f4             	push   -0xc(%ebp)
801016a0:	e8 ac eb ff ff       	call   80100251 <brelse>
801016a5:	83 c4 10             	add    $0x10,%esp
}
801016a8:	90                   	nop
801016a9:	c9                   	leave
801016aa:	c3                   	ret

801016ab <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016ab:	55                   	push   %ebp
801016ac:	89 e5                	mov    %esp,%ebp
801016ae:	57                   	push   %edi
801016af:	56                   	push   %esi
801016b0:	53                   	push   %ebx
801016b1:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016bb:	83 ec 08             	sub    $0x8,%esp
801016be:	68 e9 90 10 80       	push   $0x801090e9
801016c3:	68 20 1a 11 80       	push   $0x80111a20
801016c8:	e8 15 43 00 00       	call   801059e2 <initlock>
801016cd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016d7:	eb 2d                	jmp    80101706 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016dc:	89 d0                	mov    %edx,%eax
801016de:	c1 e0 03             	shl    $0x3,%eax
801016e1:	01 d0                	add    %edx,%eax
801016e3:	c1 e0 04             	shl    $0x4,%eax
801016e6:	83 c0 30             	add    $0x30,%eax
801016e9:	05 20 1a 11 80       	add    $0x80111a20,%eax
801016ee:	83 c0 10             	add    $0x10,%eax
801016f1:	83 ec 08             	sub    $0x8,%esp
801016f4:	68 f0 90 10 80       	push   $0x801090f0
801016f9:	50                   	push   %eax
801016fa:	e8 60 41 00 00       	call   8010585f <initsleeplock>
801016ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101702:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101706:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010170a:	7e cd                	jle    801016d9 <iinit+0x2e>
  }

  readsb(dev, &sb);
8010170c:	83 ec 08             	sub    $0x8,%esp
8010170f:	68 00 1a 11 80       	push   $0x80111a00
80101714:	ff 75 08             	push   0x8(%ebp)
80101717:	e8 f9 fc ff ff       	call   80101415 <readsb>
8010171c:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010171f:	a1 18 1a 11 80       	mov    0x80111a18,%eax
80101724:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101727:	8b 3d 14 1a 11 80    	mov    0x80111a14,%edi
8010172d:	8b 35 10 1a 11 80    	mov    0x80111a10,%esi
80101733:	8b 1d 0c 1a 11 80    	mov    0x80111a0c,%ebx
80101739:	8b 0d 08 1a 11 80    	mov    0x80111a08,%ecx
8010173f:	8b 15 04 1a 11 80    	mov    0x80111a04,%edx
80101745:	a1 00 1a 11 80       	mov    0x80111a00,%eax
8010174a:	ff 75 d4             	push   -0x2c(%ebp)
8010174d:	57                   	push   %edi
8010174e:	56                   	push   %esi
8010174f:	53                   	push   %ebx
80101750:	51                   	push   %ecx
80101751:	52                   	push   %edx
80101752:	50                   	push   %eax
80101753:	68 f8 90 10 80       	push   $0x801090f8
80101758:	e8 a1 ec ff ff       	call   801003fe <cprintf>
8010175d:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101760:	90                   	nop
80101761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5f                   	pop    %edi
80101767:	5d                   	pop    %ebp
80101768:	c3                   	ret

80101769 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101769:	55                   	push   %ebp
8010176a:	89 e5                	mov    %esp,%ebp
8010176c:	83 ec 28             	sub    $0x28,%esp
8010176f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101772:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101776:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010177d:	e9 9e 00 00 00       	jmp    80101820 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101785:	c1 e8 03             	shr    $0x3,%eax
80101788:	89 c2                	mov    %eax,%edx
8010178a:	a1 14 1a 11 80       	mov    0x80111a14,%eax
8010178f:	01 d0                	add    %edx,%eax
80101791:	83 ec 08             	sub    $0x8,%esp
80101794:	50                   	push   %eax
80101795:	ff 75 08             	push   0x8(%ebp)
80101798:	e8 32 ea ff ff       	call   801001cf <bread>
8010179d:	83 c4 10             	add    $0x10,%esp
801017a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a6:	8d 50 5c             	lea    0x5c(%eax),%edx
801017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ac:	83 e0 07             	and    $0x7,%eax
801017af:	c1 e0 06             	shl    $0x6,%eax
801017b2:	01 d0                	add    %edx,%eax
801017b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ba:	0f b7 00             	movzwl (%eax),%eax
801017bd:	66 85 c0             	test   %ax,%ax
801017c0:	75 4c                	jne    8010180e <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017c2:	83 ec 04             	sub    $0x4,%esp
801017c5:	6a 40                	push   $0x40
801017c7:	6a 00                	push   $0x0
801017c9:	ff 75 ec             	push   -0x14(%ebp)
801017cc:	e8 b9 44 00 00       	call   80105c8a <memset>
801017d1:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017d7:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017db:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017de:	83 ec 0c             	sub    $0xc,%esp
801017e1:	ff 75 f0             	push   -0x10(%ebp)
801017e4:	e8 08 24 00 00       	call   80103bf1 <log_write>
801017e9:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017ec:	83 ec 0c             	sub    $0xc,%esp
801017ef:	ff 75 f0             	push   -0x10(%ebp)
801017f2:	e8 5a ea ff ff       	call   80100251 <brelse>
801017f7:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fd:	83 ec 08             	sub    $0x8,%esp
80101800:	50                   	push   %eax
80101801:	ff 75 08             	push   0x8(%ebp)
80101804:	e8 f7 00 00 00       	call   80101900 <iget>
80101809:	83 c4 10             	add    $0x10,%esp
8010180c:	eb 2f                	jmp    8010183d <ialloc+0xd4>
    }
    brelse(bp);
8010180e:	83 ec 0c             	sub    $0xc,%esp
80101811:	ff 75 f0             	push   -0x10(%ebp)
80101814:	e8 38 ea ff ff       	call   80100251 <brelse>
80101819:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
8010181c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101820:	a1 08 1a 11 80       	mov    0x80111a08,%eax
80101825:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101828:	39 c2                	cmp    %eax,%edx
8010182a:	0f 82 52 ff ff ff    	jb     80101782 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101830:	83 ec 0c             	sub    $0xc,%esp
80101833:	68 4b 91 10 80       	push   $0x8010914b
80101838:	e8 76 ed ff ff       	call   801005b3 <panic>
}
8010183d:	c9                   	leave
8010183e:	c3                   	ret

8010183f <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010183f:	55                   	push   %ebp
80101840:	89 e5                	mov    %esp,%ebp
80101842:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101845:	8b 45 08             	mov    0x8(%ebp),%eax
80101848:	8b 40 04             	mov    0x4(%eax),%eax
8010184b:	c1 e8 03             	shr    $0x3,%eax
8010184e:	89 c2                	mov    %eax,%edx
80101850:	a1 14 1a 11 80       	mov    0x80111a14,%eax
80101855:	01 c2                	add    %eax,%edx
80101857:	8b 45 08             	mov    0x8(%ebp),%eax
8010185a:	8b 00                	mov    (%eax),%eax
8010185c:	83 ec 08             	sub    $0x8,%esp
8010185f:	52                   	push   %edx
80101860:	50                   	push   %eax
80101861:	e8 69 e9 ff ff       	call   801001cf <bread>
80101866:	83 c4 10             	add    $0x10,%esp
80101869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101872:	8b 45 08             	mov    0x8(%ebp),%eax
80101875:	8b 40 04             	mov    0x4(%eax),%eax
80101878:	83 e0 07             	and    $0x7,%eax
8010187b:	c1 e0 06             	shl    $0x6,%eax
8010187e:	01 d0                	add    %edx,%eax
80101880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101883:	8b 45 08             	mov    0x8(%ebp),%eax
80101886:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189a:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010189e:	8b 45 08             	mov    0x8(%ebp),%eax
801018a1:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a8:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018ac:	8b 45 08             	mov    0x8(%ebp),%eax
801018af:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b6:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018ba:	8b 45 08             	mov    0x8(%ebp),%eax
801018bd:	8b 50 58             	mov    0x58(%eax),%edx
801018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018c6:	8b 45 08             	mov    0x8(%ebp),%eax
801018c9:	8d 50 5c             	lea    0x5c(%eax),%edx
801018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018cf:	83 c0 0c             	add    $0xc,%eax
801018d2:	83 ec 04             	sub    $0x4,%esp
801018d5:	6a 34                	push   $0x34
801018d7:	52                   	push   %edx
801018d8:	50                   	push   %eax
801018d9:	e8 6b 44 00 00       	call   80105d49 <memmove>
801018de:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018e1:	83 ec 0c             	sub    $0xc,%esp
801018e4:	ff 75 f4             	push   -0xc(%ebp)
801018e7:	e8 05 23 00 00       	call   80103bf1 <log_write>
801018ec:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018ef:	83 ec 0c             	sub    $0xc,%esp
801018f2:	ff 75 f4             	push   -0xc(%ebp)
801018f5:	e8 57 e9 ff ff       	call   80100251 <brelse>
801018fa:	83 c4 10             	add    $0x10,%esp
}
801018fd:	90                   	nop
801018fe:	c9                   	leave
801018ff:	c3                   	ret

80101900 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101906:	83 ec 0c             	sub    $0xc,%esp
80101909:	68 20 1a 11 80       	push   $0x80111a20
8010190e:	e8 f1 40 00 00       	call   80105a04 <acquire>
80101913:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101916:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010191d:	c7 45 f4 54 1a 11 80 	movl   $0x80111a54,-0xc(%ebp)
80101924:	eb 60                	jmp    80101986 <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101929:	8b 40 08             	mov    0x8(%eax),%eax
8010192c:	85 c0                	test   %eax,%eax
8010192e:	7e 39                	jle    80101969 <iget+0x69>
80101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101933:	8b 00                	mov    (%eax),%eax
80101935:	39 45 08             	cmp    %eax,0x8(%ebp)
80101938:	75 2f                	jne    80101969 <iget+0x69>
8010193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193d:	8b 40 04             	mov    0x4(%eax),%eax
80101940:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101943:	75 24                	jne    80101969 <iget+0x69>
      ip->ref++;
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	8b 40 08             	mov    0x8(%eax),%eax
8010194b:	8d 50 01             	lea    0x1(%eax),%edx
8010194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101951:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101954:	83 ec 0c             	sub    $0xc,%esp
80101957:	68 20 1a 11 80       	push   $0x80111a20
8010195c:	e8 11 41 00 00       	call   80105a72 <release>
80101961:	83 c4 10             	add    $0x10,%esp
      return ip;
80101964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101967:	eb 77                	jmp    801019e0 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010196d:	75 10                	jne    8010197f <iget+0x7f>
8010196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101972:	8b 40 08             	mov    0x8(%eax),%eax
80101975:	85 c0                	test   %eax,%eax
80101977:	75 06                	jne    8010197f <iget+0x7f>
      empty = ip;
80101979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010197f:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101986:	81 7d f4 74 36 11 80 	cmpl   $0x80113674,-0xc(%ebp)
8010198d:	72 97                	jb     80101926 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010198f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101993:	75 0d                	jne    801019a2 <iget+0xa2>
    panic("iget: no inodes");
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	68 5d 91 10 80       	push   $0x8010915d
8010199d:	e8 11 ec ff ff       	call   801005b3 <panic>

  ip = empty;
801019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	8b 55 08             	mov    0x8(%ebp),%edx
801019ae:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801019b6:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019bc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019cd:	83 ec 0c             	sub    $0xc,%esp
801019d0:	68 20 1a 11 80       	push   $0x80111a20
801019d5:	e8 98 40 00 00       	call   80105a72 <release>
801019da:	83 c4 10             	add    $0x10,%esp

  return ip;
801019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019e0:	c9                   	leave
801019e1:	c3                   	ret

801019e2 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019e2:	55                   	push   %ebp
801019e3:	89 e5                	mov    %esp,%ebp
801019e5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019e8:	83 ec 0c             	sub    $0xc,%esp
801019eb:	68 20 1a 11 80       	push   $0x80111a20
801019f0:	e8 0f 40 00 00       	call   80105a04 <acquire>
801019f5:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f8:	8b 45 08             	mov    0x8(%ebp),%eax
801019fb:	8b 40 08             	mov    0x8(%eax),%eax
801019fe:	8d 50 01             	lea    0x1(%eax),%edx
80101a01:	8b 45 08             	mov    0x8(%ebp),%eax
80101a04:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 20 1a 11 80       	push   $0x80111a20
80101a0f:	e8 5e 40 00 00       	call   80105a72 <release>
80101a14:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a17:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a1a:	c9                   	leave
80101a1b:	c3                   	ret

80101a1c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a1c:	55                   	push   %ebp
80101a1d:	89 e5                	mov    %esp,%ebp
80101a1f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a26:	74 0a                	je     80101a32 <ilock+0x16>
80101a28:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2b:	8b 40 08             	mov    0x8(%eax),%eax
80101a2e:	85 c0                	test   %eax,%eax
80101a30:	7f 0d                	jg     80101a3f <ilock+0x23>
    panic("ilock");
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	68 6d 91 10 80       	push   $0x8010916d
80101a3a:	e8 74 eb ff ff       	call   801005b3 <panic>

  acquiresleep(&ip->lock);
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	83 c0 0c             	add    $0xc,%eax
80101a45:	83 ec 0c             	sub    $0xc,%esp
80101a48:	50                   	push   %eax
80101a49:	e8 4d 3e 00 00       	call   8010589b <acquiresleep>
80101a4e:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a57:	85 c0                	test   %eax,%eax
80101a59:	0f 85 cd 00 00 00    	jne    80101b2c <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	8b 40 04             	mov    0x4(%eax),%eax
80101a65:	c1 e8 03             	shr    $0x3,%eax
80101a68:	89 c2                	mov    %eax,%edx
80101a6a:	a1 14 1a 11 80       	mov    0x80111a14,%eax
80101a6f:	01 c2                	add    %eax,%edx
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 00                	mov    (%eax),%eax
80101a76:	83 ec 08             	sub    $0x8,%esp
80101a79:	52                   	push   %edx
80101a7a:	50                   	push   %eax
80101a7b:	e8 4f e7 ff ff       	call   801001cf <bread>
80101a80:	83 c4 10             	add    $0x10,%esp
80101a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a89:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8f:	8b 40 04             	mov    0x4(%eax),%eax
80101a92:	83 e0 07             	and    $0x7,%eax
80101a95:	c1 e0 06             	shl    $0x6,%eax
80101a98:	01 d0                	add    %edx,%eax
80101a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa0:	0f b7 10             	movzwl (%eax),%edx
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aad:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abb:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad7:	8b 50 08             	mov    0x8(%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae3:	8d 50 0c             	lea    0xc(%eax),%edx
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	83 c0 5c             	add    $0x5c,%eax
80101aec:	83 ec 04             	sub    $0x4,%esp
80101aef:	6a 34                	push   $0x34
80101af1:	52                   	push   %edx
80101af2:	50                   	push   %eax
80101af3:	e8 51 42 00 00       	call   80105d49 <memmove>
80101af8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101afb:	83 ec 0c             	sub    $0xc,%esp
80101afe:	ff 75 f4             	push   -0xc(%ebp)
80101b01:	e8 4b e7 ff ff       	call   80100251 <brelse>
80101b06:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b1a:	66 85 c0             	test   %ax,%ax
80101b1d:	75 0d                	jne    80101b2c <ilock+0x110>
      panic("ilock: no type");
80101b1f:	83 ec 0c             	sub    $0xc,%esp
80101b22:	68 73 91 10 80       	push   $0x80109173
80101b27:	e8 87 ea ff ff       	call   801005b3 <panic>
  }
}
80101b2c:	90                   	nop
80101b2d:	c9                   	leave
80101b2e:	c3                   	ret

80101b2f <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b2f:	55                   	push   %ebp
80101b30:	89 e5                	mov    %esp,%ebp
80101b32:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b39:	74 20                	je     80101b5b <iunlock+0x2c>
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	83 c0 0c             	add    $0xc,%eax
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	50                   	push   %eax
80101b45:	e8 03 3e 00 00       	call   8010594d <holdingsleep>
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	74 0a                	je     80101b5b <iunlock+0x2c>
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8b 40 08             	mov    0x8(%eax),%eax
80101b57:	85 c0                	test   %eax,%eax
80101b59:	7f 0d                	jg     80101b68 <iunlock+0x39>
    panic("iunlock");
80101b5b:	83 ec 0c             	sub    $0xc,%esp
80101b5e:	68 82 91 10 80       	push   $0x80109182
80101b63:	e8 4b ea ff ff       	call   801005b3 <panic>

  releasesleep(&ip->lock);
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	83 c0 0c             	add    $0xc,%eax
80101b6e:	83 ec 0c             	sub    $0xc,%esp
80101b71:	50                   	push   %eax
80101b72:	e8 88 3d 00 00       	call   801058ff <releasesleep>
80101b77:	83 c4 10             	add    $0x10,%esp
}
80101b7a:	90                   	nop
80101b7b:	c9                   	leave
80101b7c:	c3                   	ret

80101b7d <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b7d:	55                   	push   %ebp
80101b7e:	89 e5                	mov    %esp,%ebp
80101b80:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	83 c0 0c             	add    $0xc,%eax
80101b89:	83 ec 0c             	sub    $0xc,%esp
80101b8c:	50                   	push   %eax
80101b8d:	e8 09 3d 00 00       	call   8010589b <acquiresleep>
80101b92:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b9b:	85 c0                	test   %eax,%eax
80101b9d:	74 6a                	je     80101c09 <iput+0x8c>
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ba6:	66 85 c0             	test   %ax,%ax
80101ba9:	75 5e                	jne    80101c09 <iput+0x8c>
    acquire(&icache.lock);
80101bab:	83 ec 0c             	sub    $0xc,%esp
80101bae:	68 20 1a 11 80       	push   $0x80111a20
80101bb3:	e8 4c 3e 00 00       	call   80105a04 <acquire>
80101bb8:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	8b 40 08             	mov    0x8(%eax),%eax
80101bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	68 20 1a 11 80       	push   $0x80111a20
80101bcc:	e8 a1 3e 00 00       	call   80105a72 <release>
80101bd1:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101bd4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bd8:	75 2f                	jne    80101c09 <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bda:	83 ec 0c             	sub    $0xc,%esp
80101bdd:	ff 75 08             	push   0x8(%ebp)
80101be0:	e8 ad 01 00 00       	call   80101d92 <itrunc>
80101be5:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	ff 75 08             	push   0x8(%ebp)
80101bf7:	e8 43 fc ff ff       	call   8010183f <iupdate>
80101bfc:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bff:	8b 45 08             	mov    0x8(%ebp),%eax
80101c02:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	83 c0 0c             	add    $0xc,%eax
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	50                   	push   %eax
80101c13:	e8 e7 3c 00 00       	call   801058ff <releasesleep>
80101c18:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
80101c1e:	68 20 1a 11 80       	push   $0x80111a20
80101c23:	e8 dc 3d 00 00       	call   80105a04 <acquire>
80101c28:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2e:	8b 40 08             	mov    0x8(%eax),%eax
80101c31:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	68 20 1a 11 80       	push   $0x80111a20
80101c42:	e8 2b 3e 00 00       	call   80105a72 <release>
80101c47:	83 c4 10             	add    $0x10,%esp
}
80101c4a:	90                   	nop
80101c4b:	c9                   	leave
80101c4c:	c3                   	ret

80101c4d <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c4d:	55                   	push   %ebp
80101c4e:	89 e5                	mov    %esp,%ebp
80101c50:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c53:	83 ec 0c             	sub    $0xc,%esp
80101c56:	ff 75 08             	push   0x8(%ebp)
80101c59:	e8 d1 fe ff ff       	call   80101b2f <iunlock>
80101c5e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c61:	83 ec 0c             	sub    $0xc,%esp
80101c64:	ff 75 08             	push   0x8(%ebp)
80101c67:	e8 11 ff ff ff       	call   80101b7d <iput>
80101c6c:	83 c4 10             	add    $0x10,%esp
}
80101c6f:	90                   	nop
80101c70:	c9                   	leave
80101c71:	c3                   	ret

80101c72 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c72:	55                   	push   %ebp
80101c73:	89 e5                	mov    %esp,%ebp
80101c75:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c78:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c7c:	77 42                	ja     80101cc0 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c84:	83 c2 14             	add    $0x14,%edx
80101c87:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c92:	75 24                	jne    80101cb8 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 00                	mov    (%eax),%eax
80101c99:	83 ec 0c             	sub    $0xc,%esp
80101c9c:	50                   	push   %eax
80101c9d:	e8 09 f8 ff ff       	call   801014ab <balloc>
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cab:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cae:	8d 4a 14             	lea    0x14(%edx),%ecx
80101cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb4:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cbb:	e9 d0 00 00 00       	jmp    80101d90 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101cc0:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cc4:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cc8:	0f 87 b5 00 00 00    	ja     80101d83 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cde:	75 20                	jne    80101d00 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce3:	8b 00                	mov    (%eax),%eax
80101ce5:	83 ec 0c             	sub    $0xc,%esp
80101ce8:	50                   	push   %eax
80101ce9:	e8 bd f7 ff ff       	call   801014ab <balloc>
80101cee:	83 c4 10             	add    $0x10,%esp
80101cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfa:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 00                	mov    (%eax),%eax
80101d05:	83 ec 08             	sub    $0x8,%esp
80101d08:	ff 75 f4             	push   -0xc(%ebp)
80101d0b:	50                   	push   %eax
80101d0c:	e8 be e4 ff ff       	call   801001cf <bread>
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1a:	83 c0 5c             	add    $0x5c,%eax
80101d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d2d:	01 d0                	add    %edx,%eax
80101d2f:	8b 00                	mov    (%eax),%eax
80101d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d38:	75 36                	jne    80101d70 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3d:	8b 00                	mov    (%eax),%eax
80101d3f:	83 ec 0c             	sub    $0xc,%esp
80101d42:	50                   	push   %eax
80101d43:	e8 63 f7 ff ff       	call   801014ab <balloc>
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d5b:	01 c2                	add    %eax,%edx
80101d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d60:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	ff 75 f0             	push   -0x10(%ebp)
80101d68:	e8 84 1e 00 00       	call   80103bf1 <log_write>
80101d6d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d70:	83 ec 0c             	sub    $0xc,%esp
80101d73:	ff 75 f0             	push   -0x10(%ebp)
80101d76:	e8 d6 e4 ff ff       	call   80100251 <brelse>
80101d7b:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d81:	eb 0d                	jmp    80101d90 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d83:	83 ec 0c             	sub    $0xc,%esp
80101d86:	68 8a 91 10 80       	push   $0x8010918a
80101d8b:	e8 23 e8 ff ff       	call   801005b3 <panic>
}
80101d90:	c9                   	leave
80101d91:	c3                   	ret

80101d92 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d92:	55                   	push   %ebp
80101d93:	89 e5                	mov    %esp,%ebp
80101d95:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d9f:	eb 45                	jmp    80101de6 <itrunc+0x54>
    if(ip->addrs[i]){
80101da1:	8b 45 08             	mov    0x8(%ebp),%eax
80101da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da7:	83 c2 14             	add    $0x14,%edx
80101daa:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dae:	85 c0                	test   %eax,%eax
80101db0:	74 30                	je     80101de2 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db8:	83 c2 14             	add    $0x14,%edx
80101dbb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc2:	8b 12                	mov    (%edx),%edx
80101dc4:	83 ec 08             	sub    $0x8,%esp
80101dc7:	50                   	push   %eax
80101dc8:	52                   	push   %edx
80101dc9:	e8 20 f8 ff ff       	call   801015ee <bfree>
80101dce:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dd7:	83 c2 14             	add    $0x14,%edx
80101dda:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101de1:	00 
  for(i = 0; i < NDIRECT; i++){
80101de2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101de6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dea:	7e b5                	jle    80101da1 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101df5:	85 c0                	test   %eax,%eax
80101df7:	0f 84 aa 00 00 00    	je     80101ea7 <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 00                	mov    (%eax),%eax
80101e0b:	83 ec 08             	sub    $0x8,%esp
80101e0e:	52                   	push   %edx
80101e0f:	50                   	push   %eax
80101e10:	e8 ba e3 ff ff       	call   801001cf <bread>
80101e15:	83 c4 10             	add    $0x10,%esp
80101e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e1e:	83 c0 5c             	add    $0x5c,%eax
80101e21:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e2b:	eb 3c                	jmp    80101e69 <itrunc+0xd7>
      if(a[j])
80101e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e3a:	01 d0                	add    %edx,%eax
80101e3c:	8b 00                	mov    (%eax),%eax
80101e3e:	85 c0                	test   %eax,%eax
80101e40:	74 23                	je     80101e65 <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e4f:	01 d0                	add    %edx,%eax
80101e51:	8b 00                	mov    (%eax),%eax
80101e53:	8b 55 08             	mov    0x8(%ebp),%edx
80101e56:	8b 12                	mov    (%edx),%edx
80101e58:	83 ec 08             	sub    $0x8,%esp
80101e5b:	50                   	push   %eax
80101e5c:	52                   	push   %edx
80101e5d:	e8 8c f7 ff ff       	call   801015ee <bfree>
80101e62:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e65:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6c:	83 f8 7f             	cmp    $0x7f,%eax
80101e6f:	76 bc                	jbe    80101e2d <itrunc+0x9b>
    }
    brelse(bp);
80101e71:	83 ec 0c             	sub    $0xc,%esp
80101e74:	ff 75 ec             	push   -0x14(%ebp)
80101e77:	e8 d5 e3 ff ff       	call   80100251 <brelse>
80101e7c:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e88:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8b:	8b 12                	mov    (%edx),%edx
80101e8d:	83 ec 08             	sub    $0x8,%esp
80101e90:	50                   	push   %eax
80101e91:	52                   	push   %edx
80101e92:	e8 57 f7 ff ff       	call   801015ee <bfree>
80101e97:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101ea4:	00 00 00 
  }

  ip->size = 0;
80101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaa:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101eb1:	83 ec 0c             	sub    $0xc,%esp
80101eb4:	ff 75 08             	push   0x8(%ebp)
80101eb7:	e8 83 f9 ff ff       	call   8010183f <iupdate>
80101ebc:	83 c4 10             	add    $0x10,%esp
}
80101ebf:	90                   	nop
80101ec0:	c9                   	leave
80101ec1:	c3                   	ret

80101ec2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ec2:	55                   	push   %ebp
80101ec3:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	8b 00                	mov    (%eax),%eax
80101eca:	89 c2                	mov    %eax,%edx
80101ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecf:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed5:	8b 50 04             	mov    0x4(%eax),%edx
80101ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edb:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee8:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef5:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	8b 50 58             	mov    0x58(%eax),%edx
80101eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f02:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f05:	90                   	nop
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret

80101f08 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f08:	55                   	push   %ebp
80101f09:	89 e5                	mov    %esp,%ebp
80101f0b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f11:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f15:	66 83 f8 03          	cmp    $0x3,%ax
80101f19:	75 5c                	jne    80101f77 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f22:	66 85 c0             	test   %ax,%ax
80101f25:	78 20                	js     80101f47 <readi+0x3f>
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f2e:	66 83 f8 09          	cmp    $0x9,%ax
80101f32:	7f 13                	jg     80101f47 <readi+0x3f>
80101f34:	8b 45 08             	mov    0x8(%ebp),%eax
80101f37:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f3b:	98                   	cwtl
80101f3c:	8b 04 c5 00 10 11 80 	mov    -0x7feef000(,%eax,8),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	75 0a                	jne    80101f51 <readi+0x49>
      return -1;
80101f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4c:	e9 0a 01 00 00       	jmp    8010205b <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f51:	8b 45 08             	mov    0x8(%ebp),%eax
80101f54:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f58:	98                   	cwtl
80101f59:	8b 04 c5 00 10 11 80 	mov    -0x7feef000(,%eax,8),%eax
80101f60:	8b 55 14             	mov    0x14(%ebp),%edx
80101f63:	83 ec 04             	sub    $0x4,%esp
80101f66:	52                   	push   %edx
80101f67:	ff 75 0c             	push   0xc(%ebp)
80101f6a:	ff 75 08             	push   0x8(%ebp)
80101f6d:	ff d0                	call   *%eax
80101f6f:	83 c4 10             	add    $0x10,%esp
80101f72:	e9 e4 00 00 00       	jmp    8010205b <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	8b 40 58             	mov    0x58(%eax),%eax
80101f7d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f80:	72 0d                	jb     80101f8f <readi+0x87>
80101f82:	8b 55 10             	mov    0x10(%ebp),%edx
80101f85:	8b 45 14             	mov    0x14(%ebp),%eax
80101f88:	01 d0                	add    %edx,%eax
80101f8a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f8d:	73 0a                	jae    80101f99 <readi+0x91>
    return -1;
80101f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f94:	e9 c2 00 00 00       	jmp    8010205b <readi+0x153>
  if(off + n > ip->size)
80101f99:	8b 55 10             	mov    0x10(%ebp),%edx
80101f9c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f9f:	01 c2                	add    %eax,%edx
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	8b 40 58             	mov    0x58(%eax),%eax
80101fa7:	39 d0                	cmp    %edx,%eax
80101fa9:	73 0c                	jae    80101fb7 <readi+0xaf>
    n = ip->size - off;
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
80101fae:	8b 40 58             	mov    0x58(%eax),%eax
80101fb1:	2b 45 10             	sub    0x10(%ebp),%eax
80101fb4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fbe:	e9 89 00 00 00       	jmp    8010204c <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc6:	c1 e8 09             	shr    $0x9,%eax
80101fc9:	83 ec 08             	sub    $0x8,%esp
80101fcc:	50                   	push   %eax
80101fcd:	ff 75 08             	push   0x8(%ebp)
80101fd0:	e8 9d fc ff ff       	call   80101c72 <bmap>
80101fd5:	83 c4 10             	add    $0x10,%esp
80101fd8:	8b 55 08             	mov    0x8(%ebp),%edx
80101fdb:	8b 12                	mov    (%edx),%edx
80101fdd:	83 ec 08             	sub    $0x8,%esp
80101fe0:	50                   	push   %eax
80101fe1:	52                   	push   %edx
80101fe2:	e8 e8 e1 ff ff       	call   801001cf <bread>
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fed:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff5:	ba 00 02 00 00       	mov    $0x200,%edx
80101ffa:	29 c2                	sub    %eax,%edx
80101ffc:	8b 45 14             	mov    0x14(%ebp),%eax
80101fff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102002:	39 c2                	cmp    %eax,%edx
80102004:	0f 46 c2             	cmovbe %edx,%eax
80102007:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102010:	8b 45 10             	mov    0x10(%ebp),%eax
80102013:	25 ff 01 00 00       	and    $0x1ff,%eax
80102018:	01 d0                	add    %edx,%eax
8010201a:	83 ec 04             	sub    $0x4,%esp
8010201d:	ff 75 ec             	push   -0x14(%ebp)
80102020:	50                   	push   %eax
80102021:	ff 75 0c             	push   0xc(%ebp)
80102024:	e8 20 3d 00 00       	call   80105d49 <memmove>
80102029:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	ff 75 f0             	push   -0x10(%ebp)
80102032:	e8 1a e2 ff ff       	call   80100251 <brelse>
80102037:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102040:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102043:	01 45 10             	add    %eax,0x10(%ebp)
80102046:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102049:	01 45 0c             	add    %eax,0xc(%ebp)
8010204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102052:	0f 82 6b ff ff ff    	jb     80101fc3 <readi+0xbb>
  }
  return n;
80102058:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010205b:	c9                   	leave
8010205c:	c3                   	ret

8010205d <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010205d:	55                   	push   %ebp
8010205e:	89 e5                	mov    %esp,%ebp
80102060:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102063:	8b 45 08             	mov    0x8(%ebp),%eax
80102066:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010206a:	66 83 f8 03          	cmp    $0x3,%ax
8010206e:	75 5c                	jne    801020cc <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102070:	8b 45 08             	mov    0x8(%ebp),%eax
80102073:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102077:	66 85 c0             	test   %ax,%ax
8010207a:	78 20                	js     8010209c <writei+0x3f>
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102083:	66 83 f8 09          	cmp    $0x9,%ax
80102087:	7f 13                	jg     8010209c <writei+0x3f>
80102089:	8b 45 08             	mov    0x8(%ebp),%eax
8010208c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102090:	98                   	cwtl
80102091:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80102098:	85 c0                	test   %eax,%eax
8010209a:	75 0a                	jne    801020a6 <writei+0x49>
      return -1;
8010209c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a1:	e9 3b 01 00 00       	jmp    801021e1 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
801020a6:	8b 45 08             	mov    0x8(%ebp),%eax
801020a9:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020ad:	98                   	cwtl
801020ae:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
801020b5:	8b 55 14             	mov    0x14(%ebp),%edx
801020b8:	83 ec 04             	sub    $0x4,%esp
801020bb:	52                   	push   %edx
801020bc:	ff 75 0c             	push   0xc(%ebp)
801020bf:	ff 75 08             	push   0x8(%ebp)
801020c2:	ff d0                	call   *%eax
801020c4:	83 c4 10             	add    $0x10,%esp
801020c7:	e9 15 01 00 00       	jmp    801021e1 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	8b 40 58             	mov    0x58(%eax),%eax
801020d2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d5:	72 0d                	jb     801020e4 <writei+0x87>
801020d7:	8b 55 10             	mov    0x10(%ebp),%edx
801020da:	8b 45 14             	mov    0x14(%ebp),%eax
801020dd:	01 d0                	add    %edx,%eax
801020df:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e2:	73 0a                	jae    801020ee <writei+0x91>
    return -1;
801020e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e9:	e9 f3 00 00 00       	jmp    801021e1 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020ee:	8b 55 10             	mov    0x10(%ebp),%edx
801020f1:	8b 45 14             	mov    0x14(%ebp),%eax
801020f4:	01 d0                	add    %edx,%eax
801020f6:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020fb:	76 0a                	jbe    80102107 <writei+0xaa>
    return -1;
801020fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102102:	e9 da 00 00 00       	jmp    801021e1 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010210e:	e9 97 00 00 00       	jmp    801021aa <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	c1 e8 09             	shr    $0x9,%eax
80102119:	83 ec 08             	sub    $0x8,%esp
8010211c:	50                   	push   %eax
8010211d:	ff 75 08             	push   0x8(%ebp)
80102120:	e8 4d fb ff ff       	call   80101c72 <bmap>
80102125:	83 c4 10             	add    $0x10,%esp
80102128:	8b 55 08             	mov    0x8(%ebp),%edx
8010212b:	8b 12                	mov    (%edx),%edx
8010212d:	83 ec 08             	sub    $0x8,%esp
80102130:	50                   	push   %eax
80102131:	52                   	push   %edx
80102132:	e8 98 e0 ff ff       	call   801001cf <bread>
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010213d:	8b 45 10             	mov    0x10(%ebp),%eax
80102140:	25 ff 01 00 00       	and    $0x1ff,%eax
80102145:	ba 00 02 00 00       	mov    $0x200,%edx
8010214a:	29 c2                	sub    %eax,%edx
8010214c:	8b 45 14             	mov    0x14(%ebp),%eax
8010214f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102152:	39 c2                	cmp    %eax,%edx
80102154:	0f 46 c2             	cmovbe %edx,%eax
80102157:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010215d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102160:	8b 45 10             	mov    0x10(%ebp),%eax
80102163:	25 ff 01 00 00       	and    $0x1ff,%eax
80102168:	01 d0                	add    %edx,%eax
8010216a:	83 ec 04             	sub    $0x4,%esp
8010216d:	ff 75 ec             	push   -0x14(%ebp)
80102170:	ff 75 0c             	push   0xc(%ebp)
80102173:	50                   	push   %eax
80102174:	e8 d0 3b 00 00       	call   80105d49 <memmove>
80102179:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010217c:	83 ec 0c             	sub    $0xc,%esp
8010217f:	ff 75 f0             	push   -0x10(%ebp)
80102182:	e8 6a 1a 00 00       	call   80103bf1 <log_write>
80102187:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010218a:	83 ec 0c             	sub    $0xc,%esp
8010218d:	ff 75 f0             	push   -0x10(%ebp)
80102190:	e8 bc e0 ff ff       	call   80100251 <brelse>
80102195:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102198:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010219e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a1:	01 45 10             	add    %eax,0x10(%ebp)
801021a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a7:	01 45 0c             	add    %eax,0xc(%ebp)
801021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ad:	3b 45 14             	cmp    0x14(%ebp),%eax
801021b0:	0f 82 5d ff ff ff    	jb     80102113 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
801021b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021ba:	74 22                	je     801021de <writei+0x181>
801021bc:	8b 45 08             	mov    0x8(%ebp),%eax
801021bf:	8b 40 58             	mov    0x58(%eax),%eax
801021c2:	3b 45 10             	cmp    0x10(%ebp),%eax
801021c5:	73 17                	jae    801021de <writei+0x181>
    ip->size = off;
801021c7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ca:	8b 55 10             	mov    0x10(%ebp),%edx
801021cd:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	ff 75 08             	push   0x8(%ebp)
801021d6:	e8 64 f6 ff ff       	call   8010183f <iupdate>
801021db:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021de:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021e1:	c9                   	leave
801021e2:	c3                   	ret

801021e3 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021e3:	55                   	push   %ebp
801021e4:	89 e5                	mov    %esp,%ebp
801021e6:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021e9:	83 ec 04             	sub    $0x4,%esp
801021ec:	6a 0e                	push   $0xe
801021ee:	ff 75 0c             	push   0xc(%ebp)
801021f1:	ff 75 08             	push   0x8(%ebp)
801021f4:	e8 e6 3b 00 00       	call   80105ddf <strncmp>
801021f9:	83 c4 10             	add    $0x10,%esp
}
801021fc:	c9                   	leave
801021fd:	c3                   	ret

801021fe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021fe:	55                   	push   %ebp
801021ff:	89 e5                	mov    %esp,%ebp
80102201:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102204:	8b 45 08             	mov    0x8(%ebp),%eax
80102207:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010220b:	66 83 f8 01          	cmp    $0x1,%ax
8010220f:	74 0d                	je     8010221e <dirlookup+0x20>
    panic("dirlookup not DIR");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 9d 91 10 80       	push   $0x8010919d
80102219:	e8 95 e3 ff ff       	call   801005b3 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102225:	eb 7b                	jmp    801022a2 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102227:	6a 10                	push   $0x10
80102229:	ff 75 f4             	push   -0xc(%ebp)
8010222c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222f:	50                   	push   %eax
80102230:	ff 75 08             	push   0x8(%ebp)
80102233:	e8 d0 fc ff ff       	call   80101f08 <readi>
80102238:	83 c4 10             	add    $0x10,%esp
8010223b:	83 f8 10             	cmp    $0x10,%eax
8010223e:	74 0d                	je     8010224d <dirlookup+0x4f>
      panic("dirlookup read");
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 af 91 10 80       	push   $0x801091af
80102248:	e8 66 e3 ff ff       	call   801005b3 <panic>
    if(de.inum == 0)
8010224d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102251:	66 85 c0             	test   %ax,%ax
80102254:	74 47                	je     8010229d <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102256:	83 ec 08             	sub    $0x8,%esp
80102259:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010225c:	83 c0 02             	add    $0x2,%eax
8010225f:	50                   	push   %eax
80102260:	ff 75 0c             	push   0xc(%ebp)
80102263:	e8 7b ff ff ff       	call   801021e3 <namecmp>
80102268:	83 c4 10             	add    $0x10,%esp
8010226b:	85 c0                	test   %eax,%eax
8010226d:	75 2f                	jne    8010229e <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010226f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102273:	74 08                	je     8010227d <dirlookup+0x7f>
        *poff = off;
80102275:	8b 45 10             	mov    0x10(%ebp),%eax
80102278:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010227b:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010227d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102281:	0f b7 c0             	movzwl %ax,%eax
80102284:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102287:	8b 45 08             	mov    0x8(%ebp),%eax
8010228a:	8b 00                	mov    (%eax),%eax
8010228c:	83 ec 08             	sub    $0x8,%esp
8010228f:	ff 75 f0             	push   -0x10(%ebp)
80102292:	50                   	push   %eax
80102293:	e8 68 f6 ff ff       	call   80101900 <iget>
80102298:	83 c4 10             	add    $0x10,%esp
8010229b:	eb 19                	jmp    801022b6 <dirlookup+0xb8>
      continue;
8010229d:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010229e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022a2:	8b 45 08             	mov    0x8(%ebp),%eax
801022a5:	8b 40 58             	mov    0x58(%eax),%eax
801022a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801022ab:	0f 82 76 ff ff ff    	jb     80102227 <dirlookup+0x29>
    }
  }

  return 0;
801022b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b6:	c9                   	leave
801022b7:	c3                   	ret

801022b8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022b8:	55                   	push   %ebp
801022b9:	89 e5                	mov    %esp,%ebp
801022bb:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022be:	83 ec 04             	sub    $0x4,%esp
801022c1:	6a 00                	push   $0x0
801022c3:	ff 75 0c             	push   0xc(%ebp)
801022c6:	ff 75 08             	push   0x8(%ebp)
801022c9:	e8 30 ff ff ff       	call   801021fe <dirlookup>
801022ce:	83 c4 10             	add    $0x10,%esp
801022d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022d8:	74 18                	je     801022f2 <dirlink+0x3a>
    iput(ip);
801022da:	83 ec 0c             	sub    $0xc,%esp
801022dd:	ff 75 f0             	push   -0x10(%ebp)
801022e0:	e8 98 f8 ff ff       	call   80101b7d <iput>
801022e5:	83 c4 10             	add    $0x10,%esp
    return -1;
801022e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022ed:	e9 9c 00 00 00       	jmp    8010238e <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022f9:	eb 39                	jmp    80102334 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fe:	6a 10                	push   $0x10
80102300:	50                   	push   %eax
80102301:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102304:	50                   	push   %eax
80102305:	ff 75 08             	push   0x8(%ebp)
80102308:	e8 fb fb ff ff       	call   80101f08 <readi>
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	83 f8 10             	cmp    $0x10,%eax
80102313:	74 0d                	je     80102322 <dirlink+0x6a>
      panic("dirlink read");
80102315:	83 ec 0c             	sub    $0xc,%esp
80102318:	68 be 91 10 80       	push   $0x801091be
8010231d:	e8 91 e2 ff ff       	call   801005b3 <panic>
    if(de.inum == 0)
80102322:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102326:	66 85 c0             	test   %ax,%ax
80102329:	74 18                	je     80102343 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232e:	83 c0 10             	add    $0x10,%eax
80102331:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102334:	8b 45 08             	mov    0x8(%ebp),%eax
80102337:	8b 40 58             	mov    0x58(%eax),%eax
8010233a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010233d:	39 c2                	cmp    %eax,%edx
8010233f:	72 ba                	jb     801022fb <dirlink+0x43>
80102341:	eb 01                	jmp    80102344 <dirlink+0x8c>
      break;
80102343:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	6a 0e                	push   $0xe
80102349:	ff 75 0c             	push   0xc(%ebp)
8010234c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234f:	83 c0 02             	add    $0x2,%eax
80102352:	50                   	push   %eax
80102353:	e8 dd 3a 00 00       	call   80105e35 <strncpy>
80102358:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010235b:	8b 45 10             	mov    0x10(%ebp),%eax
8010235e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102365:	6a 10                	push   $0x10
80102367:	50                   	push   %eax
80102368:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010236b:	50                   	push   %eax
8010236c:	ff 75 08             	push   0x8(%ebp)
8010236f:	e8 e9 fc ff ff       	call   8010205d <writei>
80102374:	83 c4 10             	add    $0x10,%esp
80102377:	83 f8 10             	cmp    $0x10,%eax
8010237a:	74 0d                	je     80102389 <dirlink+0xd1>
    panic("dirlink");
8010237c:	83 ec 0c             	sub    $0xc,%esp
8010237f:	68 cb 91 10 80       	push   $0x801091cb
80102384:	e8 2a e2 ff ff       	call   801005b3 <panic>

  return 0;
80102389:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010238e:	c9                   	leave
8010238f:	c3                   	ret

80102390 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102396:	eb 04                	jmp    8010239c <skipelem+0xc>
    path++;
80102398:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010239c:	8b 45 08             	mov    0x8(%ebp),%eax
8010239f:	0f b6 00             	movzbl (%eax),%eax
801023a2:	3c 2f                	cmp    $0x2f,%al
801023a4:	74 f2                	je     80102398 <skipelem+0x8>
  if(*path == 0)
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
801023a9:	0f b6 00             	movzbl (%eax),%eax
801023ac:	84 c0                	test   %al,%al
801023ae:	75 07                	jne    801023b7 <skipelem+0x27>
    return 0;
801023b0:	b8 00 00 00 00       	mov    $0x0,%eax
801023b5:	eb 77                	jmp    8010242e <skipelem+0x9e>
  s = path;
801023b7:	8b 45 08             	mov    0x8(%ebp),%eax
801023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023bd:	eb 04                	jmp    801023c3 <skipelem+0x33>
    path++;
801023bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801023c3:	8b 45 08             	mov    0x8(%ebp),%eax
801023c6:	0f b6 00             	movzbl (%eax),%eax
801023c9:	3c 2f                	cmp    $0x2f,%al
801023cb:	74 0a                	je     801023d7 <skipelem+0x47>
801023cd:	8b 45 08             	mov    0x8(%ebp),%eax
801023d0:	0f b6 00             	movzbl (%eax),%eax
801023d3:	84 c0                	test   %al,%al
801023d5:	75 e8                	jne    801023bf <skipelem+0x2f>
  len = path - s;
801023d7:	8b 45 08             	mov    0x8(%ebp),%eax
801023da:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023e0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e4:	7e 15                	jle    801023fb <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023e6:	83 ec 04             	sub    $0x4,%esp
801023e9:	6a 0e                	push   $0xe
801023eb:	ff 75 f4             	push   -0xc(%ebp)
801023ee:	ff 75 0c             	push   0xc(%ebp)
801023f1:	e8 53 39 00 00       	call   80105d49 <memmove>
801023f6:	83 c4 10             	add    $0x10,%esp
801023f9:	eb 26                	jmp    80102421 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023fe:	83 ec 04             	sub    $0x4,%esp
80102401:	50                   	push   %eax
80102402:	ff 75 f4             	push   -0xc(%ebp)
80102405:	ff 75 0c             	push   0xc(%ebp)
80102408:	e8 3c 39 00 00       	call   80105d49 <memmove>
8010240d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102410:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102413:	8b 45 0c             	mov    0xc(%ebp),%eax
80102416:	01 d0                	add    %edx,%eax
80102418:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010241b:	eb 04                	jmp    80102421 <skipelem+0x91>
    path++;
8010241d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	0f b6 00             	movzbl (%eax),%eax
80102427:	3c 2f                	cmp    $0x2f,%al
80102429:	74 f2                	je     8010241d <skipelem+0x8d>
  return path;
8010242b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010242e:	c9                   	leave
8010242f:	c3                   	ret

80102430 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102436:	8b 45 08             	mov    0x8(%ebp),%eax
80102439:	0f b6 00             	movzbl (%eax),%eax
8010243c:	3c 2f                	cmp    $0x2f,%al
8010243e:	75 17                	jne    80102457 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	6a 01                	push   $0x1
80102445:	6a 01                	push   $0x1
80102447:	e8 b4 f4 ff ff       	call   80101900 <iget>
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102452:	e9 ba 00 00 00       	jmp    80102511 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102457:	e8 bf 22 00 00       	call   8010471b <myproc>
8010245c:	8b 40 68             	mov    0x68(%eax),%eax
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	50                   	push   %eax
80102463:	e8 7a f5 ff ff       	call   801019e2 <idup>
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010246e:	e9 9e 00 00 00       	jmp    80102511 <namex+0xe1>
    ilock(ip);
80102473:	83 ec 0c             	sub    $0xc,%esp
80102476:	ff 75 f4             	push   -0xc(%ebp)
80102479:	e8 9e f5 ff ff       	call   80101a1c <ilock>
8010247e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102484:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102488:	66 83 f8 01          	cmp    $0x1,%ax
8010248c:	74 18                	je     801024a6 <namex+0x76>
      iunlockput(ip);
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	ff 75 f4             	push   -0xc(%ebp)
80102494:	e8 b4 f7 ff ff       	call   80101c4d <iunlockput>
80102499:	83 c4 10             	add    $0x10,%esp
      return 0;
8010249c:	b8 00 00 00 00       	mov    $0x0,%eax
801024a1:	e9 a7 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
801024a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024aa:	74 20                	je     801024cc <namex+0x9c>
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	84 c0                	test   %al,%al
801024b4:	75 16                	jne    801024cc <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	push   -0xc(%ebp)
801024bc:	e8 6e f6 ff ff       	call   80101b2f <iunlock>
801024c1:	83 c4 10             	add    $0x10,%esp
      return ip;
801024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c7:	e9 81 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cc:	83 ec 04             	sub    $0x4,%esp
801024cf:	6a 00                	push   $0x0
801024d1:	ff 75 10             	push   0x10(%ebp)
801024d4:	ff 75 f4             	push   -0xc(%ebp)
801024d7:	e8 22 fd ff ff       	call   801021fe <dirlookup>
801024dc:	83 c4 10             	add    $0x10,%esp
801024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e6:	75 15                	jne    801024fd <namex+0xcd>
      iunlockput(ip);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f4             	push   -0xc(%ebp)
801024ee:	e8 5a f7 ff ff       	call   80101c4d <iunlockput>
801024f3:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 50                	jmp    8010254d <namex+0x11d>
    }
    iunlockput(ip);
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	ff 75 f4             	push   -0xc(%ebp)
80102503:	e8 45 f7 ff ff       	call   80101c4d <iunlockput>
80102508:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102511:	83 ec 08             	sub    $0x8,%esp
80102514:	ff 75 10             	push   0x10(%ebp)
80102517:	ff 75 08             	push   0x8(%ebp)
8010251a:	e8 71 fe ff ff       	call   80102390 <skipelem>
8010251f:	83 c4 10             	add    $0x10,%esp
80102522:	89 45 08             	mov    %eax,0x8(%ebp)
80102525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102529:	0f 85 44 ff ff ff    	jne    80102473 <namex+0x43>
  }
  if(nameiparent){
8010252f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102533:	74 15                	je     8010254a <namex+0x11a>
    iput(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	ff 75 f4             	push   -0xc(%ebp)
8010253b:	e8 3d f6 ff ff       	call   80101b7d <iput>
80102540:	83 c4 10             	add    $0x10,%esp
    return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
80102548:	eb 03                	jmp    8010254d <namex+0x11d>
  }
  return ip;
8010254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254d:	c9                   	leave
8010254e:	c3                   	ret

8010254f <namei>:

struct inode*
namei(char *path)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	83 ec 04             	sub    $0x4,%esp
80102558:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010255b:	50                   	push   %eax
8010255c:	6a 00                	push   $0x0
8010255e:	ff 75 08             	push   0x8(%ebp)
80102561:	e8 ca fe ff ff       	call   80102430 <namex>
80102566:	83 c4 10             	add    $0x10,%esp
}
80102569:	c9                   	leave
8010256a:	c3                   	ret

8010256b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102571:	83 ec 04             	sub    $0x4,%esp
80102574:	ff 75 0c             	push   0xc(%ebp)
80102577:	6a 01                	push   $0x1
80102579:	ff 75 08             	push   0x8(%ebp)
8010257c:	e8 af fe ff ff       	call   80102430 <namex>
80102581:	83 c4 10             	add    $0x10,%esp
}
80102584:	c9                   	leave
80102585:	c3                   	ret

80102586 <inb>:
{
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 14             	sub    $0x14,%esp
8010258c:	8b 45 08             	mov    0x8(%ebp),%eax
8010258f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102593:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102597:	89 c2                	mov    %eax,%edx
80102599:	ec                   	in     (%dx),%al
8010259a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010259d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025a1:	c9                   	leave
801025a2:	c3                   	ret

801025a3 <insl>:
{
801025a3:	55                   	push   %ebp
801025a4:	89 e5                	mov    %esp,%ebp
801025a6:	57                   	push   %edi
801025a7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025a8:	8b 55 08             	mov    0x8(%ebp),%edx
801025ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025ae:	8b 45 10             	mov    0x10(%ebp),%eax
801025b1:	89 cb                	mov    %ecx,%ebx
801025b3:	89 df                	mov    %ebx,%edi
801025b5:	89 c1                	mov    %eax,%ecx
801025b7:	fc                   	cld
801025b8:	f3 6d                	rep insl (%dx),%es:(%edi)
801025ba:	89 c8                	mov    %ecx,%eax
801025bc:	89 fb                	mov    %edi,%ebx
801025be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c1:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025c4:	90                   	nop
801025c5:	5b                   	pop    %ebx
801025c6:	5f                   	pop    %edi
801025c7:	5d                   	pop    %ebp
801025c8:	c3                   	ret

801025c9 <outb>:
{
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	83 ec 08             	sub    $0x8,%esp
801025cf:	8b 55 08             	mov    0x8(%ebp),%edx
801025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025d9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025e4:	ee                   	out    %al,(%dx)
}
801025e5:	90                   	nop
801025e6:	c9                   	leave
801025e7:	c3                   	ret

801025e8 <outsl>:
{
801025e8:	55                   	push   %ebp
801025e9:	89 e5                	mov    %esp,%ebp
801025eb:	56                   	push   %esi
801025ec:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025ed:	8b 55 08             	mov    0x8(%ebp),%edx
801025f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f3:	8b 45 10             	mov    0x10(%ebp),%eax
801025f6:	89 cb                	mov    %ecx,%ebx
801025f8:	89 de                	mov    %ebx,%esi
801025fa:	89 c1                	mov    %eax,%ecx
801025fc:	fc                   	cld
801025fd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ff:	89 c8                	mov    %ecx,%eax
80102601:	89 f3                	mov    %esi,%ebx
80102603:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102606:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102609:	90                   	nop
8010260a:	5b                   	pop    %ebx
8010260b:	5e                   	pop    %esi
8010260c:	5d                   	pop    %ebp
8010260d:	c3                   	ret

8010260e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010260e:	55                   	push   %ebp
8010260f:	89 e5                	mov    %esp,%ebp
80102611:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102614:	90                   	nop
80102615:	68 f7 01 00 00       	push   $0x1f7
8010261a:	e8 67 ff ff ff       	call   80102586 <inb>
8010261f:	83 c4 04             	add    $0x4,%esp
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262b:	25 c0 00 00 00       	and    $0xc0,%eax
80102630:	83 f8 40             	cmp    $0x40,%eax
80102633:	75 e0                	jne    80102615 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102635:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102639:	74 11                	je     8010264c <idewait+0x3e>
8010263b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010263e:	83 e0 21             	and    $0x21,%eax
80102641:	85 c0                	test   %eax,%eax
80102643:	74 07                	je     8010264c <idewait+0x3e>
    return -1;
80102645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264a:	eb 05                	jmp    80102651 <idewait+0x43>
  return 0;
8010264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102651:	c9                   	leave
80102652:	c3                   	ret

80102653 <ideinit>:

void
ideinit(void)
{
80102653:	55                   	push   %ebp
80102654:	89 e5                	mov    %esp,%ebp
80102656:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102659:	83 ec 08             	sub    $0x8,%esp
8010265c:	68 d3 91 10 80       	push   $0x801091d3
80102661:	68 80 36 11 80       	push   $0x80113680
80102666:	e8 77 33 00 00       	call   801059e2 <initlock>
8010266b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010266e:	a1 c0 41 11 80       	mov    0x801141c0,%eax
80102673:	83 e8 01             	sub    $0x1,%eax
80102676:	83 ec 08             	sub    $0x8,%esp
80102679:	50                   	push   %eax
8010267a:	6a 0e                	push   $0xe
8010267c:	e8 a3 04 00 00       	call   80102b24 <ioapicenable>
80102681:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	6a 00                	push   $0x0
80102689:	e8 80 ff ff ff       	call   8010260e <idewait>
8010268e:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102691:	83 ec 08             	sub    $0x8,%esp
80102694:	68 f0 00 00 00       	push   $0xf0
80102699:	68 f6 01 00 00       	push   $0x1f6
8010269e:	e8 26 ff ff ff       	call   801025c9 <outb>
801026a3:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ad:	eb 24                	jmp    801026d3 <ideinit+0x80>
    if(inb(0x1f7) != 0){
801026af:	83 ec 0c             	sub    $0xc,%esp
801026b2:	68 f7 01 00 00       	push   $0x1f7
801026b7:	e8 ca fe ff ff       	call   80102586 <inb>
801026bc:	83 c4 10             	add    $0x10,%esp
801026bf:	84 c0                	test   %al,%al
801026c1:	74 0c                	je     801026cf <ideinit+0x7c>
      havedisk1 = 1;
801026c3:	c7 05 b8 36 11 80 01 	movl   $0x1,0x801136b8
801026ca:	00 00 00 
      break;
801026cd:	eb 0d                	jmp    801026dc <ideinit+0x89>
  for(i=0; i<1000; i++){
801026cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026d3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026da:	7e d3                	jle    801026af <ideinit+0x5c>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026dc:	83 ec 08             	sub    $0x8,%esp
801026df:	68 e0 00 00 00       	push   $0xe0
801026e4:	68 f6 01 00 00       	push   $0x1f6
801026e9:	e8 db fe ff ff       	call   801025c9 <outb>
801026ee:	83 c4 10             	add    $0x10,%esp
}
801026f1:	90                   	nop
801026f2:	c9                   	leave
801026f3:	c3                   	ret

801026f4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f4:	55                   	push   %ebp
801026f5:	89 e5                	mov    %esp,%ebp
801026f7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026fe:	75 0d                	jne    8010270d <idestart+0x19>
    panic("idestart");
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 d7 91 10 80       	push   $0x801091d7
80102708:	e8 a6 de ff ff       	call   801005b3 <panic>
  if(b->blockno >= FSSIZE)
8010270d:	8b 45 08             	mov    0x8(%ebp),%eax
80102710:	8b 40 08             	mov    0x8(%eax),%eax
80102713:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102718:	76 0d                	jbe    80102727 <idestart+0x33>
    panic("incorrect blockno");
8010271a:	83 ec 0c             	sub    $0xc,%esp
8010271d:	68 e0 91 10 80       	push   $0x801091e0
80102722:	e8 8c de ff ff       	call   801005b3 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102727:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010272e:	8b 45 08             	mov    0x8(%ebp),%eax
80102731:	8b 50 08             	mov    0x8(%eax),%edx
80102734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102737:	0f af c2             	imul   %edx,%eax
8010273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010273d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102741:	75 07                	jne    8010274a <idestart+0x56>
80102743:	b8 20 00 00 00       	mov    $0x20,%eax
80102748:	eb 05                	jmp    8010274f <idestart+0x5b>
8010274a:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010274f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102752:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102756:	75 07                	jne    8010275f <idestart+0x6b>
80102758:	b8 30 00 00 00       	mov    $0x30,%eax
8010275d:	eb 05                	jmp    80102764 <idestart+0x70>
8010275f:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102764:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102767:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010276b:	7e 0d                	jle    8010277a <idestart+0x86>
8010276d:	83 ec 0c             	sub    $0xc,%esp
80102770:	68 d7 91 10 80       	push   $0x801091d7
80102775:	e8 39 de ff ff       	call   801005b3 <panic>

  idewait(0);
8010277a:	83 ec 0c             	sub    $0xc,%esp
8010277d:	6a 00                	push   $0x0
8010277f:	e8 8a fe ff ff       	call   8010260e <idewait>
80102784:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102787:	83 ec 08             	sub    $0x8,%esp
8010278a:	6a 00                	push   $0x0
8010278c:	68 f6 03 00 00       	push   $0x3f6
80102791:	e8 33 fe ff ff       	call   801025c9 <outb>
80102796:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279c:	0f b6 c0             	movzbl %al,%eax
8010279f:	83 ec 08             	sub    $0x8,%esp
801027a2:	50                   	push   %eax
801027a3:	68 f2 01 00 00       	push   $0x1f2
801027a8:	e8 1c fe ff ff       	call   801025c9 <outb>
801027ad:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b3:	0f b6 c0             	movzbl %al,%eax
801027b6:	83 ec 08             	sub    $0x8,%esp
801027b9:	50                   	push   %eax
801027ba:	68 f3 01 00 00       	push   $0x1f3
801027bf:	e8 05 fe ff ff       	call   801025c9 <outb>
801027c4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ca:	c1 f8 08             	sar    $0x8,%eax
801027cd:	0f b6 c0             	movzbl %al,%eax
801027d0:	83 ec 08             	sub    $0x8,%esp
801027d3:	50                   	push   %eax
801027d4:	68 f4 01 00 00       	push   $0x1f4
801027d9:	e8 eb fd ff ff       	call   801025c9 <outb>
801027de:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027e4:	c1 f8 10             	sar    $0x10,%eax
801027e7:	0f b6 c0             	movzbl %al,%eax
801027ea:	83 ec 08             	sub    $0x8,%esp
801027ed:	50                   	push   %eax
801027ee:	68 f5 01 00 00       	push   $0x1f5
801027f3:	e8 d1 fd ff ff       	call   801025c9 <outb>
801027f8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	8b 40 04             	mov    0x4(%eax),%eax
80102801:	c1 e0 04             	shl    $0x4,%eax
80102804:	83 e0 10             	and    $0x10,%eax
80102807:	89 c2                	mov    %eax,%edx
80102809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280c:	c1 f8 18             	sar    $0x18,%eax
8010280f:	83 e0 0f             	and    $0xf,%eax
80102812:	09 d0                	or     %edx,%eax
80102814:	83 c8 e0             	or     $0xffffffe0,%eax
80102817:	0f b6 c0             	movzbl %al,%eax
8010281a:	83 ec 08             	sub    $0x8,%esp
8010281d:	50                   	push   %eax
8010281e:	68 f6 01 00 00       	push   $0x1f6
80102823:	e8 a1 fd ff ff       	call   801025c9 <outb>
80102828:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010282b:	8b 45 08             	mov    0x8(%ebp),%eax
8010282e:	8b 00                	mov    (%eax),%eax
80102830:	83 e0 04             	and    $0x4,%eax
80102833:	85 c0                	test   %eax,%eax
80102835:	74 35                	je     8010286c <idestart+0x178>
    outb(0x1f7, write_cmd);
80102837:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010283a:	0f b6 c0             	movzbl %al,%eax
8010283d:	83 ec 08             	sub    $0x8,%esp
80102840:	50                   	push   %eax
80102841:	68 f7 01 00 00       	push   $0x1f7
80102846:	e8 7e fd ff ff       	call   801025c9 <outb>
8010284b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	83 c0 5c             	add    $0x5c,%eax
80102854:	83 ec 04             	sub    $0x4,%esp
80102857:	68 80 00 00 00       	push   $0x80
8010285c:	50                   	push   %eax
8010285d:	68 f0 01 00 00       	push   $0x1f0
80102862:	e8 81 fd ff ff       	call   801025e8 <outsl>
80102867:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010286a:	eb 17                	jmp    80102883 <idestart+0x18f>
    outb(0x1f7, read_cmd);
8010286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010286f:	0f b6 c0             	movzbl %al,%eax
80102872:	83 ec 08             	sub    $0x8,%esp
80102875:	50                   	push   %eax
80102876:	68 f7 01 00 00       	push   $0x1f7
8010287b:	e8 49 fd ff ff       	call   801025c9 <outb>
80102880:	83 c4 10             	add    $0x10,%esp
}
80102883:	90                   	nop
80102884:	c9                   	leave
80102885:	c3                   	ret

80102886 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102886:	55                   	push   %ebp
80102887:	89 e5                	mov    %esp,%ebp
80102889:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288c:	83 ec 0c             	sub    $0xc,%esp
8010288f:	68 80 36 11 80       	push   $0x80113680
80102894:	e8 6b 31 00 00       	call   80105a04 <acquire>
80102899:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010289c:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028a8:	75 15                	jne    801028bf <ideintr+0x39>
    release(&idelock);
801028aa:	83 ec 0c             	sub    $0xc,%esp
801028ad:	68 80 36 11 80       	push   $0x80113680
801028b2:	e8 bb 31 00 00       	call   80105a72 <release>
801028b7:	83 c4 10             	add    $0x10,%esp
    return;
801028ba:	e9 9a 00 00 00       	jmp    80102959 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c2:	8b 40 58             	mov    0x58(%eax),%eax
801028c5:	a3 b4 36 11 80       	mov    %eax,0x801136b4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 04             	and    $0x4,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 2d                	jne    80102903 <ideintr+0x7d>
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	6a 01                	push   $0x1
801028db:	e8 2e fd ff ff       	call   8010260e <idewait>
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	85 c0                	test   %eax,%eax
801028e5:	78 1c                	js     80102903 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ea:	83 c0 5c             	add    $0x5c,%eax
801028ed:	83 ec 04             	sub    $0x4,%esp
801028f0:	68 80 00 00 00       	push   $0x80
801028f5:	50                   	push   %eax
801028f6:	68 f0 01 00 00       	push   $0x1f0
801028fb:	e8 a3 fc ff ff       	call   801025a3 <insl>
80102900:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102906:	8b 00                	mov    (%eax),%eax
80102908:	83 c8 02             	or     $0x2,%eax
8010290b:	89 c2                	mov    %eax,%edx
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102915:	8b 00                	mov    (%eax),%eax
80102917:	83 e0 fb             	and    $0xfffffffb,%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	ff 75 f4             	push   -0xc(%ebp)
80102927:	e8 78 2d 00 00       	call   801056a4 <wakeup>
8010292c:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010292f:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102934:	85 c0                	test   %eax,%eax
80102936:	74 11                	je     80102949 <ideintr+0xc3>
    idestart(idequeue);
80102938:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	50                   	push   %eax
80102941:	e8 ae fd ff ff       	call   801026f4 <idestart>
80102946:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102949:	83 ec 0c             	sub    $0xc,%esp
8010294c:	68 80 36 11 80       	push   $0x80113680
80102951:	e8 1c 31 00 00       	call   80105a72 <release>
80102956:	83 c4 10             	add    $0x10,%esp
}
80102959:	c9                   	leave
8010295a:	c3                   	ret

8010295b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295b:	55                   	push   %ebp
8010295c:	89 e5                	mov    %esp,%ebp
8010295e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	83 c0 0c             	add    $0xc,%eax
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	50                   	push   %eax
8010296b:	e8 dd 2f 00 00       	call   8010594d <holdingsleep>
80102970:	83 c4 10             	add    $0x10,%esp
80102973:	85 c0                	test   %eax,%eax
80102975:	75 0d                	jne    80102984 <iderw+0x29>
    panic("iderw: buf not locked");
80102977:	83 ec 0c             	sub    $0xc,%esp
8010297a:	68 f2 91 10 80       	push   $0x801091f2
8010297f:	e8 2f dc ff ff       	call   801005b3 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102984:	8b 45 08             	mov    0x8(%ebp),%eax
80102987:	8b 00                	mov    (%eax),%eax
80102989:	83 e0 06             	and    $0x6,%eax
8010298c:	83 f8 02             	cmp    $0x2,%eax
8010298f:	75 0d                	jne    8010299e <iderw+0x43>
    panic("iderw: nothing to do");
80102991:	83 ec 0c             	sub    $0xc,%esp
80102994:	68 08 92 10 80       	push   $0x80109208
80102999:	e8 15 dc ff ff       	call   801005b3 <panic>
  if(b->dev != 0 && !havedisk1)
8010299e:	8b 45 08             	mov    0x8(%ebp),%eax
801029a1:	8b 40 04             	mov    0x4(%eax),%eax
801029a4:	85 c0                	test   %eax,%eax
801029a6:	74 16                	je     801029be <iderw+0x63>
801029a8:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801029ad:	85 c0                	test   %eax,%eax
801029af:	75 0d                	jne    801029be <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029b1:	83 ec 0c             	sub    $0xc,%esp
801029b4:	68 1d 92 10 80       	push   $0x8010921d
801029b9:	e8 f5 db ff ff       	call   801005b3 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029be:	83 ec 0c             	sub    $0xc,%esp
801029c1:	68 80 36 11 80       	push   $0x80113680
801029c6:	e8 39 30 00 00       	call   80105a04 <acquire>
801029cb:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029ce:	8b 45 08             	mov    0x8(%ebp),%eax
801029d1:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d8:	c7 45 f4 b4 36 11 80 	movl   $0x801136b4,-0xc(%ebp)
801029df:	eb 0b                	jmp    801029ec <iderw+0x91>
801029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e4:	8b 00                	mov    (%eax),%eax
801029e6:	83 c0 58             	add    $0x58,%eax
801029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ef:	8b 00                	mov    (%eax),%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	75 ec                	jne    801029e1 <iderw+0x86>
    ;
  *pp = b;
801029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f8:	8b 55 08             	mov    0x8(%ebp),%edx
801029fb:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029fd:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a02:	39 45 08             	cmp    %eax,0x8(%ebp)
80102a05:	75 23                	jne    80102a2a <iderw+0xcf>
    idestart(b);
80102a07:	83 ec 0c             	sub    $0xc,%esp
80102a0a:	ff 75 08             	push   0x8(%ebp)
80102a0d:	e8 e2 fc ff ff       	call   801026f4 <idestart>
80102a12:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a15:	eb 13                	jmp    80102a2a <iderw+0xcf>
    sleep(b, &idelock);
80102a17:	83 ec 08             	sub    $0x8,%esp
80102a1a:	68 80 36 11 80       	push   $0x80113680
80102a1f:	ff 75 08             	push   0x8(%ebp)
80102a22:	e8 93 2b 00 00       	call   801055ba <sleep>
80102a27:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2d:	8b 00                	mov    (%eax),%eax
80102a2f:	83 e0 06             	and    $0x6,%eax
80102a32:	83 f8 02             	cmp    $0x2,%eax
80102a35:	75 e0                	jne    80102a17 <iderw+0xbc>
  }


  release(&idelock);
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 80 36 11 80       	push   $0x80113680
80102a3f:	e8 2e 30 00 00       	call   80105a72 <release>
80102a44:	83 c4 10             	add    $0x10,%esp
}
80102a47:	90                   	nop
80102a48:	c9                   	leave
80102a49:	c3                   	ret

80102a4a <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a4a:	55                   	push   %ebp
80102a4b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a4d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102a52:	8b 55 08             	mov    0x8(%ebp),%edx
80102a55:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a57:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102a5c:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a5f:	5d                   	pop    %ebp
80102a60:	c3                   	ret

80102a61 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a61:	55                   	push   %ebp
80102a62:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a64:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102a69:	8b 55 08             	mov    0x8(%ebp),%edx
80102a6c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a6e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102a73:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a76:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a79:	90                   	nop
80102a7a:	5d                   	pop    %ebp
80102a7b:	c3                   	ret

80102a7c <ioapicinit>:

void
ioapicinit(void)
{
80102a7c:	55                   	push   %ebp
80102a7d:	89 e5                	mov    %esp,%ebp
80102a7f:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a82:	c7 05 bc 36 11 80 00 	movl   $0xfec00000,0x801136bc
80102a89:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a8c:	6a 01                	push   $0x1
80102a8e:	e8 b7 ff ff ff       	call   80102a4a <ioapicread>
80102a93:	83 c4 04             	add    $0x4,%esp
80102a96:	c1 e8 10             	shr    $0x10,%eax
80102a99:	25 ff 00 00 00       	and    $0xff,%eax
80102a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa1:	6a 00                	push   $0x0
80102aa3:	e8 a2 ff ff ff       	call   80102a4a <ioapicread>
80102aa8:	83 c4 04             	add    $0x4,%esp
80102aab:	c1 e8 18             	shr    $0x18,%eax
80102aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab1:	0f b6 05 c4 41 11 80 	movzbl 0x801141c4,%eax
80102ab8:	0f b6 c0             	movzbl %al,%eax
80102abb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102abe:	74 10                	je     80102ad0 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	68 3c 92 10 80       	push   $0x8010923c
80102ac8:	e8 31 d9 ff ff       	call   801003fe <cprintf>
80102acd:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ad7:	eb 3f                	jmp    80102b18 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102adc:	83 c0 20             	add    $0x20,%eax
80102adf:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae9:	83 c0 08             	add    $0x8,%eax
80102aec:	01 c0                	add    %eax,%eax
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	52                   	push   %edx
80102af2:	50                   	push   %eax
80102af3:	e8 69 ff ff ff       	call   80102a61 <ioapicwrite>
80102af8:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afe:	83 c0 08             	add    $0x8,%eax
80102b01:	01 c0                	add    %eax,%eax
80102b03:	83 c0 01             	add    $0x1,%eax
80102b06:	83 ec 08             	sub    $0x8,%esp
80102b09:	6a 00                	push   $0x0
80102b0b:	50                   	push   %eax
80102b0c:	e8 50 ff ff ff       	call   80102a61 <ioapicwrite>
80102b11:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b1e:	7e b9                	jle    80102ad9 <ioapicinit+0x5d>
  }
}
80102b20:	90                   	nop
80102b21:	90                   	nop
80102b22:	c9                   	leave
80102b23:	c3                   	ret

80102b24 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2a:	83 c0 20             	add    $0x20,%eax
80102b2d:	89 c2                	mov    %eax,%edx
80102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b32:	83 c0 08             	add    $0x8,%eax
80102b35:	01 c0                	add    %eax,%eax
80102b37:	52                   	push   %edx
80102b38:	50                   	push   %eax
80102b39:	e8 23 ff ff ff       	call   80102a61 <ioapicwrite>
80102b3e:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b44:	c1 e0 18             	shl    $0x18,%eax
80102b47:	89 c2                	mov    %eax,%edx
80102b49:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4c:	83 c0 08             	add    $0x8,%eax
80102b4f:	01 c0                	add    %eax,%eax
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	52                   	push   %edx
80102b55:	50                   	push   %eax
80102b56:	e8 06 ff ff ff       	call   80102a61 <ioapicwrite>
80102b5b:	83 c4 08             	add    $0x8,%esp
}
80102b5e:	90                   	nop
80102b5f:	c9                   	leave
80102b60:	c3                   	ret

80102b61 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b61:	55                   	push   %ebp
80102b62:	89 e5                	mov    %esp,%ebp
80102b64:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b67:	83 ec 08             	sub    $0x8,%esp
80102b6a:	68 6e 92 10 80       	push   $0x8010926e
80102b6f:	68 c0 36 11 80       	push   $0x801136c0
80102b74:	e8 69 2e 00 00       	call   801059e2 <initlock>
80102b79:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b7c:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102b83:	00 00 00 
  freerange(vstart, vend);
80102b86:	83 ec 08             	sub    $0x8,%esp
80102b89:	ff 75 0c             	push   0xc(%ebp)
80102b8c:	ff 75 08             	push   0x8(%ebp)
80102b8f:	e8 2a 00 00 00       	call   80102bbe <freerange>
80102b94:	83 c4 10             	add    $0x10,%esp
}
80102b97:	90                   	nop
80102b98:	c9                   	leave
80102b99:	c3                   	ret

80102b9a <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b9a:	55                   	push   %ebp
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ba0:	83 ec 08             	sub    $0x8,%esp
80102ba3:	ff 75 0c             	push   0xc(%ebp)
80102ba6:	ff 75 08             	push   0x8(%ebp)
80102ba9:	e8 10 00 00 00       	call   80102bbe <freerange>
80102bae:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bb1:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102bb8:	00 00 00 
}
80102bbb:	90                   	nop
80102bbc:	c9                   	leave
80102bbd:	c3                   	ret

80102bbe <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc7:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd4:	eb 15                	jmp    80102beb <freerange+0x2d>
    kfree(p);
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	ff 75 f4             	push   -0xc(%ebp)
80102bdc:	e8 1b 00 00 00       	call   80102bfc <kfree>
80102be1:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bee:	05 00 10 00 00       	add    $0x1000,%eax
80102bf3:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102bf6:	73 de                	jae    80102bd6 <freerange+0x18>
}
80102bf8:	90                   	nop
80102bf9:	90                   	nop
80102bfa:	c9                   	leave
80102bfb:	c3                   	ret

80102bfc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bfc:	55                   	push   %ebp
80102bfd:	89 e5                	mov    %esp,%ebp
80102bff:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c02:	8b 45 08             	mov    0x8(%ebp),%eax
80102c05:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c0a:	85 c0                	test   %eax,%eax
80102c0c:	75 18                	jne    80102c26 <kfree+0x2a>
80102c0e:	81 7d 08 60 7e 11 80 	cmpl   $0x80117e60,0x8(%ebp)
80102c15:	72 0f                	jb     80102c26 <kfree+0x2a>
80102c17:	8b 45 08             	mov    0x8(%ebp),%eax
80102c1a:	05 00 00 00 80       	add    $0x80000000,%eax
80102c1f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c24:	76 0d                	jbe    80102c33 <kfree+0x37>
    panic("kfree");
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	68 73 92 10 80       	push   $0x80109273
80102c2e:	e8 80 d9 ff ff       	call   801005b3 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c33:	83 ec 04             	sub    $0x4,%esp
80102c36:	68 00 10 00 00       	push   $0x1000
80102c3b:	6a 01                	push   $0x1
80102c3d:	ff 75 08             	push   0x8(%ebp)
80102c40:	e8 45 30 00 00       	call   80105c8a <memset>
80102c45:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c48:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c4d:	85 c0                	test   %eax,%eax
80102c4f:	74 10                	je     80102c61 <kfree+0x65>
    acquire(&kmem.lock);
80102c51:	83 ec 0c             	sub    $0xc,%esp
80102c54:	68 c0 36 11 80       	push   $0x801136c0
80102c59:	e8 a6 2d 00 00       	call   80105a04 <acquire>
80102c5e:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c61:	8b 45 08             	mov    0x8(%ebp),%eax
80102c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c67:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c70:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c75:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102c7a:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c7f:	85 c0                	test   %eax,%eax
80102c81:	74 10                	je     80102c93 <kfree+0x97>
    release(&kmem.lock);
80102c83:	83 ec 0c             	sub    $0xc,%esp
80102c86:	68 c0 36 11 80       	push   $0x801136c0
80102c8b:	e8 e2 2d 00 00       	call   80105a72 <release>
80102c90:	83 c4 10             	add    $0x10,%esp
}
80102c93:	90                   	nop
80102c94:	c9                   	leave
80102c95:	c3                   	ret

80102c96 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c96:	55                   	push   %ebp
80102c97:	89 e5                	mov    %esp,%ebp
80102c99:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c9c:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102ca1:	85 c0                	test   %eax,%eax
80102ca3:	74 10                	je     80102cb5 <kalloc+0x1f>
    acquire(&kmem.lock);
80102ca5:	83 ec 0c             	sub    $0xc,%esp
80102ca8:	68 c0 36 11 80       	push   $0x801136c0
80102cad:	e8 52 2d 00 00       	call   80105a04 <acquire>
80102cb2:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cb5:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cc1:	74 0a                	je     80102ccd <kalloc+0x37>
    kmem.freelist = r->next;
80102cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc6:	8b 00                	mov    (%eax),%eax
80102cc8:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102ccd:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	74 10                	je     80102ce6 <kalloc+0x50>
    release(&kmem.lock);
80102cd6:	83 ec 0c             	sub    $0xc,%esp
80102cd9:	68 c0 36 11 80       	push   $0x801136c0
80102cde:	e8 8f 2d 00 00       	call   80105a72 <release>
80102ce3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ce9:	c9                   	leave
80102cea:	c3                   	ret

80102ceb <inb>:
{
80102ceb:	55                   	push   %ebp
80102cec:	89 e5                	mov    %esp,%ebp
80102cee:	83 ec 14             	sub    $0x14,%esp
80102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cfc:	89 c2                	mov    %eax,%edx
80102cfe:	ec                   	in     (%dx),%al
80102cff:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d02:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d06:	c9                   	leave
80102d07:	c3                   	ret

80102d08 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d08:	55                   	push   %ebp
80102d09:	89 e5                	mov    %esp,%ebp
80102d0b:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d0e:	6a 64                	push   $0x64
80102d10:	e8 d6 ff ff ff       	call   80102ceb <inb>
80102d15:	83 c4 04             	add    $0x4,%esp
80102d18:	0f b6 c0             	movzbl %al,%eax
80102d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d21:	83 e0 01             	and    $0x1,%eax
80102d24:	85 c0                	test   %eax,%eax
80102d26:	75 0a                	jne    80102d32 <kbdgetc+0x2a>
    return -1;
80102d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d2d:	e9 23 01 00 00       	jmp    80102e55 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d32:	6a 60                	push   $0x60
80102d34:	e8 b2 ff ff ff       	call   80102ceb <inb>
80102d39:	83 c4 04             	add    $0x4,%esp
80102d3c:	0f b6 c0             	movzbl %al,%eax
80102d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d42:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d49:	75 17                	jne    80102d62 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d4b:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102d50:	83 c8 40             	or     $0x40,%eax
80102d53:	a3 fc 36 11 80       	mov    %eax,0x801136fc
    return 0;
80102d58:	b8 00 00 00 00       	mov    $0x0,%eax
80102d5d:	e9 f3 00 00 00       	jmp    80102e55 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d65:	25 80 00 00 00       	and    $0x80,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	74 45                	je     80102db3 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d6e:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102d73:	83 e0 40             	and    $0x40,%eax
80102d76:	85 c0                	test   %eax,%eax
80102d78:	75 08                	jne    80102d82 <kbdgetc+0x7a>
80102d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7d:	83 e0 7f             	and    $0x7f,%eax
80102d80:	eb 03                	jmp    80102d85 <kbdgetc+0x7d>
80102d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d8b:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d90:	0f b6 00             	movzbl (%eax),%eax
80102d93:	83 c8 40             	or     $0x40,%eax
80102d96:	0f b6 c0             	movzbl %al,%eax
80102d99:	f7 d0                	not    %eax
80102d9b:	89 c2                	mov    %eax,%edx
80102d9d:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102da2:	21 d0                	and    %edx,%eax
80102da4:	a3 fc 36 11 80       	mov    %eax,0x801136fc
    return 0;
80102da9:	b8 00 00 00 00       	mov    $0x0,%eax
80102dae:	e9 a2 00 00 00       	jmp    80102e55 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102db3:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102db8:	83 e0 40             	and    $0x40,%eax
80102dbb:	85 c0                	test   %eax,%eax
80102dbd:	74 14                	je     80102dd3 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dbf:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102dc6:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102dcb:	83 e0 bf             	and    $0xffffffbf,%eax
80102dce:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  }

  shift |= shiftcode[data];
80102dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd6:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ddb:	0f b6 00             	movzbl (%eax),%eax
80102dde:	0f b6 d0             	movzbl %al,%edx
80102de1:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102de6:	09 d0                	or     %edx,%eax
80102de8:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  shift ^= togglecode[data];
80102ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df0:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102df5:	0f b6 00             	movzbl (%eax),%eax
80102df8:	0f b6 d0             	movzbl %al,%edx
80102dfb:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e00:	31 d0                	xor    %edx,%eax
80102e02:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102e07:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e0c:	83 e0 03             	and    $0x3,%eax
80102e0f:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e19:	01 d0                	add    %edx,%eax
80102e1b:	0f b6 00             	movzbl (%eax),%eax
80102e1e:	0f b6 c0             	movzbl %al,%eax
80102e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e24:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e29:	83 e0 08             	and    $0x8,%eax
80102e2c:	85 c0                	test   %eax,%eax
80102e2e:	74 22                	je     80102e52 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e30:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e34:	76 0c                	jbe    80102e42 <kbdgetc+0x13a>
80102e36:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e3a:	77 06                	ja     80102e42 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e3c:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e40:	eb 10                	jmp    80102e52 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e42:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e46:	76 0a                	jbe    80102e52 <kbdgetc+0x14a>
80102e48:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e4c:	77 04                	ja     80102e52 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e4e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e55:	c9                   	leave
80102e56:	c3                   	ret

80102e57 <kbdintr>:

void
kbdintr(void)
{
80102e57:	55                   	push   %ebp
80102e58:	89 e5                	mov    %esp,%ebp
80102e5a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e5d:	83 ec 0c             	sub    $0xc,%esp
80102e60:	68 08 2d 10 80       	push   $0x80102d08
80102e65:	e8 df d9 ff ff       	call   80100849 <consoleintr>
80102e6a:	83 c4 10             	add    $0x10,%esp
}
80102e6d:	90                   	nop
80102e6e:	c9                   	leave
80102e6f:	c3                   	ret

80102e70 <ensureinit>:
struct kobj { int used, kind, value, owner; };
static struct spinlock ksync_lock;
static struct kobj objs[NKSYNC];
static int initialized;

static void ensureinit(void){ if(!initialized){ initlock(&ksync_lock, "ksync"); initialized=1; } }
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 08             	sub    $0x8,%esp
80102e76:	a1 40 3b 11 80       	mov    0x80113b40,%eax
80102e7b:	85 c0                	test   %eax,%eax
80102e7d:	75 1f                	jne    80102e9e <ensureinit+0x2e>
80102e7f:	83 ec 08             	sub    $0x8,%esp
80102e82:	68 79 92 10 80       	push   $0x80109279
80102e87:	68 00 37 11 80       	push   $0x80113700
80102e8c:	e8 51 2b 00 00       	call   801059e2 <initlock>
80102e91:	83 c4 10             	add    $0x10,%esp
80102e94:	c7 05 40 3b 11 80 01 	movl   $0x1,0x80113b40
80102e9b:	00 00 00 
80102e9e:	90                   	nop
80102e9f:	c9                   	leave
80102ea0:	c3                   	ret

80102ea1 <create>:
static int create(int kind, int value){ int i; ensureinit(); acquire(&ksync_lock); for(i=0;i<NKSYNC;i++) if(!objs[i].used){ objs[i].used=1; objs[i].kind=kind; objs[i].value=value; objs[i].owner=0; release(&ksync_lock); return i; } release(&ksync_lock); return -1; }
80102ea1:	55                   	push   %ebp
80102ea2:	89 e5                	mov    %esp,%ebp
80102ea4:	83 ec 18             	sub    $0x18,%esp
80102ea7:	e8 c4 ff ff ff       	call   80102e70 <ensureinit>
80102eac:	83 ec 0c             	sub    $0xc,%esp
80102eaf:	68 00 37 11 80       	push   $0x80113700
80102eb4:	e8 4b 2b 00 00       	call   80105a04 <acquire>
80102eb9:	83 c4 10             	add    $0x10,%esp
80102ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ec3:	eb 6e                	jmp    80102f33 <create+0x92>
80102ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ec8:	c1 e0 04             	shl    $0x4,%eax
80102ecb:	05 40 37 11 80       	add    $0x80113740,%eax
80102ed0:	8b 00                	mov    (%eax),%eax
80102ed2:	85 c0                	test   %eax,%eax
80102ed4:	75 59                	jne    80102f2f <create+0x8e>
80102ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed9:	c1 e0 04             	shl    $0x4,%eax
80102edc:	05 40 37 11 80       	add    $0x80113740,%eax
80102ee1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80102ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eea:	c1 e0 04             	shl    $0x4,%eax
80102eed:	8d 90 44 37 11 80    	lea    -0x7feec8bc(%eax),%edx
80102ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ef6:	89 02                	mov    %eax,(%edx)
80102ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102efb:	c1 e0 04             	shl    $0x4,%eax
80102efe:	8d 90 48 37 11 80    	lea    -0x7feec8b8(%eax),%edx
80102f04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f07:	89 02                	mov    %eax,(%edx)
80102f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f0c:	c1 e0 04             	shl    $0x4,%eax
80102f0f:	05 4c 37 11 80       	add    $0x8011374c,%eax
80102f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80102f1a:	83 ec 0c             	sub    $0xc,%esp
80102f1d:	68 00 37 11 80       	push   $0x80113700
80102f22:	e8 4b 2b 00 00       	call   80105a72 <release>
80102f27:	83 c4 10             	add    $0x10,%esp
80102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f2d:	eb 1f                	jmp    80102f4e <create+0xad>
80102f2f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f33:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80102f37:	7e 8c                	jle    80102ec5 <create+0x24>
80102f39:	83 ec 0c             	sub    $0xc,%esp
80102f3c:	68 00 37 11 80       	push   $0x80113700
80102f41:	e8 2c 2b 00 00       	call   80105a72 <release>
80102f46:	83 c4 10             	add    $0x10,%esp
80102f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f4e:	c9                   	leave
80102f4f:	c3                   	ret

80102f50 <klock_create>:
int klock_create(void){ return create(1,1); }
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	83 ec 08             	sub    $0x8,%esp
80102f59:	6a 01                	push   $0x1
80102f5b:	6a 01                	push   $0x1
80102f5d:	e8 3f ff ff ff       	call   80102ea1 <create>
80102f62:	83 c4 10             	add    $0x10,%esp
80102f65:	c9                   	leave
80102f66:	c3                   	ret

80102f67 <klock_acquire>:
int klock_acquire(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=1){ release(&ksync_lock); return -1; } while(objs[id].value==0){ if(myproc()->killed){ release(&ksync_lock); return -1; } sleep(&objs[id], &ksync_lock); } objs[id].value=0; objs[id].owner=myproc()->pid; release(&ksync_lock); return 0; }
80102f67:	55                   	push   %ebp
80102f68:	89 e5                	mov    %esp,%ebp
80102f6a:	83 ec 08             	sub    $0x8,%esp
80102f6d:	e8 fe fe ff ff       	call   80102e70 <ensureinit>
80102f72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102f76:	78 06                	js     80102f7e <klock_acquire+0x17>
80102f78:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
80102f7c:	7e 0a                	jle    80102f88 <klock_acquire+0x21>
80102f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f83:	e9 d9 00 00 00       	jmp    80103061 <klock_acquire+0xfa>
80102f88:	83 ec 0c             	sub    $0xc,%esp
80102f8b:	68 00 37 11 80       	push   $0x80113700
80102f90:	e8 6f 2a 00 00       	call   80105a04 <acquire>
80102f95:	83 c4 10             	add    $0x10,%esp
80102f98:	8b 45 08             	mov    0x8(%ebp),%eax
80102f9b:	c1 e0 04             	shl    $0x4,%eax
80102f9e:	05 40 37 11 80       	add    $0x80113740,%eax
80102fa3:	8b 00                	mov    (%eax),%eax
80102fa5:	85 c0                	test   %eax,%eax
80102fa7:	74 12                	je     80102fbb <klock_acquire+0x54>
80102fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	05 44 37 11 80       	add    $0x80113744,%eax
80102fb4:	8b 00                	mov    (%eax),%eax
80102fb6:	83 f8 01             	cmp    $0x1,%eax
80102fb9:	74 59                	je     80103014 <klock_acquire+0xad>
80102fbb:	83 ec 0c             	sub    $0xc,%esp
80102fbe:	68 00 37 11 80       	push   $0x80113700
80102fc3:	e8 aa 2a 00 00       	call   80105a72 <release>
80102fc8:	83 c4 10             	add    $0x10,%esp
80102fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fd0:	e9 8c 00 00 00       	jmp    80103061 <klock_acquire+0xfa>
80102fd5:	e8 41 17 00 00       	call   8010471b <myproc>
80102fda:	8b 40 24             	mov    0x24(%eax),%eax
80102fdd:	85 c0                	test   %eax,%eax
80102fdf:	74 17                	je     80102ff8 <klock_acquire+0x91>
80102fe1:	83 ec 0c             	sub    $0xc,%esp
80102fe4:	68 00 37 11 80       	push   $0x80113700
80102fe9:	e8 84 2a 00 00       	call   80105a72 <release>
80102fee:	83 c4 10             	add    $0x10,%esp
80102ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ff6:	eb 69                	jmp    80103061 <klock_acquire+0xfa>
80102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ffb:	c1 e0 04             	shl    $0x4,%eax
80102ffe:	05 40 37 11 80       	add    $0x80113740,%eax
80103003:	83 ec 08             	sub    $0x8,%esp
80103006:	68 00 37 11 80       	push   $0x80113700
8010300b:	50                   	push   %eax
8010300c:	e8 a9 25 00 00       	call   801055ba <sleep>
80103011:	83 c4 10             	add    $0x10,%esp
80103014:	8b 45 08             	mov    0x8(%ebp),%eax
80103017:	c1 e0 04             	shl    $0x4,%eax
8010301a:	05 48 37 11 80       	add    $0x80113748,%eax
8010301f:	8b 00                	mov    (%eax),%eax
80103021:	85 c0                	test   %eax,%eax
80103023:	74 b0                	je     80102fd5 <klock_acquire+0x6e>
80103025:	8b 45 08             	mov    0x8(%ebp),%eax
80103028:	c1 e0 04             	shl    $0x4,%eax
8010302b:	05 48 37 11 80       	add    $0x80113748,%eax
80103030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103036:	e8 e0 16 00 00       	call   8010471b <myproc>
8010303b:	8b 40 10             	mov    0x10(%eax),%eax
8010303e:	8b 55 08             	mov    0x8(%ebp),%edx
80103041:	c1 e2 04             	shl    $0x4,%edx
80103044:	81 c2 4c 37 11 80    	add    $0x8011374c,%edx
8010304a:	89 02                	mov    %eax,(%edx)
8010304c:	83 ec 0c             	sub    $0xc,%esp
8010304f:	68 00 37 11 80       	push   $0x80113700
80103054:	e8 19 2a 00 00       	call   80105a72 <release>
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	b8 00 00 00 00       	mov    $0x0,%eax
80103061:	c9                   	leave
80103062:	c3                   	ret

80103063 <klock_release>:
int klock_release(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=1||objs[id].value!=0){ release(&ksync_lock); return -1; } objs[id].owner=0; objs[id].value=1; wakeup(&objs[id]); release(&ksync_lock); return 0; }
80103063:	55                   	push   %ebp
80103064:	89 e5                	mov    %esp,%ebp
80103066:	83 ec 08             	sub    $0x8,%esp
80103069:	e8 02 fe ff ff       	call   80102e70 <ensureinit>
8010306e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103072:	78 06                	js     8010307a <klock_release+0x17>
80103074:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
80103078:	7e 0a                	jle    80103084 <klock_release+0x21>
8010307a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010307f:	e9 a9 00 00 00       	jmp    8010312d <klock_release+0xca>
80103084:	83 ec 0c             	sub    $0xc,%esp
80103087:	68 00 37 11 80       	push   $0x80113700
8010308c:	e8 73 29 00 00       	call   80105a04 <acquire>
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	8b 45 08             	mov    0x8(%ebp),%eax
80103097:	c1 e0 04             	shl    $0x4,%eax
8010309a:	05 40 37 11 80       	add    $0x80113740,%eax
8010309f:	8b 00                	mov    (%eax),%eax
801030a1:	85 c0                	test   %eax,%eax
801030a3:	74 23                	je     801030c8 <klock_release+0x65>
801030a5:	8b 45 08             	mov    0x8(%ebp),%eax
801030a8:	c1 e0 04             	shl    $0x4,%eax
801030ab:	05 44 37 11 80       	add    $0x80113744,%eax
801030b0:	8b 00                	mov    (%eax),%eax
801030b2:	83 f8 01             	cmp    $0x1,%eax
801030b5:	75 11                	jne    801030c8 <klock_release+0x65>
801030b7:	8b 45 08             	mov    0x8(%ebp),%eax
801030ba:	c1 e0 04             	shl    $0x4,%eax
801030bd:	05 48 37 11 80       	add    $0x80113748,%eax
801030c2:	8b 00                	mov    (%eax),%eax
801030c4:	85 c0                	test   %eax,%eax
801030c6:	74 17                	je     801030df <klock_release+0x7c>
801030c8:	83 ec 0c             	sub    $0xc,%esp
801030cb:	68 00 37 11 80       	push   $0x80113700
801030d0:	e8 9d 29 00 00       	call   80105a72 <release>
801030d5:	83 c4 10             	add    $0x10,%esp
801030d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030dd:	eb 4e                	jmp    8010312d <klock_release+0xca>
801030df:	8b 45 08             	mov    0x8(%ebp),%eax
801030e2:	c1 e0 04             	shl    $0x4,%eax
801030e5:	05 4c 37 11 80       	add    $0x8011374c,%eax
801030ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801030f0:	8b 45 08             	mov    0x8(%ebp),%eax
801030f3:	c1 e0 04             	shl    $0x4,%eax
801030f6:	05 48 37 11 80       	add    $0x80113748,%eax
801030fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103101:	8b 45 08             	mov    0x8(%ebp),%eax
80103104:	c1 e0 04             	shl    $0x4,%eax
80103107:	05 40 37 11 80       	add    $0x80113740,%eax
8010310c:	83 ec 0c             	sub    $0xc,%esp
8010310f:	50                   	push   %eax
80103110:	e8 8f 25 00 00       	call   801056a4 <wakeup>
80103115:	83 c4 10             	add    $0x10,%esp
80103118:	83 ec 0c             	sub    $0xc,%esp
8010311b:	68 00 37 11 80       	push   $0x80113700
80103120:	e8 4d 29 00 00       	call   80105a72 <release>
80103125:	83 c4 10             	add    $0x10,%esp
80103128:	b8 00 00 00 00       	mov    $0x0,%eax
8010312d:	c9                   	leave
8010312e:	c3                   	ret

8010312f <ksem_create>:
int ksem_create(int value){ if(value<0) return -1; return create(2,value); }
8010312f:	55                   	push   %ebp
80103130:	89 e5                	mov    %esp,%ebp
80103132:	83 ec 08             	sub    $0x8,%esp
80103135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103139:	79 07                	jns    80103142 <ksem_create+0x13>
8010313b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103140:	eb 10                	jmp    80103152 <ksem_create+0x23>
80103142:	83 ec 08             	sub    $0x8,%esp
80103145:	ff 75 08             	push   0x8(%ebp)
80103148:	6a 02                	push   $0x2
8010314a:	e8 52 fd ff ff       	call   80102ea1 <create>
8010314f:	83 c4 10             	add    $0x10,%esp
80103152:	c9                   	leave
80103153:	c3                   	ret

80103154 <ksem_wait>:
int ksem_wait(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=2){ release(&ksync_lock); return -1; } while(objs[id].value==0){ if(myproc()->killed){ release(&ksync_lock); return -1; } sleep(&objs[id], &ksync_lock); } objs[id].value--; release(&ksync_lock); return 0; }
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	83 ec 08             	sub    $0x8,%esp
8010315a:	e8 11 fd ff ff       	call   80102e70 <ensureinit>
8010315f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103163:	78 06                	js     8010316b <ksem_wait+0x17>
80103165:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
80103169:	7e 0a                	jle    80103175 <ksem_wait+0x21>
8010316b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103170:	e9 cf 00 00 00       	jmp    80103244 <ksem_wait+0xf0>
80103175:	83 ec 0c             	sub    $0xc,%esp
80103178:	68 00 37 11 80       	push   $0x80113700
8010317d:	e8 82 28 00 00       	call   80105a04 <acquire>
80103182:	83 c4 10             	add    $0x10,%esp
80103185:	8b 45 08             	mov    0x8(%ebp),%eax
80103188:	c1 e0 04             	shl    $0x4,%eax
8010318b:	05 40 37 11 80       	add    $0x80113740,%eax
80103190:	8b 00                	mov    (%eax),%eax
80103192:	85 c0                	test   %eax,%eax
80103194:	74 12                	je     801031a8 <ksem_wait+0x54>
80103196:	8b 45 08             	mov    0x8(%ebp),%eax
80103199:	c1 e0 04             	shl    $0x4,%eax
8010319c:	05 44 37 11 80       	add    $0x80113744,%eax
801031a1:	8b 00                	mov    (%eax),%eax
801031a3:	83 f8 02             	cmp    $0x2,%eax
801031a6:	74 59                	je     80103201 <ksem_wait+0xad>
801031a8:	83 ec 0c             	sub    $0xc,%esp
801031ab:	68 00 37 11 80       	push   $0x80113700
801031b0:	e8 bd 28 00 00       	call   80105a72 <release>
801031b5:	83 c4 10             	add    $0x10,%esp
801031b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031bd:	e9 82 00 00 00       	jmp    80103244 <ksem_wait+0xf0>
801031c2:	e8 54 15 00 00       	call   8010471b <myproc>
801031c7:	8b 40 24             	mov    0x24(%eax),%eax
801031ca:	85 c0                	test   %eax,%eax
801031cc:	74 17                	je     801031e5 <ksem_wait+0x91>
801031ce:	83 ec 0c             	sub    $0xc,%esp
801031d1:	68 00 37 11 80       	push   $0x80113700
801031d6:	e8 97 28 00 00       	call   80105a72 <release>
801031db:	83 c4 10             	add    $0x10,%esp
801031de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031e3:	eb 5f                	jmp    80103244 <ksem_wait+0xf0>
801031e5:	8b 45 08             	mov    0x8(%ebp),%eax
801031e8:	c1 e0 04             	shl    $0x4,%eax
801031eb:	05 40 37 11 80       	add    $0x80113740,%eax
801031f0:	83 ec 08             	sub    $0x8,%esp
801031f3:	68 00 37 11 80       	push   $0x80113700
801031f8:	50                   	push   %eax
801031f9:	e8 bc 23 00 00       	call   801055ba <sleep>
801031fe:	83 c4 10             	add    $0x10,%esp
80103201:	8b 45 08             	mov    0x8(%ebp),%eax
80103204:	c1 e0 04             	shl    $0x4,%eax
80103207:	05 48 37 11 80       	add    $0x80113748,%eax
8010320c:	8b 00                	mov    (%eax),%eax
8010320e:	85 c0                	test   %eax,%eax
80103210:	74 b0                	je     801031c2 <ksem_wait+0x6e>
80103212:	8b 45 08             	mov    0x8(%ebp),%eax
80103215:	c1 e0 04             	shl    $0x4,%eax
80103218:	05 48 37 11 80       	add    $0x80113748,%eax
8010321d:	8b 00                	mov    (%eax),%eax
8010321f:	8d 50 ff             	lea    -0x1(%eax),%edx
80103222:	8b 45 08             	mov    0x8(%ebp),%eax
80103225:	c1 e0 04             	shl    $0x4,%eax
80103228:	05 48 37 11 80       	add    $0x80113748,%eax
8010322d:	89 10                	mov    %edx,(%eax)
8010322f:	83 ec 0c             	sub    $0xc,%esp
80103232:	68 00 37 11 80       	push   $0x80113700
80103237:	e8 36 28 00 00       	call   80105a72 <release>
8010323c:	83 c4 10             	add    $0x10,%esp
8010323f:	b8 00 00 00 00       	mov    $0x0,%eax
80103244:	c9                   	leave
80103245:	c3                   	ret

80103246 <ksem_post>:
int ksem_post(int id){ ensureinit(); if(id<0||id>=NKSYNC) return -1; acquire(&ksync_lock); if(!objs[id].used||objs[id].kind!=2){ release(&ksync_lock); return -1; } objs[id].value++; wakeup(&objs[id]); release(&ksync_lock); return 0; }
80103246:	55                   	push   %ebp
80103247:	89 e5                	mov    %esp,%ebp
80103249:	83 ec 08             	sub    $0x8,%esp
8010324c:	e8 1f fc ff ff       	call   80102e70 <ensureinit>
80103251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103255:	78 06                	js     8010325d <ksem_post+0x17>
80103257:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
8010325b:	7e 0a                	jle    80103267 <ksem_post+0x21>
8010325d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103262:	e9 93 00 00 00       	jmp    801032fa <ksem_post+0xb4>
80103267:	83 ec 0c             	sub    $0xc,%esp
8010326a:	68 00 37 11 80       	push   $0x80113700
8010326f:	e8 90 27 00 00       	call   80105a04 <acquire>
80103274:	83 c4 10             	add    $0x10,%esp
80103277:	8b 45 08             	mov    0x8(%ebp),%eax
8010327a:	c1 e0 04             	shl    $0x4,%eax
8010327d:	05 40 37 11 80       	add    $0x80113740,%eax
80103282:	8b 00                	mov    (%eax),%eax
80103284:	85 c0                	test   %eax,%eax
80103286:	74 12                	je     8010329a <ksem_post+0x54>
80103288:	8b 45 08             	mov    0x8(%ebp),%eax
8010328b:	c1 e0 04             	shl    $0x4,%eax
8010328e:	05 44 37 11 80       	add    $0x80113744,%eax
80103293:	8b 00                	mov    (%eax),%eax
80103295:	83 f8 02             	cmp    $0x2,%eax
80103298:	74 17                	je     801032b1 <ksem_post+0x6b>
8010329a:	83 ec 0c             	sub    $0xc,%esp
8010329d:	68 00 37 11 80       	push   $0x80113700
801032a2:	e8 cb 27 00 00       	call   80105a72 <release>
801032a7:	83 c4 10             	add    $0x10,%esp
801032aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032af:	eb 49                	jmp    801032fa <ksem_post+0xb4>
801032b1:	8b 45 08             	mov    0x8(%ebp),%eax
801032b4:	c1 e0 04             	shl    $0x4,%eax
801032b7:	05 48 37 11 80       	add    $0x80113748,%eax
801032bc:	8b 00                	mov    (%eax),%eax
801032be:	8d 50 01             	lea    0x1(%eax),%edx
801032c1:	8b 45 08             	mov    0x8(%ebp),%eax
801032c4:	c1 e0 04             	shl    $0x4,%eax
801032c7:	05 48 37 11 80       	add    $0x80113748,%eax
801032cc:	89 10                	mov    %edx,(%eax)
801032ce:	8b 45 08             	mov    0x8(%ebp),%eax
801032d1:	c1 e0 04             	shl    $0x4,%eax
801032d4:	05 40 37 11 80       	add    $0x80113740,%eax
801032d9:	83 ec 0c             	sub    $0xc,%esp
801032dc:	50                   	push   %eax
801032dd:	e8 c2 23 00 00       	call   801056a4 <wakeup>
801032e2:	83 c4 10             	add    $0x10,%esp
801032e5:	83 ec 0c             	sub    $0xc,%esp
801032e8:	68 00 37 11 80       	push   $0x80113700
801032ed:	e8 80 27 00 00       	call   80105a72 <release>
801032f2:	83 c4 10             	add    $0x10,%esp
801032f5:	b8 00 00 00 00       	mov    $0x0,%eax
801032fa:	c9                   	leave
801032fb:	c3                   	ret

801032fc <inb>:
{
801032fc:	55                   	push   %ebp
801032fd:	89 e5                	mov    %esp,%ebp
801032ff:	83 ec 14             	sub    $0x14,%esp
80103302:	8b 45 08             	mov    0x8(%ebp),%eax
80103305:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010330d:	89 c2                	mov    %eax,%edx
8010330f:	ec                   	in     (%dx),%al
80103310:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103313:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103317:	c9                   	leave
80103318:	c3                   	ret

80103319 <outb>:
{
80103319:	55                   	push   %ebp
8010331a:	89 e5                	mov    %esp,%ebp
8010331c:	83 ec 08             	sub    $0x8,%esp
8010331f:	8b 55 08             	mov    0x8(%ebp),%edx
80103322:	8b 45 0c             	mov    0xc(%ebp),%eax
80103325:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103329:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103330:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103334:	ee                   	out    %al,(%dx)
}
80103335:	90                   	nop
80103336:	c9                   	leave
80103337:	c3                   	ret

80103338 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103338:	55                   	push   %ebp
80103339:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010333b:	a1 44 3b 11 80       	mov    0x80113b44,%eax
80103340:	8b 55 08             	mov    0x8(%ebp),%edx
80103343:	c1 e2 02             	shl    $0x2,%edx
80103346:	01 c2                	add    %eax,%edx
80103348:	8b 45 0c             	mov    0xc(%ebp),%eax
8010334b:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010334d:	a1 44 3b 11 80       	mov    0x80113b44,%eax
80103352:	83 c0 20             	add    $0x20,%eax
80103355:	8b 00                	mov    (%eax),%eax
}
80103357:	90                   	nop
80103358:	5d                   	pop    %ebp
80103359:	c3                   	ret

8010335a <lapicinit>:

void
lapicinit(void)
{
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
  if(!lapic)
8010335d:	a1 44 3b 11 80       	mov    0x80113b44,%eax
80103362:	85 c0                	test   %eax,%eax
80103364:	0f 84 09 01 00 00    	je     80103473 <lapicinit+0x119>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010336a:	68 3f 01 00 00       	push   $0x13f
8010336f:	6a 3c                	push   $0x3c
80103371:	e8 c2 ff ff ff       	call   80103338 <lapicw>
80103376:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103379:	6a 0b                	push   $0xb
8010337b:	68 f8 00 00 00       	push   $0xf8
80103380:	e8 b3 ff ff ff       	call   80103338 <lapicw>
80103385:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103388:	68 20 00 02 00       	push   $0x20020
8010338d:	68 c8 00 00 00       	push   $0xc8
80103392:	e8 a1 ff ff ff       	call   80103338 <lapicw>
80103397:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
8010339a:	68 80 96 98 00       	push   $0x989680
8010339f:	68 e0 00 00 00       	push   $0xe0
801033a4:	e8 8f ff ff ff       	call   80103338 <lapicw>
801033a9:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801033ac:	68 00 00 01 00       	push   $0x10000
801033b1:	68 d4 00 00 00       	push   $0xd4
801033b6:	e8 7d ff ff ff       	call   80103338 <lapicw>
801033bb:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801033be:	68 00 00 01 00       	push   $0x10000
801033c3:	68 d8 00 00 00       	push   $0xd8
801033c8:	e8 6b ff ff ff       	call   80103338 <lapicw>
801033cd:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801033d0:	a1 44 3b 11 80       	mov    0x80113b44,%eax
801033d5:	83 c0 30             	add    $0x30,%eax
801033d8:	8b 00                	mov    (%eax),%eax
801033da:	25 00 00 fc 00       	and    $0xfc0000,%eax
801033df:	85 c0                	test   %eax,%eax
801033e1:	74 12                	je     801033f5 <lapicinit+0x9b>
    lapicw(PCINT, MASKED);
801033e3:	68 00 00 01 00       	push   $0x10000
801033e8:	68 d0 00 00 00       	push   $0xd0
801033ed:	e8 46 ff ff ff       	call   80103338 <lapicw>
801033f2:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801033f5:	6a 33                	push   $0x33
801033f7:	68 dc 00 00 00       	push   $0xdc
801033fc:	e8 37 ff ff ff       	call   80103338 <lapicw>
80103401:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103404:	6a 00                	push   $0x0
80103406:	68 a0 00 00 00       	push   $0xa0
8010340b:	e8 28 ff ff ff       	call   80103338 <lapicw>
80103410:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103413:	6a 00                	push   $0x0
80103415:	68 a0 00 00 00       	push   $0xa0
8010341a:	e8 19 ff ff ff       	call   80103338 <lapicw>
8010341f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103422:	6a 00                	push   $0x0
80103424:	6a 2c                	push   $0x2c
80103426:	e8 0d ff ff ff       	call   80103338 <lapicw>
8010342b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010342e:	6a 00                	push   $0x0
80103430:	68 c4 00 00 00       	push   $0xc4
80103435:	e8 fe fe ff ff       	call   80103338 <lapicw>
8010343a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010343d:	68 00 85 08 00       	push   $0x88500
80103442:	68 c0 00 00 00       	push   $0xc0
80103447:	e8 ec fe ff ff       	call   80103338 <lapicw>
8010344c:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010344f:	90                   	nop
80103450:	a1 44 3b 11 80       	mov    0x80113b44,%eax
80103455:	05 00 03 00 00       	add    $0x300,%eax
8010345a:	8b 00                	mov    (%eax),%eax
8010345c:	25 00 10 00 00       	and    $0x1000,%eax
80103461:	85 c0                	test   %eax,%eax
80103463:	75 eb                	jne    80103450 <lapicinit+0xf6>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103465:	6a 00                	push   $0x0
80103467:	6a 20                	push   $0x20
80103469:	e8 ca fe ff ff       	call   80103338 <lapicw>
8010346e:	83 c4 08             	add    $0x8,%esp
80103471:	eb 01                	jmp    80103474 <lapicinit+0x11a>
    return;
80103473:	90                   	nop
}
80103474:	c9                   	leave
80103475:	c3                   	ret

80103476 <lapicid>:

int
lapicid(void)
{
80103476:	55                   	push   %ebp
80103477:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103479:	a1 44 3b 11 80       	mov    0x80113b44,%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	75 07                	jne    80103489 <lapicid+0x13>
    return 0;
80103482:	b8 00 00 00 00       	mov    $0x0,%eax
80103487:	eb 0d                	jmp    80103496 <lapicid+0x20>
  return lapic[ID] >> 24;
80103489:	a1 44 3b 11 80       	mov    0x80113b44,%eax
8010348e:	83 c0 20             	add    $0x20,%eax
80103491:	8b 00                	mov    (%eax),%eax
80103493:	c1 e8 18             	shr    $0x18,%eax
}
80103496:	5d                   	pop    %ebp
80103497:	c3                   	ret

80103498 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103498:	55                   	push   %ebp
80103499:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010349b:	a1 44 3b 11 80       	mov    0x80113b44,%eax
801034a0:	85 c0                	test   %eax,%eax
801034a2:	74 0c                	je     801034b0 <lapiceoi+0x18>
    lapicw(EOI, 0);
801034a4:	6a 00                	push   $0x0
801034a6:	6a 2c                	push   $0x2c
801034a8:	e8 8b fe ff ff       	call   80103338 <lapicw>
801034ad:	83 c4 08             	add    $0x8,%esp
}
801034b0:	90                   	nop
801034b1:	c9                   	leave
801034b2:	c3                   	ret

801034b3 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801034b3:	55                   	push   %ebp
801034b4:	89 e5                	mov    %esp,%ebp
}
801034b6:	90                   	nop
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret

801034b9 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801034b9:	55                   	push   %ebp
801034ba:	89 e5                	mov    %esp,%ebp
801034bc:	83 ec 14             	sub    $0x14,%esp
801034bf:	8b 45 08             	mov    0x8(%ebp),%eax
801034c2:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801034c5:	6a 0f                	push   $0xf
801034c7:	6a 70                	push   $0x70
801034c9:	e8 4b fe ff ff       	call   80103319 <outb>
801034ce:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801034d1:	6a 0a                	push   $0xa
801034d3:	6a 71                	push   $0x71
801034d5:	e8 3f fe ff ff       	call   80103319 <outb>
801034da:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801034dd:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801034e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801034e7:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801034ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801034ef:	c1 e8 04             	shr    $0x4,%eax
801034f2:	89 c2                	mov    %eax,%edx
801034f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801034f7:	83 c0 02             	add    $0x2,%eax
801034fa:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801034fd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103501:	c1 e0 18             	shl    $0x18,%eax
80103504:	50                   	push   %eax
80103505:	68 c4 00 00 00       	push   $0xc4
8010350a:	e8 29 fe ff ff       	call   80103338 <lapicw>
8010350f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103512:	68 00 c5 00 00       	push   $0xc500
80103517:	68 c0 00 00 00       	push   $0xc0
8010351c:	e8 17 fe ff ff       	call   80103338 <lapicw>
80103521:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103524:	68 c8 00 00 00       	push   $0xc8
80103529:	e8 85 ff ff ff       	call   801034b3 <microdelay>
8010352e:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103531:	68 00 85 00 00       	push   $0x8500
80103536:	68 c0 00 00 00       	push   $0xc0
8010353b:	e8 f8 fd ff ff       	call   80103338 <lapicw>
80103540:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103543:	6a 64                	push   $0x64
80103545:	e8 69 ff ff ff       	call   801034b3 <microdelay>
8010354a:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010354d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103554:	eb 3d                	jmp    80103593 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80103556:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010355a:	c1 e0 18             	shl    $0x18,%eax
8010355d:	50                   	push   %eax
8010355e:	68 c4 00 00 00       	push   $0xc4
80103563:	e8 d0 fd ff ff       	call   80103338 <lapicw>
80103568:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010356b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010356e:	c1 e8 0c             	shr    $0xc,%eax
80103571:	80 cc 06             	or     $0x6,%ah
80103574:	50                   	push   %eax
80103575:	68 c0 00 00 00       	push   $0xc0
8010357a:	e8 b9 fd ff ff       	call   80103338 <lapicw>
8010357f:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103582:	68 c8 00 00 00       	push   $0xc8
80103587:	e8 27 ff ff ff       	call   801034b3 <microdelay>
8010358c:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
8010358f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103593:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103597:	7e bd                	jle    80103556 <lapicstartap+0x9d>
  }
}
80103599:	90                   	nop
8010359a:	90                   	nop
8010359b:	c9                   	leave
8010359c:	c3                   	ret

8010359d <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
8010359d:	55                   	push   %ebp
8010359e:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801035a0:	8b 45 08             	mov    0x8(%ebp),%eax
801035a3:	0f b6 c0             	movzbl %al,%eax
801035a6:	50                   	push   %eax
801035a7:	6a 70                	push   $0x70
801035a9:	e8 6b fd ff ff       	call   80103319 <outb>
801035ae:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801035b1:	68 c8 00 00 00       	push   $0xc8
801035b6:	e8 f8 fe ff ff       	call   801034b3 <microdelay>
801035bb:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801035be:	6a 71                	push   $0x71
801035c0:	e8 37 fd ff ff       	call   801032fc <inb>
801035c5:	83 c4 04             	add    $0x4,%esp
801035c8:	0f b6 c0             	movzbl %al,%eax
}
801035cb:	c9                   	leave
801035cc:	c3                   	ret

801035cd <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801035cd:	55                   	push   %ebp
801035ce:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801035d0:	6a 00                	push   $0x0
801035d2:	e8 c6 ff ff ff       	call   8010359d <cmos_read>
801035d7:	83 c4 04             	add    $0x4,%esp
801035da:	8b 55 08             	mov    0x8(%ebp),%edx
801035dd:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801035df:	6a 02                	push   $0x2
801035e1:	e8 b7 ff ff ff       	call   8010359d <cmos_read>
801035e6:	83 c4 04             	add    $0x4,%esp
801035e9:	8b 55 08             	mov    0x8(%ebp),%edx
801035ec:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801035ef:	6a 04                	push   $0x4
801035f1:	e8 a7 ff ff ff       	call   8010359d <cmos_read>
801035f6:	83 c4 04             	add    $0x4,%esp
801035f9:	8b 55 08             	mov    0x8(%ebp),%edx
801035fc:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801035ff:	6a 07                	push   $0x7
80103601:	e8 97 ff ff ff       	call   8010359d <cmos_read>
80103606:	83 c4 04             	add    $0x4,%esp
80103609:	8b 55 08             	mov    0x8(%ebp),%edx
8010360c:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010360f:	6a 08                	push   $0x8
80103611:	e8 87 ff ff ff       	call   8010359d <cmos_read>
80103616:	83 c4 04             	add    $0x4,%esp
80103619:	8b 55 08             	mov    0x8(%ebp),%edx
8010361c:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010361f:	6a 09                	push   $0x9
80103621:	e8 77 ff ff ff       	call   8010359d <cmos_read>
80103626:	83 c4 04             	add    $0x4,%esp
80103629:	8b 55 08             	mov    0x8(%ebp),%edx
8010362c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010362f:	90                   	nop
80103630:	c9                   	leave
80103631:	c3                   	ret

80103632 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103632:	55                   	push   %ebp
80103633:	89 e5                	mov    %esp,%ebp
80103635:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103638:	6a 0b                	push   $0xb
8010363a:	e8 5e ff ff ff       	call   8010359d <cmos_read>
8010363f:	83 c4 04             	add    $0x4,%esp
80103642:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103645:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103648:	83 e0 04             	and    $0x4,%eax
8010364b:	85 c0                	test   %eax,%eax
8010364d:	0f 94 c0             	sete   %al
80103650:	0f b6 c0             	movzbl %al,%eax
80103653:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103656:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103659:	50                   	push   %eax
8010365a:	e8 6e ff ff ff       	call   801035cd <fill_rtcdate>
8010365f:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103662:	6a 0a                	push   $0xa
80103664:	e8 34 ff ff ff       	call   8010359d <cmos_read>
80103669:	83 c4 04             	add    $0x4,%esp
8010366c:	25 80 00 00 00       	and    $0x80,%eax
80103671:	85 c0                	test   %eax,%eax
80103673:	75 27                	jne    8010369c <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103675:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103678:	50                   	push   %eax
80103679:	e8 4f ff ff ff       	call   801035cd <fill_rtcdate>
8010367e:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103681:	83 ec 04             	sub    $0x4,%esp
80103684:	6a 18                	push   $0x18
80103686:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103689:	50                   	push   %eax
8010368a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010368d:	50                   	push   %eax
8010368e:	e8 5e 26 00 00       	call   80105cf1 <memcmp>
80103693:	83 c4 10             	add    $0x10,%esp
80103696:	85 c0                	test   %eax,%eax
80103698:	74 05                	je     8010369f <cmostime+0x6d>
8010369a:	eb ba                	jmp    80103656 <cmostime+0x24>
        continue;
8010369c:	90                   	nop
    fill_rtcdate(&t1);
8010369d:	eb b7                	jmp    80103656 <cmostime+0x24>
      break;
8010369f:	90                   	nop
  }

  // convert
  if(bcd) {
801036a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801036a4:	0f 84 b4 00 00 00    	je     8010375e <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801036aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
801036ad:	c1 e8 04             	shr    $0x4,%eax
801036b0:	89 c2                	mov    %eax,%edx
801036b2:	89 d0                	mov    %edx,%eax
801036b4:	c1 e0 02             	shl    $0x2,%eax
801036b7:	01 d0                	add    %edx,%eax
801036b9:	01 c0                	add    %eax,%eax
801036bb:	89 c2                	mov    %eax,%edx
801036bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801036c0:	83 e0 0f             	and    $0xf,%eax
801036c3:	01 d0                	add    %edx,%eax
801036c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801036c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801036cb:	c1 e8 04             	shr    $0x4,%eax
801036ce:	89 c2                	mov    %eax,%edx
801036d0:	89 d0                	mov    %edx,%eax
801036d2:	c1 e0 02             	shl    $0x2,%eax
801036d5:	01 d0                	add    %edx,%eax
801036d7:	01 c0                	add    %eax,%eax
801036d9:	89 c2                	mov    %eax,%edx
801036db:	8b 45 dc             	mov    -0x24(%ebp),%eax
801036de:	83 e0 0f             	and    $0xf,%eax
801036e1:	01 d0                	add    %edx,%eax
801036e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801036e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036e9:	c1 e8 04             	shr    $0x4,%eax
801036ec:	89 c2                	mov    %eax,%edx
801036ee:	89 d0                	mov    %edx,%eax
801036f0:	c1 e0 02             	shl    $0x2,%eax
801036f3:	01 d0                	add    %edx,%eax
801036f5:	01 c0                	add    %eax,%eax
801036f7:	89 c2                	mov    %eax,%edx
801036f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036fc:	83 e0 0f             	and    $0xf,%eax
801036ff:	01 d0                	add    %edx,%eax
80103701:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103707:	c1 e8 04             	shr    $0x4,%eax
8010370a:	89 c2                	mov    %eax,%edx
8010370c:	89 d0                	mov    %edx,%eax
8010370e:	c1 e0 02             	shl    $0x2,%eax
80103711:	01 d0                	add    %edx,%eax
80103713:	01 c0                	add    %eax,%eax
80103715:	89 c2                	mov    %eax,%edx
80103717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010371a:	83 e0 0f             	and    $0xf,%eax
8010371d:	01 d0                	add    %edx,%eax
8010371f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103722:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103725:	c1 e8 04             	shr    $0x4,%eax
80103728:	89 c2                	mov    %eax,%edx
8010372a:	89 d0                	mov    %edx,%eax
8010372c:	c1 e0 02             	shl    $0x2,%eax
8010372f:	01 d0                	add    %edx,%eax
80103731:	01 c0                	add    %eax,%eax
80103733:	89 c2                	mov    %eax,%edx
80103735:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103738:	83 e0 0f             	and    $0xf,%eax
8010373b:	01 d0                	add    %edx,%eax
8010373d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103740:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103743:	c1 e8 04             	shr    $0x4,%eax
80103746:	89 c2                	mov    %eax,%edx
80103748:	89 d0                	mov    %edx,%eax
8010374a:	c1 e0 02             	shl    $0x2,%eax
8010374d:	01 d0                	add    %edx,%eax
8010374f:	01 c0                	add    %eax,%eax
80103751:	89 c2                	mov    %eax,%edx
80103753:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103756:	83 e0 0f             	and    $0xf,%eax
80103759:	01 d0                	add    %edx,%eax
8010375b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010375e:	8b 45 08             	mov    0x8(%ebp),%eax
80103761:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103764:	89 10                	mov    %edx,(%eax)
80103766:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103769:	89 50 04             	mov    %edx,0x4(%eax)
8010376c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010376f:	89 50 08             	mov    %edx,0x8(%eax)
80103772:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103775:	89 50 0c             	mov    %edx,0xc(%eax)
80103778:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010377b:	89 50 10             	mov    %edx,0x10(%eax)
8010377e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103781:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103784:	8b 45 08             	mov    0x8(%ebp),%eax
80103787:	8b 40 14             	mov    0x14(%eax),%eax
8010378a:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103790:	8b 45 08             	mov    0x8(%ebp),%eax
80103793:	89 50 14             	mov    %edx,0x14(%eax)
}
80103796:	90                   	nop
80103797:	c9                   	leave
80103798:	c3                   	ret

80103799 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103799:	55                   	push   %ebp
8010379a:	89 e5                	mov    %esp,%ebp
8010379c:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010379f:	83 ec 08             	sub    $0x8,%esp
801037a2:	68 7f 92 10 80       	push   $0x8010927f
801037a7:	68 60 3b 11 80       	push   $0x80113b60
801037ac:	e8 31 22 00 00       	call   801059e2 <initlock>
801037b1:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801037b4:	83 ec 08             	sub    $0x8,%esp
801037b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801037ba:	50                   	push   %eax
801037bb:	ff 75 08             	push   0x8(%ebp)
801037be:	e8 52 dc ff ff       	call   80101415 <readsb>
801037c3:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801037c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037c9:	a3 94 3b 11 80       	mov    %eax,0x80113b94
  log.size = sb.nlog;
801037ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801037d1:	a3 98 3b 11 80       	mov    %eax,0x80113b98
  log.dev = dev;
801037d6:	8b 45 08             	mov    0x8(%ebp),%eax
801037d9:	a3 a4 3b 11 80       	mov    %eax,0x80113ba4
  recover_from_log();
801037de:	e8 b3 01 00 00       	call   80103996 <recover_from_log>
}
801037e3:	90                   	nop
801037e4:	c9                   	leave
801037e5:	c3                   	ret

801037e6 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801037e6:	55                   	push   %ebp
801037e7:	89 e5                	mov    %esp,%ebp
801037e9:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037f3:	e9 95 00 00 00       	jmp    8010388d <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801037f8:	8b 15 94 3b 11 80    	mov    0x80113b94,%edx
801037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103801:	01 d0                	add    %edx,%eax
80103803:	83 c0 01             	add    $0x1,%eax
80103806:	89 c2                	mov    %eax,%edx
80103808:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
8010380d:	83 ec 08             	sub    $0x8,%esp
80103810:	52                   	push   %edx
80103811:	50                   	push   %eax
80103812:	e8 b8 c9 ff ff       	call   801001cf <bread>
80103817:	83 c4 10             	add    $0x10,%esp
8010381a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010381d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103820:	83 c0 10             	add    $0x10,%eax
80103823:	8b 04 85 6c 3b 11 80 	mov    -0x7feec494(,%eax,4),%eax
8010382a:	89 c2                	mov    %eax,%edx
8010382c:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
80103831:	83 ec 08             	sub    $0x8,%esp
80103834:	52                   	push   %edx
80103835:	50                   	push   %eax
80103836:	e8 94 c9 ff ff       	call   801001cf <bread>
8010383b:	83 c4 10             	add    $0x10,%esp
8010383e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103844:	8d 50 5c             	lea    0x5c(%eax),%edx
80103847:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010384a:	83 c0 5c             	add    $0x5c,%eax
8010384d:	83 ec 04             	sub    $0x4,%esp
80103850:	68 00 02 00 00       	push   $0x200
80103855:	52                   	push   %edx
80103856:	50                   	push   %eax
80103857:	e8 ed 24 00 00       	call   80105d49 <memmove>
8010385c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010385f:	83 ec 0c             	sub    $0xc,%esp
80103862:	ff 75 ec             	push   -0x14(%ebp)
80103865:	e8 9e c9 ff ff       	call   80100208 <bwrite>
8010386a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	ff 75 f0             	push   -0x10(%ebp)
80103873:	e8 d9 c9 ff ff       	call   80100251 <brelse>
80103878:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	ff 75 ec             	push   -0x14(%ebp)
80103881:	e8 cb c9 ff ff       	call   80100251 <brelse>
80103886:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103889:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010388d:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103892:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103895:	0f 8c 5d ff ff ff    	jl     801037f8 <install_trans+0x12>
  }
}
8010389b:	90                   	nop
8010389c:	90                   	nop
8010389d:	c9                   	leave
8010389e:	c3                   	ret

8010389f <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010389f:	55                   	push   %ebp
801038a0:	89 e5                	mov    %esp,%ebp
801038a2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801038a5:	a1 94 3b 11 80       	mov    0x80113b94,%eax
801038aa:	89 c2                	mov    %eax,%edx
801038ac:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
801038b1:	83 ec 08             	sub    $0x8,%esp
801038b4:	52                   	push   %edx
801038b5:	50                   	push   %eax
801038b6:	e8 14 c9 ff ff       	call   801001cf <bread>
801038bb:	83 c4 10             	add    $0x10,%esp
801038be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801038c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c4:	83 c0 5c             	add    $0x5c,%eax
801038c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801038ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038cd:	8b 00                	mov    (%eax),%eax
801038cf:	a3 a8 3b 11 80       	mov    %eax,0x80113ba8
  for (i = 0; i < log.lh.n; i++) {
801038d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038db:	eb 1b                	jmp    801038f8 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801038dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038e3:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801038e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038ea:	83 c2 10             	add    $0x10,%edx
801038ed:	89 04 95 6c 3b 11 80 	mov    %eax,-0x7feec494(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801038f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038f8:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
801038fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103900:	7c db                	jl     801038dd <read_head+0x3e>
  }
  brelse(buf);
80103902:	83 ec 0c             	sub    $0xc,%esp
80103905:	ff 75 f0             	push   -0x10(%ebp)
80103908:	e8 44 c9 ff ff       	call   80100251 <brelse>
8010390d:	83 c4 10             	add    $0x10,%esp
}
80103910:	90                   	nop
80103911:	c9                   	leave
80103912:	c3                   	ret

80103913 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103913:	55                   	push   %ebp
80103914:	89 e5                	mov    %esp,%ebp
80103916:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103919:	a1 94 3b 11 80       	mov    0x80113b94,%eax
8010391e:	89 c2                	mov    %eax,%edx
80103920:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
80103925:	83 ec 08             	sub    $0x8,%esp
80103928:	52                   	push   %edx
80103929:	50                   	push   %eax
8010392a:	e8 a0 c8 ff ff       	call   801001cf <bread>
8010392f:	83 c4 10             	add    $0x10,%esp
80103932:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103935:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103938:	83 c0 5c             	add    $0x5c,%eax
8010393b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010393e:	8b 15 a8 3b 11 80    	mov    0x80113ba8,%edx
80103944:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103947:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103950:	eb 1b                	jmp    8010396d <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103955:	83 c0 10             	add    $0x10,%eax
80103958:	8b 0c 85 6c 3b 11 80 	mov    -0x7feec494(,%eax,4),%ecx
8010395f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103962:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103965:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103969:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010396d:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103972:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103975:	7c db                	jl     80103952 <write_head+0x3f>
  }
  bwrite(buf);
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	ff 75 f0             	push   -0x10(%ebp)
8010397d:	e8 86 c8 ff ff       	call   80100208 <bwrite>
80103982:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103985:	83 ec 0c             	sub    $0xc,%esp
80103988:	ff 75 f0             	push   -0x10(%ebp)
8010398b:	e8 c1 c8 ff ff       	call   80100251 <brelse>
80103990:	83 c4 10             	add    $0x10,%esp
}
80103993:	90                   	nop
80103994:	c9                   	leave
80103995:	c3                   	ret

80103996 <recover_from_log>:

static void
recover_from_log(void)
{
80103996:	55                   	push   %ebp
80103997:	89 e5                	mov    %esp,%ebp
80103999:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010399c:	e8 fe fe ff ff       	call   8010389f <read_head>
  install_trans(); // if committed, copy from log to disk
801039a1:	e8 40 fe ff ff       	call   801037e6 <install_trans>
  log.lh.n = 0;
801039a6:	c7 05 a8 3b 11 80 00 	movl   $0x0,0x80113ba8
801039ad:	00 00 00 
  write_head(); // clear the log
801039b0:	e8 5e ff ff ff       	call   80103913 <write_head>
}
801039b5:	90                   	nop
801039b6:	c9                   	leave
801039b7:	c3                   	ret

801039b8 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp
801039c1:	68 60 3b 11 80       	push   $0x80113b60
801039c6:	e8 39 20 00 00       	call   80105a04 <acquire>
801039cb:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801039ce:	a1 a0 3b 11 80       	mov    0x80113ba0,%eax
801039d3:	85 c0                	test   %eax,%eax
801039d5:	74 17                	je     801039ee <begin_op+0x36>
      sleep(&log, &log.lock);
801039d7:	83 ec 08             	sub    $0x8,%esp
801039da:	68 60 3b 11 80       	push   $0x80113b60
801039df:	68 60 3b 11 80       	push   $0x80113b60
801039e4:	e8 d1 1b 00 00       	call   801055ba <sleep>
801039e9:	83 c4 10             	add    $0x10,%esp
801039ec:	eb e0                	jmp    801039ce <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801039ee:	8b 0d a8 3b 11 80    	mov    0x80113ba8,%ecx
801039f4:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
801039f9:	8d 50 01             	lea    0x1(%eax),%edx
801039fc:	89 d0                	mov    %edx,%eax
801039fe:	c1 e0 02             	shl    $0x2,%eax
80103a01:	01 d0                	add    %edx,%eax
80103a03:	01 c0                	add    %eax,%eax
80103a05:	01 c8                	add    %ecx,%eax
80103a07:	83 f8 1e             	cmp    $0x1e,%eax
80103a0a:	7e 17                	jle    80103a23 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103a0c:	83 ec 08             	sub    $0x8,%esp
80103a0f:	68 60 3b 11 80       	push   $0x80113b60
80103a14:	68 60 3b 11 80       	push   $0x80113b60
80103a19:	e8 9c 1b 00 00       	call   801055ba <sleep>
80103a1e:	83 c4 10             	add    $0x10,%esp
80103a21:	eb ab                	jmp    801039ce <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103a23:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103a28:	83 c0 01             	add    $0x1,%eax
80103a2b:	a3 9c 3b 11 80       	mov    %eax,0x80113b9c
      release(&log.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	68 60 3b 11 80       	push   $0x80113b60
80103a38:	e8 35 20 00 00       	call   80105a72 <release>
80103a3d:	83 c4 10             	add    $0x10,%esp
      break;
80103a40:	90                   	nop
    }
  }
}
80103a41:	90                   	nop
80103a42:	c9                   	leave
80103a43:	c3                   	ret

80103a44 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103a51:	83 ec 0c             	sub    $0xc,%esp
80103a54:	68 60 3b 11 80       	push   $0x80113b60
80103a59:	e8 a6 1f 00 00       	call   80105a04 <acquire>
80103a5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103a61:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103a66:	83 e8 01             	sub    $0x1,%eax
80103a69:	a3 9c 3b 11 80       	mov    %eax,0x80113b9c
  if(log.committing)
80103a6e:	a1 a0 3b 11 80       	mov    0x80113ba0,%eax
80103a73:	85 c0                	test   %eax,%eax
80103a75:	74 0d                	je     80103a84 <end_op+0x40>
    panic("log.committing");
80103a77:	83 ec 0c             	sub    $0xc,%esp
80103a7a:	68 83 92 10 80       	push   $0x80109283
80103a7f:	e8 2f cb ff ff       	call   801005b3 <panic>
  if(log.outstanding == 0){
80103a84:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103a89:	85 c0                	test   %eax,%eax
80103a8b:	75 13                	jne    80103aa0 <end_op+0x5c>
    do_commit = 1;
80103a8d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103a94:	c7 05 a0 3b 11 80 01 	movl   $0x1,0x80113ba0
80103a9b:	00 00 00 
80103a9e:	eb 10                	jmp    80103ab0 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 60 3b 11 80       	push   $0x80113b60
80103aa8:	e8 f7 1b 00 00       	call   801056a4 <wakeup>
80103aad:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 60 3b 11 80       	push   $0x80113b60
80103ab8:	e8 b5 1f 00 00       	call   80105a72 <release>
80103abd:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ac4:	74 3f                	je     80103b05 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103ac6:	e8 f6 00 00 00       	call   80103bc1 <commit>
    acquire(&log.lock);
80103acb:	83 ec 0c             	sub    $0xc,%esp
80103ace:	68 60 3b 11 80       	push   $0x80113b60
80103ad3:	e8 2c 1f 00 00       	call   80105a04 <acquire>
80103ad8:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103adb:	c7 05 a0 3b 11 80 00 	movl   $0x0,0x80113ba0
80103ae2:	00 00 00 
    wakeup(&log);
80103ae5:	83 ec 0c             	sub    $0xc,%esp
80103ae8:	68 60 3b 11 80       	push   $0x80113b60
80103aed:	e8 b2 1b 00 00       	call   801056a4 <wakeup>
80103af2:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103af5:	83 ec 0c             	sub    $0xc,%esp
80103af8:	68 60 3b 11 80       	push   $0x80113b60
80103afd:	e8 70 1f 00 00       	call   80105a72 <release>
80103b02:	83 c4 10             	add    $0x10,%esp
  }
}
80103b05:	90                   	nop
80103b06:	c9                   	leave
80103b07:	c3                   	ret

80103b08 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103b08:	55                   	push   %ebp
80103b09:	89 e5                	mov    %esp,%ebp
80103b0b:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103b0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b15:	e9 95 00 00 00       	jmp    80103baf <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103b1a:	8b 15 94 3b 11 80    	mov    0x80113b94,%edx
80103b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b23:	01 d0                	add    %edx,%eax
80103b25:	83 c0 01             	add    $0x1,%eax
80103b28:	89 c2                	mov    %eax,%edx
80103b2a:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
80103b2f:	83 ec 08             	sub    $0x8,%esp
80103b32:	52                   	push   %edx
80103b33:	50                   	push   %eax
80103b34:	e8 96 c6 ff ff       	call   801001cf <bread>
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b42:	83 c0 10             	add    $0x10,%eax
80103b45:	8b 04 85 6c 3b 11 80 	mov    -0x7feec494(,%eax,4),%eax
80103b4c:	89 c2                	mov    %eax,%edx
80103b4e:	a1 a4 3b 11 80       	mov    0x80113ba4,%eax
80103b53:	83 ec 08             	sub    $0x8,%esp
80103b56:	52                   	push   %edx
80103b57:	50                   	push   %eax
80103b58:	e8 72 c6 ff ff       	call   801001cf <bread>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b66:	8d 50 5c             	lea    0x5c(%eax),%edx
80103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6c:	83 c0 5c             	add    $0x5c,%eax
80103b6f:	83 ec 04             	sub    $0x4,%esp
80103b72:	68 00 02 00 00       	push   $0x200
80103b77:	52                   	push   %edx
80103b78:	50                   	push   %eax
80103b79:	e8 cb 21 00 00       	call   80105d49 <memmove>
80103b7e:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103b81:	83 ec 0c             	sub    $0xc,%esp
80103b84:	ff 75 f0             	push   -0x10(%ebp)
80103b87:	e8 7c c6 ff ff       	call   80100208 <bwrite>
80103b8c:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103b8f:	83 ec 0c             	sub    $0xc,%esp
80103b92:	ff 75 ec             	push   -0x14(%ebp)
80103b95:	e8 b7 c6 ff ff       	call   80100251 <brelse>
80103b9a:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	ff 75 f0             	push   -0x10(%ebp)
80103ba3:	e8 a9 c6 ff ff       	call   80100251 <brelse>
80103ba8:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103bab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103baf:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103bb4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bb7:	0f 8c 5d ff ff ff    	jl     80103b1a <write_log+0x12>
  }
}
80103bbd:	90                   	nop
80103bbe:	90                   	nop
80103bbf:	c9                   	leave
80103bc0:	c3                   	ret

80103bc1 <commit>:

static void
commit()
{
80103bc1:	55                   	push   %ebp
80103bc2:	89 e5                	mov    %esp,%ebp
80103bc4:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103bc7:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	7e 1e                	jle    80103bee <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103bd0:	e8 33 ff ff ff       	call   80103b08 <write_log>
    write_head();    // Write header to disk -- the real commit
80103bd5:	e8 39 fd ff ff       	call   80103913 <write_head>
    install_trans(); // Now install writes to home locations
80103bda:	e8 07 fc ff ff       	call   801037e6 <install_trans>
    log.lh.n = 0;
80103bdf:	c7 05 a8 3b 11 80 00 	movl   $0x0,0x80113ba8
80103be6:	00 00 00 
    write_head();    // Erase the transaction from the log
80103be9:	e8 25 fd ff ff       	call   80103913 <write_head>
  }
}
80103bee:	90                   	nop
80103bef:	c9                   	leave
80103bf0:	c3                   	ret

80103bf1 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103bf1:	55                   	push   %ebp
80103bf2:	89 e5                	mov    %esp,%ebp
80103bf4:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103bf7:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103bfc:	83 f8 1d             	cmp    $0x1d,%eax
80103bff:	7f 12                	jg     80103c13 <log_write+0x22>
80103c01:	8b 15 a8 3b 11 80    	mov    0x80113ba8,%edx
80103c07:	a1 98 3b 11 80       	mov    0x80113b98,%eax
80103c0c:	83 e8 01             	sub    $0x1,%eax
80103c0f:	39 c2                	cmp    %eax,%edx
80103c11:	7c 0d                	jl     80103c20 <log_write+0x2f>
    panic("too big a transaction");
80103c13:	83 ec 0c             	sub    $0xc,%esp
80103c16:	68 92 92 10 80       	push   $0x80109292
80103c1b:	e8 93 c9 ff ff       	call   801005b3 <panic>
  if (log.outstanding < 1)
80103c20:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103c25:	85 c0                	test   %eax,%eax
80103c27:	7f 0d                	jg     80103c36 <log_write+0x45>
    panic("log_write outside of trans");
80103c29:	83 ec 0c             	sub    $0xc,%esp
80103c2c:	68 a8 92 10 80       	push   $0x801092a8
80103c31:	e8 7d c9 ff ff       	call   801005b3 <panic>

  acquire(&log.lock);
80103c36:	83 ec 0c             	sub    $0xc,%esp
80103c39:	68 60 3b 11 80       	push   $0x80113b60
80103c3e:	e8 c1 1d 00 00       	call   80105a04 <acquire>
80103c43:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103c4d:	eb 1d                	jmp    80103c6c <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c52:	83 c0 10             	add    $0x10,%eax
80103c55:	8b 04 85 6c 3b 11 80 	mov    -0x7feec494(,%eax,4),%eax
80103c5c:	89 c2                	mov    %eax,%edx
80103c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c61:	8b 40 08             	mov    0x8(%eax),%eax
80103c64:	39 c2                	cmp    %eax,%edx
80103c66:	74 10                	je     80103c78 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
80103c68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103c6c:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103c71:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103c74:	7c d9                	jl     80103c4f <log_write+0x5e>
80103c76:	eb 01                	jmp    80103c79 <log_write+0x88>
      break;
80103c78:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103c79:	8b 45 08             	mov    0x8(%ebp),%eax
80103c7c:	8b 40 08             	mov    0x8(%eax),%eax
80103c7f:	89 c2                	mov    %eax,%edx
80103c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c84:	83 c0 10             	add    $0x10,%eax
80103c87:	89 14 85 6c 3b 11 80 	mov    %edx,-0x7feec494(,%eax,4)
  if (i == log.lh.n)
80103c8e:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103c93:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103c96:	75 0d                	jne    80103ca5 <log_write+0xb4>
    log.lh.n++;
80103c98:	a1 a8 3b 11 80       	mov    0x80113ba8,%eax
80103c9d:	83 c0 01             	add    $0x1,%eax
80103ca0:	a3 a8 3b 11 80       	mov    %eax,0x80113ba8
  b->flags |= B_DIRTY; // prevent eviction
80103ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca8:	8b 00                	mov    (%eax),%eax
80103caa:	83 c8 04             	or     $0x4,%eax
80103cad:	89 c2                	mov    %eax,%edx
80103caf:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb2:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	68 60 3b 11 80       	push   $0x80113b60
80103cbc:	e8 b1 1d 00 00       	call   80105a72 <release>
80103cc1:	83 c4 10             	add    $0x10,%esp
}
80103cc4:	90                   	nop
80103cc5:	c9                   	leave
80103cc6:	c3                   	ret

80103cc7 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103cc7:	55                   	push   %ebp
80103cc8:	89 e5                	mov    %esp,%ebp
80103cca:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103ccd:	8b 55 08             	mov    0x8(%ebp),%edx
80103cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103cd6:	f0 87 02             	lock xchg %eax,(%edx)
80103cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103cdf:	c9                   	leave
80103ce0:	c3                   	ret

80103ce1 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103ce1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103ce5:	83 e4 f0             	and    $0xfffffff0,%esp
80103ce8:	ff 71 fc             	push   -0x4(%ecx)
80103ceb:	55                   	push   %ebp
80103cec:	89 e5                	mov    %esp,%ebp
80103cee:	51                   	push   %ecx
80103cef:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103cf2:	83 ec 08             	sub    $0x8,%esp
80103cf5:	68 00 00 40 80       	push   $0x80400000
80103cfa:	68 60 7e 11 80       	push   $0x80117e60
80103cff:	e8 5d ee ff ff       	call   80102b61 <kinit1>
80103d04:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103d07:	e8 3e 4b 00 00       	call   8010884a <kvmalloc>
  mpinit();        // detect other processors
80103d0c:	e8 bb 03 00 00       	call   801040cc <mpinit>
  lapicinit();     // interrupt controller
80103d11:	e8 44 f6 ff ff       	call   8010335a <lapicinit>
  seginit();       // segment descriptors
80103d16:	e8 1a 46 00 00       	call   80108335 <seginit>
  picinit();       // disable pic
80103d1b:	e8 11 05 00 00       	call   80104231 <picinit>
  ioapicinit();    // another interrupt controller
80103d20:	e8 57 ed ff ff       	call   80102a7c <ioapicinit>
  consoleinit();   // console hardware
80103d25:	e8 52 ce ff ff       	call   80100b7c <consoleinit>
  uartinit();      // serial port
80103d2a:	e8 9f 39 00 00       	call   801076ce <uartinit>
  pinit();         // process table
80103d2f:	e8 36 09 00 00       	call   8010466a <pinit>
  tvinit();        // trap vectors
80103d34:	e8 77 35 00 00       	call   801072b0 <tvinit>
  binit();         // buffer cache
80103d39:	e8 f6 c2 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103d3e:	e8 c3 d2 ff ff       	call   80101006 <fileinit>
  ideinit();       // disk 
80103d43:	e8 0b e9 ff ff       	call   80102653 <ideinit>
  startothers();   // start other processors
80103d48:	e8 80 00 00 00       	call   80103dcd <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103d4d:	83 ec 08             	sub    $0x8,%esp
80103d50:	68 00 00 00 8e       	push   $0x8e000000
80103d55:	68 00 00 40 80       	push   $0x80400000
80103d5a:	e8 3b ee ff ff       	call   80102b9a <kinit2>
80103d5f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103d62:	e8 28 0b 00 00       	call   8010488f <userinit>
  mpmain();        // finish this processor's setup
80103d67:	e8 1a 00 00 00       	call   80103d86 <mpmain>

80103d6c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103d6c:	55                   	push   %ebp
80103d6d:	89 e5                	mov    %esp,%ebp
80103d6f:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103d72:	e8 eb 4a 00 00       	call   80108862 <switchkvm>
  seginit();
80103d77:	e8 b9 45 00 00       	call   80108335 <seginit>
  lapicinit();
80103d7c:	e8 d9 f5 ff ff       	call   8010335a <lapicinit>
  mpmain();
80103d81:	e8 00 00 00 00       	call   80103d86 <mpmain>

80103d86 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103d8d:	e8 f6 08 00 00       	call   80104688 <cpuid>
80103d92:	89 c3                	mov    %eax,%ebx
80103d94:	e8 ef 08 00 00       	call   80104688 <cpuid>
80103d99:	83 ec 04             	sub    $0x4,%esp
80103d9c:	53                   	push   %ebx
80103d9d:	50                   	push   %eax
80103d9e:	68 c3 92 10 80       	push   $0x801092c3
80103da3:	e8 56 c6 ff ff       	call   801003fe <cprintf>
80103da8:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103dab:	e8 76 36 00 00       	call   80107426 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103db0:	e8 ee 08 00 00       	call   801046a3 <mycpu>
80103db5:	05 a0 00 00 00       	add    $0xa0,%eax
80103dba:	83 ec 08             	sub    $0x8,%esp
80103dbd:	6a 01                	push   $0x1
80103dbf:	50                   	push   %eax
80103dc0:	e8 02 ff ff ff       	call   80103cc7 <xchg>
80103dc5:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103dc8:	e8 f9 15 00 00       	call   801053c6 <scheduler>

80103dcd <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103dcd:	55                   	push   %ebp
80103dce:	89 e5                	mov    %esp,%ebp
80103dd0:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103dd3:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103dda:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103ddf:	83 ec 04             	sub    $0x4,%esp
80103de2:	50                   	push   %eax
80103de3:	68 2c c5 10 80       	push   $0x8010c52c
80103de8:	ff 75 f0             	push   -0x10(%ebp)
80103deb:	e8 59 1f 00 00       	call   80105d49 <memmove>
80103df0:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103df3:	c7 45 f4 40 3c 11 80 	movl   $0x80113c40,-0xc(%ebp)
80103dfa:	eb 79                	jmp    80103e75 <startothers+0xa8>
    if(c == mycpu())  // We've started already.
80103dfc:	e8 a2 08 00 00       	call   801046a3 <mycpu>
80103e01:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103e04:	74 67                	je     80103e6d <startothers+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103e06:	e8 8b ee ff ff       	call   80102c96 <kalloc>
80103e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e11:	83 e8 04             	sub    $0x4,%eax
80103e14:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103e17:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103e1d:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e22:	83 e8 08             	sub    $0x8,%eax
80103e25:	c7 00 6c 3d 10 80    	movl   $0x80103d6c,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103e2b:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103e30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e39:	83 e8 0c             	sub    $0xc,%eax
80103e3c:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e41:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e4a:	0f b6 00             	movzbl (%eax),%eax
80103e4d:	0f b6 c0             	movzbl %al,%eax
80103e50:	83 ec 08             	sub    $0x8,%esp
80103e53:	52                   	push   %edx
80103e54:	50                   	push   %eax
80103e55:	e8 5f f6 ff ff       	call   801034b9 <lapicstartap>
80103e5a:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103e5d:	90                   	nop
80103e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e61:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103e67:	85 c0                	test   %eax,%eax
80103e69:	74 f3                	je     80103e5e <startothers+0x91>
80103e6b:	eb 01                	jmp    80103e6e <startothers+0xa1>
      continue;
80103e6d:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103e6e:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103e75:	a1 c0 41 11 80       	mov    0x801141c0,%eax
80103e7a:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103e80:	05 40 3c 11 80       	add    $0x80113c40,%eax
80103e85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103e88:	0f 82 6e ff ff ff    	jb     80103dfc <startothers+0x2f>
      ;
  }
}
80103e8e:	90                   	nop
80103e8f:	90                   	nop
80103e90:	c9                   	leave
80103e91:	c3                   	ret

80103e92 <inb>:
{
80103e92:	55                   	push   %ebp
80103e93:	89 e5                	mov    %esp,%ebp
80103e95:	83 ec 14             	sub    $0x14,%esp
80103e98:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e9f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103ea3:	89 c2                	mov    %eax,%edx
80103ea5:	ec                   	in     (%dx),%al
80103ea6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103ea9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103ead:	c9                   	leave
80103eae:	c3                   	ret

80103eaf <outb>:
{
80103eaf:	55                   	push   %ebp
80103eb0:	89 e5                	mov    %esp,%ebp
80103eb2:	83 ec 08             	sub    $0x8,%esp
80103eb5:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ebb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ebf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ec2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ec6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103eca:	ee                   	out    %al,(%dx)
}
80103ecb:	90                   	nop
80103ecc:	c9                   	leave
80103ecd:	c3                   	ret

80103ece <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103ece:	55                   	push   %ebp
80103ecf:	89 e5                	mov    %esp,%ebp
80103ed1:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103ed4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103edb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ee2:	eb 15                	jmp    80103ef9 <sum+0x2b>
    sum += addr[i];
80103ee4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eea:	01 d0                	add    %edx,%eax
80103eec:	0f b6 00             	movzbl (%eax),%eax
80103eef:	0f b6 c0             	movzbl %al,%eax
80103ef2:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ef5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103efc:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103eff:	7c e3                	jl     80103ee4 <sum+0x16>
  return sum;
80103f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103f04:	c9                   	leave
80103f05:	c3                   	ret

80103f06 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103f06:	55                   	push   %ebp
80103f07:	89 e5                	mov    %esp,%ebp
80103f09:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0f:	05 00 00 00 80       	add    $0x80000000,%eax
80103f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103f17:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f1d:	01 d0                	add    %edx,%eax
80103f1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f28:	eb 36                	jmp    80103f60 <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103f2a:	83 ec 04             	sub    $0x4,%esp
80103f2d:	6a 04                	push   $0x4
80103f2f:	68 d8 92 10 80       	push   $0x801092d8
80103f34:	ff 75 f4             	push   -0xc(%ebp)
80103f37:	e8 b5 1d 00 00       	call   80105cf1 <memcmp>
80103f3c:	83 c4 10             	add    $0x10,%esp
80103f3f:	85 c0                	test   %eax,%eax
80103f41:	75 19                	jne    80103f5c <mpsearch1+0x56>
80103f43:	83 ec 08             	sub    $0x8,%esp
80103f46:	6a 10                	push   $0x10
80103f48:	ff 75 f4             	push   -0xc(%ebp)
80103f4b:	e8 7e ff ff ff       	call   80103ece <sum>
80103f50:	83 c4 10             	add    $0x10,%esp
80103f53:	84 c0                	test   %al,%al
80103f55:	75 05                	jne    80103f5c <mpsearch1+0x56>
      return (struct mp*)p;
80103f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5a:	eb 11                	jmp    80103f6d <mpsearch1+0x67>
  for(p = addr; p < e; p += sizeof(struct mp))
80103f5c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f63:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f66:	72 c2                	jb     80103f2a <mpsearch1+0x24>
  return 0;
80103f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f6d:	c9                   	leave
80103f6e:	c3                   	ret

80103f6f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103f6f:	55                   	push   %ebp
80103f70:	89 e5                	mov    %esp,%ebp
80103f72:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103f75:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f7f:	83 c0 0f             	add    $0xf,%eax
80103f82:	0f b6 00             	movzbl (%eax),%eax
80103f85:	0f b6 c0             	movzbl %al,%eax
80103f88:	c1 e0 08             	shl    $0x8,%eax
80103f8b:	89 c2                	mov    %eax,%edx
80103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f90:	83 c0 0e             	add    $0xe,%eax
80103f93:	0f b6 00             	movzbl (%eax),%eax
80103f96:	0f b6 c0             	movzbl %al,%eax
80103f99:	09 d0                	or     %edx,%eax
80103f9b:	c1 e0 04             	shl    $0x4,%eax
80103f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103fa5:	74 21                	je     80103fc8 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103fa7:	83 ec 08             	sub    $0x8,%esp
80103faa:	68 00 04 00 00       	push   $0x400
80103faf:	ff 75 f0             	push   -0x10(%ebp)
80103fb2:	e8 4f ff ff ff       	call   80103f06 <mpsearch1>
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103fc1:	74 51                	je     80104014 <mpsearch+0xa5>
      return mp;
80103fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fc6:	eb 61                	jmp    80104029 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcb:	83 c0 14             	add    $0x14,%eax
80103fce:	0f b6 00             	movzbl (%eax),%eax
80103fd1:	0f b6 c0             	movzbl %al,%eax
80103fd4:	c1 e0 08             	shl    $0x8,%eax
80103fd7:	89 c2                	mov    %eax,%edx
80103fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fdc:	83 c0 13             	add    $0x13,%eax
80103fdf:	0f b6 00             	movzbl (%eax),%eax
80103fe2:	0f b6 c0             	movzbl %al,%eax
80103fe5:	09 d0                	or     %edx,%eax
80103fe7:	c1 e0 0a             	shl    $0xa,%eax
80103fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ff0:	2d 00 04 00 00       	sub    $0x400,%eax
80103ff5:	83 ec 08             	sub    $0x8,%esp
80103ff8:	68 00 04 00 00       	push   $0x400
80103ffd:	50                   	push   %eax
80103ffe:	e8 03 ff ff ff       	call   80103f06 <mpsearch1>
80104003:	83 c4 10             	add    $0x10,%esp
80104006:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104009:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010400d:	74 05                	je     80104014 <mpsearch+0xa5>
      return mp;
8010400f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104012:	eb 15                	jmp    80104029 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80104014:	83 ec 08             	sub    $0x8,%esp
80104017:	68 00 00 01 00       	push   $0x10000
8010401c:	68 00 00 0f 00       	push   $0xf0000
80104021:	e8 e0 fe ff ff       	call   80103f06 <mpsearch1>
80104026:	83 c4 10             	add    $0x10,%esp
}
80104029:	c9                   	leave
8010402a:	c3                   	ret

8010402b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010402b:	55                   	push   %ebp
8010402c:	89 e5                	mov    %esp,%ebp
8010402e:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104031:	e8 39 ff ff ff       	call   80103f6f <mpsearch>
80104036:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010403d:	74 0a                	je     80104049 <mpconfig+0x1e>
8010403f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104042:	8b 40 04             	mov    0x4(%eax),%eax
80104045:	85 c0                	test   %eax,%eax
80104047:	75 07                	jne    80104050 <mpconfig+0x25>
    return 0;
80104049:	b8 00 00 00 00       	mov    $0x0,%eax
8010404e:	eb 7a                	jmp    801040ca <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104053:	8b 40 04             	mov    0x4(%eax),%eax
80104056:	05 00 00 00 80       	add    $0x80000000,%eax
8010405b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010405e:	83 ec 04             	sub    $0x4,%esp
80104061:	6a 04                	push   $0x4
80104063:	68 dd 92 10 80       	push   $0x801092dd
80104068:	ff 75 f0             	push   -0x10(%ebp)
8010406b:	e8 81 1c 00 00       	call   80105cf1 <memcmp>
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	85 c0                	test   %eax,%eax
80104075:	74 07                	je     8010407e <mpconfig+0x53>
    return 0;
80104077:	b8 00 00 00 00       	mov    $0x0,%eax
8010407c:	eb 4c                	jmp    801040ca <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
8010407e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104081:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104085:	3c 01                	cmp    $0x1,%al
80104087:	74 12                	je     8010409b <mpconfig+0x70>
80104089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010408c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104090:	3c 04                	cmp    $0x4,%al
80104092:	74 07                	je     8010409b <mpconfig+0x70>
    return 0;
80104094:	b8 00 00 00 00       	mov    $0x0,%eax
80104099:	eb 2f                	jmp    801040ca <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
8010409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010409e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801040a2:	0f b7 c0             	movzwl %ax,%eax
801040a5:	83 ec 08             	sub    $0x8,%esp
801040a8:	50                   	push   %eax
801040a9:	ff 75 f0             	push   -0x10(%ebp)
801040ac:	e8 1d fe ff ff       	call   80103ece <sum>
801040b1:	83 c4 10             	add    $0x10,%esp
801040b4:	84 c0                	test   %al,%al
801040b6:	74 07                	je     801040bf <mpconfig+0x94>
    return 0;
801040b8:	b8 00 00 00 00       	mov    $0x0,%eax
801040bd:	eb 0b                	jmp    801040ca <mpconfig+0x9f>
  *pmp = mp;
801040bf:	8b 45 08             	mov    0x8(%ebp),%eax
801040c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c5:	89 10                	mov    %edx,(%eax)
  return conf;
801040c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801040ca:	c9                   	leave
801040cb:	c3                   	ret

801040cc <mpinit>:

void
mpinit(void)
{
801040cc:	55                   	push   %ebp
801040cd:	89 e5                	mov    %esp,%ebp
801040cf:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801040d2:	83 ec 0c             	sub    $0xc,%esp
801040d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801040d8:	50                   	push   %eax
801040d9:	e8 4d ff ff ff       	call   8010402b <mpconfig>
801040de:	83 c4 10             	add    $0x10,%esp
801040e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801040e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801040e8:	75 0d                	jne    801040f7 <mpinit+0x2b>
    panic("Expect to run on an SMP");
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 e2 92 10 80       	push   $0x801092e2
801040f2:	e8 bc c4 ff ff       	call   801005b3 <panic>
  ismp = 1;
801040f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
801040fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104101:	8b 40 24             	mov    0x24(%eax),%eax
80104104:	a3 44 3b 11 80       	mov    %eax,0x80113b44
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104109:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010410c:	83 c0 2c             	add    $0x2c,%eax
8010410f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104115:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104119:	0f b7 d0             	movzwl %ax,%edx
8010411c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010411f:	01 d0                	add    %edx,%eax
80104121:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104124:	e9 8c 00 00 00       	jmp    801041b5 <mpinit+0xe9>
    switch(*p){
80104129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412c:	0f b6 00             	movzbl (%eax),%eax
8010412f:	0f b6 c0             	movzbl %al,%eax
80104132:	83 f8 04             	cmp    $0x4,%eax
80104135:	7f 76                	jg     801041ad <mpinit+0xe1>
80104137:	83 f8 03             	cmp    $0x3,%eax
8010413a:	7d 6b                	jge    801041a7 <mpinit+0xdb>
8010413c:	83 f8 02             	cmp    $0x2,%eax
8010413f:	74 4e                	je     8010418f <mpinit+0xc3>
80104141:	83 f8 02             	cmp    $0x2,%eax
80104144:	7f 67                	jg     801041ad <mpinit+0xe1>
80104146:	85 c0                	test   %eax,%eax
80104148:	74 07                	je     80104151 <mpinit+0x85>
8010414a:	83 f8 01             	cmp    $0x1,%eax
8010414d:	74 58                	je     801041a7 <mpinit+0xdb>
8010414f:	eb 5c                	jmp    801041ad <mpinit+0xe1>
    case MPPROC:
      proc = (struct mpproc*)p;
80104151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104154:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80104157:	a1 c0 41 11 80       	mov    0x801141c0,%eax
8010415c:	83 f8 07             	cmp    $0x7,%eax
8010415f:	7f 28                	jg     80104189 <mpinit+0xbd>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80104161:	8b 15 c0 41 11 80    	mov    0x801141c0,%edx
80104167:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010416a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010416e:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80104174:	81 c2 40 3c 11 80    	add    $0x80113c40,%edx
8010417a:	88 02                	mov    %al,(%edx)
        ncpu++;
8010417c:	a1 c0 41 11 80       	mov    0x801141c0,%eax
80104181:	83 c0 01             	add    $0x1,%eax
80104184:	a3 c0 41 11 80       	mov    %eax,0x801141c0
      }
      p += sizeof(struct mpproc);
80104189:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010418d:	eb 26                	jmp    801041b5 <mpinit+0xe9>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010418f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104198:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010419c:	a2 c4 41 11 80       	mov    %al,0x801141c4
      p += sizeof(struct mpioapic);
801041a1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801041a5:	eb 0e                	jmp    801041b5 <mpinit+0xe9>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801041a7:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801041ab:	eb 08                	jmp    801041b5 <mpinit+0xe9>
    default:
      ismp = 0;
801041ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
801041b4:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801041b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801041bb:	0f 82 68 ff ff ff    	jb     80104129 <mpinit+0x5d>
    }
  }
  if(!ismp)
801041c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801041c5:	75 0d                	jne    801041d4 <mpinit+0x108>
    panic("Didn't find a suitable machine");
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	68 fc 92 10 80       	push   $0x801092fc
801041cf:	e8 df c3 ff ff       	call   801005b3 <panic>

  if(mp->imcrp){
801041d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801041d7:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801041db:	84 c0                	test   %al,%al
801041dd:	74 30                	je     8010420f <mpinit+0x143>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801041df:	83 ec 08             	sub    $0x8,%esp
801041e2:	6a 70                	push   $0x70
801041e4:	6a 22                	push   $0x22
801041e6:	e8 c4 fc ff ff       	call   80103eaf <outb>
801041eb:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801041ee:	83 ec 0c             	sub    $0xc,%esp
801041f1:	6a 23                	push   $0x23
801041f3:	e8 9a fc ff ff       	call   80103e92 <inb>
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	83 c8 01             	or     $0x1,%eax
801041fe:	0f b6 c0             	movzbl %al,%eax
80104201:	83 ec 08             	sub    $0x8,%esp
80104204:	50                   	push   %eax
80104205:	6a 23                	push   $0x23
80104207:	e8 a3 fc ff ff       	call   80103eaf <outb>
8010420c:	83 c4 10             	add    $0x10,%esp
  }
}
8010420f:	90                   	nop
80104210:	c9                   	leave
80104211:	c3                   	ret

80104212 <outb>:
{
80104212:	55                   	push   %ebp
80104213:	89 e5                	mov    %esp,%ebp
80104215:	83 ec 08             	sub    $0x8,%esp
80104218:	8b 55 08             	mov    0x8(%ebp),%edx
8010421b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104222:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104225:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104229:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010422d:	ee                   	out    %al,(%dx)
}
8010422e:	90                   	nop
8010422f:	c9                   	leave
80104230:	c3                   	ret

80104231 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80104231:	55                   	push   %ebp
80104232:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104234:	68 ff 00 00 00       	push   $0xff
80104239:	6a 21                	push   $0x21
8010423b:	e8 d2 ff ff ff       	call   80104212 <outb>
80104240:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104243:	68 ff 00 00 00       	push   $0xff
80104248:	68 a1 00 00 00       	push   $0xa1
8010424d:	e8 c0 ff ff ff       	call   80104212 <outb>
80104252:	83 c4 08             	add    $0x8,%esp
}
80104255:	90                   	nop
80104256:	c9                   	leave
80104257:	c3                   	ret

80104258 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104258:	55                   	push   %ebp
80104259:	89 e5                	mov    %esp,%ebp
8010425b:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010425e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104265:	8b 45 0c             	mov    0xc(%ebp),%eax
80104268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010426e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104271:	8b 10                	mov    (%eax),%edx
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
80104276:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104278:	e8 a7 cd ff ff       	call   80101024 <filealloc>
8010427d:	8b 55 08             	mov    0x8(%ebp),%edx
80104280:	89 02                	mov    %eax,(%edx)
80104282:	8b 45 08             	mov    0x8(%ebp),%eax
80104285:	8b 00                	mov    (%eax),%eax
80104287:	85 c0                	test   %eax,%eax
80104289:	0f 84 c8 00 00 00    	je     80104357 <pipealloc+0xff>
8010428f:	e8 90 cd ff ff       	call   80101024 <filealloc>
80104294:	8b 55 0c             	mov    0xc(%ebp),%edx
80104297:	89 02                	mov    %eax,(%edx)
80104299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010429c:	8b 00                	mov    (%eax),%eax
8010429e:	85 c0                	test   %eax,%eax
801042a0:	0f 84 b1 00 00 00    	je     80104357 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801042a6:	e8 eb e9 ff ff       	call   80102c96 <kalloc>
801042ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042b2:	0f 84 a2 00 00 00    	je     8010435a <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801042c2:	00 00 00 
  p->writeopen = 1;
801042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801042cf:	00 00 00 
  p->nwrite = 0;
801042d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801042dc:	00 00 00 
  p->nread = 0;
801042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801042e9:	00 00 00 
  initlock(&p->lock, "pipe");
801042ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ef:	83 ec 08             	sub    $0x8,%esp
801042f2:	68 1b 93 10 80       	push   $0x8010931b
801042f7:	50                   	push   %eax
801042f8:	e8 e5 16 00 00       	call   801059e2 <initlock>
801042fd:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104300:	8b 45 08             	mov    0x8(%ebp),%eax
80104303:	8b 00                	mov    (%eax),%eax
80104305:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010430b:	8b 45 08             	mov    0x8(%ebp),%eax
8010430e:	8b 00                	mov    (%eax),%eax
80104310:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	8b 00                	mov    (%eax),%eax
80104319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010431d:	8b 45 08             	mov    0x8(%ebp),%eax
80104320:	8b 00                	mov    (%eax),%eax
80104322:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104325:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104328:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432b:	8b 00                	mov    (%eax),%eax
8010432d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104333:	8b 45 0c             	mov    0xc(%ebp),%eax
80104336:	8b 00                	mov    (%eax),%eax
80104338:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010433c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433f:	8b 00                	mov    (%eax),%eax
80104341:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104345:	8b 45 0c             	mov    0xc(%ebp),%eax
80104348:	8b 00                	mov    (%eax),%eax
8010434a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010434d:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104350:	b8 00 00 00 00       	mov    $0x0,%eax
80104355:	eb 51                	jmp    801043a8 <pipealloc+0x150>
    goto bad;
80104357:	90                   	nop
80104358:	eb 01                	jmp    8010435b <pipealloc+0x103>
    goto bad;
8010435a:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
8010435b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010435f:	74 0e                	je     8010436f <pipealloc+0x117>
    kfree((char*)p);
80104361:	83 ec 0c             	sub    $0xc,%esp
80104364:	ff 75 f4             	push   -0xc(%ebp)
80104367:	e8 90 e8 ff ff       	call   80102bfc <kfree>
8010436c:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010436f:	8b 45 08             	mov    0x8(%ebp),%eax
80104372:	8b 00                	mov    (%eax),%eax
80104374:	85 c0                	test   %eax,%eax
80104376:	74 11                	je     80104389 <pipealloc+0x131>
    fileclose(*f0);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	8b 00                	mov    (%eax),%eax
8010437d:	83 ec 0c             	sub    $0xc,%esp
80104380:	50                   	push   %eax
80104381:	e8 5c cd ff ff       	call   801010e2 <fileclose>
80104386:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104389:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438c:	8b 00                	mov    (%eax),%eax
8010438e:	85 c0                	test   %eax,%eax
80104390:	74 11                	je     801043a3 <pipealloc+0x14b>
    fileclose(*f1);
80104392:	8b 45 0c             	mov    0xc(%ebp),%eax
80104395:	8b 00                	mov    (%eax),%eax
80104397:	83 ec 0c             	sub    $0xc,%esp
8010439a:	50                   	push   %eax
8010439b:	e8 42 cd ff ff       	call   801010e2 <fileclose>
801043a0:	83 c4 10             	add    $0x10,%esp
  return -1;
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	c9                   	leave
801043a9:	c3                   	ret

801043aa <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801043aa:	55                   	push   %ebp
801043ab:	89 e5                	mov    %esp,%ebp
801043ad:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801043b0:	8b 45 08             	mov    0x8(%ebp),%eax
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	50                   	push   %eax
801043b7:	e8 48 16 00 00       	call   80105a04 <acquire>
801043bc:	83 c4 10             	add    $0x10,%esp
  if(writable){
801043bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801043c3:	74 23                	je     801043e8 <pipeclose+0x3e>
    p->writeopen = 0;
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801043cf:	00 00 00 
    wakeup(&p->nread);
801043d2:	8b 45 08             	mov    0x8(%ebp),%eax
801043d5:	05 34 02 00 00       	add    $0x234,%eax
801043da:	83 ec 0c             	sub    $0xc,%esp
801043dd:	50                   	push   %eax
801043de:	e8 c1 12 00 00       	call   801056a4 <wakeup>
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	eb 21                	jmp    80104409 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801043e8:	8b 45 08             	mov    0x8(%ebp),%eax
801043eb:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801043f2:	00 00 00 
    wakeup(&p->nwrite);
801043f5:	8b 45 08             	mov    0x8(%ebp),%eax
801043f8:	05 38 02 00 00       	add    $0x238,%eax
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	50                   	push   %eax
80104401:	e8 9e 12 00 00       	call   801056a4 <wakeup>
80104406:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104409:	8b 45 08             	mov    0x8(%ebp),%eax
8010440c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104412:	85 c0                	test   %eax,%eax
80104414:	75 2c                	jne    80104442 <pipeclose+0x98>
80104416:	8b 45 08             	mov    0x8(%ebp),%eax
80104419:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010441f:	85 c0                	test   %eax,%eax
80104421:	75 1f                	jne    80104442 <pipeclose+0x98>
    release(&p->lock);
80104423:	8b 45 08             	mov    0x8(%ebp),%eax
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	50                   	push   %eax
8010442a:	e8 43 16 00 00       	call   80105a72 <release>
8010442f:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	ff 75 08             	push   0x8(%ebp)
80104438:	e8 bf e7 ff ff       	call   80102bfc <kfree>
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	eb 10                	jmp    80104452 <pipeclose+0xa8>
  } else
    release(&p->lock);
80104442:	8b 45 08             	mov    0x8(%ebp),%eax
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	50                   	push   %eax
80104449:	e8 24 16 00 00       	call   80105a72 <release>
8010444e:	83 c4 10             	add    $0x10,%esp
}
80104451:	90                   	nop
80104452:	90                   	nop
80104453:	c9                   	leave
80104454:	c3                   	ret

80104455 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104455:	55                   	push   %ebp
80104456:	89 e5                	mov    %esp,%ebp
80104458:	53                   	push   %ebx
80104459:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010445c:	8b 45 08             	mov    0x8(%ebp),%eax
8010445f:	83 ec 0c             	sub    $0xc,%esp
80104462:	50                   	push   %eax
80104463:	e8 9c 15 00 00       	call   80105a04 <acquire>
80104468:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010446b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104472:	e9 ad 00 00 00       	jmp    80104524 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80104477:	8b 45 08             	mov    0x8(%ebp),%eax
8010447a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104480:	85 c0                	test   %eax,%eax
80104482:	74 0c                	je     80104490 <pipewrite+0x3b>
80104484:	e8 92 02 00 00       	call   8010471b <myproc>
80104489:	8b 40 24             	mov    0x24(%eax),%eax
8010448c:	85 c0                	test   %eax,%eax
8010448e:	74 19                	je     801044a9 <pipewrite+0x54>
        release(&p->lock);
80104490:	8b 45 08             	mov    0x8(%ebp),%eax
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	50                   	push   %eax
80104497:	e8 d6 15 00 00       	call   80105a72 <release>
8010449c:	83 c4 10             	add    $0x10,%esp
        return -1;
8010449f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044a4:	e9 a9 00 00 00       	jmp    80104552 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801044a9:	8b 45 08             	mov    0x8(%ebp),%eax
801044ac:	05 34 02 00 00       	add    $0x234,%eax
801044b1:	83 ec 0c             	sub    $0xc,%esp
801044b4:	50                   	push   %eax
801044b5:	e8 ea 11 00 00       	call   801056a4 <wakeup>
801044ba:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801044bd:	8b 45 08             	mov    0x8(%ebp),%eax
801044c0:	8b 55 08             	mov    0x8(%ebp),%edx
801044c3:	81 c2 38 02 00 00    	add    $0x238,%edx
801044c9:	83 ec 08             	sub    $0x8,%esp
801044cc:	50                   	push   %eax
801044cd:	52                   	push   %edx
801044ce:	e8 e7 10 00 00       	call   801055ba <sleep>
801044d3:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
801044d9:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801044df:	8b 45 08             	mov    0x8(%ebp),%eax
801044e2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044e8:	05 00 02 00 00       	add    $0x200,%eax
801044ed:	39 c2                	cmp    %eax,%edx
801044ef:	74 86                	je     80104477 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801044f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801044f7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801044fa:	8b 45 08             	mov    0x8(%ebp),%eax
801044fd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104503:	8d 48 01             	lea    0x1(%eax),%ecx
80104506:	8b 55 08             	mov    0x8(%ebp),%edx
80104509:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010450f:	25 ff 01 00 00       	and    $0x1ff,%eax
80104514:	89 c1                	mov    %eax,%ecx
80104516:	0f b6 13             	movzbl (%ebx),%edx
80104519:	8b 45 08             	mov    0x8(%ebp),%eax
8010451c:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104527:	3b 45 10             	cmp    0x10(%ebp),%eax
8010452a:	7c aa                	jl     801044d6 <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010452c:	8b 45 08             	mov    0x8(%ebp),%eax
8010452f:	05 34 02 00 00       	add    $0x234,%eax
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	50                   	push   %eax
80104538:	e8 67 11 00 00       	call   801056a4 <wakeup>
8010453d:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104540:	8b 45 08             	mov    0x8(%ebp),%eax
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	50                   	push   %eax
80104547:	e8 26 15 00 00       	call   80105a72 <release>
8010454c:	83 c4 10             	add    $0x10,%esp
  return n;
8010454f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104555:	c9                   	leave
80104556:	c3                   	ret

80104557 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104557:	55                   	push   %ebp
80104558:	89 e5                	mov    %esp,%ebp
8010455a:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010455d:	8b 45 08             	mov    0x8(%ebp),%eax
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	50                   	push   %eax
80104564:	e8 9b 14 00 00       	call   80105a04 <acquire>
80104569:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010456c:	eb 3e                	jmp    801045ac <piperead+0x55>
    if(myproc()->killed){
8010456e:	e8 a8 01 00 00       	call   8010471b <myproc>
80104573:	8b 40 24             	mov    0x24(%eax),%eax
80104576:	85 c0                	test   %eax,%eax
80104578:	74 19                	je     80104593 <piperead+0x3c>
      release(&p->lock);
8010457a:	8b 45 08             	mov    0x8(%ebp),%eax
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	50                   	push   %eax
80104581:	e8 ec 14 00 00       	call   80105a72 <release>
80104586:	83 c4 10             	add    $0x10,%esp
      return -1;
80104589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458e:	e9 be 00 00 00       	jmp    80104651 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104593:	8b 45 08             	mov    0x8(%ebp),%eax
80104596:	8b 55 08             	mov    0x8(%ebp),%edx
80104599:	81 c2 34 02 00 00    	add    $0x234,%edx
8010459f:	83 ec 08             	sub    $0x8,%esp
801045a2:	50                   	push   %eax
801045a3:	52                   	push   %edx
801045a4:	e8 11 10 00 00       	call   801055ba <sleep>
801045a9:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801045ac:	8b 45 08             	mov    0x8(%ebp),%eax
801045af:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801045b5:	8b 45 08             	mov    0x8(%ebp),%eax
801045b8:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045be:	39 c2                	cmp    %eax,%edx
801045c0:	75 0d                	jne    801045cf <piperead+0x78>
801045c2:	8b 45 08             	mov    0x8(%ebp),%eax
801045c5:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801045cb:	85 c0                	test   %eax,%eax
801045cd:	75 9f                	jne    8010456e <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801045cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045d6:	eb 48                	jmp    80104620 <piperead+0xc9>
    if(p->nread == p->nwrite)
801045d8:	8b 45 08             	mov    0x8(%ebp),%eax
801045db:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801045e1:	8b 45 08             	mov    0x8(%ebp),%eax
801045e4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045ea:	39 c2                	cmp    %eax,%edx
801045ec:	74 3c                	je     8010462a <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801045ee:	8b 45 08             	mov    0x8(%ebp),%eax
801045f1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045f7:	8d 48 01             	lea    0x1(%eax),%ecx
801045fa:	8b 55 08             	mov    0x8(%ebp),%edx
801045fd:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104603:	25 ff 01 00 00       	and    $0x1ff,%eax
80104608:	89 c1                	mov    %eax,%ecx
8010460a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010460d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104610:	01 c2                	add    %eax,%edx
80104612:	8b 45 08             	mov    0x8(%ebp),%eax
80104615:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010461a:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010461c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104623:	3b 45 10             	cmp    0x10(%ebp),%eax
80104626:	7c b0                	jl     801045d8 <piperead+0x81>
80104628:	eb 01                	jmp    8010462b <piperead+0xd4>
      break;
8010462a:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010462b:	8b 45 08             	mov    0x8(%ebp),%eax
8010462e:	05 38 02 00 00       	add    $0x238,%eax
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	50                   	push   %eax
80104637:	e8 68 10 00 00       	call   801056a4 <wakeup>
8010463c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010463f:	8b 45 08             	mov    0x8(%ebp),%eax
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	50                   	push   %eax
80104646:	e8 27 14 00 00       	call   80105a72 <release>
8010464b:	83 c4 10             	add    $0x10,%esp
  return i;
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104651:	c9                   	leave
80104652:	c3                   	ret

80104653 <readeflags>:
{
80104653:	55                   	push   %ebp
80104654:	89 e5                	mov    %esp,%ebp
80104656:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104659:	9c                   	pushf
8010465a:	58                   	pop    %eax
8010465b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010465e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104661:	c9                   	leave
80104662:	c3                   	ret

80104663 <sti>:
{
80104663:	55                   	push   %ebp
80104664:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104666:	fb                   	sti
}
80104667:	90                   	nop
80104668:	5d                   	pop    %ebp
80104669:	c3                   	ret

8010466a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010466a:	55                   	push   %ebp
8010466b:	89 e5                	mov    %esp,%ebp
8010466d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104670:	83 ec 08             	sub    $0x8,%esp
80104673:	68 20 93 10 80       	push   $0x80109320
80104678:	68 e0 41 11 80       	push   $0x801141e0
8010467d:	e8 60 13 00 00       	call   801059e2 <initlock>
80104682:	83 c4 10             	add    $0x10,%esp
}
80104685:	90                   	nop
80104686:	c9                   	leave
80104687:	c3                   	ret

80104688 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104688:	55                   	push   %ebp
80104689:	89 e5                	mov    %esp,%ebp
8010468b:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010468e:	e8 10 00 00 00       	call   801046a3 <mycpu>
80104693:	2d 40 3c 11 80       	sub    $0x80113c40,%eax
80104698:	c1 f8 04             	sar    $0x4,%eax
8010469b:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801046a1:	c9                   	leave
801046a2:	c3                   	ret

801046a3 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801046a3:	55                   	push   %ebp
801046a4:	89 e5                	mov    %esp,%ebp
801046a6:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801046a9:	e8 a5 ff ff ff       	call   80104653 <readeflags>
801046ae:	25 00 02 00 00       	and    $0x200,%eax
801046b3:	85 c0                	test   %eax,%eax
801046b5:	74 0d                	je     801046c4 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801046b7:	83 ec 0c             	sub    $0xc,%esp
801046ba:	68 28 93 10 80       	push   $0x80109328
801046bf:	e8 ef be ff ff       	call   801005b3 <panic>
  
  apicid = lapicid();
801046c4:	e8 ad ed ff ff       	call   80103476 <lapicid>
801046c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801046cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046d3:	eb 2d                	jmp    80104702 <mycpu+0x5f>
    if (cpus[i].apicid == apicid)
801046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d8:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801046de:	05 40 3c 11 80       	add    $0x80113c40,%eax
801046e3:	0f b6 00             	movzbl (%eax),%eax
801046e6:	0f b6 c0             	movzbl %al,%eax
801046e9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801046ec:	75 10                	jne    801046fe <mycpu+0x5b>
      return &cpus[i];
801046ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801046f7:	05 40 3c 11 80       	add    $0x80113c40,%eax
801046fc:	eb 1b                	jmp    80104719 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
801046fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104702:	a1 c0 41 11 80       	mov    0x801141c0,%eax
80104707:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010470a:	7c c9                	jl     801046d5 <mycpu+0x32>
  }
  panic("unknown apicid\n");
8010470c:	83 ec 0c             	sub    $0xc,%esp
8010470f:	68 4e 93 10 80       	push   $0x8010934e
80104714:	e8 9a be ff ff       	call   801005b3 <panic>
}
80104719:	c9                   	leave
8010471a:	c3                   	ret

8010471b <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010471b:	55                   	push   %ebp
8010471c:	89 e5                	mov    %esp,%ebp
8010471e:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104721:	e8 59 14 00 00       	call   80105b7f <pushcli>
  c = mycpu();
80104726:	e8 78 ff ff ff       	call   801046a3 <mycpu>
8010472b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104731:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
8010473a:	e8 8d 14 00 00       	call   80105bcc <popcli>
  return p;
8010473f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104742:	c9                   	leave
80104743:	c3                   	ret

80104744 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010474a:	83 ec 0c             	sub    $0xc,%esp
8010474d:	68 e0 41 11 80       	push   $0x801141e0
80104752:	e8 ad 12 00 00       	call   80105a04 <acquire>
80104757:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475a:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
80104761:	eb 11                	jmp    80104774 <allocproc+0x30>
    if(p->state == UNUSED)
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	8b 40 0c             	mov    0xc(%eax),%eax
80104769:	85 c0                	test   %eax,%eax
8010476b:	74 2a                	je     80104797 <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010476d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104774:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
8010477b:	72 e6                	jb     80104763 <allocproc+0x1f>
      goto found;

  release(&ptable.lock);
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 e0 41 11 80       	push   $0x801141e0
80104785:	e8 e8 12 00 00       	call   80105a72 <release>
8010478a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010478d:	b8 00 00 00 00       	mov    $0x0,%eax
80104792:	e9 f6 00 00 00       	jmp    8010488d <allocproc+0x149>
      goto found;
80104797:	90                   	nop

found:
  p->state = EMBRYO;
80104798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801047a2:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801047a7:	8d 50 01             	lea    0x1(%eax),%edx
801047aa:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
801047b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047b3:	89 42 10             	mov    %eax,0x10(%edx)
  p->isthread = 0; p->tgid = p->pid; p->ustack = 0; p->randstate = p->pid; p->randpct = 0;
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
801047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c3:	8b 50 10             	mov    0x10(%eax),%edx
801047c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
801047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801047d9:	00 00 00 
801047dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047df:	8b 40 10             	mov    0x10(%eax),%eax
801047e2:	89 c2                	mov    %eax,%edx
801047e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e7:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
801047ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f0:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801047f7:	00 00 00 

  release(&ptable.lock);
801047fa:	83 ec 0c             	sub    $0xc,%esp
801047fd:	68 e0 41 11 80       	push   $0x801141e0
80104802:	e8 6b 12 00 00       	call   80105a72 <release>
80104807:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010480a:	e8 87 e4 ff ff       	call   80102c96 <kalloc>
8010480f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104812:	89 42 08             	mov    %eax,0x8(%edx)
80104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104818:	8b 40 08             	mov    0x8(%eax),%eax
8010481b:	85 c0                	test   %eax,%eax
8010481d:	75 11                	jne    80104830 <allocproc+0xec>
    p->state = UNUSED;
8010481f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104822:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104829:	b8 00 00 00 00       	mov    $0x0,%eax
8010482e:	eb 5d                	jmp    8010488d <allocproc+0x149>
  }
  sp = p->kstack + KSTACKSIZE;
80104830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104833:	8b 40 08             	mov    0x8(%eax),%eax
80104836:	05 00 10 00 00       	add    $0x1000,%eax
8010483b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010483e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104845:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104848:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010484b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010484f:	ba 6a 72 10 80       	mov    $0x8010726a,%edx
80104854:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104857:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104859:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104860:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104863:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104869:	8b 40 1c             	mov    0x1c(%eax),%eax
8010486c:	83 ec 04             	sub    $0x4,%esp
8010486f:	6a 14                	push   $0x14
80104871:	6a 00                	push   $0x0
80104873:	50                   	push   %eax
80104874:	e8 11 14 00 00       	call   80105c8a <memset>
80104879:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010487c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104882:	ba 74 55 10 80       	mov    $0x80105574,%edx
80104887:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010488a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010488d:	c9                   	leave
8010488e:	c3                   	ret

8010488f <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010488f:	55                   	push   %ebp
80104890:	89 e5                	mov    %esp,%ebp
80104892:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104895:	e8 aa fe ff ff       	call   80104744 <allocproc>
8010489a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
8010489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a0:	a3 14 66 11 80       	mov    %eax,0x80116614
  if((p->pgdir = setupkvm()) == 0)
801048a5:	e8 07 3f 00 00       	call   801087b1 <setupkvm>
801048aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048ad:	89 42 04             	mov    %eax,0x4(%edx)
801048b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b3:	8b 40 04             	mov    0x4(%eax),%eax
801048b6:	85 c0                	test   %eax,%eax
801048b8:	75 0d                	jne    801048c7 <userinit+0x38>
    panic("userinit: out of memory?");
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	68 5e 93 10 80       	push   $0x8010935e
801048c2:	e8 ec bc ff ff       	call   801005b3 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801048c7:	ba 2c 00 00 00       	mov    $0x2c,%edx
801048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cf:	8b 40 04             	mov    0x4(%eax),%eax
801048d2:	83 ec 04             	sub    $0x4,%esp
801048d5:	52                   	push   %edx
801048d6:	68 00 c5 10 80       	push   $0x8010c500
801048db:	50                   	push   %eax
801048dc:	e8 39 41 00 00       	call   80108a1a <inituvm>
801048e1:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801048e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e7:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801048ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f0:	8b 40 18             	mov    0x18(%eax),%eax
801048f3:	83 ec 04             	sub    $0x4,%esp
801048f6:	6a 4c                	push   $0x4c
801048f8:	6a 00                	push   $0x0
801048fa:	50                   	push   %eax
801048fb:	e8 8a 13 00 00       	call   80105c8a <memset>
80104900:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104906:	8b 40 18             	mov    0x18(%eax),%eax
80104909:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010490f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104912:	8b 40 18             	mov    0x18(%eax),%eax
80104915:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010491b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491e:	8b 50 18             	mov    0x18(%eax),%edx
80104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104924:	8b 40 18             	mov    0x18(%eax),%eax
80104927:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010492b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010492f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104932:	8b 50 18             	mov    0x18(%eax),%edx
80104935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104938:	8b 40 18             	mov    0x18(%eax),%eax
8010493b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010493f:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104946:	8b 40 18             	mov    0x18(%eax),%eax
80104949:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104953:	8b 40 18             	mov    0x18(%eax),%eax
80104956:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010495d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104960:	8b 40 18             	mov    0x18(%eax),%eax
80104963:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010496a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496d:	83 c0 6c             	add    $0x6c,%eax
80104970:	83 ec 04             	sub    $0x4,%esp
80104973:	6a 10                	push   $0x10
80104975:	68 77 93 10 80       	push   $0x80109377
8010497a:	50                   	push   %eax
8010497b:	e8 0d 15 00 00       	call   80105e8d <safestrcpy>
80104980:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104983:	83 ec 0c             	sub    $0xc,%esp
80104986:	68 80 93 10 80       	push   $0x80109380
8010498b:	e8 bf db ff ff       	call   8010254f <namei>
80104990:	83 c4 10             	add    $0x10,%esp
80104993:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104996:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104999:	83 ec 0c             	sub    $0xc,%esp
8010499c:	68 e0 41 11 80       	push   $0x801141e0
801049a1:	e8 5e 10 00 00       	call   80105a04 <acquire>
801049a6:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801049a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	68 e0 41 11 80       	push   $0x801141e0
801049bb:	e8 b2 10 00 00       	call   80105a72 <release>
801049c0:	83 c4 10             	add    $0x10,%esp
}
801049c3:	90                   	nop
801049c4:	c9                   	leave
801049c5:	c3                   	ret

801049c6 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801049c6:	55                   	push   %ebp
801049c7:	89 e5                	mov    %esp,%ebp
801049c9:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
801049cc:	e8 4a fd ff ff       	call   8010471b <myproc>
801049d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801049d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049d7:	8b 00                	mov    (%eax),%eax
801049d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801049dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801049e0:	7e 2e                	jle    80104a10 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801049e2:	8b 55 08             	mov    0x8(%ebp),%edx
801049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e8:	01 c2                	add    %eax,%edx
801049ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ed:	8b 40 04             	mov    0x4(%eax),%eax
801049f0:	83 ec 04             	sub    $0x4,%esp
801049f3:	52                   	push   %edx
801049f4:	ff 75 f4             	push   -0xc(%ebp)
801049f7:	50                   	push   %eax
801049f8:	e8 5a 41 00 00       	call   80108b57 <allocuvm>
801049fd:	83 c4 10             	add    $0x10,%esp
80104a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a07:	75 3b                	jne    80104a44 <growproc+0x7e>
      return -1;
80104a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a0e:	eb 4f                	jmp    80104a5f <growproc+0x99>
  } else if(n < 0){
80104a10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a14:	79 2e                	jns    80104a44 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104a16:	8b 55 08             	mov    0x8(%ebp),%edx
80104a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1c:	01 c2                	add    %eax,%edx
80104a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a21:	8b 40 04             	mov    0x4(%eax),%eax
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	52                   	push   %edx
80104a28:	ff 75 f4             	push   -0xc(%ebp)
80104a2b:	50                   	push   %eax
80104a2c:	e8 2b 42 00 00       	call   80108c5c <deallocuvm>
80104a31:	83 c4 10             	add    $0x10,%esp
80104a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a3b:	75 07                	jne    80104a44 <growproc+0x7e>
      return -1;
80104a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a42:	eb 1b                	jmp    80104a5f <growproc+0x99>
  }
  curproc->sz = sz;
80104a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4a:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	ff 75 f0             	push   -0x10(%ebp)
80104a52:	e8 24 3e 00 00       	call   8010887b <switchuvm>
80104a57:	83 c4 10             	add    $0x10,%esp
  return 0;
80104a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a5f:	c9                   	leave
80104a60:	c3                   	ret

80104a61 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104a61:	55                   	push   %ebp
80104a62:	89 e5                	mov    %esp,%ebp
80104a64:	57                   	push   %edi
80104a65:	56                   	push   %esi
80104a66:	53                   	push   %ebx
80104a67:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104a6a:	e8 ac fc ff ff       	call   8010471b <myproc>
80104a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104a72:	e8 cd fc ff ff       	call   80104744 <allocproc>
80104a77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104a7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104a7e:	75 0a                	jne    80104a8a <fork+0x29>
    return -1;
80104a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a85:	e9 7b 01 00 00       	jmp    80104c05 <fork+0x1a4>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8d:	8b 10                	mov    (%eax),%edx
80104a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a92:	8b 40 04             	mov    0x4(%eax),%eax
80104a95:	83 ec 08             	sub    $0x8,%esp
80104a98:	52                   	push   %edx
80104a99:	50                   	push   %eax
80104a9a:	e8 5b 43 00 00       	call   80108dfa <copyuvm>
80104a9f:	83 c4 10             	add    $0x10,%esp
80104aa2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104aa5:	89 42 04             	mov    %eax,0x4(%edx)
80104aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aab:	8b 40 04             	mov    0x4(%eax),%eax
80104aae:	85 c0                	test   %eax,%eax
80104ab0:	75 30                	jne    80104ae2 <fork+0x81>
    kfree(np->kstack);
80104ab2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ab5:	8b 40 08             	mov    0x8(%eax),%eax
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	50                   	push   %eax
80104abc:	e8 3b e1 ff ff       	call   80102bfc <kfree>
80104ac1:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104ac4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ac7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ad1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104add:	e9 23 01 00 00       	jmp    80104c05 <fork+0x1a4>
  }
  np->sz = curproc->sz;
80104ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ae5:	8b 10                	mov    (%eax),%edx
80104ae7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aea:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104aec:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104af2:	89 50 14             	mov    %edx,0x14(%eax)
  np->tgid = np->pid; np->randstate = curproc->randstate; np->randpct = curproc->randpct;
80104af5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104af8:	8b 50 10             	mov    0x10(%eax),%edx
80104afb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104afe:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
80104b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b07:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104b0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b10:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
80104b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b19:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104b1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b22:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
  *np->tf = *curproc->tf;
80104b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b2b:	8b 48 18             	mov    0x18(%eax),%ecx
80104b2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b31:	8b 40 18             	mov    0x18(%eax),%eax
80104b34:	89 c2                	mov    %eax,%edx
80104b36:	89 cb                	mov    %ecx,%ebx
80104b38:	b8 13 00 00 00       	mov    $0x13,%eax
80104b3d:	89 d7                	mov    %edx,%edi
80104b3f:	89 de                	mov    %ebx,%esi
80104b41:	89 c1                	mov    %eax,%ecx
80104b43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b45:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b48:	8b 40 18             	mov    0x18(%eax),%eax
80104b4b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b59:	eb 3b                	jmp    80104b96 <fork+0x135>
    if(curproc->ofile[i])
80104b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b61:	83 c2 08             	add    $0x8,%edx
80104b64:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	74 26                	je     80104b92 <fork+0x131>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104b6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b72:	83 c2 08             	add    $0x8,%edx
80104b75:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	50                   	push   %eax
80104b7d:	e8 0f c5 ff ff       	call   80101091 <filedup>
80104b82:	83 c4 10             	add    $0x10,%esp
80104b85:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104b88:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104b8b:	83 c1 08             	add    $0x8,%ecx
80104b8e:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104b92:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b96:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b9a:	7e bf                	jle    80104b5b <fork+0xfa>
  np->cwd = idup(curproc->cwd);
80104b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b9f:	8b 40 68             	mov    0x68(%eax),%eax
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	50                   	push   %eax
80104ba6:	e8 37 ce ff ff       	call   801019e2 <idup>
80104bab:	83 c4 10             	add    $0x10,%esp
80104bae:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104bb1:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bb7:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bbd:	83 c0 6c             	add    $0x6c,%eax
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	6a 10                	push   $0x10
80104bc5:	52                   	push   %edx
80104bc6:	50                   	push   %eax
80104bc7:	e8 c1 12 00 00       	call   80105e8d <safestrcpy>
80104bcc:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bd2:	8b 40 10             	mov    0x10(%eax),%eax
80104bd5:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	68 e0 41 11 80       	push   $0x801141e0
80104be0:	e8 1f 0e 00 00       	call   80105a04 <acquire>
80104be5:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104be8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104beb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	68 e0 41 11 80       	push   $0x801141e0
80104bfa:	e8 73 0e 00 00       	call   80105a72 <release>
80104bff:	83 c4 10             	add    $0x10,%esp

  return pid;
80104c02:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c08:	5b                   	pop    %ebx
80104c09:	5e                   	pop    %esi
80104c0a:	5f                   	pop    %edi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret

80104c0d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104c0d:	55                   	push   %ebp
80104c0e:	89 e5                	mov    %esp,%ebp
80104c10:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104c13:	e8 03 fb ff ff       	call   8010471b <myproc>
80104c18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104c1b:	a1 14 66 11 80       	mov    0x80116614,%eax
80104c20:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104c23:	75 0d                	jne    80104c32 <exit+0x25>
    panic("init exiting");
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	68 82 93 10 80       	push   $0x80109382
80104c2d:	e8 81 b9 ff ff       	call   801005b3 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c39:	eb 3f                	jmp    80104c7a <exit+0x6d>
    if(curproc->ofile[fd]){
80104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c41:	83 c2 08             	add    $0x8,%edx
80104c44:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c48:	85 c0                	test   %eax,%eax
80104c4a:	74 2a                	je     80104c76 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80104c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c52:	83 c2 08             	add    $0x8,%edx
80104c55:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	50                   	push   %eax
80104c5d:	e8 80 c4 ff ff       	call   801010e2 <fileclose>
80104c62:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6b:	83 c2 08             	add    $0x8,%edx
80104c6e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c75:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104c76:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c7a:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c7e:	7e bb                	jle    80104c3b <exit+0x2e>
    }
  }

  begin_op();
80104c80:	e8 33 ed ff ff       	call   801039b8 <begin_op>
  iput(curproc->cwd);
80104c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c88:	8b 40 68             	mov    0x68(%eax),%eax
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	50                   	push   %eax
80104c8f:	e8 e9 ce ff ff       	call   80101b7d <iput>
80104c94:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c97:	e8 a8 ed ff ff       	call   80103a44 <end_op>
  curproc->cwd = 0;
80104c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c9f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	68 e0 41 11 80       	push   $0x801141e0
80104cae:	e8 51 0d 00 00       	call   80105a04 <acquire>
80104cb3:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cb9:	8b 40 14             	mov    0x14(%eax),%eax
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 9c 09 00 00       	call   80105661 <wakeup1>
80104cc5:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc8:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
80104ccf:	eb 3a                	jmp    80104d0b <exit+0xfe>
    if(p->parent == curproc){
80104cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd4:	8b 40 14             	mov    0x14(%eax),%eax
80104cd7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104cda:	75 28                	jne    80104d04 <exit+0xf7>
      p->parent = initproc;
80104cdc:	8b 15 14 66 11 80    	mov    0x80116614,%edx
80104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce5:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ceb:	8b 40 0c             	mov    0xc(%eax),%eax
80104cee:	83 f8 05             	cmp    $0x5,%eax
80104cf1:	75 11                	jne    80104d04 <exit+0xf7>
        wakeup1(initproc);
80104cf3:	a1 14 66 11 80       	mov    0x80116614,%eax
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	50                   	push   %eax
80104cfc:	e8 60 09 00 00       	call   80105661 <wakeup1>
80104d01:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d04:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104d0b:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
80104d12:	72 bd                	jb     80104cd1 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d17:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104d1e:	e8 5e 07 00 00       	call   80105481 <sched>
  panic("zombie exit");
80104d23:	83 ec 0c             	sub    $0xc,%esp
80104d26:	68 8f 93 10 80       	push   $0x8010938f
80104d2b:	e8 83 b8 ff ff       	call   801005b3 <panic>

80104d30 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104d36:	e8 e0 f9 ff ff       	call   8010471b <myproc>
80104d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104d3e:	83 ec 0c             	sub    $0xc,%esp
80104d41:	68 e0 41 11 80       	push   $0x801141e0
80104d46:	e8 b9 0c 00 00       	call   80105a04 <acquire>
80104d4b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104d4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d55:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
80104d5c:	e9 a4 00 00 00       	jmp    80104e05 <wait+0xd5>
      if(p->parent != curproc)
80104d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d64:	8b 40 14             	mov    0x14(%eax),%eax
80104d67:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104d6a:	0f 85 8d 00 00 00    	jne    80104dfd <wait+0xcd>
        continue;
      havekids = 1;
80104d70:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7a:	8b 40 0c             	mov    0xc(%eax),%eax
80104d7d:	83 f8 05             	cmp    $0x5,%eax
80104d80:	75 7c                	jne    80104dfe <wait+0xce>
        // Found one.
        pid = p->pid;
80104d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d85:	8b 40 10             	mov    0x10(%eax),%eax
80104d88:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8e:	8b 40 08             	mov    0x8(%eax),%eax
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	50                   	push   %eax
80104d95:	e8 62 de ff ff       	call   80102bfc <kfree>
80104d9a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104daa:	8b 40 04             	mov    0x4(%eax),%eax
80104dad:	83 ec 0c             	sub    $0xc,%esp
80104db0:	50                   	push   %eax
80104db1:	e8 6a 3f 00 00       	call   80108d20 <freevm>
80104db6:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbc:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd0:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	68 e0 41 11 80       	push   $0x801141e0
80104df0:	e8 7d 0c 00 00       	call   80105a72 <release>
80104df5:	83 c4 10             	add    $0x10,%esp
        return pid;
80104df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104dfb:	eb 54                	jmp    80104e51 <wait+0x121>
        continue;
80104dfd:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dfe:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104e05:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
80104e0c:	0f 82 4f ff ff ff    	jb     80104d61 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e16:	74 0a                	je     80104e22 <wait+0xf2>
80104e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e1b:	8b 40 24             	mov    0x24(%eax),%eax
80104e1e:	85 c0                	test   %eax,%eax
80104e20:	74 17                	je     80104e39 <wait+0x109>
      release(&ptable.lock);
80104e22:	83 ec 0c             	sub    $0xc,%esp
80104e25:	68 e0 41 11 80       	push   $0x801141e0
80104e2a:	e8 43 0c 00 00       	call   80105a72 <release>
80104e2f:	83 c4 10             	add    $0x10,%esp
      return -1;
80104e32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e37:	eb 18                	jmp    80104e51 <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	68 e0 41 11 80       	push   $0x801141e0
80104e41:	ff 75 ec             	push   -0x14(%ebp)
80104e44:	e8 71 07 00 00       	call   801055ba <sleep>
80104e49:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104e4c:	e9 fd fe ff ff       	jmp    80104d4e <wait+0x1e>
  }
}
80104e51:	c9                   	leave
80104e52:	c3                   	ret

80104e53 <clone>:


// Create a kernel-scheduled user thread sharing the caller's address space.
int
clone(void (*fn)(void*), void *arg, void *stack)
{
80104e53:	55                   	push   %ebp
80104e54:	89 e5                	mov    %esp,%ebp
80104e56:	57                   	push   %edi
80104e57:	56                   	push   %esi
80104e58:	53                   	push   %ebx
80104e59:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  uint sp, fake;
  struct proc *np, *curproc = myproc();
80104e5c:	e8 ba f8 ff ff       	call   8010471b <myproc>
80104e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((uint)stack % PGSIZE || (uint)stack + PGSIZE > curproc->sz)
80104e64:	8b 45 10             	mov    0x10(%ebp),%eax
80104e67:	25 ff 0f 00 00       	and    $0xfff,%eax
80104e6c:	85 c0                	test   %eax,%eax
80104e6e:	75 12                	jne    80104e82 <clone+0x2f>
80104e70:	8b 45 10             	mov    0x10(%ebp),%eax
80104e73:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80104e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e7c:	8b 00                	mov    (%eax),%eax
80104e7e:	39 d0                	cmp    %edx,%eax
80104e80:	73 0a                	jae    80104e8c <clone+0x39>
    return -1;
80104e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e87:	e9 aa 01 00 00       	jmp    80105036 <clone+0x1e3>
  if((np = allocproc()) == 0)
80104e8c:	e8 b3 f8 ff ff       	call   80104744 <allocproc>
80104e91:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104e94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104e98:	75 0a                	jne    80104ea4 <clone+0x51>
    return -1;
80104e9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9f:	e9 92 01 00 00       	jmp    80105036 <clone+0x1e3>
  np->pgdir = curproc->pgdir;
80104ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ea7:	8b 50 04             	mov    0x4(%eax),%edx
80104eaa:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ead:	89 50 04             	mov    %edx,0x4(%eax)
  np->sz = curproc->sz;
80104eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb3:	8b 10                	mov    (%eax),%edx
80104eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104eb8:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104eba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104ec0:	89 50 14             	mov    %edx,0x14(%eax)
  np->isthread = 1;
80104ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ec6:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  np->tgid = curproc->tgid;
80104ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ed0:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104ed6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ed9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->ustack = stack;
80104edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ee2:	8b 55 10             	mov    0x10(%ebp),%edx
80104ee5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  np->randstate = curproc->randstate ^ np->pid;
80104eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eee:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104ef4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ef7:	8b 40 10             	mov    0x10(%eax),%eax
80104efa:	31 c2                	xor    %eax,%edx
80104efc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104eff:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  np->randpct = curproc->randpct;
80104f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f08:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f11:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
  *np->tf = *curproc->tf;
80104f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f1a:	8b 48 18             	mov    0x18(%eax),%ecx
80104f1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f20:	8b 40 18             	mov    0x18(%eax),%eax
80104f23:	89 c2                	mov    %eax,%edx
80104f25:	89 cb                	mov    %ecx,%ebx
80104f27:	b8 13 00 00 00       	mov    $0x13,%eax
80104f2c:	89 d7                	mov    %edx,%edi
80104f2e:	89 de                	mov    %ebx,%esi
80104f30:	89 c1                	mov    %eax,%ecx
80104f32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eip = (uint)fn;
80104f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f37:	8b 40 18             	mov    0x18(%eax),%eax
80104f3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f3d:	89 50 38             	mov    %edx,0x38(%eax)
  sp = (uint)stack + PGSIZE;
80104f40:	8b 45 10             	mov    0x10(%ebp),%eax
80104f43:	05 00 10 00 00       	add    $0x1000,%eax
80104f48:	89 45 d8             	mov    %eax,-0x28(%ebp)
  sp -= 4; *(uint*)sp = (uint)arg;
80104f4b:	83 6d d8 04          	subl   $0x4,-0x28(%ebp)
80104f4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104f52:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f55:	89 10                	mov    %edx,(%eax)
  sp -= 4; fake = 0xffffffff; *(uint*)sp = fake;
80104f57:	83 6d d8 04          	subl   $0x4,-0x28(%ebp)
80104f5b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80104f62:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104f65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104f68:	89 10                	mov    %edx,(%eax)
  np->tf->esp = sp;
80104f6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f6d:	8b 40 18             	mov    0x18(%eax),%eax
80104f70:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104f73:	89 50 44             	mov    %edx,0x44(%eax)
  np->tf->eax = 0;
80104f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f79:	8b 40 18             	mov    0x18(%eax),%eax
80104f7c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i=0;i<NOFILE;i++) if(curproc->ofile[i]) np->ofile[i]=filedup(curproc->ofile[i]);
80104f83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104f8a:	eb 3b                	jmp    80104fc7 <clone+0x174>
80104f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f92:	83 c2 08             	add    $0x8,%edx
80104f95:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	74 26                	je     80104fc3 <clone+0x170>
80104f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104fa3:	83 c2 08             	add    $0x8,%edx
80104fa6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104faa:	83 ec 0c             	sub    $0xc,%esp
80104fad:	50                   	push   %eax
80104fae:	e8 de c0 ff ff       	call   80101091 <filedup>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104fb9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104fbc:	83 c1 08             	add    $0x8,%ecx
80104fbf:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
80104fc3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104fc7:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104fcb:	7e bf                	jle    80104f8c <clone+0x139>
  np->cwd=idup(curproc->cwd);
80104fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fd0:	8b 40 68             	mov    0x68(%eax),%eax
80104fd3:	83 ec 0c             	sub    $0xc,%esp
80104fd6:	50                   	push   %eax
80104fd7:	e8 06 ca ff ff       	call   801019e2 <idup>
80104fdc:	83 c4 10             	add    $0x10,%esp
80104fdf:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104fe2:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fe8:	8d 50 6c             	lea    0x6c(%eax),%edx
80104feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104fee:	83 c0 6c             	add    $0x6c,%eax
80104ff1:	83 ec 04             	sub    $0x4,%esp
80104ff4:	6a 10                	push   $0x10
80104ff6:	52                   	push   %edx
80104ff7:	50                   	push   %eax
80104ff8:	e8 90 0e 00 00       	call   80105e8d <safestrcpy>
80104ffd:	83 c4 10             	add    $0x10,%esp
  pid=np->pid;
80105000:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105003:	8b 40 10             	mov    0x10(%eax),%eax
80105006:	89 45 d0             	mov    %eax,-0x30(%ebp)
  acquire(&ptable.lock); np->state=RUNNABLE; release(&ptable.lock);
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	68 e0 41 11 80       	push   $0x801141e0
80105011:	e8 ee 09 00 00       	call   80105a04 <acquire>
80105016:	83 c4 10             	add    $0x10,%esp
80105019:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010501c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105023:	83 ec 0c             	sub    $0xc,%esp
80105026:	68 e0 41 11 80       	push   $0x801141e0
8010502b:	e8 42 0a 00 00       	call   80105a72 <release>
80105030:	83 c4 10             	add    $0x10,%esp
  return pid;
80105033:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
80105036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105039:	5b                   	pop    %ebx
8010503a:	5e                   	pop    %esi
8010503b:	5f                   	pop    %edi
8010503c:	5d                   	pop    %ebp
8010503d:	c3                   	ret

8010503e <thread_exit>:

void
thread_exit(void)
{
8010503e:	55                   	push   %ebp
8010503f:	89 e5                	mov    %esp,%ebp
80105041:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc=myproc();
80105044:	e8 d2 f6 ff ff       	call   8010471b <myproc>
80105049:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int fd;
  if(!curproc->isthread) exit();
8010504c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504f:	8b 40 7c             	mov    0x7c(%eax),%eax
80105052:	85 c0                	test   %eax,%eax
80105054:	75 05                	jne    8010505b <thread_exit+0x1d>
80105056:	e8 b2 fb ff ff       	call   80104c0d <exit>
  for(fd=0;fd<NOFILE;fd++) if(curproc->ofile[fd]){ fileclose(curproc->ofile[fd]); curproc->ofile[fd]=0; }
8010505b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105062:	eb 3f                	jmp    801050a3 <thread_exit+0x65>
80105064:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105067:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010506a:	83 c2 08             	add    $0x8,%edx
8010506d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105071:	85 c0                	test   %eax,%eax
80105073:	74 2a                	je     8010509f <thread_exit+0x61>
80105075:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105078:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010507b:	83 c2 08             	add    $0x8,%edx
8010507e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	50                   	push   %eax
80105086:	e8 57 c0 ff ff       	call   801010e2 <fileclose>
8010508b:	83 c4 10             	add    $0x10,%esp
8010508e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105094:	83 c2 08             	add    $0x8,%edx
80105097:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010509e:	00 
8010509f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050a3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050a7:	7e bb                	jle    80105064 <thread_exit+0x26>
  begin_op(); if(curproc->cwd) iput(curproc->cwd); end_op(); curproc->cwd=0;
801050a9:	e8 0a e9 ff ff       	call   801039b8 <begin_op>
801050ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b1:	8b 40 68             	mov    0x68(%eax),%eax
801050b4:	85 c0                	test   %eax,%eax
801050b6:	74 12                	je     801050ca <thread_exit+0x8c>
801050b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050bb:	8b 40 68             	mov    0x68(%eax),%eax
801050be:	83 ec 0c             	sub    $0xc,%esp
801050c1:	50                   	push   %eax
801050c2:	e8 b6 ca ff ff       	call   80101b7d <iput>
801050c7:	83 c4 10             	add    $0x10,%esp
801050ca:	e8 75 e9 ff ff       	call   80103a44 <end_op>
801050cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	68 e0 41 11 80       	push   $0x801141e0
801050e1:	e8 1e 09 00 00       	call   80105a04 <acquire>
801050e6:	83 c4 10             	add    $0x10,%esp
  wakeup1(curproc->parent);
801050e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ec:	8b 40 14             	mov    0x14(%eax),%eax
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	50                   	push   %eax
801050f3:	e8 69 05 00 00       	call   80105661 <wakeup1>
801050f8:	83 c4 10             	add    $0x10,%esp
  curproc->state=ZOMBIE;
801050fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050fe:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80105105:	e8 77 03 00 00       	call   80105481 <sched>
  panic("thread zombie");
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	68 9b 93 10 80       	push   $0x8010939b
80105112:	e8 9c b4 ff ff       	call   801005b3 <panic>

80105117 <join>:
}

int
join(int wanted, void **stack)
{
80105117:	55                   	push   %ebp
80105118:	89 e5                	mov    %esp,%ebp
8010511a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p, *curproc=myproc(); int have, pid;
8010511d:	e8 f9 f5 ff ff       	call   8010471b <myproc>
80105122:	89 45 ec             	mov    %eax,-0x14(%ebp)
  acquire(&ptable.lock);
80105125:	83 ec 0c             	sub    $0xc,%esp
80105128:	68 e0 41 11 80       	push   $0x801141e0
8010512d:	e8 d2 08 00 00       	call   80105a04 <acquire>
80105132:	83 c4 10             	add    $0x10,%esp
  for(;;){
    have=0;
80105135:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
8010513c:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
80105143:	e9 ee 00 00 00       	jmp    80105236 <join+0x11f>
      if(p->parent!=curproc || !p->isthread || (wanted > 0 && p->pid != wanted)) continue;
80105148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514b:	8b 40 14             	mov    0x14(%eax),%eax
8010514e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80105151:	0f 85 d7 00 00 00    	jne    8010522e <join+0x117>
80105157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515a:	8b 40 7c             	mov    0x7c(%eax),%eax
8010515d:	85 c0                	test   %eax,%eax
8010515f:	0f 84 c9 00 00 00    	je     8010522e <join+0x117>
80105165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105169:	7e 0f                	jle    8010517a <join+0x63>
8010516b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516e:	8b 40 10             	mov    0x10(%eax),%eax
80105171:	39 45 08             	cmp    %eax,0x8(%ebp)
80105174:	0f 85 b4 00 00 00    	jne    8010522e <join+0x117>
      have=1;
8010517a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state==ZOMBIE){
80105181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105184:	8b 40 0c             	mov    0xc(%eax),%eax
80105187:	83 f8 05             	cmp    $0x5,%eax
8010518a:	0f 85 9f 00 00 00    	jne    8010522f <join+0x118>
        pid=p->pid; if(stack) *stack=p->ustack;
80105190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105193:	8b 40 10             	mov    0x10(%eax),%eax
80105196:	89 45 e8             	mov    %eax,-0x18(%ebp)
80105199:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010519d:	74 0e                	je     801051ad <join+0x96>
8010519f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801051a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ab:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack); p->kstack=0; p->pid=0; p->parent=0; p->pgdir=0;
801051ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b0:	8b 40 08             	mov    0x8(%eax),%eax
801051b3:	83 ec 0c             	sub    $0xc,%esp
801051b6:	50                   	push   %eax
801051b7:	e8 40 da ff ff       	call   80102bfc <kfree>
801051bc:	83 c4 10             	add    $0x10,%esp
801051bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801051c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cc:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
801051d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
801051dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->name[0]=0; p->killed=0; p->isthread=0; p->ustack=0; p->state=UNUSED;
801051e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ea:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
801051ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f1:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
801051f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fb:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
80105202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105205:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010520c:	00 00 00 
8010520f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock); return pid;
80105219:	83 ec 0c             	sub    $0xc,%esp
8010521c:	68 e0 41 11 80       	push   $0x801141e0
80105221:	e8 4c 08 00 00       	call   80105a72 <release>
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010522c:	eb 54                	jmp    80105282 <join+0x16b>
      if(p->parent!=curproc || !p->isthread || (wanted > 0 && p->pid != wanted)) continue;
8010522e:	90                   	nop
    for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
8010522f:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105236:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
8010523d:	0f 82 05 ff ff ff    	jb     80105148 <join+0x31>
      }
    }
    if(!have || curproc->killed){ release(&ptable.lock); return -1; }
80105243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105247:	74 0a                	je     80105253 <join+0x13c>
80105249:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010524c:	8b 40 24             	mov    0x24(%eax),%eax
8010524f:	85 c0                	test   %eax,%eax
80105251:	74 17                	je     8010526a <join+0x153>
80105253:	83 ec 0c             	sub    $0xc,%esp
80105256:	68 e0 41 11 80       	push   $0x801141e0
8010525b:	e8 12 08 00 00       	call   80105a72 <release>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105268:	eb 18                	jmp    80105282 <join+0x16b>
    sleep(curproc,&ptable.lock);
8010526a:	83 ec 08             	sub    $0x8,%esp
8010526d:	68 e0 41 11 80       	push   $0x801141e0
80105272:	ff 75 ec             	push   -0x14(%ebp)
80105275:	e8 40 03 00 00       	call   801055ba <sleep>
8010527a:	83 c4 10             	add    $0x10,%esp
    have=0;
8010527d:	e9 b3 fe ff ff       	jmp    80105135 <join+0x1e>
  }
}
80105282:	c9                   	leave
80105283:	c3                   	ret

80105284 <random_config>:

void
random_config(uint seed, int pct)
{
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	83 ec 18             	sub    $0x18,%esp
  struct proc *p, *cur=myproc();
8010528a:	e8 8c f4 ff ff       	call   8010471b <myproc>
8010528f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pct < 0) pct = 0;
80105292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105296:	79 07                	jns    8010529f <random_config+0x1b>
80105298:	c7 45 0c 00 00 00 00 	movl   $0x0,0xc(%ebp)
  if(pct > 100) pct = 100;
8010529f:	83 7d 0c 64          	cmpl   $0x64,0xc(%ebp)
801052a3:	7e 07                	jle    801052ac <random_config+0x28>
801052a5:	c7 45 0c 64 00 00 00 	movl   $0x64,0xc(%ebp)
  if(seed == 0) seed = 1;
801052ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801052b0:	75 07                	jne    801052b9 <random_config+0x35>
801052b2:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
  acquire(&ptable.lock);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	68 e0 41 11 80       	push   $0x801141e0
801052c1:	e8 3e 07 00 00       	call   80105a04 <acquire>
801052c6:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++) if(p->tgid==cur->tgid){ p->randstate=seed ^ p->pid; p->randpct=pct; }
801052c9:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
801052d0:	eb 3d                	jmp    8010530f <random_config+0x8b>
801052d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801052db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052de:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801052e4:	39 c2                	cmp    %eax,%edx
801052e6:	75 20                	jne    80105308 <random_config+0x84>
801052e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052eb:	8b 40 10             	mov    0x10(%eax),%eax
801052ee:	33 45 08             	xor    0x8(%ebp),%eax
801052f1:	89 c2                	mov    %eax,%edx
801052f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f6:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
801052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105302:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
80105308:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010530f:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
80105316:	72 ba                	jb     801052d2 <random_config+0x4e>
  release(&ptable.lock);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	68 e0 41 11 80       	push   $0x801141e0
80105320:	e8 4d 07 00 00       	call   80105a72 <release>
80105325:	83 c4 10             	add    $0x10,%esp
}
80105328:	90                   	nop
80105329:	c9                   	leave
8010532a:	c3                   	ret

8010532b <random_should_yield>:

int
random_should_yield(void)
{
8010532b:	55                   	push   %ebp
8010532c:	89 e5                	mov    %esp,%ebp
8010532e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p=myproc(); uint x;
80105331:	e8 e5 f3 ff ff       	call   8010471b <myproc>
80105336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!p || p->randpct<=0) return 0;
80105339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010533d:	74 0d                	je     8010534c <random_should_yield+0x21>
8010533f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105342:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80105348:	85 c0                	test   %eax,%eax
8010534a:	7f 07                	jg     80105353 <random_should_yield+0x28>
8010534c:	b8 00 00 00 00       	mov    $0x0,%eax
80105351:	eb 71                	jmp    801053c4 <random_should_yield+0x99>
  x=p->randstate; x^=x<<13; x^=x>>17; x^=x<<5; p->randstate=x?x:1;
80105353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105356:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010535c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010535f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105362:	c1 e0 0d             	shl    $0xd,%eax
80105365:	31 45 f0             	xor    %eax,-0x10(%ebp)
80105368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536b:	c1 e8 11             	shr    $0x11,%eax
8010536e:	31 45 f0             	xor    %eax,-0x10(%ebp)
80105371:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105374:	c1 e0 05             	shl    $0x5,%eax
80105377:	31 45 f0             	xor    %eax,-0x10(%ebp)
8010537a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010537e:	74 05                	je     80105385 <random_should_yield+0x5a>
80105380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105383:	eb 05                	jmp    8010538a <random_should_yield+0x5f>
80105385:	b8 01 00 00 00       	mov    $0x1,%eax
8010538a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010538d:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  return (int)(p->randstate%100) < p->randpct;
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
8010539c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801053a1:	89 c8                	mov    %ecx,%eax
801053a3:	f7 e2                	mul    %edx
801053a5:	89 d0                	mov    %edx,%eax
801053a7:	c1 e8 05             	shr    $0x5,%eax
801053aa:	6b d0 64             	imul   $0x64,%eax,%edx
801053ad:	89 c8                	mov    %ecx,%eax
801053af:	29 d0                	sub    %edx,%eax
801053b1:	89 c2                	mov    %eax,%edx
801053b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801053bc:	39 c2                	cmp    %eax,%edx
801053be:	0f 9c c0             	setl   %al
801053c1:	0f b6 c0             	movzbl %al,%eax
}
801053c4:	c9                   	leave
801053c5:	c3                   	ret

801053c6 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801053c6:	55                   	push   %ebp
801053c7:	89 e5                	mov    %esp,%ebp
801053c9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801053cc:	e8 d2 f2 ff ff       	call   801046a3 <mycpu>
801053d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801053d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801053de:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801053e1:	e8 7d f2 ff ff       	call   80104663 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801053e6:	83 ec 0c             	sub    $0xc,%esp
801053e9:	68 e0 41 11 80       	push   $0x801141e0
801053ee:	e8 11 06 00 00       	call   80105a04 <acquire>
801053f3:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053f6:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
801053fd:	eb 64                	jmp    80105463 <scheduler+0x9d>
      if(p->state != RUNNABLE)
801053ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105402:	8b 40 0c             	mov    0xc(%eax),%eax
80105405:	83 f8 03             	cmp    $0x3,%eax
80105408:	75 51                	jne    8010545b <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
8010540a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010540d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105410:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80105416:	83 ec 0c             	sub    $0xc,%esp
80105419:	ff 75 f4             	push   -0xc(%ebp)
8010541c:	e8 5a 34 00 00       	call   8010887b <switchuvm>
80105421:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80105424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105427:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
8010542e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105431:	8b 40 1c             	mov    0x1c(%eax),%eax
80105434:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105437:	83 c2 04             	add    $0x4,%edx
8010543a:	83 ec 08             	sub    $0x8,%esp
8010543d:	50                   	push   %eax
8010543e:	52                   	push   %edx
8010543f:	e8 bb 0a 00 00       	call   80105eff <swtch>
80105444:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80105447:	e8 16 34 00 00       	call   80108862 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010544c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010544f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105456:	00 00 00 
80105459:	eb 01                	jmp    8010545c <scheduler+0x96>
        continue;
8010545b:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010545c:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105463:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
8010546a:	72 93                	jb     801053ff <scheduler+0x39>
    }
    release(&ptable.lock);
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	68 e0 41 11 80       	push   $0x801141e0
80105474:	e8 f9 05 00 00       	call   80105a72 <release>
80105479:	83 c4 10             	add    $0x10,%esp
    sti();
8010547c:	e9 60 ff ff ff       	jmp    801053e1 <scheduler+0x1b>

80105481 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80105481:	55                   	push   %ebp
80105482:	89 e5                	mov    %esp,%ebp
80105484:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80105487:	e8 8f f2 ff ff       	call   8010471b <myproc>
8010548c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	68 e0 41 11 80       	push   $0x801141e0
80105497:	e8 a3 06 00 00       	call   80105b3f <holding>
8010549c:	83 c4 10             	add    $0x10,%esp
8010549f:	85 c0                	test   %eax,%eax
801054a1:	75 0d                	jne    801054b0 <sched+0x2f>
    panic("sched ptable.lock");
801054a3:	83 ec 0c             	sub    $0xc,%esp
801054a6:	68 a9 93 10 80       	push   $0x801093a9
801054ab:	e8 03 b1 ff ff       	call   801005b3 <panic>
  if(mycpu()->ncli != 1)
801054b0:	e8 ee f1 ff ff       	call   801046a3 <mycpu>
801054b5:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801054bb:	83 f8 01             	cmp    $0x1,%eax
801054be:	74 0d                	je     801054cd <sched+0x4c>
    panic("sched locks");
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	68 bb 93 10 80       	push   $0x801093bb
801054c8:	e8 e6 b0 ff ff       	call   801005b3 <panic>
  if(p->state == RUNNING)
801054cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d0:	8b 40 0c             	mov    0xc(%eax),%eax
801054d3:	83 f8 04             	cmp    $0x4,%eax
801054d6:	75 0d                	jne    801054e5 <sched+0x64>
    panic("sched running");
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	68 c7 93 10 80       	push   $0x801093c7
801054e0:	e8 ce b0 ff ff       	call   801005b3 <panic>
  if(readeflags()&FL_IF)
801054e5:	e8 69 f1 ff ff       	call   80104653 <readeflags>
801054ea:	25 00 02 00 00       	and    $0x200,%eax
801054ef:	85 c0                	test   %eax,%eax
801054f1:	74 0d                	je     80105500 <sched+0x7f>
    panic("sched interruptible");
801054f3:	83 ec 0c             	sub    $0xc,%esp
801054f6:	68 d5 93 10 80       	push   $0x801093d5
801054fb:	e8 b3 b0 ff ff       	call   801005b3 <panic>
  intena = mycpu()->intena;
80105500:	e8 9e f1 ff ff       	call   801046a3 <mycpu>
80105505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010550b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
8010550e:	e8 90 f1 ff ff       	call   801046a3 <mycpu>
80105513:	8b 40 04             	mov    0x4(%eax),%eax
80105516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105519:	83 c2 1c             	add    $0x1c,%edx
8010551c:	83 ec 08             	sub    $0x8,%esp
8010551f:	50                   	push   %eax
80105520:	52                   	push   %edx
80105521:	e8 d9 09 00 00       	call   80105eff <swtch>
80105526:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105529:	e8 75 f1 ff ff       	call   801046a3 <mycpu>
8010552e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105531:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80105537:	90                   	nop
80105538:	c9                   	leave
80105539:	c3                   	ret

8010553a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010553a:	55                   	push   %ebp
8010553b:	89 e5                	mov    %esp,%ebp
8010553d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	68 e0 41 11 80       	push   $0x801141e0
80105548:	e8 b7 04 00 00       	call   80105a04 <acquire>
8010554d:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80105550:	e8 c6 f1 ff ff       	call   8010471b <myproc>
80105555:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010555c:	e8 20 ff ff ff       	call   80105481 <sched>
  release(&ptable.lock);
80105561:	83 ec 0c             	sub    $0xc,%esp
80105564:	68 e0 41 11 80       	push   $0x801141e0
80105569:	e8 04 05 00 00       	call   80105a72 <release>
8010556e:	83 c4 10             	add    $0x10,%esp
}
80105571:	90                   	nop
80105572:	c9                   	leave
80105573:	c3                   	ret

80105574 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	68 e0 41 11 80       	push   $0x801141e0
80105582:	e8 eb 04 00 00       	call   80105a72 <release>
80105587:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010558a:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010558f:	85 c0                	test   %eax,%eax
80105591:	74 24                	je     801055b7 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80105593:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
8010559a:	00 00 00 
    iinit(ROOTDEV);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	6a 01                	push   $0x1
801055a2:	e8 04 c1 ff ff       	call   801016ab <iinit>
801055a7:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	6a 01                	push   $0x1
801055af:	e8 e5 e1 ff ff       	call   80103799 <initlog>
801055b4:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801055b7:	90                   	nop
801055b8:	c9                   	leave
801055b9:	c3                   	ret

801055ba <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801055ba:	55                   	push   %ebp
801055bb:	89 e5                	mov    %esp,%ebp
801055bd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801055c0:	e8 56 f1 ff ff       	call   8010471b <myproc>
801055c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801055c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055cc:	75 0d                	jne    801055db <sleep+0x21>
    panic("sleep");
801055ce:	83 ec 0c             	sub    $0xc,%esp
801055d1:	68 e9 93 10 80       	push   $0x801093e9
801055d6:	e8 d8 af ff ff       	call   801005b3 <panic>

  if(lk == 0)
801055db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055df:	75 0d                	jne    801055ee <sleep+0x34>
    panic("sleep without lk");
801055e1:	83 ec 0c             	sub    $0xc,%esp
801055e4:	68 ef 93 10 80       	push   $0x801093ef
801055e9:	e8 c5 af ff ff       	call   801005b3 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801055ee:	81 7d 0c e0 41 11 80 	cmpl   $0x801141e0,0xc(%ebp)
801055f5:	74 1e                	je     80105615 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	68 e0 41 11 80       	push   $0x801141e0
801055ff:	e8 00 04 00 00       	call   80105a04 <acquire>
80105604:	83 c4 10             	add    $0x10,%esp
    release(lk);
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	ff 75 0c             	push   0xc(%ebp)
8010560d:	e8 60 04 00 00       	call   80105a72 <release>
80105612:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80105615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105618:	8b 55 08             	mov    0x8(%ebp),%edx
8010561b:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
8010561e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105621:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80105628:	e8 54 fe ff ff       	call   80105481 <sched>

  // Tidy up.
  p->chan = 0;
8010562d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105630:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80105637:	81 7d 0c e0 41 11 80 	cmpl   $0x801141e0,0xc(%ebp)
8010563e:	74 1e                	je     8010565e <sleep+0xa4>
    release(&ptable.lock);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 e0 41 11 80       	push   $0x801141e0
80105648:	e8 25 04 00 00       	call   80105a72 <release>
8010564d:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	ff 75 0c             	push   0xc(%ebp)
80105656:	e8 a9 03 00 00       	call   80105a04 <acquire>
8010565b:	83 c4 10             	add    $0x10,%esp
  }
}
8010565e:	90                   	nop
8010565f:	c9                   	leave
80105660:	c3                   	ret

80105661 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80105661:	55                   	push   %ebp
80105662:	89 e5                	mov    %esp,%ebp
80105664:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105667:	c7 45 fc 14 42 11 80 	movl   $0x80114214,-0x4(%ebp)
8010566e:	eb 27                	jmp    80105697 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80105670:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105673:	8b 40 0c             	mov    0xc(%eax),%eax
80105676:	83 f8 02             	cmp    $0x2,%eax
80105679:	75 15                	jne    80105690 <wakeup1+0x2f>
8010567b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010567e:	8b 40 20             	mov    0x20(%eax),%eax
80105681:	39 45 08             	cmp    %eax,0x8(%ebp)
80105684:	75 0a                	jne    80105690 <wakeup1+0x2f>
      p->state = RUNNABLE;
80105686:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105689:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105690:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
80105697:	81 7d fc 14 66 11 80 	cmpl   $0x80116614,-0x4(%ebp)
8010569e:	72 d0                	jb     80105670 <wakeup1+0xf>
}
801056a0:	90                   	nop
801056a1:	90                   	nop
801056a2:	c9                   	leave
801056a3:	c3                   	ret

801056a4 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	68 e0 41 11 80       	push   $0x801141e0
801056b2:	e8 4d 03 00 00       	call   80105a04 <acquire>
801056b7:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	ff 75 08             	push   0x8(%ebp)
801056c0:	e8 9c ff ff ff       	call   80105661 <wakeup1>
801056c5:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801056c8:	83 ec 0c             	sub    $0xc,%esp
801056cb:	68 e0 41 11 80       	push   $0x801141e0
801056d0:	e8 9d 03 00 00       	call   80105a72 <release>
801056d5:	83 c4 10             	add    $0x10,%esp
}
801056d8:	90                   	nop
801056d9:	c9                   	leave
801056da:	c3                   	ret

801056db <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801056db:	55                   	push   %ebp
801056dc:	89 e5                	mov    %esp,%ebp
801056de:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801056e1:	83 ec 0c             	sub    $0xc,%esp
801056e4:	68 e0 41 11 80       	push   $0x801141e0
801056e9:	e8 16 03 00 00       	call   80105a04 <acquire>
801056ee:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801056f1:	c7 45 f4 14 42 11 80 	movl   $0x80114214,-0xc(%ebp)
801056f8:	eb 48                	jmp    80105742 <kill+0x67>
    if(p->pid == pid){
801056fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fd:	8b 40 10             	mov    0x10(%eax),%eax
80105700:	39 45 08             	cmp    %eax,0x8(%ebp)
80105703:	75 36                	jne    8010573b <kill+0x60>
      p->killed = 1;
80105705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105708:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105712:	8b 40 0c             	mov    0xc(%eax),%eax
80105715:	83 f8 02             	cmp    $0x2,%eax
80105718:	75 0a                	jne    80105724 <kill+0x49>
        p->state = RUNNABLE;
8010571a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	68 e0 41 11 80       	push   $0x801141e0
8010572c:	e8 41 03 00 00       	call   80105a72 <release>
80105731:	83 c4 10             	add    $0x10,%esp
      return 0;
80105734:	b8 00 00 00 00       	mov    $0x0,%eax
80105739:	eb 25                	jmp    80105760 <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010573b:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105742:	81 7d f4 14 66 11 80 	cmpl   $0x80116614,-0xc(%ebp)
80105749:	72 af                	jb     801056fa <kill+0x1f>
    }
  }
  release(&ptable.lock);
8010574b:	83 ec 0c             	sub    $0xc,%esp
8010574e:	68 e0 41 11 80       	push   $0x801141e0
80105753:	e8 1a 03 00 00       	call   80105a72 <release>
80105758:	83 c4 10             	add    $0x10,%esp
  return -1;
8010575b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105760:	c9                   	leave
80105761:	c3                   	ret

80105762 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105762:	55                   	push   %ebp
80105763:	89 e5                	mov    %esp,%ebp
80105765:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105768:	c7 45 f0 14 42 11 80 	movl   $0x80114214,-0x10(%ebp)
8010576f:	e9 da 00 00 00       	jmp    8010584e <procdump+0xec>
    if(p->state == UNUSED)
80105774:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105777:	8b 40 0c             	mov    0xc(%eax),%eax
8010577a:	85 c0                	test   %eax,%eax
8010577c:	0f 84 c4 00 00 00    	je     80105846 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105785:	8b 40 0c             	mov    0xc(%eax),%eax
80105788:	83 f8 05             	cmp    $0x5,%eax
8010578b:	77 23                	ja     801057b0 <procdump+0x4e>
8010578d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105790:	8b 40 0c             	mov    0xc(%eax),%eax
80105793:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010579a:	85 c0                	test   %eax,%eax
8010579c:	74 12                	je     801057b0 <procdump+0x4e>
      state = states[p->state];
8010579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a1:	8b 40 0c             	mov    0xc(%eax),%eax
801057a4:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801057ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
801057ae:	eb 07                	jmp    801057b7 <procdump+0x55>
    else
      state = "???";
801057b0:	c7 45 ec 00 94 10 80 	movl   $0x80109400,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801057b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ba:	8d 50 6c             	lea    0x6c(%eax),%edx
801057bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c0:	8b 40 10             	mov    0x10(%eax),%eax
801057c3:	52                   	push   %edx
801057c4:	ff 75 ec             	push   -0x14(%ebp)
801057c7:	50                   	push   %eax
801057c8:	68 04 94 10 80       	push   $0x80109404
801057cd:	e8 2c ac ff ff       	call   801003fe <cprintf>
801057d2:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d8:	8b 40 0c             	mov    0xc(%eax),%eax
801057db:	83 f8 02             	cmp    $0x2,%eax
801057de:	75 54                	jne    80105834 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801057e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e3:	8b 40 1c             	mov    0x1c(%eax),%eax
801057e6:	8b 40 0c             	mov    0xc(%eax),%eax
801057e9:	83 c0 08             	add    $0x8,%eax
801057ec:	89 c2                	mov    %eax,%edx
801057ee:	83 ec 08             	sub    $0x8,%esp
801057f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057f4:	50                   	push   %eax
801057f5:	52                   	push   %edx
801057f6:	e8 c9 02 00 00       	call   80105ac4 <getcallerpcs>
801057fb:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801057fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105805:	eb 1c                	jmp    80105823 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010580e:	83 ec 08             	sub    $0x8,%esp
80105811:	50                   	push   %eax
80105812:	68 0d 94 10 80       	push   $0x8010940d
80105817:	e8 e2 ab ff ff       	call   801003fe <cprintf>
8010581c:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010581f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105823:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105827:	7f 0b                	jg     80105834 <procdump+0xd2>
80105829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105830:	85 c0                	test   %eax,%eax
80105832:	75 d3                	jne    80105807 <procdump+0xa5>
    }
    cprintf("\n");
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	68 11 94 10 80       	push   $0x80109411
8010583c:	e8 bd ab ff ff       	call   801003fe <cprintf>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	eb 01                	jmp    80105847 <procdump+0xe5>
      continue;
80105846:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105847:	81 45 f0 90 00 00 00 	addl   $0x90,-0x10(%ebp)
8010584e:	81 7d f0 14 66 11 80 	cmpl   $0x80116614,-0x10(%ebp)
80105855:	0f 82 19 ff ff ff    	jb     80105774 <procdump+0x12>
  }
}
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	c9                   	leave
8010585e:	c3                   	ret

8010585f <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010585f:	55                   	push   %ebp
80105860:	89 e5                	mov    %esp,%ebp
80105862:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80105865:	8b 45 08             	mov    0x8(%ebp),%eax
80105868:	83 c0 04             	add    $0x4,%eax
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	68 3d 94 10 80       	push   $0x8010943d
80105873:	50                   	push   %eax
80105874:	e8 69 01 00 00       	call   801059e2 <initlock>
80105879:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010587c:	8b 45 08             	mov    0x8(%ebp),%eax
8010587f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105882:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105885:	8b 45 08             	mov    0x8(%ebp),%eax
80105888:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010588e:	8b 45 08             	mov    0x8(%ebp),%eax
80105891:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105898:	90                   	nop
80105899:	c9                   	leave
8010589a:	c3                   	ret

8010589b <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010589b:	55                   	push   %ebp
8010589c:	89 e5                	mov    %esp,%ebp
8010589e:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801058a1:	8b 45 08             	mov    0x8(%ebp),%eax
801058a4:	83 c0 04             	add    $0x4,%eax
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	50                   	push   %eax
801058ab:	e8 54 01 00 00       	call   80105a04 <acquire>
801058b0:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801058b3:	eb 15                	jmp    801058ca <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
801058b5:	8b 45 08             	mov    0x8(%ebp),%eax
801058b8:	83 c0 04             	add    $0x4,%eax
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	50                   	push   %eax
801058bf:	ff 75 08             	push   0x8(%ebp)
801058c2:	e8 f3 fc ff ff       	call   801055ba <sleep>
801058c7:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801058ca:	8b 45 08             	mov    0x8(%ebp),%eax
801058cd:	8b 00                	mov    (%eax),%eax
801058cf:	85 c0                	test   %eax,%eax
801058d1:	75 e2                	jne    801058b5 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801058d3:	8b 45 08             	mov    0x8(%ebp),%eax
801058d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801058dc:	e8 3a ee ff ff       	call   8010471b <myproc>
801058e1:	8b 50 10             	mov    0x10(%eax),%edx
801058e4:	8b 45 08             	mov    0x8(%ebp),%eax
801058e7:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801058ea:	8b 45 08             	mov    0x8(%ebp),%eax
801058ed:	83 c0 04             	add    $0x4,%eax
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	50                   	push   %eax
801058f4:	e8 79 01 00 00       	call   80105a72 <release>
801058f9:	83 c4 10             	add    $0x10,%esp
}
801058fc:	90                   	nop
801058fd:	c9                   	leave
801058fe:	c3                   	ret

801058ff <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801058ff:	55                   	push   %ebp
80105900:	89 e5                	mov    %esp,%ebp
80105902:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105905:	8b 45 08             	mov    0x8(%ebp),%eax
80105908:	83 c0 04             	add    $0x4,%eax
8010590b:	83 ec 0c             	sub    $0xc,%esp
8010590e:	50                   	push   %eax
8010590f:	e8 f0 00 00 00       	call   80105a04 <acquire>
80105914:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80105917:	8b 45 08             	mov    0x8(%ebp),%eax
8010591a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105920:	8b 45 08             	mov    0x8(%ebp),%eax
80105923:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010592a:	83 ec 0c             	sub    $0xc,%esp
8010592d:	ff 75 08             	push   0x8(%ebp)
80105930:	e8 6f fd ff ff       	call   801056a4 <wakeup>
80105935:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80105938:	8b 45 08             	mov    0x8(%ebp),%eax
8010593b:	83 c0 04             	add    $0x4,%eax
8010593e:	83 ec 0c             	sub    $0xc,%esp
80105941:	50                   	push   %eax
80105942:	e8 2b 01 00 00       	call   80105a72 <release>
80105947:	83 c4 10             	add    $0x10,%esp
}
8010594a:	90                   	nop
8010594b:	c9                   	leave
8010594c:	c3                   	ret

8010594d <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010594d:	55                   	push   %ebp
8010594e:	89 e5                	mov    %esp,%ebp
80105950:	53                   	push   %ebx
80105951:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
80105954:	8b 45 08             	mov    0x8(%ebp),%eax
80105957:	83 c0 04             	add    $0x4,%eax
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	50                   	push   %eax
8010595e:	e8 a1 00 00 00       	call   80105a04 <acquire>
80105963:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
80105966:	8b 45 08             	mov    0x8(%ebp),%eax
80105969:	8b 00                	mov    (%eax),%eax
8010596b:	85 c0                	test   %eax,%eax
8010596d:	74 19                	je     80105988 <holdingsleep+0x3b>
8010596f:	8b 45 08             	mov    0x8(%ebp),%eax
80105972:	8b 58 3c             	mov    0x3c(%eax),%ebx
80105975:	e8 a1 ed ff ff       	call   8010471b <myproc>
8010597a:	8b 40 10             	mov    0x10(%eax),%eax
8010597d:	39 c3                	cmp    %eax,%ebx
8010597f:	75 07                	jne    80105988 <holdingsleep+0x3b>
80105981:	b8 01 00 00 00       	mov    $0x1,%eax
80105986:	eb 05                	jmp    8010598d <holdingsleep+0x40>
80105988:	b8 00 00 00 00       	mov    $0x0,%eax
8010598d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105990:	8b 45 08             	mov    0x8(%ebp),%eax
80105993:	83 c0 04             	add    $0x4,%eax
80105996:	83 ec 0c             	sub    $0xc,%esp
80105999:	50                   	push   %eax
8010599a:	e8 d3 00 00 00       	call   80105a72 <release>
8010599f:	83 c4 10             	add    $0x10,%esp
  return r;
801059a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801059a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a8:	c9                   	leave
801059a9:	c3                   	ret

801059aa <readeflags>:
{
801059aa:	55                   	push   %ebp
801059ab:	89 e5                	mov    %esp,%ebp
801059ad:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801059b0:	9c                   	pushf
801059b1:	58                   	pop    %eax
801059b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801059b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059b8:	c9                   	leave
801059b9:	c3                   	ret

801059ba <cli>:
{
801059ba:	55                   	push   %ebp
801059bb:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801059bd:	fa                   	cli
}
801059be:	90                   	nop
801059bf:	5d                   	pop    %ebp
801059c0:	c3                   	ret

801059c1 <sti>:
{
801059c1:	55                   	push   %ebp
801059c2:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801059c4:	fb                   	sti
}
801059c5:	90                   	nop
801059c6:	5d                   	pop    %ebp
801059c7:	c3                   	ret

801059c8 <xchg>:
{
801059c8:	55                   	push   %ebp
801059c9:	89 e5                	mov    %esp,%ebp
801059cb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801059ce:	8b 55 08             	mov    0x8(%ebp),%edx
801059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801059d7:	f0 87 02             	lock xchg %eax,(%edx)
801059da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801059dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059e0:	c9                   	leave
801059e1:	c3                   	ret

801059e2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801059e2:	55                   	push   %ebp
801059e3:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801059e5:	8b 45 08             	mov    0x8(%ebp),%eax
801059e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801059eb:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801059ee:	8b 45 08             	mov    0x8(%ebp),%eax
801059f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801059f7:	8b 45 08             	mov    0x8(%ebp),%eax
801059fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105a01:	90                   	nop
80105a02:	5d                   	pop    %ebp
80105a03:	c3                   	ret

80105a04 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	53                   	push   %ebx
80105a08:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105a0b:	e8 6f 01 00 00       	call   80105b7f <pushcli>
  if(holding(lk))
80105a10:	8b 45 08             	mov    0x8(%ebp),%eax
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	50                   	push   %eax
80105a17:	e8 23 01 00 00       	call   80105b3f <holding>
80105a1c:	83 c4 10             	add    $0x10,%esp
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	74 0d                	je     80105a30 <acquire+0x2c>
    panic("acquire");
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	68 48 94 10 80       	push   $0x80109448
80105a2b:	e8 83 ab ff ff       	call   801005b3 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105a30:	90                   	nop
80105a31:	8b 45 08             	mov    0x8(%ebp),%eax
80105a34:	83 ec 08             	sub    $0x8,%esp
80105a37:	6a 01                	push   $0x1
80105a39:	50                   	push   %eax
80105a3a:	e8 89 ff ff ff       	call   801059c8 <xchg>
80105a3f:	83 c4 10             	add    $0x10,%esp
80105a42:	85 c0                	test   %eax,%eax
80105a44:	75 eb                	jne    80105a31 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80105a46:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105a4e:	e8 50 ec ff ff       	call   801046a3 <mycpu>
80105a53:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105a56:	8b 45 08             	mov    0x8(%ebp),%eax
80105a59:	83 c0 0c             	add    $0xc,%eax
80105a5c:	83 ec 08             	sub    $0x8,%esp
80105a5f:	50                   	push   %eax
80105a60:	8d 45 08             	lea    0x8(%ebp),%eax
80105a63:	50                   	push   %eax
80105a64:	e8 5b 00 00 00       	call   80105ac4 <getcallerpcs>
80105a69:	83 c4 10             	add    $0x10,%esp
}
80105a6c:	90                   	nop
80105a6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a70:	c9                   	leave
80105a71:	c3                   	ret

80105a72 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105a72:	55                   	push   %ebp
80105a73:	89 e5                	mov    %esp,%ebp
80105a75:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 08             	push   0x8(%ebp)
80105a7e:	e8 bc 00 00 00       	call   80105b3f <holding>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	75 0d                	jne    80105a97 <release+0x25>
    panic("release");
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	68 50 94 10 80       	push   $0x80109450
80105a92:	e8 1c ab ff ff       	call   801005b3 <panic>

  lk->pcs[0] = 0;
80105a97:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105aab:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80105ab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105abc:	e8 0b 01 00 00       	call   80105bcc <popcli>
}
80105ac1:	90                   	nop
80105ac2:	c9                   	leave
80105ac3:	c3                   	ret

80105ac4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105aca:	8b 45 08             	mov    0x8(%ebp),%eax
80105acd:	83 e8 08             	sub    $0x8,%eax
80105ad0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105ad3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105ada:	eb 38                	jmp    80105b14 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105adc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105ae0:	74 53                	je     80105b35 <getcallerpcs+0x71>
80105ae2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105ae9:	76 4a                	jbe    80105b35 <getcallerpcs+0x71>
80105aeb:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105aef:	74 44                	je     80105b35 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105af1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105af4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105afb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105afe:	01 c2                	add    %eax,%edx
80105b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b03:	8b 40 04             	mov    0x4(%eax),%eax
80105b06:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b0b:	8b 00                	mov    (%eax),%eax
80105b0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105b10:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105b14:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105b18:	7e c2                	jle    80105adc <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105b1a:	eb 19                	jmp    80105b35 <getcallerpcs+0x71>
    pcs[i] = 0;
80105b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105b26:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b29:	01 d0                	add    %edx,%eax
80105b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105b31:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105b35:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105b39:	7e e1                	jle    80105b1c <getcallerpcs+0x58>
}
80105b3b:	90                   	nop
80105b3c:	90                   	nop
80105b3d:	c9                   	leave
80105b3e:	c3                   	ret

80105b3f <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105b3f:	55                   	push   %ebp
80105b40:	89 e5                	mov    %esp,%ebp
80105b42:	53                   	push   %ebx
80105b43:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
80105b46:	e8 34 00 00 00       	call   80105b7f <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80105b4e:	8b 00                	mov    (%eax),%eax
80105b50:	85 c0                	test   %eax,%eax
80105b52:	74 16                	je     80105b6a <holding+0x2b>
80105b54:	8b 45 08             	mov    0x8(%ebp),%eax
80105b57:	8b 58 08             	mov    0x8(%eax),%ebx
80105b5a:	e8 44 eb ff ff       	call   801046a3 <mycpu>
80105b5f:	39 c3                	cmp    %eax,%ebx
80105b61:	75 07                	jne    80105b6a <holding+0x2b>
80105b63:	b8 01 00 00 00       	mov    $0x1,%eax
80105b68:	eb 05                	jmp    80105b6f <holding+0x30>
80105b6a:	b8 00 00 00 00       	mov    $0x0,%eax
80105b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80105b72:	e8 55 00 00 00       	call   80105bcc <popcli>
  return r;
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b7d:	c9                   	leave
80105b7e:	c3                   	ret

80105b7f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105b7f:	55                   	push   %ebp
80105b80:	89 e5                	mov    %esp,%ebp
80105b82:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105b85:	e8 20 fe ff ff       	call   801059aa <readeflags>
80105b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105b8d:	e8 28 fe ff ff       	call   801059ba <cli>
  if(mycpu()->ncli == 0)
80105b92:	e8 0c eb ff ff       	call   801046a3 <mycpu>
80105b97:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	75 14                	jne    80105bb5 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80105ba1:	e8 fd ea ff ff       	call   801046a3 <mycpu>
80105ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ba9:	81 e2 00 02 00 00    	and    $0x200,%edx
80105baf:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105bb5:	e8 e9 ea ff ff       	call   801046a3 <mycpu>
80105bba:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105bc0:	83 c2 01             	add    $0x1,%edx
80105bc3:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105bc9:	90                   	nop
80105bca:	c9                   	leave
80105bcb:	c3                   	ret

80105bcc <popcli>:

void
popcli(void)
{
80105bcc:	55                   	push   %ebp
80105bcd:	89 e5                	mov    %esp,%ebp
80105bcf:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105bd2:	e8 d3 fd ff ff       	call   801059aa <readeflags>
80105bd7:	25 00 02 00 00       	and    $0x200,%eax
80105bdc:	85 c0                	test   %eax,%eax
80105bde:	74 0d                	je     80105bed <popcli+0x21>
    panic("popcli - interruptible");
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	68 58 94 10 80       	push   $0x80109458
80105be8:	e8 c6 a9 ff ff       	call   801005b3 <panic>
  if(--mycpu()->ncli < 0)
80105bed:	e8 b1 ea ff ff       	call   801046a3 <mycpu>
80105bf2:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105bf8:	83 ea 01             	sub    $0x1,%edx
80105bfb:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105c01:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105c07:	85 c0                	test   %eax,%eax
80105c09:	79 0d                	jns    80105c18 <popcli+0x4c>
    panic("popcli");
80105c0b:	83 ec 0c             	sub    $0xc,%esp
80105c0e:	68 6f 94 10 80       	push   $0x8010946f
80105c13:	e8 9b a9 ff ff       	call   801005b3 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105c18:	e8 86 ea ff ff       	call   801046a3 <mycpu>
80105c1d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105c23:	85 c0                	test   %eax,%eax
80105c25:	75 14                	jne    80105c3b <popcli+0x6f>
80105c27:	e8 77 ea ff ff       	call   801046a3 <mycpu>
80105c2c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105c32:	85 c0                	test   %eax,%eax
80105c34:	74 05                	je     80105c3b <popcli+0x6f>
    sti();
80105c36:	e8 86 fd ff ff       	call   801059c1 <sti>
}
80105c3b:	90                   	nop
80105c3c:	c9                   	leave
80105c3d:	c3                   	ret

80105c3e <stosb>:
{
80105c3e:	55                   	push   %ebp
80105c3f:	89 e5                	mov    %esp,%ebp
80105c41:	57                   	push   %edi
80105c42:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105c43:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105c46:	8b 55 10             	mov    0x10(%ebp),%edx
80105c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c4c:	89 cb                	mov    %ecx,%ebx
80105c4e:	89 df                	mov    %ebx,%edi
80105c50:	89 d1                	mov    %edx,%ecx
80105c52:	fc                   	cld
80105c53:	f3 aa                	rep stos %al,%es:(%edi)
80105c55:	89 ca                	mov    %ecx,%edx
80105c57:	89 fb                	mov    %edi,%ebx
80105c59:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105c5c:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105c5f:	90                   	nop
80105c60:	5b                   	pop    %ebx
80105c61:	5f                   	pop    %edi
80105c62:	5d                   	pop    %ebp
80105c63:	c3                   	ret

80105c64 <stosl>:
{
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	57                   	push   %edi
80105c68:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105c6c:	8b 55 10             	mov    0x10(%ebp),%edx
80105c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c72:	89 cb                	mov    %ecx,%ebx
80105c74:	89 df                	mov    %ebx,%edi
80105c76:	89 d1                	mov    %edx,%ecx
80105c78:	fc                   	cld
80105c79:	f3 ab                	rep stos %eax,%es:(%edi)
80105c7b:	89 ca                	mov    %ecx,%edx
80105c7d:	89 fb                	mov    %edi,%ebx
80105c7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105c82:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105c85:	90                   	nop
80105c86:	5b                   	pop    %ebx
80105c87:	5f                   	pop    %edi
80105c88:	5d                   	pop    %ebp
80105c89:	c3                   	ret

80105c8a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105c8a:	55                   	push   %ebp
80105c8b:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80105c90:	83 e0 03             	and    $0x3,%eax
80105c93:	85 c0                	test   %eax,%eax
80105c95:	75 43                	jne    80105cda <memset+0x50>
80105c97:	8b 45 10             	mov    0x10(%ebp),%eax
80105c9a:	83 e0 03             	and    $0x3,%eax
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	75 39                	jne    80105cda <memset+0x50>
    c &= 0xFF;
80105ca1:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105ca8:	8b 45 10             	mov    0x10(%ebp),%eax
80105cab:	c1 e8 02             	shr    $0x2,%eax
80105cae:	89 c1                	mov    %eax,%ecx
80105cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cb3:	c1 e0 18             	shl    $0x18,%eax
80105cb6:	89 c2                	mov    %eax,%edx
80105cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cbb:	c1 e0 10             	shl    $0x10,%eax
80105cbe:	09 c2                	or     %eax,%edx
80105cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cc3:	c1 e0 08             	shl    $0x8,%eax
80105cc6:	09 d0                	or     %edx,%eax
80105cc8:	0b 45 0c             	or     0xc(%ebp),%eax
80105ccb:	51                   	push   %ecx
80105ccc:	50                   	push   %eax
80105ccd:	ff 75 08             	push   0x8(%ebp)
80105cd0:	e8 8f ff ff ff       	call   80105c64 <stosl>
80105cd5:	83 c4 0c             	add    $0xc,%esp
80105cd8:	eb 12                	jmp    80105cec <memset+0x62>
  } else
    stosb(dst, c, n);
80105cda:	8b 45 10             	mov    0x10(%ebp),%eax
80105cdd:	50                   	push   %eax
80105cde:	ff 75 0c             	push   0xc(%ebp)
80105ce1:	ff 75 08             	push   0x8(%ebp)
80105ce4:	e8 55 ff ff ff       	call   80105c3e <stosb>
80105ce9:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105cec:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105cef:	c9                   	leave
80105cf0:	c3                   	ret

80105cf1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105cf1:	55                   	push   %ebp
80105cf2:	89 e5                	mov    %esp,%ebp
80105cf4:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80105cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105d03:	eb 2e                	jmp    80105d33 <memcmp+0x42>
    if(*s1 != *s2)
80105d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d08:	0f b6 10             	movzbl (%eax),%edx
80105d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d0e:	0f b6 00             	movzbl (%eax),%eax
80105d11:	38 c2                	cmp    %al,%dl
80105d13:	74 16                	je     80105d2b <memcmp+0x3a>
      return *s1 - *s2;
80105d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d18:	0f b6 00             	movzbl (%eax),%eax
80105d1b:	0f b6 d0             	movzbl %al,%edx
80105d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d21:	0f b6 00             	movzbl (%eax),%eax
80105d24:	0f b6 c0             	movzbl %al,%eax
80105d27:	29 c2                	sub    %eax,%edx
80105d29:	eb 1a                	jmp    80105d45 <memcmp+0x54>
    s1++, s2++;
80105d2b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d2f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105d33:	8b 45 10             	mov    0x10(%ebp),%eax
80105d36:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d39:	89 55 10             	mov    %edx,0x10(%ebp)
80105d3c:	85 c0                	test   %eax,%eax
80105d3e:	75 c5                	jne    80105d05 <memcmp+0x14>
  }

  return 0;
80105d40:	ba 00 00 00 00       	mov    $0x0,%edx
}
80105d45:	89 d0                	mov    %edx,%eax
80105d47:	c9                   	leave
80105d48:	c3                   	ret

80105d49 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105d49:	55                   	push   %ebp
80105d4a:	89 e5                	mov    %esp,%ebp
80105d4c:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105d55:	8b 45 08             	mov    0x8(%ebp),%eax
80105d58:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105d61:	73 54                	jae    80105db7 <memmove+0x6e>
80105d63:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d66:	8b 45 10             	mov    0x10(%ebp),%eax
80105d69:	01 d0                	add    %edx,%eax
80105d6b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105d6e:	73 47                	jae    80105db7 <memmove+0x6e>
    s += n;
80105d70:	8b 45 10             	mov    0x10(%ebp),%eax
80105d73:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105d76:	8b 45 10             	mov    0x10(%ebp),%eax
80105d79:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105d7c:	eb 13                	jmp    80105d91 <memmove+0x48>
      *--d = *--s;
80105d7e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105d82:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d89:	0f b6 10             	movzbl (%eax),%edx
80105d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d8f:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105d91:	8b 45 10             	mov    0x10(%ebp),%eax
80105d94:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d97:	89 55 10             	mov    %edx,0x10(%ebp)
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	75 e0                	jne    80105d7e <memmove+0x35>
  if(s < d && s + n > d){
80105d9e:	eb 24                	jmp    80105dc4 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105da0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105da3:	8d 42 01             	lea    0x1(%edx),%eax
80105da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105da9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105dac:	8d 48 01             	lea    0x1(%eax),%ecx
80105daf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80105db2:	0f b6 12             	movzbl (%edx),%edx
80105db5:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105db7:	8b 45 10             	mov    0x10(%ebp),%eax
80105dba:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dbd:	89 55 10             	mov    %edx,0x10(%ebp)
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	75 dc                	jne    80105da0 <memmove+0x57>

  return dst;
80105dc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105dc7:	c9                   	leave
80105dc8:	c3                   	ret

80105dc9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105dc9:	55                   	push   %ebp
80105dca:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105dcc:	ff 75 10             	push   0x10(%ebp)
80105dcf:	ff 75 0c             	push   0xc(%ebp)
80105dd2:	ff 75 08             	push   0x8(%ebp)
80105dd5:	e8 6f ff ff ff       	call   80105d49 <memmove>
80105dda:	83 c4 0c             	add    $0xc,%esp
}
80105ddd:	c9                   	leave
80105dde:	c3                   	ret

80105ddf <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105ddf:	55                   	push   %ebp
80105de0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105de2:	eb 0c                	jmp    80105df0 <strncmp+0x11>
    n--, p++, q++;
80105de4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105de8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105dec:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105df4:	74 1a                	je     80105e10 <strncmp+0x31>
80105df6:	8b 45 08             	mov    0x8(%ebp),%eax
80105df9:	0f b6 00             	movzbl (%eax),%eax
80105dfc:	84 c0                	test   %al,%al
80105dfe:	74 10                	je     80105e10 <strncmp+0x31>
80105e00:	8b 45 08             	mov    0x8(%ebp),%eax
80105e03:	0f b6 10             	movzbl (%eax),%edx
80105e06:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e09:	0f b6 00             	movzbl (%eax),%eax
80105e0c:	38 c2                	cmp    %al,%dl
80105e0e:	74 d4                	je     80105de4 <strncmp+0x5>
  if(n == 0)
80105e10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e14:	75 07                	jne    80105e1d <strncmp+0x3e>
    return 0;
80105e16:	ba 00 00 00 00       	mov    $0x0,%edx
80105e1b:	eb 14                	jmp    80105e31 <strncmp+0x52>
  return (uchar)*p - (uchar)*q;
80105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80105e20:	0f b6 00             	movzbl (%eax),%eax
80105e23:	0f b6 d0             	movzbl %al,%edx
80105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e29:	0f b6 00             	movzbl (%eax),%eax
80105e2c:	0f b6 c0             	movzbl %al,%eax
80105e2f:	29 c2                	sub    %eax,%edx
}
80105e31:	89 d0                	mov    %edx,%eax
80105e33:	5d                   	pop    %ebp
80105e34:	c3                   	ret

80105e35 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105e35:	55                   	push   %ebp
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105e3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105e41:	90                   	nop
80105e42:	8b 45 10             	mov    0x10(%ebp),%eax
80105e45:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e48:	89 55 10             	mov    %edx,0x10(%ebp)
80105e4b:	85 c0                	test   %eax,%eax
80105e4d:	7e 2c                	jle    80105e7b <strncpy+0x46>
80105e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e52:	8d 42 01             	lea    0x1(%edx),%eax
80105e55:	89 45 0c             	mov    %eax,0xc(%ebp)
80105e58:	8b 45 08             	mov    0x8(%ebp),%eax
80105e5b:	8d 48 01             	lea    0x1(%eax),%ecx
80105e5e:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105e61:	0f b6 12             	movzbl (%edx),%edx
80105e64:	88 10                	mov    %dl,(%eax)
80105e66:	0f b6 00             	movzbl (%eax),%eax
80105e69:	84 c0                	test   %al,%al
80105e6b:	75 d5                	jne    80105e42 <strncpy+0xd>
    ;
  while(n-- > 0)
80105e6d:	eb 0c                	jmp    80105e7b <strncpy+0x46>
    *s++ = 0;
80105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e72:	8d 50 01             	lea    0x1(%eax),%edx
80105e75:	89 55 08             	mov    %edx,0x8(%ebp)
80105e78:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105e7b:	8b 45 10             	mov    0x10(%ebp),%eax
80105e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e81:	89 55 10             	mov    %edx,0x10(%ebp)
80105e84:	85 c0                	test   %eax,%eax
80105e86:	7f e7                	jg     80105e6f <strncpy+0x3a>
  return os;
80105e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105e8b:	c9                   	leave
80105e8c:	c3                   	ret

80105e8d <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105e8d:	55                   	push   %ebp
80105e8e:	89 e5                	mov    %esp,%ebp
80105e90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105e93:	8b 45 08             	mov    0x8(%ebp),%eax
80105e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e9d:	7f 05                	jg     80105ea4 <safestrcpy+0x17>
    return os;
80105e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ea2:	eb 32                	jmp    80105ed6 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80105ea4:	90                   	nop
80105ea5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ead:	7e 1e                	jle    80105ecd <safestrcpy+0x40>
80105eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
80105eb2:	8d 42 01             	lea    0x1(%edx),%eax
80105eb5:	89 45 0c             	mov    %eax,0xc(%ebp)
80105eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80105ebb:	8d 48 01             	lea    0x1(%eax),%ecx
80105ebe:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105ec1:	0f b6 12             	movzbl (%edx),%edx
80105ec4:	88 10                	mov    %dl,(%eax)
80105ec6:	0f b6 00             	movzbl (%eax),%eax
80105ec9:	84 c0                	test   %al,%al
80105ecb:	75 d8                	jne    80105ea5 <safestrcpy+0x18>
    ;
  *s = 0;
80105ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ed0:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ed6:	c9                   	leave
80105ed7:	c3                   	ret

80105ed8 <strlen>:

int
strlen(const char *s)
{
80105ed8:	55                   	push   %ebp
80105ed9:	89 e5                	mov    %esp,%ebp
80105edb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ee5:	eb 04                	jmp    80105eeb <strlen+0x13>
80105ee7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105eee:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef1:	01 d0                	add    %edx,%eax
80105ef3:	0f b6 00             	movzbl (%eax),%eax
80105ef6:	84 c0                	test   %al,%al
80105ef8:	75 ed                	jne    80105ee7 <strlen+0xf>
    ;
  return n;
80105efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105efd:	c9                   	leave
80105efe:	c3                   	ret

80105eff <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105eff:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105f03:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105f07:	55                   	push   %ebp
  pushl %ebx
80105f08:	53                   	push   %ebx
  pushl %esi
80105f09:	56                   	push   %esi
  pushl %edi
80105f0a:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105f0b:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105f0d:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105f0f:	5f                   	pop    %edi
  popl %esi
80105f10:	5e                   	pop    %esi
  popl %ebx
80105f11:	5b                   	pop    %ebx
  popl %ebp
80105f12:	5d                   	pop    %ebp
  ret
80105f13:	c3                   	ret

80105f14 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105f1a:	e8 fc e7 ff ff       	call   8010471b <myproc>
80105f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f25:	8b 00                	mov    (%eax),%eax
80105f27:	39 45 08             	cmp    %eax,0x8(%ebp)
80105f2a:	73 0f                	jae    80105f3b <fetchint+0x27>
80105f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80105f2f:	8d 50 04             	lea    0x4(%eax),%edx
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	8b 00                	mov    (%eax),%eax
80105f37:	39 d0                	cmp    %edx,%eax
80105f39:	73 07                	jae    80105f42 <fetchint+0x2e>
    return -1;
80105f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f40:	eb 0f                	jmp    80105f51 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105f42:	8b 45 08             	mov    0x8(%ebp),%eax
80105f45:	8b 10                	mov    (%eax),%edx
80105f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f4a:	89 10                	mov    %edx,(%eax)
  return 0;
80105f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f51:	c9                   	leave
80105f52:	c3                   	ret

80105f53 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105f53:	55                   	push   %ebp
80105f54:	89 e5                	mov    %esp,%ebp
80105f56:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105f59:	e8 bd e7 ff ff       	call   8010471b <myproc>
80105f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f64:	8b 00                	mov    (%eax),%eax
80105f66:	39 45 08             	cmp    %eax,0x8(%ebp)
80105f69:	72 07                	jb     80105f72 <fetchstr+0x1f>
    return -1;
80105f6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f70:	eb 41                	jmp    80105fb3 <fetchstr+0x60>
  *pp = (char*)addr;
80105f72:	8b 55 08             	mov    0x8(%ebp),%edx
80105f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f78:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7d:	8b 00                	mov    (%eax),%eax
80105f7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105f82:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f85:	8b 00                	mov    (%eax),%eax
80105f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f8a:	eb 1a                	jmp    80105fa6 <fetchstr+0x53>
    if(*s == 0)
80105f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8f:	0f b6 00             	movzbl (%eax),%eax
80105f92:	84 c0                	test   %al,%al
80105f94:	75 0c                	jne    80105fa2 <fetchstr+0x4f>
      return s - *pp;
80105f96:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f99:	8b 10                	mov    (%eax),%edx
80105f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9e:	29 d0                	sub    %edx,%eax
80105fa0:	eb 11                	jmp    80105fb3 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80105fa2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105fac:	72 de                	jb     80105f8c <fetchstr+0x39>
  }
  return -1;
80105fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fb3:	c9                   	leave
80105fb4:	c3                   	ret

80105fb5 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105fb5:	55                   	push   %ebp
80105fb6:	89 e5                	mov    %esp,%ebp
80105fb8:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105fbb:	e8 5b e7 ff ff       	call   8010471b <myproc>
80105fc0:	8b 40 18             	mov    0x18(%eax),%eax
80105fc3:	8b 40 44             	mov    0x44(%eax),%eax
80105fc6:	8b 55 08             	mov    0x8(%ebp),%edx
80105fc9:	c1 e2 02             	shl    $0x2,%edx
80105fcc:	01 d0                	add    %edx,%eax
80105fce:	83 c0 04             	add    $0x4,%eax
80105fd1:	83 ec 08             	sub    $0x8,%esp
80105fd4:	ff 75 0c             	push   0xc(%ebp)
80105fd7:	50                   	push   %eax
80105fd8:	e8 37 ff ff ff       	call   80105f14 <fetchint>
80105fdd:	83 c4 10             	add    $0x10,%esp
}
80105fe0:	c9                   	leave
80105fe1:	c3                   	ret

80105fe2 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105fe2:	55                   	push   %ebp
80105fe3:	89 e5                	mov    %esp,%ebp
80105fe5:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105fe8:	e8 2e e7 ff ff       	call   8010471b <myproc>
80105fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ff6:	50                   	push   %eax
80105ff7:	ff 75 08             	push   0x8(%ebp)
80105ffa:	e8 b6 ff ff ff       	call   80105fb5 <argint>
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	85 c0                	test   %eax,%eax
80106004:	79 07                	jns    8010600d <argptr+0x2b>
    return -1;
80106006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600b:	eb 3b                	jmp    80106048 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010600d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106011:	78 1f                	js     80106032 <argptr+0x50>
80106013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106016:	8b 00                	mov    (%eax),%eax
80106018:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010601b:	39 c2                	cmp    %eax,%edx
8010601d:	73 13                	jae    80106032 <argptr+0x50>
8010601f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106022:	89 c2                	mov    %eax,%edx
80106024:	8b 45 10             	mov    0x10(%ebp),%eax
80106027:	01 c2                	add    %eax,%edx
80106029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602c:	8b 00                	mov    (%eax),%eax
8010602e:	39 d0                	cmp    %edx,%eax
80106030:	73 07                	jae    80106039 <argptr+0x57>
    return -1;
80106032:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106037:	eb 0f                	jmp    80106048 <argptr+0x66>
  *pp = (char*)i;
80106039:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603c:	89 c2                	mov    %eax,%edx
8010603e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106041:	89 10                	mov    %edx,(%eax)
  return 0;
80106043:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106048:	c9                   	leave
80106049:	c3                   	ret

8010604a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010604a:	55                   	push   %ebp
8010604b:	89 e5                	mov    %esp,%ebp
8010604d:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106050:	83 ec 08             	sub    $0x8,%esp
80106053:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106056:	50                   	push   %eax
80106057:	ff 75 08             	push   0x8(%ebp)
8010605a:	e8 56 ff ff ff       	call   80105fb5 <argint>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	85 c0                	test   %eax,%eax
80106064:	79 07                	jns    8010606d <argstr+0x23>
    return -1;
80106066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606b:	eb 12                	jmp    8010607f <argstr+0x35>
  return fetchstr(addr, pp);
8010606d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106070:	83 ec 08             	sub    $0x8,%esp
80106073:	ff 75 0c             	push   0xc(%ebp)
80106076:	50                   	push   %eax
80106077:	e8 d7 fe ff ff       	call   80105f53 <fetchstr>
8010607c:	83 c4 10             	add    $0x10,%esp
}
8010607f:	c9                   	leave
80106080:	c3                   	ret

80106081 <syscall>:
[SYS_sem_post] sys_sem_post,
};

void
syscall(void)
{
80106081:	55                   	push   %ebp
80106082:	89 e5                	mov    %esp,%ebp
80106084:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80106087:	e8 8f e6 ff ff       	call   8010471b <myproc>
8010608c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010608f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106092:	8b 40 18             	mov    0x18(%eax),%eax
80106095:	8b 40 1c             	mov    0x1c(%eax),%eax
80106098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010609b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010609f:	7e 55                	jle    801060f6 <syscall+0x75>
801060a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a4:	83 f8 20             	cmp    $0x20,%eax
801060a7:	77 4d                	ja     801060f6 <syscall+0x75>
801060a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ac:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
801060b3:	85 c0                	test   %eax,%eax
801060b5:	74 3f                	je     801060f6 <syscall+0x75>
    curproc->tf->eax = syscalls[num]();
801060b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ba:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
801060c1:	ff d0                	call   *%eax
801060c3:	89 c2                	mov    %eax,%edx
801060c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c8:	8b 40 18             	mov    0x18(%eax),%eax
801060cb:	89 50 1c             	mov    %edx,0x1c(%eax)
    if(num != SYS_write && num != SYS_yield && num != SYS_exit && num != SYS_thread_exit && random_should_yield())
801060ce:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
801060d2:	74 4f                	je     80106123 <syscall+0xa2>
801060d4:	83 7d f0 1a          	cmpl   $0x1a,-0x10(%ebp)
801060d8:	74 49                	je     80106123 <syscall+0xa2>
801060da:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
801060de:	74 43                	je     80106123 <syscall+0xa2>
801060e0:	83 7d f0 18          	cmpl   $0x18,-0x10(%ebp)
801060e4:	74 3d                	je     80106123 <syscall+0xa2>
801060e6:	e8 40 f2 ff ff       	call   8010532b <random_should_yield>
801060eb:	85 c0                	test   %eax,%eax
801060ed:	74 34                	je     80106123 <syscall+0xa2>
      yield();
801060ef:	e8 46 f4 ff ff       	call   8010553a <yield>
    if(num != SYS_write && num != SYS_yield && num != SYS_exit && num != SYS_thread_exit && random_should_yield())
801060f4:	eb 2d                	jmp    80106123 <syscall+0xa2>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801060f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f9:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
801060fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ff:	8b 40 10             	mov    0x10(%eax),%eax
80106102:	ff 75 f0             	push   -0x10(%ebp)
80106105:	52                   	push   %edx
80106106:	50                   	push   %eax
80106107:	68 76 94 10 80       	push   $0x80109476
8010610c:	e8 ed a2 ff ff       	call   801003fe <cprintf>
80106111:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80106114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106117:	8b 40 18             	mov    0x18(%eax),%eax
8010611a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106121:	eb 01                	jmp    80106124 <syscall+0xa3>
    if(num != SYS_write && num != SYS_yield && num != SYS_exit && num != SYS_thread_exit && random_should_yield())
80106123:	90                   	nop
}
80106124:	90                   	nop
80106125:	c9                   	leave
80106126:	c3                   	ret

80106127 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106127:	55                   	push   %ebp
80106128:	89 e5                	mov    %esp,%ebp
8010612a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010612d:	83 ec 08             	sub    $0x8,%esp
80106130:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106133:	50                   	push   %eax
80106134:	ff 75 08             	push   0x8(%ebp)
80106137:	e8 79 fe ff ff       	call   80105fb5 <argint>
8010613c:	83 c4 10             	add    $0x10,%esp
8010613f:	85 c0                	test   %eax,%eax
80106141:	79 07                	jns    8010614a <argfd+0x23>
    return -1;
80106143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106148:	eb 4f                	jmp    80106199 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010614a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614d:	85 c0                	test   %eax,%eax
8010614f:	78 20                	js     80106171 <argfd+0x4a>
80106151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106154:	83 f8 0f             	cmp    $0xf,%eax
80106157:	7f 18                	jg     80106171 <argfd+0x4a>
80106159:	e8 bd e5 ff ff       	call   8010471b <myproc>
8010615e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106161:	83 c2 08             	add    $0x8,%edx
80106164:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010616b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010616f:	75 07                	jne    80106178 <argfd+0x51>
    return -1;
80106171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106176:	eb 21                	jmp    80106199 <argfd+0x72>
  if(pfd)
80106178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010617c:	74 08                	je     80106186 <argfd+0x5f>
    *pfd = fd;
8010617e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106181:	8b 45 0c             	mov    0xc(%ebp),%eax
80106184:	89 10                	mov    %edx,(%eax)
  if(pf)
80106186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010618a:	74 08                	je     80106194 <argfd+0x6d>
    *pf = f;
8010618c:	8b 45 10             	mov    0x10(%ebp),%eax
8010618f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106192:	89 10                	mov    %edx,(%eax)
  return 0;
80106194:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106199:	c9                   	leave
8010619a:	c3                   	ret

8010619b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010619b:	55                   	push   %ebp
8010619c:	89 e5                	mov    %esp,%ebp
8010619e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801061a1:	e8 75 e5 ff ff       	call   8010471b <myproc>
801061a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801061a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061b0:	eb 2a                	jmp    801061dc <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801061b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061b8:	83 c2 08             	add    $0x8,%edx
801061bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801061bf:	85 c0                	test   %eax,%eax
801061c1:	75 15                	jne    801061d8 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801061c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c9:	8d 4a 08             	lea    0x8(%edx),%ecx
801061cc:	8b 55 08             	mov    0x8(%ebp),%edx
801061cf:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801061d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d6:	eb 0f                	jmp    801061e7 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
801061d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801061dc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801061e0:	7e d0                	jle    801061b2 <fdalloc+0x17>
    }
  }
  return -1;
801061e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061e7:	c9                   	leave
801061e8:	c3                   	ret

801061e9 <sys_dup>:

int
sys_dup(void)
{
801061e9:	55                   	push   %ebp
801061ea:	89 e5                	mov    %esp,%ebp
801061ec:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801061ef:	83 ec 04             	sub    $0x4,%esp
801061f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061f5:	50                   	push   %eax
801061f6:	6a 00                	push   $0x0
801061f8:	6a 00                	push   $0x0
801061fa:	e8 28 ff ff ff       	call   80106127 <argfd>
801061ff:	83 c4 10             	add    $0x10,%esp
80106202:	85 c0                	test   %eax,%eax
80106204:	79 07                	jns    8010620d <sys_dup+0x24>
    return -1;
80106206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620b:	eb 31                	jmp    8010623e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010620d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	50                   	push   %eax
80106214:	e8 82 ff ff ff       	call   8010619b <fdalloc>
80106219:	83 c4 10             	add    $0x10,%esp
8010621c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010621f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106223:	79 07                	jns    8010622c <sys_dup+0x43>
    return -1;
80106225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622a:	eb 12                	jmp    8010623e <sys_dup+0x55>
  filedup(f);
8010622c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622f:	83 ec 0c             	sub    $0xc,%esp
80106232:	50                   	push   %eax
80106233:	e8 59 ae ff ff       	call   80101091 <filedup>
80106238:	83 c4 10             	add    $0x10,%esp
  return fd;
8010623b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010623e:	c9                   	leave
8010623f:	c3                   	ret

80106240 <sys_read>:

int
sys_read(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106246:	83 ec 04             	sub    $0x4,%esp
80106249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010624c:	50                   	push   %eax
8010624d:	6a 00                	push   $0x0
8010624f:	6a 00                	push   $0x0
80106251:	e8 d1 fe ff ff       	call   80106127 <argfd>
80106256:	83 c4 10             	add    $0x10,%esp
80106259:	85 c0                	test   %eax,%eax
8010625b:	78 2e                	js     8010628b <sys_read+0x4b>
8010625d:	83 ec 08             	sub    $0x8,%esp
80106260:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106263:	50                   	push   %eax
80106264:	6a 02                	push   $0x2
80106266:	e8 4a fd ff ff       	call   80105fb5 <argint>
8010626b:	83 c4 10             	add    $0x10,%esp
8010626e:	85 c0                	test   %eax,%eax
80106270:	78 19                	js     8010628b <sys_read+0x4b>
80106272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106275:	83 ec 04             	sub    $0x4,%esp
80106278:	50                   	push   %eax
80106279:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010627c:	50                   	push   %eax
8010627d:	6a 01                	push   $0x1
8010627f:	e8 5e fd ff ff       	call   80105fe2 <argptr>
80106284:	83 c4 10             	add    $0x10,%esp
80106287:	85 c0                	test   %eax,%eax
80106289:	79 07                	jns    80106292 <sys_read+0x52>
    return -1;
8010628b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106290:	eb 17                	jmp    801062a9 <sys_read+0x69>
  return fileread(f, p, n);
80106292:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106295:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629b:	83 ec 04             	sub    $0x4,%esp
8010629e:	51                   	push   %ecx
8010629f:	52                   	push   %edx
801062a0:	50                   	push   %eax
801062a1:	e8 7b af ff ff       	call   80101221 <fileread>
801062a6:	83 c4 10             	add    $0x10,%esp
}
801062a9:	c9                   	leave
801062aa:	c3                   	ret

801062ab <sys_write>:

int
sys_write(void)
{
801062ab:	55                   	push   %ebp
801062ac:	89 e5                	mov    %esp,%ebp
801062ae:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801062b1:	83 ec 04             	sub    $0x4,%esp
801062b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b7:	50                   	push   %eax
801062b8:	6a 00                	push   $0x0
801062ba:	6a 00                	push   $0x0
801062bc:	e8 66 fe ff ff       	call   80106127 <argfd>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	78 2e                	js     801062f6 <sys_write+0x4b>
801062c8:	83 ec 08             	sub    $0x8,%esp
801062cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ce:	50                   	push   %eax
801062cf:	6a 02                	push   $0x2
801062d1:	e8 df fc ff ff       	call   80105fb5 <argint>
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	85 c0                	test   %eax,%eax
801062db:	78 19                	js     801062f6 <sys_write+0x4b>
801062dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e0:	83 ec 04             	sub    $0x4,%esp
801062e3:	50                   	push   %eax
801062e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062e7:	50                   	push   %eax
801062e8:	6a 01                	push   $0x1
801062ea:	e8 f3 fc ff ff       	call   80105fe2 <argptr>
801062ef:	83 c4 10             	add    $0x10,%esp
801062f2:	85 c0                	test   %eax,%eax
801062f4:	79 07                	jns    801062fd <sys_write+0x52>
    return -1;
801062f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fb:	eb 17                	jmp    80106314 <sys_write+0x69>
  return filewrite(f, p, n);
801062fd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106300:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106306:	83 ec 04             	sub    $0x4,%esp
80106309:	51                   	push   %ecx
8010630a:	52                   	push   %edx
8010630b:	50                   	push   %eax
8010630c:	e8 c8 af ff ff       	call   801012d9 <filewrite>
80106311:	83 c4 10             	add    $0x10,%esp
}
80106314:	c9                   	leave
80106315:	c3                   	ret

80106316 <sys_close>:

int
sys_close(void)
{
80106316:	55                   	push   %ebp
80106317:	89 e5                	mov    %esp,%ebp
80106319:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010631c:	83 ec 04             	sub    $0x4,%esp
8010631f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106322:	50                   	push   %eax
80106323:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106326:	50                   	push   %eax
80106327:	6a 00                	push   $0x0
80106329:	e8 f9 fd ff ff       	call   80106127 <argfd>
8010632e:	83 c4 10             	add    $0x10,%esp
80106331:	85 c0                	test   %eax,%eax
80106333:	79 07                	jns    8010633c <sys_close+0x26>
    return -1;
80106335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633a:	eb 27                	jmp    80106363 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
8010633c:	e8 da e3 ff ff       	call   8010471b <myproc>
80106341:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106344:	83 c2 08             	add    $0x8,%edx
80106347:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010634e:	00 
  fileclose(f);
8010634f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106352:	83 ec 0c             	sub    $0xc,%esp
80106355:	50                   	push   %eax
80106356:	e8 87 ad ff ff       	call   801010e2 <fileclose>
8010635b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010635e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106363:	c9                   	leave
80106364:	c3                   	ret

80106365 <sys_fstat>:

int
sys_fstat(void)
{
80106365:	55                   	push   %ebp
80106366:	89 e5                	mov    %esp,%ebp
80106368:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010636b:	83 ec 04             	sub    $0x4,%esp
8010636e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106371:	50                   	push   %eax
80106372:	6a 00                	push   $0x0
80106374:	6a 00                	push   $0x0
80106376:	e8 ac fd ff ff       	call   80106127 <argfd>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	85 c0                	test   %eax,%eax
80106380:	78 17                	js     80106399 <sys_fstat+0x34>
80106382:	83 ec 04             	sub    $0x4,%esp
80106385:	6a 14                	push   $0x14
80106387:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010638a:	50                   	push   %eax
8010638b:	6a 01                	push   $0x1
8010638d:	e8 50 fc ff ff       	call   80105fe2 <argptr>
80106392:	83 c4 10             	add    $0x10,%esp
80106395:	85 c0                	test   %eax,%eax
80106397:	79 07                	jns    801063a0 <sys_fstat+0x3b>
    return -1;
80106399:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639e:	eb 13                	jmp    801063b3 <sys_fstat+0x4e>
  return filestat(f, st);
801063a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a6:	83 ec 08             	sub    $0x8,%esp
801063a9:	52                   	push   %edx
801063aa:	50                   	push   %eax
801063ab:	e8 1a ae ff ff       	call   801011ca <filestat>
801063b0:	83 c4 10             	add    $0x10,%esp
}
801063b3:	c9                   	leave
801063b4:	c3                   	ret

801063b5 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801063b5:	55                   	push   %ebp
801063b6:	89 e5                	mov    %esp,%ebp
801063b8:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801063bb:	83 ec 08             	sub    $0x8,%esp
801063be:	8d 45 d8             	lea    -0x28(%ebp),%eax
801063c1:	50                   	push   %eax
801063c2:	6a 00                	push   $0x0
801063c4:	e8 81 fc ff ff       	call   8010604a <argstr>
801063c9:	83 c4 10             	add    $0x10,%esp
801063cc:	85 c0                	test   %eax,%eax
801063ce:	78 15                	js     801063e5 <sys_link+0x30>
801063d0:	83 ec 08             	sub    $0x8,%esp
801063d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801063d6:	50                   	push   %eax
801063d7:	6a 01                	push   $0x1
801063d9:	e8 6c fc ff ff       	call   8010604a <argstr>
801063de:	83 c4 10             	add    $0x10,%esp
801063e1:	85 c0                	test   %eax,%eax
801063e3:	79 0a                	jns    801063ef <sys_link+0x3a>
    return -1;
801063e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ea:	e9 68 01 00 00       	jmp    80106557 <sys_link+0x1a2>

  begin_op();
801063ef:	e8 c4 d5 ff ff       	call   801039b8 <begin_op>
  if((ip = namei(old)) == 0){
801063f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801063f7:	83 ec 0c             	sub    $0xc,%esp
801063fa:	50                   	push   %eax
801063fb:	e8 4f c1 ff ff       	call   8010254f <namei>
80106400:	83 c4 10             	add    $0x10,%esp
80106403:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010640a:	75 0f                	jne    8010641b <sys_link+0x66>
    end_op();
8010640c:	e8 33 d6 ff ff       	call   80103a44 <end_op>
    return -1;
80106411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106416:	e9 3c 01 00 00       	jmp    80106557 <sys_link+0x1a2>
  }

  ilock(ip);
8010641b:	83 ec 0c             	sub    $0xc,%esp
8010641e:	ff 75 f4             	push   -0xc(%ebp)
80106421:	e8 f6 b5 ff ff       	call   80101a1c <ilock>
80106426:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106430:	66 83 f8 01          	cmp    $0x1,%ax
80106434:	75 1d                	jne    80106453 <sys_link+0x9e>
    iunlockput(ip);
80106436:	83 ec 0c             	sub    $0xc,%esp
80106439:	ff 75 f4             	push   -0xc(%ebp)
8010643c:	e8 0c b8 ff ff       	call   80101c4d <iunlockput>
80106441:	83 c4 10             	add    $0x10,%esp
    end_op();
80106444:	e8 fb d5 ff ff       	call   80103a44 <end_op>
    return -1;
80106449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644e:	e9 04 01 00 00       	jmp    80106557 <sys_link+0x1a2>
  }

  ip->nlink++;
80106453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106456:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010645a:	83 c0 01             	add    $0x1,%eax
8010645d:	89 c2                	mov    %eax,%edx
8010645f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106462:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106466:	83 ec 0c             	sub    $0xc,%esp
80106469:	ff 75 f4             	push   -0xc(%ebp)
8010646c:	e8 ce b3 ff ff       	call   8010183f <iupdate>
80106471:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106474:	83 ec 0c             	sub    $0xc,%esp
80106477:	ff 75 f4             	push   -0xc(%ebp)
8010647a:	e8 b0 b6 ff ff       	call   80101b2f <iunlock>
8010647f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106482:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106485:	83 ec 08             	sub    $0x8,%esp
80106488:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010648b:	52                   	push   %edx
8010648c:	50                   	push   %eax
8010648d:	e8 d9 c0 ff ff       	call   8010256b <nameiparent>
80106492:	83 c4 10             	add    $0x10,%esp
80106495:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010649c:	74 71                	je     8010650f <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010649e:	83 ec 0c             	sub    $0xc,%esp
801064a1:	ff 75 f0             	push   -0x10(%ebp)
801064a4:	e8 73 b5 ff ff       	call   80101a1c <ilock>
801064a9:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801064ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064af:	8b 10                	mov    (%eax),%edx
801064b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b4:	8b 00                	mov    (%eax),%eax
801064b6:	39 c2                	cmp    %eax,%edx
801064b8:	75 1d                	jne    801064d7 <sys_link+0x122>
801064ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064bd:	8b 40 04             	mov    0x4(%eax),%eax
801064c0:	83 ec 04             	sub    $0x4,%esp
801064c3:	50                   	push   %eax
801064c4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801064c7:	50                   	push   %eax
801064c8:	ff 75 f0             	push   -0x10(%ebp)
801064cb:	e8 e8 bd ff ff       	call   801022b8 <dirlink>
801064d0:	83 c4 10             	add    $0x10,%esp
801064d3:	85 c0                	test   %eax,%eax
801064d5:	79 10                	jns    801064e7 <sys_link+0x132>
    iunlockput(dp);
801064d7:	83 ec 0c             	sub    $0xc,%esp
801064da:	ff 75 f0             	push   -0x10(%ebp)
801064dd:	e8 6b b7 ff ff       	call   80101c4d <iunlockput>
801064e2:	83 c4 10             	add    $0x10,%esp
    goto bad;
801064e5:	eb 29                	jmp    80106510 <sys_link+0x15b>
  }
  iunlockput(dp);
801064e7:	83 ec 0c             	sub    $0xc,%esp
801064ea:	ff 75 f0             	push   -0x10(%ebp)
801064ed:	e8 5b b7 ff ff       	call   80101c4d <iunlockput>
801064f2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	ff 75 f4             	push   -0xc(%ebp)
801064fb:	e8 7d b6 ff ff       	call   80101b7d <iput>
80106500:	83 c4 10             	add    $0x10,%esp

  end_op();
80106503:	e8 3c d5 ff ff       	call   80103a44 <end_op>

  return 0;
80106508:	b8 00 00 00 00       	mov    $0x0,%eax
8010650d:	eb 48                	jmp    80106557 <sys_link+0x1a2>
    goto bad;
8010650f:	90                   	nop

bad:
  ilock(ip);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	ff 75 f4             	push   -0xc(%ebp)
80106516:	e8 01 b5 ff ff       	call   80101a1c <ilock>
8010651b:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010651e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106521:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106525:	83 e8 01             	sub    $0x1,%eax
80106528:	89 c2                	mov    %eax,%edx
8010652a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010652d:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106531:	83 ec 0c             	sub    $0xc,%esp
80106534:	ff 75 f4             	push   -0xc(%ebp)
80106537:	e8 03 b3 ff ff       	call   8010183f <iupdate>
8010653c:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010653f:	83 ec 0c             	sub    $0xc,%esp
80106542:	ff 75 f4             	push   -0xc(%ebp)
80106545:	e8 03 b7 ff ff       	call   80101c4d <iunlockput>
8010654a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010654d:	e8 f2 d4 ff ff       	call   80103a44 <end_op>
  return -1;
80106552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106557:	c9                   	leave
80106558:	c3                   	ret

80106559 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106559:	55                   	push   %ebp
8010655a:	89 e5                	mov    %esp,%ebp
8010655c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010655f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106566:	eb 40                	jmp    801065a8 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656b:	6a 10                	push   $0x10
8010656d:	50                   	push   %eax
8010656e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106571:	50                   	push   %eax
80106572:	ff 75 08             	push   0x8(%ebp)
80106575:	e8 8e b9 ff ff       	call   80101f08 <readi>
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	83 f8 10             	cmp    $0x10,%eax
80106580:	74 0d                	je     8010658f <isdirempty+0x36>
      panic("isdirempty: readi");
80106582:	83 ec 0c             	sub    $0xc,%esp
80106585:	68 92 94 10 80       	push   $0x80109492
8010658a:	e8 24 a0 ff ff       	call   801005b3 <panic>
    if(de.inum != 0)
8010658f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106593:	66 85 c0             	test   %ax,%ax
80106596:	74 07                	je     8010659f <isdirempty+0x46>
      return 0;
80106598:	b8 00 00 00 00       	mov    $0x0,%eax
8010659d:	eb 1b                	jmp    801065ba <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010659f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a2:	83 c0 10             	add    $0x10,%eax
801065a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065a8:	8b 45 08             	mov    0x8(%ebp),%eax
801065ab:	8b 40 58             	mov    0x58(%eax),%eax
801065ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065b1:	39 c2                	cmp    %eax,%edx
801065b3:	72 b3                	jb     80106568 <isdirempty+0xf>
  }
  return 1;
801065b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
801065ba:	c9                   	leave
801065bb:	c3                   	ret

801065bc <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801065bc:	55                   	push   %ebp
801065bd:	89 e5                	mov    %esp,%ebp
801065bf:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801065c2:	83 ec 08             	sub    $0x8,%esp
801065c5:	8d 45 cc             	lea    -0x34(%ebp),%eax
801065c8:	50                   	push   %eax
801065c9:	6a 00                	push   $0x0
801065cb:	e8 7a fa ff ff       	call   8010604a <argstr>
801065d0:	83 c4 10             	add    $0x10,%esp
801065d3:	85 c0                	test   %eax,%eax
801065d5:	79 0a                	jns    801065e1 <sys_unlink+0x25>
    return -1;
801065d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065dc:	e9 bf 01 00 00       	jmp    801067a0 <sys_unlink+0x1e4>

  begin_op();
801065e1:	e8 d2 d3 ff ff       	call   801039b8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801065e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
801065e9:	83 ec 08             	sub    $0x8,%esp
801065ec:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801065ef:	52                   	push   %edx
801065f0:	50                   	push   %eax
801065f1:	e8 75 bf ff ff       	call   8010256b <nameiparent>
801065f6:	83 c4 10             	add    $0x10,%esp
801065f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106600:	75 0f                	jne    80106611 <sys_unlink+0x55>
    end_op();
80106602:	e8 3d d4 ff ff       	call   80103a44 <end_op>
    return -1;
80106607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660c:	e9 8f 01 00 00       	jmp    801067a0 <sys_unlink+0x1e4>
  }

  ilock(dp);
80106611:	83 ec 0c             	sub    $0xc,%esp
80106614:	ff 75 f4             	push   -0xc(%ebp)
80106617:	e8 00 b4 ff ff       	call   80101a1c <ilock>
8010661c:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010661f:	83 ec 08             	sub    $0x8,%esp
80106622:	68 a4 94 10 80       	push   $0x801094a4
80106627:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010662a:	50                   	push   %eax
8010662b:	e8 b3 bb ff ff       	call   801021e3 <namecmp>
80106630:	83 c4 10             	add    $0x10,%esp
80106633:	85 c0                	test   %eax,%eax
80106635:	0f 84 49 01 00 00    	je     80106784 <sys_unlink+0x1c8>
8010663b:	83 ec 08             	sub    $0x8,%esp
8010663e:	68 a6 94 10 80       	push   $0x801094a6
80106643:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106646:	50                   	push   %eax
80106647:	e8 97 bb ff ff       	call   801021e3 <namecmp>
8010664c:	83 c4 10             	add    $0x10,%esp
8010664f:	85 c0                	test   %eax,%eax
80106651:	0f 84 2d 01 00 00    	je     80106784 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106657:	83 ec 04             	sub    $0x4,%esp
8010665a:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010665d:	50                   	push   %eax
8010665e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106661:	50                   	push   %eax
80106662:	ff 75 f4             	push   -0xc(%ebp)
80106665:	e8 94 bb ff ff       	call   801021fe <dirlookup>
8010666a:	83 c4 10             	add    $0x10,%esp
8010666d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106670:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106674:	0f 84 0d 01 00 00    	je     80106787 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
8010667a:	83 ec 0c             	sub    $0xc,%esp
8010667d:	ff 75 f0             	push   -0x10(%ebp)
80106680:	e8 97 b3 ff ff       	call   80101a1c <ilock>
80106685:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106688:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010668b:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010668f:	66 85 c0             	test   %ax,%ax
80106692:	7f 0d                	jg     801066a1 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106694:	83 ec 0c             	sub    $0xc,%esp
80106697:	68 a9 94 10 80       	push   $0x801094a9
8010669c:	e8 12 9f ff ff       	call   801005b3 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801066a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801066a8:	66 83 f8 01          	cmp    $0x1,%ax
801066ac:	75 25                	jne    801066d3 <sys_unlink+0x117>
801066ae:	83 ec 0c             	sub    $0xc,%esp
801066b1:	ff 75 f0             	push   -0x10(%ebp)
801066b4:	e8 a0 fe ff ff       	call   80106559 <isdirempty>
801066b9:	83 c4 10             	add    $0x10,%esp
801066bc:	85 c0                	test   %eax,%eax
801066be:	75 13                	jne    801066d3 <sys_unlink+0x117>
    iunlockput(ip);
801066c0:	83 ec 0c             	sub    $0xc,%esp
801066c3:	ff 75 f0             	push   -0x10(%ebp)
801066c6:	e8 82 b5 ff ff       	call   80101c4d <iunlockput>
801066cb:	83 c4 10             	add    $0x10,%esp
    goto bad;
801066ce:	e9 b5 00 00 00       	jmp    80106788 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
801066d3:	83 ec 04             	sub    $0x4,%esp
801066d6:	6a 10                	push   $0x10
801066d8:	6a 00                	push   $0x0
801066da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801066dd:	50                   	push   %eax
801066de:	e8 a7 f5 ff ff       	call   80105c8a <memset>
801066e3:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801066e9:	6a 10                	push   $0x10
801066eb:	50                   	push   %eax
801066ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
801066ef:	50                   	push   %eax
801066f0:	ff 75 f4             	push   -0xc(%ebp)
801066f3:	e8 65 b9 ff ff       	call   8010205d <writei>
801066f8:	83 c4 10             	add    $0x10,%esp
801066fb:	83 f8 10             	cmp    $0x10,%eax
801066fe:	74 0d                	je     8010670d <sys_unlink+0x151>
    panic("unlink: writei");
80106700:	83 ec 0c             	sub    $0xc,%esp
80106703:	68 bb 94 10 80       	push   $0x801094bb
80106708:	e8 a6 9e ff ff       	call   801005b3 <panic>
  if(ip->type == T_DIR){
8010670d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106710:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106714:	66 83 f8 01          	cmp    $0x1,%ax
80106718:	75 21                	jne    8010673b <sys_unlink+0x17f>
    dp->nlink--;
8010671a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106721:	83 e8 01             	sub    $0x1,%eax
80106724:	89 c2                	mov    %eax,%edx
80106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106729:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010672d:	83 ec 0c             	sub    $0xc,%esp
80106730:	ff 75 f4             	push   -0xc(%ebp)
80106733:	e8 07 b1 ff ff       	call   8010183f <iupdate>
80106738:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010673b:	83 ec 0c             	sub    $0xc,%esp
8010673e:	ff 75 f4             	push   -0xc(%ebp)
80106741:	e8 07 b5 ff ff       	call   80101c4d <iunlockput>
80106746:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106749:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010674c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106750:	83 e8 01             	sub    $0x1,%eax
80106753:	89 c2                	mov    %eax,%edx
80106755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106758:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010675c:	83 ec 0c             	sub    $0xc,%esp
8010675f:	ff 75 f0             	push   -0x10(%ebp)
80106762:	e8 d8 b0 ff ff       	call   8010183f <iupdate>
80106767:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010676a:	83 ec 0c             	sub    $0xc,%esp
8010676d:	ff 75 f0             	push   -0x10(%ebp)
80106770:	e8 d8 b4 ff ff       	call   80101c4d <iunlockput>
80106775:	83 c4 10             	add    $0x10,%esp

  end_op();
80106778:	e8 c7 d2 ff ff       	call   80103a44 <end_op>

  return 0;
8010677d:	b8 00 00 00 00       	mov    $0x0,%eax
80106782:	eb 1c                	jmp    801067a0 <sys_unlink+0x1e4>
    goto bad;
80106784:	90                   	nop
80106785:	eb 01                	jmp    80106788 <sys_unlink+0x1cc>
    goto bad;
80106787:	90                   	nop

bad:
  iunlockput(dp);
80106788:	83 ec 0c             	sub    $0xc,%esp
8010678b:	ff 75 f4             	push   -0xc(%ebp)
8010678e:	e8 ba b4 ff ff       	call   80101c4d <iunlockput>
80106793:	83 c4 10             	add    $0x10,%esp
  end_op();
80106796:	e8 a9 d2 ff ff       	call   80103a44 <end_op>
  return -1;
8010679b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067a0:	c9                   	leave
801067a1:	c3                   	ret

801067a2 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801067a2:	55                   	push   %ebp
801067a3:	89 e5                	mov    %esp,%ebp
801067a5:	83 ec 38             	sub    $0x38,%esp
801067a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801067ab:	8b 55 10             	mov    0x10(%ebp),%edx
801067ae:	8b 45 14             	mov    0x14(%ebp),%eax
801067b1:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801067b5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801067b9:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801067bd:	83 ec 08             	sub    $0x8,%esp
801067c0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801067c3:	50                   	push   %eax
801067c4:	ff 75 08             	push   0x8(%ebp)
801067c7:	e8 9f bd ff ff       	call   8010256b <nameiparent>
801067cc:	83 c4 10             	add    $0x10,%esp
801067cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067d6:	75 0a                	jne    801067e2 <create+0x40>
    return 0;
801067d8:	b8 00 00 00 00       	mov    $0x0,%eax
801067dd:	e9 8e 01 00 00       	jmp    80106970 <create+0x1ce>
  ilock(dp);
801067e2:	83 ec 0c             	sub    $0xc,%esp
801067e5:	ff 75 f4             	push   -0xc(%ebp)
801067e8:	e8 2f b2 ff ff       	call   80101a1c <ilock>
801067ed:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
801067f0:	83 ec 04             	sub    $0x4,%esp
801067f3:	6a 00                	push   $0x0
801067f5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801067f8:	50                   	push   %eax
801067f9:	ff 75 f4             	push   -0xc(%ebp)
801067fc:	e8 fd b9 ff ff       	call   801021fe <dirlookup>
80106801:	83 c4 10             	add    $0x10,%esp
80106804:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010680b:	74 50                	je     8010685d <create+0xbb>
    iunlockput(dp);
8010680d:	83 ec 0c             	sub    $0xc,%esp
80106810:	ff 75 f4             	push   -0xc(%ebp)
80106813:	e8 35 b4 ff ff       	call   80101c4d <iunlockput>
80106818:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010681b:	83 ec 0c             	sub    $0xc,%esp
8010681e:	ff 75 f0             	push   -0x10(%ebp)
80106821:	e8 f6 b1 ff ff       	call   80101a1c <ilock>
80106826:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106829:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010682e:	75 15                	jne    80106845 <create+0xa3>
80106830:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106833:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106837:	66 83 f8 02          	cmp    $0x2,%ax
8010683b:	75 08                	jne    80106845 <create+0xa3>
      return ip;
8010683d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106840:	e9 2b 01 00 00       	jmp    80106970 <create+0x1ce>
    iunlockput(ip);
80106845:	83 ec 0c             	sub    $0xc,%esp
80106848:	ff 75 f0             	push   -0x10(%ebp)
8010684b:	e8 fd b3 ff ff       	call   80101c4d <iunlockput>
80106850:	83 c4 10             	add    $0x10,%esp
    return 0;
80106853:	b8 00 00 00 00       	mov    $0x0,%eax
80106858:	e9 13 01 00 00       	jmp    80106970 <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010685d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106864:	8b 00                	mov    (%eax),%eax
80106866:	83 ec 08             	sub    $0x8,%esp
80106869:	52                   	push   %edx
8010686a:	50                   	push   %eax
8010686b:	e8 f9 ae ff ff       	call   80101769 <ialloc>
80106870:	83 c4 10             	add    $0x10,%esp
80106873:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010687a:	75 0d                	jne    80106889 <create+0xe7>
    panic("create: ialloc");
8010687c:	83 ec 0c             	sub    $0xc,%esp
8010687f:	68 ca 94 10 80       	push   $0x801094ca
80106884:	e8 2a 9d ff ff       	call   801005b3 <panic>

  ilock(ip);
80106889:	83 ec 0c             	sub    $0xc,%esp
8010688c:	ff 75 f0             	push   -0x10(%ebp)
8010688f:	e8 88 b1 ff ff       	call   80101a1c <ilock>
80106894:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010689a:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010689e:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801068a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068a5:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801068a9:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801068ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068b0:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801068b6:	83 ec 0c             	sub    $0xc,%esp
801068b9:	ff 75 f0             	push   -0x10(%ebp)
801068bc:	e8 7e af ff ff       	call   8010183f <iupdate>
801068c1:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801068c4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801068c9:	75 6a                	jne    80106935 <create+0x193>
    dp->nlink++;  // for ".."
801068cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ce:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801068d2:	83 c0 01             	add    $0x1,%eax
801068d5:	89 c2                	mov    %eax,%edx
801068d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068da:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801068de:	83 ec 0c             	sub    $0xc,%esp
801068e1:	ff 75 f4             	push   -0xc(%ebp)
801068e4:	e8 56 af ff ff       	call   8010183f <iupdate>
801068e9:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801068ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068ef:	8b 40 04             	mov    0x4(%eax),%eax
801068f2:	83 ec 04             	sub    $0x4,%esp
801068f5:	50                   	push   %eax
801068f6:	68 a4 94 10 80       	push   $0x801094a4
801068fb:	ff 75 f0             	push   -0x10(%ebp)
801068fe:	e8 b5 b9 ff ff       	call   801022b8 <dirlink>
80106903:	83 c4 10             	add    $0x10,%esp
80106906:	85 c0                	test   %eax,%eax
80106908:	78 1e                	js     80106928 <create+0x186>
8010690a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690d:	8b 40 04             	mov    0x4(%eax),%eax
80106910:	83 ec 04             	sub    $0x4,%esp
80106913:	50                   	push   %eax
80106914:	68 a6 94 10 80       	push   $0x801094a6
80106919:	ff 75 f0             	push   -0x10(%ebp)
8010691c:	e8 97 b9 ff ff       	call   801022b8 <dirlink>
80106921:	83 c4 10             	add    $0x10,%esp
80106924:	85 c0                	test   %eax,%eax
80106926:	79 0d                	jns    80106935 <create+0x193>
      panic("create dots");
80106928:	83 ec 0c             	sub    $0xc,%esp
8010692b:	68 d9 94 10 80       	push   $0x801094d9
80106930:	e8 7e 9c ff ff       	call   801005b3 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106935:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106938:	8b 40 04             	mov    0x4(%eax),%eax
8010693b:	83 ec 04             	sub    $0x4,%esp
8010693e:	50                   	push   %eax
8010693f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106942:	50                   	push   %eax
80106943:	ff 75 f4             	push   -0xc(%ebp)
80106946:	e8 6d b9 ff ff       	call   801022b8 <dirlink>
8010694b:	83 c4 10             	add    $0x10,%esp
8010694e:	85 c0                	test   %eax,%eax
80106950:	79 0d                	jns    8010695f <create+0x1bd>
    panic("create: dirlink");
80106952:	83 ec 0c             	sub    $0xc,%esp
80106955:	68 e5 94 10 80       	push   $0x801094e5
8010695a:	e8 54 9c ff ff       	call   801005b3 <panic>

  iunlockput(dp);
8010695f:	83 ec 0c             	sub    $0xc,%esp
80106962:	ff 75 f4             	push   -0xc(%ebp)
80106965:	e8 e3 b2 ff ff       	call   80101c4d <iunlockput>
8010696a:	83 c4 10             	add    $0x10,%esp

  return ip;
8010696d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106970:	c9                   	leave
80106971:	c3                   	ret

80106972 <sys_open>:

int
sys_open(void)
{
80106972:	55                   	push   %ebp
80106973:	89 e5                	mov    %esp,%ebp
80106975:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106978:	83 ec 08             	sub    $0x8,%esp
8010697b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010697e:	50                   	push   %eax
8010697f:	6a 00                	push   $0x0
80106981:	e8 c4 f6 ff ff       	call   8010604a <argstr>
80106986:	83 c4 10             	add    $0x10,%esp
80106989:	85 c0                	test   %eax,%eax
8010698b:	78 15                	js     801069a2 <sys_open+0x30>
8010698d:	83 ec 08             	sub    $0x8,%esp
80106990:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106993:	50                   	push   %eax
80106994:	6a 01                	push   $0x1
80106996:	e8 1a f6 ff ff       	call   80105fb5 <argint>
8010699b:	83 c4 10             	add    $0x10,%esp
8010699e:	85 c0                	test   %eax,%eax
801069a0:	79 0a                	jns    801069ac <sys_open+0x3a>
    return -1;
801069a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a7:	e9 61 01 00 00       	jmp    80106b0d <sys_open+0x19b>

  begin_op();
801069ac:	e8 07 d0 ff ff       	call   801039b8 <begin_op>

  if(omode & O_CREATE){
801069b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069b4:	25 00 02 00 00       	and    $0x200,%eax
801069b9:	85 c0                	test   %eax,%eax
801069bb:	74 2a                	je     801069e7 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801069bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069c0:	6a 00                	push   $0x0
801069c2:	6a 00                	push   $0x0
801069c4:	6a 02                	push   $0x2
801069c6:	50                   	push   %eax
801069c7:	e8 d6 fd ff ff       	call   801067a2 <create>
801069cc:	83 c4 10             	add    $0x10,%esp
801069cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801069d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069d6:	75 75                	jne    80106a4d <sys_open+0xdb>
      end_op();
801069d8:	e8 67 d0 ff ff       	call   80103a44 <end_op>
      return -1;
801069dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069e2:	e9 26 01 00 00       	jmp    80106b0d <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801069e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069ea:	83 ec 0c             	sub    $0xc,%esp
801069ed:	50                   	push   %eax
801069ee:	e8 5c bb ff ff       	call   8010254f <namei>
801069f3:	83 c4 10             	add    $0x10,%esp
801069f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069fd:	75 0f                	jne    80106a0e <sys_open+0x9c>
      end_op();
801069ff:	e8 40 d0 ff ff       	call   80103a44 <end_op>
      return -1;
80106a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a09:	e9 ff 00 00 00       	jmp    80106b0d <sys_open+0x19b>
    }
    ilock(ip);
80106a0e:	83 ec 0c             	sub    $0xc,%esp
80106a11:	ff 75 f4             	push   -0xc(%ebp)
80106a14:	e8 03 b0 ff ff       	call   80101a1c <ilock>
80106a19:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a1f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106a23:	66 83 f8 01          	cmp    $0x1,%ax
80106a27:	75 24                	jne    80106a4d <sys_open+0xdb>
80106a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a2c:	85 c0                	test   %eax,%eax
80106a2e:	74 1d                	je     80106a4d <sys_open+0xdb>
      iunlockput(ip);
80106a30:	83 ec 0c             	sub    $0xc,%esp
80106a33:	ff 75 f4             	push   -0xc(%ebp)
80106a36:	e8 12 b2 ff ff       	call   80101c4d <iunlockput>
80106a3b:	83 c4 10             	add    $0x10,%esp
      end_op();
80106a3e:	e8 01 d0 ff ff       	call   80103a44 <end_op>
      return -1;
80106a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a48:	e9 c0 00 00 00       	jmp    80106b0d <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106a4d:	e8 d2 a5 ff ff       	call   80101024 <filealloc>
80106a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a59:	74 17                	je     80106a72 <sys_open+0x100>
80106a5b:	83 ec 0c             	sub    $0xc,%esp
80106a5e:	ff 75 f0             	push   -0x10(%ebp)
80106a61:	e8 35 f7 ff ff       	call   8010619b <fdalloc>
80106a66:	83 c4 10             	add    $0x10,%esp
80106a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106a6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106a70:	79 2e                	jns    80106aa0 <sys_open+0x12e>
    if(f)
80106a72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a76:	74 0e                	je     80106a86 <sys_open+0x114>
      fileclose(f);
80106a78:	83 ec 0c             	sub    $0xc,%esp
80106a7b:	ff 75 f0             	push   -0x10(%ebp)
80106a7e:	e8 5f a6 ff ff       	call   801010e2 <fileclose>
80106a83:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106a86:	83 ec 0c             	sub    $0xc,%esp
80106a89:	ff 75 f4             	push   -0xc(%ebp)
80106a8c:	e8 bc b1 ff ff       	call   80101c4d <iunlockput>
80106a91:	83 c4 10             	add    $0x10,%esp
    end_op();
80106a94:	e8 ab cf ff ff       	call   80103a44 <end_op>
    return -1;
80106a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9e:	eb 6d                	jmp    80106b0d <sys_open+0x19b>
  }
  iunlock(ip);
80106aa0:	83 ec 0c             	sub    $0xc,%esp
80106aa3:	ff 75 f4             	push   -0xc(%ebp)
80106aa6:	e8 84 b0 ff ff       	call   80101b2f <iunlock>
80106aab:	83 c4 10             	add    $0x10,%esp
  end_op();
80106aae:	e8 91 cf ff ff       	call   80103a44 <end_op>

  f->type = FD_INODE;
80106ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ab6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ac2:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ac8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ad2:	83 e0 01             	and    $0x1,%eax
80106ad5:	85 c0                	test   %eax,%eax
80106ad7:	0f 94 c0             	sete   %al
80106ada:	89 c2                	mov    %eax,%edx
80106adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106adf:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae5:	83 e0 01             	and    $0x1,%eax
80106ae8:	85 c0                	test   %eax,%eax
80106aea:	75 0a                	jne    80106af6 <sys_open+0x184>
80106aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106aef:	83 e0 02             	and    $0x2,%eax
80106af2:	85 c0                	test   %eax,%eax
80106af4:	74 07                	je     80106afd <sys_open+0x18b>
80106af6:	b8 01 00 00 00       	mov    $0x1,%eax
80106afb:	eb 05                	jmp    80106b02 <sys_open+0x190>
80106afd:	b8 00 00 00 00       	mov    $0x0,%eax
80106b02:	89 c2                	mov    %eax,%edx
80106b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b07:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106b0d:	c9                   	leave
80106b0e:	c3                   	ret

80106b0f <sys_mkdir>:

int
sys_mkdir(void)
{
80106b0f:	55                   	push   %ebp
80106b10:	89 e5                	mov    %esp,%ebp
80106b12:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106b15:	e8 9e ce ff ff       	call   801039b8 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106b1a:	83 ec 08             	sub    $0x8,%esp
80106b1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b20:	50                   	push   %eax
80106b21:	6a 00                	push   $0x0
80106b23:	e8 22 f5 ff ff       	call   8010604a <argstr>
80106b28:	83 c4 10             	add    $0x10,%esp
80106b2b:	85 c0                	test   %eax,%eax
80106b2d:	78 1b                	js     80106b4a <sys_mkdir+0x3b>
80106b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b32:	6a 00                	push   $0x0
80106b34:	6a 00                	push   $0x0
80106b36:	6a 01                	push   $0x1
80106b38:	50                   	push   %eax
80106b39:	e8 64 fc ff ff       	call   801067a2 <create>
80106b3e:	83 c4 10             	add    $0x10,%esp
80106b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b48:	75 0c                	jne    80106b56 <sys_mkdir+0x47>
    end_op();
80106b4a:	e8 f5 ce ff ff       	call   80103a44 <end_op>
    return -1;
80106b4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b54:	eb 18                	jmp    80106b6e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106b56:	83 ec 0c             	sub    $0xc,%esp
80106b59:	ff 75 f4             	push   -0xc(%ebp)
80106b5c:	e8 ec b0 ff ff       	call   80101c4d <iunlockput>
80106b61:	83 c4 10             	add    $0x10,%esp
  end_op();
80106b64:	e8 db ce ff ff       	call   80103a44 <end_op>
  return 0;
80106b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6e:	c9                   	leave
80106b6f:	c3                   	ret

80106b70 <sys_mknod>:

int
sys_mknod(void)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106b76:	e8 3d ce ff ff       	call   801039b8 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106b7b:	83 ec 08             	sub    $0x8,%esp
80106b7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b81:	50                   	push   %eax
80106b82:	6a 00                	push   $0x0
80106b84:	e8 c1 f4 ff ff       	call   8010604a <argstr>
80106b89:	83 c4 10             	add    $0x10,%esp
80106b8c:	85 c0                	test   %eax,%eax
80106b8e:	78 4f                	js     80106bdf <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80106b90:	83 ec 08             	sub    $0x8,%esp
80106b93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b96:	50                   	push   %eax
80106b97:	6a 01                	push   $0x1
80106b99:	e8 17 f4 ff ff       	call   80105fb5 <argint>
80106b9e:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	78 3a                	js     80106bdf <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80106ba5:	83 ec 08             	sub    $0x8,%esp
80106ba8:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106bab:	50                   	push   %eax
80106bac:	6a 02                	push   $0x2
80106bae:	e8 02 f4 ff ff       	call   80105fb5 <argint>
80106bb3:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106bb6:	85 c0                	test   %eax,%eax
80106bb8:	78 25                	js     80106bdf <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bbd:	0f bf c8             	movswl %ax,%ecx
80106bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bc3:	0f bf d0             	movswl %ax,%edx
80106bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bc9:	51                   	push   %ecx
80106bca:	52                   	push   %edx
80106bcb:	6a 03                	push   $0x3
80106bcd:	50                   	push   %eax
80106bce:	e8 cf fb ff ff       	call   801067a2 <create>
80106bd3:	83 c4 10             	add    $0x10,%esp
80106bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80106bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106bdd:	75 0c                	jne    80106beb <sys_mknod+0x7b>
    end_op();
80106bdf:	e8 60 ce ff ff       	call   80103a44 <end_op>
    return -1;
80106be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be9:	eb 18                	jmp    80106c03 <sys_mknod+0x93>
  }
  iunlockput(ip);
80106beb:	83 ec 0c             	sub    $0xc,%esp
80106bee:	ff 75 f4             	push   -0xc(%ebp)
80106bf1:	e8 57 b0 ff ff       	call   80101c4d <iunlockput>
80106bf6:	83 c4 10             	add    $0x10,%esp
  end_op();
80106bf9:	e8 46 ce ff ff       	call   80103a44 <end_op>
  return 0;
80106bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c03:	c9                   	leave
80106c04:	c3                   	ret

80106c05 <sys_chdir>:

int
sys_chdir(void)
{
80106c05:	55                   	push   %ebp
80106c06:	89 e5                	mov    %esp,%ebp
80106c08:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106c0b:	e8 0b db ff ff       	call   8010471b <myproc>
80106c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106c13:	e8 a0 cd ff ff       	call   801039b8 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106c18:	83 ec 08             	sub    $0x8,%esp
80106c1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c1e:	50                   	push   %eax
80106c1f:	6a 00                	push   $0x0
80106c21:	e8 24 f4 ff ff       	call   8010604a <argstr>
80106c26:	83 c4 10             	add    $0x10,%esp
80106c29:	85 c0                	test   %eax,%eax
80106c2b:	78 18                	js     80106c45 <sys_chdir+0x40>
80106c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	50                   	push   %eax
80106c34:	e8 16 b9 ff ff       	call   8010254f <namei>
80106c39:	83 c4 10             	add    $0x10,%esp
80106c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c43:	75 0c                	jne    80106c51 <sys_chdir+0x4c>
    end_op();
80106c45:	e8 fa cd ff ff       	call   80103a44 <end_op>
    return -1;
80106c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c4f:	eb 68                	jmp    80106cb9 <sys_chdir+0xb4>
  }
  ilock(ip);
80106c51:	83 ec 0c             	sub    $0xc,%esp
80106c54:	ff 75 f0             	push   -0x10(%ebp)
80106c57:	e8 c0 ad ff ff       	call   80101a1c <ilock>
80106c5c:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c62:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106c66:	66 83 f8 01          	cmp    $0x1,%ax
80106c6a:	74 1a                	je     80106c86 <sys_chdir+0x81>
    iunlockput(ip);
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	ff 75 f0             	push   -0x10(%ebp)
80106c72:	e8 d6 af ff ff       	call   80101c4d <iunlockput>
80106c77:	83 c4 10             	add    $0x10,%esp
    end_op();
80106c7a:	e8 c5 cd ff ff       	call   80103a44 <end_op>
    return -1;
80106c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c84:	eb 33                	jmp    80106cb9 <sys_chdir+0xb4>
  }
  iunlock(ip);
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	ff 75 f0             	push   -0x10(%ebp)
80106c8c:	e8 9e ae ff ff       	call   80101b2f <iunlock>
80106c91:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80106c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c97:	8b 40 68             	mov    0x68(%eax),%eax
80106c9a:	83 ec 0c             	sub    $0xc,%esp
80106c9d:	50                   	push   %eax
80106c9e:	e8 da ae ff ff       	call   80101b7d <iput>
80106ca3:	83 c4 10             	add    $0x10,%esp
  end_op();
80106ca6:	e8 99 cd ff ff       	call   80103a44 <end_op>
  curproc->cwd = ip;
80106cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cae:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106cb1:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cb9:	c9                   	leave
80106cba:	c3                   	ret

80106cbb <sys_exec>:

int
sys_exec(void)
{
80106cbb:	55                   	push   %ebp
80106cbc:	89 e5                	mov    %esp,%ebp
80106cbe:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106cc4:	83 ec 08             	sub    $0x8,%esp
80106cc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cca:	50                   	push   %eax
80106ccb:	6a 00                	push   $0x0
80106ccd:	e8 78 f3 ff ff       	call   8010604a <argstr>
80106cd2:	83 c4 10             	add    $0x10,%esp
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	78 18                	js     80106cf1 <sys_exec+0x36>
80106cd9:	83 ec 08             	sub    $0x8,%esp
80106cdc:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106ce2:	50                   	push   %eax
80106ce3:	6a 01                	push   $0x1
80106ce5:	e8 cb f2 ff ff       	call   80105fb5 <argint>
80106cea:	83 c4 10             	add    $0x10,%esp
80106ced:	85 c0                	test   %eax,%eax
80106cef:	79 0a                	jns    80106cfb <sys_exec+0x40>
    return -1;
80106cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf6:	e9 c6 00 00 00       	jmp    80106dc1 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106cfb:	83 ec 04             	sub    $0x4,%esp
80106cfe:	68 80 00 00 00       	push   $0x80
80106d03:	6a 00                	push   $0x0
80106d05:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106d0b:	50                   	push   %eax
80106d0c:	e8 79 ef ff ff       	call   80105c8a <memset>
80106d11:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106d14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d1e:	83 f8 1f             	cmp    $0x1f,%eax
80106d21:	76 0a                	jbe    80106d2d <sys_exec+0x72>
      return -1;
80106d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d28:	e9 94 00 00 00       	jmp    80106dc1 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d30:	c1 e0 02             	shl    $0x2,%eax
80106d33:	89 c2                	mov    %eax,%edx
80106d35:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106d3b:	01 c2                	add    %eax,%edx
80106d3d:	83 ec 08             	sub    $0x8,%esp
80106d40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106d46:	50                   	push   %eax
80106d47:	52                   	push   %edx
80106d48:	e8 c7 f1 ff ff       	call   80105f14 <fetchint>
80106d4d:	83 c4 10             	add    $0x10,%esp
80106d50:	85 c0                	test   %eax,%eax
80106d52:	79 07                	jns    80106d5b <sys_exec+0xa0>
      return -1;
80106d54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d59:	eb 66                	jmp    80106dc1 <sys_exec+0x106>
    if(uarg == 0){
80106d5b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106d61:	85 c0                	test   %eax,%eax
80106d63:	75 27                	jne    80106d8c <sys_exec+0xd1>
      argv[i] = 0;
80106d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d68:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106d6f:	00 00 00 00 
      break;
80106d73:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d77:	83 ec 08             	sub    $0x8,%esp
80106d7a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106d80:	52                   	push   %edx
80106d81:	50                   	push   %eax
80106d82:	e8 40 9e ff ff       	call   80100bc7 <exec>
80106d87:	83 c4 10             	add    $0x10,%esp
80106d8a:	eb 35                	jmp    80106dc1 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80106d8c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d95:	c1 e2 02             	shl    $0x2,%edx
80106d98:	01 c2                	add    %eax,%edx
80106d9a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106da0:	83 ec 08             	sub    $0x8,%esp
80106da3:	52                   	push   %edx
80106da4:	50                   	push   %eax
80106da5:	e8 a9 f1 ff ff       	call   80105f53 <fetchstr>
80106daa:	83 c4 10             	add    $0x10,%esp
80106dad:	85 c0                	test   %eax,%eax
80106daf:	79 07                	jns    80106db8 <sys_exec+0xfd>
      return -1;
80106db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106db6:	eb 09                	jmp    80106dc1 <sys_exec+0x106>
  for(i=0;; i++){
80106db8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106dbc:	e9 5a ff ff ff       	jmp    80106d1b <sys_exec+0x60>
}
80106dc1:	c9                   	leave
80106dc2:	c3                   	ret

80106dc3 <sys_pipe>:

int
sys_pipe(void)
{
80106dc3:	55                   	push   %ebp
80106dc4:	89 e5                	mov    %esp,%ebp
80106dc6:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106dc9:	83 ec 04             	sub    $0x4,%esp
80106dcc:	6a 08                	push   $0x8
80106dce:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106dd1:	50                   	push   %eax
80106dd2:	6a 00                	push   $0x0
80106dd4:	e8 09 f2 ff ff       	call   80105fe2 <argptr>
80106dd9:	83 c4 10             	add    $0x10,%esp
80106ddc:	85 c0                	test   %eax,%eax
80106dde:	79 0a                	jns    80106dea <sys_pipe+0x27>
    return -1;
80106de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106de5:	e9 ae 00 00 00       	jmp    80106e98 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80106dea:	83 ec 08             	sub    $0x8,%esp
80106ded:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106df0:	50                   	push   %eax
80106df1:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106df4:	50                   	push   %eax
80106df5:	e8 5e d4 ff ff       	call   80104258 <pipealloc>
80106dfa:	83 c4 10             	add    $0x10,%esp
80106dfd:	85 c0                	test   %eax,%eax
80106dff:	79 0a                	jns    80106e0b <sys_pipe+0x48>
    return -1;
80106e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e06:	e9 8d 00 00 00       	jmp    80106e98 <sys_pipe+0xd5>
  fd0 = -1;
80106e0b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e15:	83 ec 0c             	sub    $0xc,%esp
80106e18:	50                   	push   %eax
80106e19:	e8 7d f3 ff ff       	call   8010619b <fdalloc>
80106e1e:	83 c4 10             	add    $0x10,%esp
80106e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e28:	78 18                	js     80106e42 <sys_pipe+0x7f>
80106e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e2d:	83 ec 0c             	sub    $0xc,%esp
80106e30:	50                   	push   %eax
80106e31:	e8 65 f3 ff ff       	call   8010619b <fdalloc>
80106e36:	83 c4 10             	add    $0x10,%esp
80106e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e40:	79 3e                	jns    80106e80 <sys_pipe+0xbd>
    if(fd0 >= 0)
80106e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e46:	78 13                	js     80106e5b <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106e48:	e8 ce d8 ff ff       	call   8010471b <myproc>
80106e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e50:	83 c2 08             	add    $0x8,%edx
80106e53:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106e5a:	00 
    fileclose(rf);
80106e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106e5e:	83 ec 0c             	sub    $0xc,%esp
80106e61:	50                   	push   %eax
80106e62:	e8 7b a2 ff ff       	call   801010e2 <fileclose>
80106e67:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e6d:	83 ec 0c             	sub    $0xc,%esp
80106e70:	50                   	push   %eax
80106e71:	e8 6c a2 ff ff       	call   801010e2 <fileclose>
80106e76:	83 c4 10             	add    $0x10,%esp
    return -1;
80106e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e7e:	eb 18                	jmp    80106e98 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80106e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e86:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106e8b:	8d 50 04             	lea    0x4(%eax),%edx
80106e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e91:	89 02                	mov    %eax,(%edx)
  return 0;
80106e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e98:	c9                   	leave
80106e99:	c3                   	ret

80106e9a <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106e9a:	55                   	push   %ebp
80106e9b:	89 e5                	mov    %esp,%ebp
80106e9d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106ea0:	e8 bc db ff ff       	call   80104a61 <fork>
}
80106ea5:	c9                   	leave
80106ea6:	c3                   	ret

80106ea7 <sys_exit>:

int
sys_exit(void)
{
80106ea7:	55                   	push   %ebp
80106ea8:	89 e5                	mov    %esp,%ebp
80106eaa:	83 ec 08             	sub    $0x8,%esp
  exit();
80106ead:	e8 5b dd ff ff       	call   80104c0d <exit>
  return 0;  // not reached
80106eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106eb7:	c9                   	leave
80106eb8:	c3                   	ret

80106eb9 <sys_wait>:

int
sys_wait(void)
{
80106eb9:	55                   	push   %ebp
80106eba:	89 e5                	mov    %esp,%ebp
80106ebc:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106ebf:	e8 6c de ff ff       	call   80104d30 <wait>
}
80106ec4:	c9                   	leave
80106ec5:	c3                   	ret

80106ec6 <sys_kill>:

int
sys_kill(void)
{
80106ec6:	55                   	push   %ebp
80106ec7:	89 e5                	mov    %esp,%ebp
80106ec9:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106ecc:	83 ec 08             	sub    $0x8,%esp
80106ecf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ed2:	50                   	push   %eax
80106ed3:	6a 00                	push   $0x0
80106ed5:	e8 db f0 ff ff       	call   80105fb5 <argint>
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	85 c0                	test   %eax,%eax
80106edf:	79 07                	jns    80106ee8 <sys_kill+0x22>
    return -1;
80106ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee6:	eb 0f                	jmp    80106ef7 <sys_kill+0x31>
  return kill(pid);
80106ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eeb:	83 ec 0c             	sub    $0xc,%esp
80106eee:	50                   	push   %eax
80106eef:	e8 e7 e7 ff ff       	call   801056db <kill>
80106ef4:	83 c4 10             	add    $0x10,%esp
}
80106ef7:	c9                   	leave
80106ef8:	c3                   	ret

80106ef9 <sys_getpid>:

int
sys_getpid(void)
{
80106ef9:	55                   	push   %ebp
80106efa:	89 e5                	mov    %esp,%ebp
80106efc:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106eff:	e8 17 d8 ff ff       	call   8010471b <myproc>
80106f04:	8b 40 10             	mov    0x10(%eax),%eax
}
80106f07:	c9                   	leave
80106f08:	c3                   	ret

80106f09 <sys_sbrk>:

int
sys_sbrk(void)
{
80106f09:	55                   	push   %ebp
80106f0a:	89 e5                	mov    %esp,%ebp
80106f0c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106f0f:	83 ec 08             	sub    $0x8,%esp
80106f12:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f15:	50                   	push   %eax
80106f16:	6a 00                	push   $0x0
80106f18:	e8 98 f0 ff ff       	call   80105fb5 <argint>
80106f1d:	83 c4 10             	add    $0x10,%esp
80106f20:	85 c0                	test   %eax,%eax
80106f22:	79 07                	jns    80106f2b <sys_sbrk+0x22>
    return -1;
80106f24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f29:	eb 27                	jmp    80106f52 <sys_sbrk+0x49>
  addr = myproc()->sz;
80106f2b:	e8 eb d7 ff ff       	call   8010471b <myproc>
80106f30:	8b 00                	mov    (%eax),%eax
80106f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f38:	83 ec 0c             	sub    $0xc,%esp
80106f3b:	50                   	push   %eax
80106f3c:	e8 85 da ff ff       	call   801049c6 <growproc>
80106f41:	83 c4 10             	add    $0x10,%esp
80106f44:	85 c0                	test   %eax,%eax
80106f46:	79 07                	jns    80106f4f <sys_sbrk+0x46>
    return -1;
80106f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f4d:	eb 03                	jmp    80106f52 <sys_sbrk+0x49>
  return addr;
80106f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106f52:	c9                   	leave
80106f53:	c3                   	ret

80106f54 <sys_sleep>:

int
sys_sleep(void)
{
80106f54:	55                   	push   %ebp
80106f55:	89 e5                	mov    %esp,%ebp
80106f57:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106f5a:	83 ec 08             	sub    $0x8,%esp
80106f5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f60:	50                   	push   %eax
80106f61:	6a 00                	push   $0x0
80106f63:	e8 4d f0 ff ff       	call   80105fb5 <argint>
80106f68:	83 c4 10             	add    $0x10,%esp
80106f6b:	85 c0                	test   %eax,%eax
80106f6d:	79 07                	jns    80106f76 <sys_sleep+0x22>
    return -1;
80106f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f74:	eb 76                	jmp    80106fec <sys_sleep+0x98>
  acquire(&tickslock);
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	68 20 6e 11 80       	push   $0x80116e20
80106f7e:	e8 81 ea ff ff       	call   80105a04 <acquire>
80106f83:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106f86:	a1 54 6e 11 80       	mov    0x80116e54,%eax
80106f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106f8e:	eb 38                	jmp    80106fc8 <sys_sleep+0x74>
    if(myproc()->killed){
80106f90:	e8 86 d7 ff ff       	call   8010471b <myproc>
80106f95:	8b 40 24             	mov    0x24(%eax),%eax
80106f98:	85 c0                	test   %eax,%eax
80106f9a:	74 17                	je     80106fb3 <sys_sleep+0x5f>
      release(&tickslock);
80106f9c:	83 ec 0c             	sub    $0xc,%esp
80106f9f:	68 20 6e 11 80       	push   $0x80116e20
80106fa4:	e8 c9 ea ff ff       	call   80105a72 <release>
80106fa9:	83 c4 10             	add    $0x10,%esp
      return -1;
80106fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fb1:	eb 39                	jmp    80106fec <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80106fb3:	83 ec 08             	sub    $0x8,%esp
80106fb6:	68 20 6e 11 80       	push   $0x80116e20
80106fbb:	68 54 6e 11 80       	push   $0x80116e54
80106fc0:	e8 f5 e5 ff ff       	call   801055ba <sleep>
80106fc5:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106fc8:	a1 54 6e 11 80       	mov    0x80116e54,%eax
80106fcd:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fd3:	39 d0                	cmp    %edx,%eax
80106fd5:	72 b9                	jb     80106f90 <sys_sleep+0x3c>
  }
  release(&tickslock);
80106fd7:	83 ec 0c             	sub    $0xc,%esp
80106fda:	68 20 6e 11 80       	push   $0x80116e20
80106fdf:	e8 8e ea ff ff       	call   80105a72 <release>
80106fe4:	83 c4 10             	add    $0x10,%esp
  return 0;
80106fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106fec:	c9                   	leave
80106fed:	c3                   	ret

80106fee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106fee:	55                   	push   %ebp
80106fef:	89 e5                	mov    %esp,%ebp
80106ff1:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106ff4:	83 ec 0c             	sub    $0xc,%esp
80106ff7:	68 20 6e 11 80       	push   $0x80116e20
80106ffc:	e8 03 ea ff ff       	call   80105a04 <acquire>
80107001:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80107004:	a1 54 6e 11 80       	mov    0x80116e54,%eax
80107009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	68 20 6e 11 80       	push   $0x80116e20
80107014:	e8 59 ea ff ff       	call   80105a72 <release>
80107019:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010701c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010701f:	c9                   	leave
80107020:	c3                   	ret

80107021 <sys_clone>:

int sys_clone(void){ int f,a,s; if(argint(0,&f)<0||argint(1,&a)<0||argint(2,&s)<0) return -1; return clone((void(*)(void*))f,(void*)a,(void*)s); }
80107021:	55                   	push   %ebp
80107022:	89 e5                	mov    %esp,%ebp
80107024:	83 ec 18             	sub    $0x18,%esp
80107027:	83 ec 08             	sub    $0x8,%esp
8010702a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010702d:	50                   	push   %eax
8010702e:	6a 00                	push   $0x0
80107030:	e8 80 ef ff ff       	call   80105fb5 <argint>
80107035:	83 c4 10             	add    $0x10,%esp
80107038:	85 c0                	test   %eax,%eax
8010703a:	78 2a                	js     80107066 <sys_clone+0x45>
8010703c:	83 ec 08             	sub    $0x8,%esp
8010703f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107042:	50                   	push   %eax
80107043:	6a 01                	push   $0x1
80107045:	e8 6b ef ff ff       	call   80105fb5 <argint>
8010704a:	83 c4 10             	add    $0x10,%esp
8010704d:	85 c0                	test   %eax,%eax
8010704f:	78 15                	js     80107066 <sys_clone+0x45>
80107051:	83 ec 08             	sub    $0x8,%esp
80107054:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107057:	50                   	push   %eax
80107058:	6a 02                	push   $0x2
8010705a:	e8 56 ef ff ff       	call   80105fb5 <argint>
8010705f:	83 c4 10             	add    $0x10,%esp
80107062:	85 c0                	test   %eax,%eax
80107064:	79 07                	jns    8010706d <sys_clone+0x4c>
80107066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010706b:	eb 1b                	jmp    80107088 <sys_clone+0x67>
8010706d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107070:	89 c1                	mov    %eax,%ecx
80107072:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107075:	89 c2                	mov    %eax,%edx
80107077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010707a:	83 ec 04             	sub    $0x4,%esp
8010707d:	51                   	push   %ecx
8010707e:	52                   	push   %edx
8010707f:	50                   	push   %eax
80107080:	e8 ce dd ff ff       	call   80104e53 <clone>
80107085:	83 c4 10             	add    $0x10,%esp
80107088:	c9                   	leave
80107089:	c3                   	ret

8010708a <sys_join>:
int sys_join(void){ int wanted; char **p; if(argint(0,&wanted)<0 || argptr(1,(char**)&p,sizeof(void*))<0) return -1; return join(wanted,(void**)p); }
8010708a:	55                   	push   %ebp
8010708b:	89 e5                	mov    %esp,%ebp
8010708d:	83 ec 18             	sub    $0x18,%esp
80107090:	83 ec 08             	sub    $0x8,%esp
80107093:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107096:	50                   	push   %eax
80107097:	6a 00                	push   $0x0
80107099:	e8 17 ef ff ff       	call   80105fb5 <argint>
8010709e:	83 c4 10             	add    $0x10,%esp
801070a1:	85 c0                	test   %eax,%eax
801070a3:	78 17                	js     801070bc <sys_join+0x32>
801070a5:	83 ec 04             	sub    $0x4,%esp
801070a8:	6a 04                	push   $0x4
801070aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070ad:	50                   	push   %eax
801070ae:	6a 01                	push   $0x1
801070b0:	e8 2d ef ff ff       	call   80105fe2 <argptr>
801070b5:	83 c4 10             	add    $0x10,%esp
801070b8:	85 c0                	test   %eax,%eax
801070ba:	79 07                	jns    801070c3 <sys_join+0x39>
801070bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070c1:	eb 13                	jmp    801070d6 <sys_join+0x4c>
801070c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801070c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c9:	83 ec 08             	sub    $0x8,%esp
801070cc:	52                   	push   %edx
801070cd:	50                   	push   %eax
801070ce:	e8 44 e0 ff ff       	call   80105117 <join>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	c9                   	leave
801070d7:	c3                   	ret

801070d8 <sys_thread_exit>:
int sys_thread_exit(void){ thread_exit(); return 0; }
801070d8:	55                   	push   %ebp
801070d9:	89 e5                	mov    %esp,%ebp
801070db:	83 ec 08             	sub    $0x8,%esp
801070de:	e8 5b df ff ff       	call   8010503e <thread_exit>

801070e3 <sys_randconfig>:
int sys_randconfig(void){ int seed,pct; if(argint(0,&seed)<0||argint(1,&pct)<0) return -1; random_config(seed,pct); return 0; }
801070e3:	55                   	push   %ebp
801070e4:	89 e5                	mov    %esp,%ebp
801070e6:	83 ec 18             	sub    $0x18,%esp
801070e9:	83 ec 08             	sub    $0x8,%esp
801070ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070ef:	50                   	push   %eax
801070f0:	6a 00                	push   $0x0
801070f2:	e8 be ee ff ff       	call   80105fb5 <argint>
801070f7:	83 c4 10             	add    $0x10,%esp
801070fa:	85 c0                	test   %eax,%eax
801070fc:	78 15                	js     80107113 <sys_randconfig+0x30>
801070fe:	83 ec 08             	sub    $0x8,%esp
80107101:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107104:	50                   	push   %eax
80107105:	6a 01                	push   $0x1
80107107:	e8 a9 ee ff ff       	call   80105fb5 <argint>
8010710c:	83 c4 10             	add    $0x10,%esp
8010710f:	85 c0                	test   %eax,%eax
80107111:	79 07                	jns    8010711a <sys_randconfig+0x37>
80107113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107118:	eb 18                	jmp    80107132 <sys_randconfig+0x4f>
8010711a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010711d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107120:	83 ec 08             	sub    $0x8,%esp
80107123:	50                   	push   %eax
80107124:	52                   	push   %edx
80107125:	e8 5a e1 ff ff       	call   80105284 <random_config>
8010712a:	83 c4 10             	add    $0x10,%esp
8010712d:	b8 00 00 00 00       	mov    $0x0,%eax
80107132:	c9                   	leave
80107133:	c3                   	ret

80107134 <sys_yield>:
int sys_yield(void){ yield(); return 0; }
80107134:	55                   	push   %ebp
80107135:	89 e5                	mov    %esp,%ebp
80107137:	83 ec 08             	sub    $0x8,%esp
8010713a:	e8 fb e3 ff ff       	call   8010553a <yield>
8010713f:	b8 00 00 00 00       	mov    $0x0,%eax
80107144:	c9                   	leave
80107145:	c3                   	ret

80107146 <sys_lock_create>:
int sys_lock_create(void){ return klock_create(); }
80107146:	55                   	push   %ebp
80107147:	89 e5                	mov    %esp,%ebp
80107149:	83 ec 08             	sub    $0x8,%esp
8010714c:	e8 ff bd ff ff       	call   80102f50 <klock_create>
80107151:	c9                   	leave
80107152:	c3                   	ret

80107153 <sys_lock_acquire>:
int sys_lock_acquire(void){ int id; if(argint(0,&id)<0) return -1; return klock_acquire(id); }
80107153:	55                   	push   %ebp
80107154:	89 e5                	mov    %esp,%ebp
80107156:	83 ec 18             	sub    $0x18,%esp
80107159:	83 ec 08             	sub    $0x8,%esp
8010715c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010715f:	50                   	push   %eax
80107160:	6a 00                	push   $0x0
80107162:	e8 4e ee ff ff       	call   80105fb5 <argint>
80107167:	83 c4 10             	add    $0x10,%esp
8010716a:	85 c0                	test   %eax,%eax
8010716c:	79 07                	jns    80107175 <sys_lock_acquire+0x22>
8010716e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107173:	eb 0f                	jmp    80107184 <sys_lock_acquire+0x31>
80107175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107178:	83 ec 0c             	sub    $0xc,%esp
8010717b:	50                   	push   %eax
8010717c:	e8 e6 bd ff ff       	call   80102f67 <klock_acquire>
80107181:	83 c4 10             	add    $0x10,%esp
80107184:	c9                   	leave
80107185:	c3                   	ret

80107186 <sys_lock_release>:
int sys_lock_release(void){ int id; if(argint(0,&id)<0) return -1; return klock_release(id); }
80107186:	55                   	push   %ebp
80107187:	89 e5                	mov    %esp,%ebp
80107189:	83 ec 18             	sub    $0x18,%esp
8010718c:	83 ec 08             	sub    $0x8,%esp
8010718f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107192:	50                   	push   %eax
80107193:	6a 00                	push   $0x0
80107195:	e8 1b ee ff ff       	call   80105fb5 <argint>
8010719a:	83 c4 10             	add    $0x10,%esp
8010719d:	85 c0                	test   %eax,%eax
8010719f:	79 07                	jns    801071a8 <sys_lock_release+0x22>
801071a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071a6:	eb 0f                	jmp    801071b7 <sys_lock_release+0x31>
801071a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ab:	83 ec 0c             	sub    $0xc,%esp
801071ae:	50                   	push   %eax
801071af:	e8 af be ff ff       	call   80103063 <klock_release>
801071b4:	83 c4 10             	add    $0x10,%esp
801071b7:	c9                   	leave
801071b8:	c3                   	ret

801071b9 <sys_sem_create>:
int sys_sem_create(void){ int v; if(argint(0,&v)<0) return -1; return ksem_create(v); }
801071b9:	55                   	push   %ebp
801071ba:	89 e5                	mov    %esp,%ebp
801071bc:	83 ec 18             	sub    $0x18,%esp
801071bf:	83 ec 08             	sub    $0x8,%esp
801071c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071c5:	50                   	push   %eax
801071c6:	6a 00                	push   $0x0
801071c8:	e8 e8 ed ff ff       	call   80105fb5 <argint>
801071cd:	83 c4 10             	add    $0x10,%esp
801071d0:	85 c0                	test   %eax,%eax
801071d2:	79 07                	jns    801071db <sys_sem_create+0x22>
801071d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071d9:	eb 0f                	jmp    801071ea <sys_sem_create+0x31>
801071db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071de:	83 ec 0c             	sub    $0xc,%esp
801071e1:	50                   	push   %eax
801071e2:	e8 48 bf ff ff       	call   8010312f <ksem_create>
801071e7:	83 c4 10             	add    $0x10,%esp
801071ea:	c9                   	leave
801071eb:	c3                   	ret

801071ec <sys_sem_wait>:
int sys_sem_wait(void){ int id; if(argint(0,&id)<0) return -1; return ksem_wait(id); }
801071ec:	55                   	push   %ebp
801071ed:	89 e5                	mov    %esp,%ebp
801071ef:	83 ec 18             	sub    $0x18,%esp
801071f2:	83 ec 08             	sub    $0x8,%esp
801071f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071f8:	50                   	push   %eax
801071f9:	6a 00                	push   $0x0
801071fb:	e8 b5 ed ff ff       	call   80105fb5 <argint>
80107200:	83 c4 10             	add    $0x10,%esp
80107203:	85 c0                	test   %eax,%eax
80107205:	79 07                	jns    8010720e <sys_sem_wait+0x22>
80107207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010720c:	eb 0f                	jmp    8010721d <sys_sem_wait+0x31>
8010720e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107211:	83 ec 0c             	sub    $0xc,%esp
80107214:	50                   	push   %eax
80107215:	e8 3a bf ff ff       	call   80103154 <ksem_wait>
8010721a:	83 c4 10             	add    $0x10,%esp
8010721d:	c9                   	leave
8010721e:	c3                   	ret

8010721f <sys_sem_post>:
int sys_sem_post(void){ int id; if(argint(0,&id)<0) return -1; return ksem_post(id); }
8010721f:	55                   	push   %ebp
80107220:	89 e5                	mov    %esp,%ebp
80107222:	83 ec 18             	sub    $0x18,%esp
80107225:	83 ec 08             	sub    $0x8,%esp
80107228:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010722b:	50                   	push   %eax
8010722c:	6a 00                	push   $0x0
8010722e:	e8 82 ed ff ff       	call   80105fb5 <argint>
80107233:	83 c4 10             	add    $0x10,%esp
80107236:	85 c0                	test   %eax,%eax
80107238:	79 07                	jns    80107241 <sys_sem_post+0x22>
8010723a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010723f:	eb 0f                	jmp    80107250 <sys_sem_post+0x31>
80107241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107244:	83 ec 0c             	sub    $0xc,%esp
80107247:	50                   	push   %eax
80107248:	e8 f9 bf ff ff       	call   80103246 <ksem_post>
8010724d:	83 c4 10             	add    $0x10,%esp
80107250:	c9                   	leave
80107251:	c3                   	ret

80107252 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107252:	1e                   	push   %ds
  pushl %es
80107253:	06                   	push   %es
  pushl %fs
80107254:	0f a0                	push   %fs
  pushl %gs
80107256:	0f a8                	push   %gs
  pushal
80107258:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107259:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010725d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010725f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107261:	54                   	push   %esp
  call trap
80107262:	e8 d7 01 00 00       	call   8010743e <trap>
  addl $4, %esp
80107267:	83 c4 04             	add    $0x4,%esp

8010726a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010726a:	61                   	popa
  popl %gs
8010726b:	0f a9                	pop    %gs
  popl %fs
8010726d:	0f a1                	pop    %fs
  popl %es
8010726f:	07                   	pop    %es
  popl %ds
80107270:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107271:	83 c4 08             	add    $0x8,%esp
  iret
80107274:	cf                   	iret

80107275 <lidt>:
{
80107275:	55                   	push   %ebp
80107276:	89 e5                	mov    %esp,%ebp
80107278:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010727b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727e:	83 e8 01             	sub    $0x1,%eax
80107281:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107285:	8b 45 08             	mov    0x8(%ebp),%eax
80107288:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010728c:	8b 45 08             	mov    0x8(%ebp),%eax
8010728f:	c1 e8 10             	shr    $0x10,%eax
80107292:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80107296:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107299:	0f 01 18             	lidtl  (%eax)
}
8010729c:	90                   	nop
8010729d:	c9                   	leave
8010729e:	c3                   	ret

8010729f <rcr2>:

static inline uint
rcr2(void)
{
8010729f:	55                   	push   %ebp
801072a0:	89 e5                	mov    %esp,%ebp
801072a2:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801072a5:	0f 20 d0             	mov    %cr2,%eax
801072a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801072ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801072ae:	c9                   	leave
801072af:	c3                   	ret

801072b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801072b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801072bd:	e9 c3 00 00 00       	jmp    80107385 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801072c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c5:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
801072cc:	89 c2                	mov    %eax,%edx
801072ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d1:	66 89 14 c5 20 66 11 	mov    %dx,-0x7fee99e0(,%eax,8)
801072d8:	80 
801072d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072dc:	66 c7 04 c5 22 66 11 	movw   $0x8,-0x7fee99de(,%eax,8)
801072e3:	80 08 00 
801072e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e9:	0f b6 14 c5 24 66 11 	movzbl -0x7fee99dc(,%eax,8),%edx
801072f0:	80 
801072f1:	83 e2 e0             	and    $0xffffffe0,%edx
801072f4:	88 14 c5 24 66 11 80 	mov    %dl,-0x7fee99dc(,%eax,8)
801072fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072fe:	0f b6 14 c5 24 66 11 	movzbl -0x7fee99dc(,%eax,8),%edx
80107305:	80 
80107306:	83 e2 1f             	and    $0x1f,%edx
80107309:	88 14 c5 24 66 11 80 	mov    %dl,-0x7fee99dc(,%eax,8)
80107310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107313:	0f b6 14 c5 25 66 11 	movzbl -0x7fee99db(,%eax,8),%edx
8010731a:	80 
8010731b:	83 e2 f0             	and    $0xfffffff0,%edx
8010731e:	83 ca 0e             	or     $0xe,%edx
80107321:	88 14 c5 25 66 11 80 	mov    %dl,-0x7fee99db(,%eax,8)
80107328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732b:	0f b6 14 c5 25 66 11 	movzbl -0x7fee99db(,%eax,8),%edx
80107332:	80 
80107333:	83 e2 ef             	and    $0xffffffef,%edx
80107336:	88 14 c5 25 66 11 80 	mov    %dl,-0x7fee99db(,%eax,8)
8010733d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107340:	0f b6 14 c5 25 66 11 	movzbl -0x7fee99db(,%eax,8),%edx
80107347:	80 
80107348:	83 e2 9f             	and    $0xffffff9f,%edx
8010734b:	88 14 c5 25 66 11 80 	mov    %dl,-0x7fee99db(,%eax,8)
80107352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107355:	0f b6 14 c5 25 66 11 	movzbl -0x7fee99db(,%eax,8),%edx
8010735c:	80 
8010735d:	83 ca 80             	or     $0xffffff80,%edx
80107360:	88 14 c5 25 66 11 80 	mov    %dl,-0x7fee99db(,%eax,8)
80107367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736a:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
80107371:	c1 e8 10             	shr    $0x10,%eax
80107374:	89 c2                	mov    %eax,%edx
80107376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107379:	66 89 14 c5 26 66 11 	mov    %dx,-0x7fee99da(,%eax,8)
80107380:	80 
  for(i = 0; i < 256; i++)
80107381:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107385:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010738c:	0f 8e 30 ff ff ff    	jle    801072c2 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107392:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80107397:	66 a3 20 68 11 80    	mov    %ax,0x80116820
8010739d:	66 c7 05 22 68 11 80 	movw   $0x8,0x80116822
801073a4:	08 00 
801073a6:	0f b6 05 24 68 11 80 	movzbl 0x80116824,%eax
801073ad:	83 e0 e0             	and    $0xffffffe0,%eax
801073b0:	a2 24 68 11 80       	mov    %al,0x80116824
801073b5:	0f b6 05 24 68 11 80 	movzbl 0x80116824,%eax
801073bc:	83 e0 1f             	and    $0x1f,%eax
801073bf:	a2 24 68 11 80       	mov    %al,0x80116824
801073c4:	0f b6 05 25 68 11 80 	movzbl 0x80116825,%eax
801073cb:	83 c8 0f             	or     $0xf,%eax
801073ce:	a2 25 68 11 80       	mov    %al,0x80116825
801073d3:	0f b6 05 25 68 11 80 	movzbl 0x80116825,%eax
801073da:	83 e0 ef             	and    $0xffffffef,%eax
801073dd:	a2 25 68 11 80       	mov    %al,0x80116825
801073e2:	0f b6 05 25 68 11 80 	movzbl 0x80116825,%eax
801073e9:	83 c8 60             	or     $0x60,%eax
801073ec:	a2 25 68 11 80       	mov    %al,0x80116825
801073f1:	0f b6 05 25 68 11 80 	movzbl 0x80116825,%eax
801073f8:	83 c8 80             	or     $0xffffff80,%eax
801073fb:	a2 25 68 11 80       	mov    %al,0x80116825
80107400:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80107405:	c1 e8 10             	shr    $0x10,%eax
80107408:	66 a3 26 68 11 80    	mov    %ax,0x80116826

  initlock(&tickslock, "time");
8010740e:	83 ec 08             	sub    $0x8,%esp
80107411:	68 f8 94 10 80       	push   $0x801094f8
80107416:	68 20 6e 11 80       	push   $0x80116e20
8010741b:	e8 c2 e5 ff ff       	call   801059e2 <initlock>
80107420:	83 c4 10             	add    $0x10,%esp
}
80107423:	90                   	nop
80107424:	c9                   	leave
80107425:	c3                   	ret

80107426 <idtinit>:

void
idtinit(void)
{
80107426:	55                   	push   %ebp
80107427:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107429:	68 00 08 00 00       	push   $0x800
8010742e:	68 20 66 11 80       	push   $0x80116620
80107433:	e8 3d fe ff ff       	call   80107275 <lidt>
80107438:	83 c4 08             	add    $0x8,%esp
}
8010743b:	90                   	nop
8010743c:	c9                   	leave
8010743d:	c3                   	ret

8010743e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010743e:	55                   	push   %ebp
8010743f:	89 e5                	mov    %esp,%ebp
80107441:	57                   	push   %edi
80107442:	56                   	push   %esi
80107443:	53                   	push   %ebx
80107444:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107447:	8b 45 08             	mov    0x8(%ebp),%eax
8010744a:	8b 40 30             	mov    0x30(%eax),%eax
8010744d:	83 f8 40             	cmp    $0x40,%eax
80107450:	75 3b                	jne    8010748d <trap+0x4f>
    if(myproc()->killed)
80107452:	e8 c4 d2 ff ff       	call   8010471b <myproc>
80107457:	8b 40 24             	mov    0x24(%eax),%eax
8010745a:	85 c0                	test   %eax,%eax
8010745c:	74 05                	je     80107463 <trap+0x25>
      exit();
8010745e:	e8 aa d7 ff ff       	call   80104c0d <exit>
    myproc()->tf = tf;
80107463:	e8 b3 d2 ff ff       	call   8010471b <myproc>
80107468:	8b 55 08             	mov    0x8(%ebp),%edx
8010746b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010746e:	e8 0e ec ff ff       	call   80106081 <syscall>
    if(myproc()->killed)
80107473:	e8 a3 d2 ff ff       	call   8010471b <myproc>
80107478:	8b 40 24             	mov    0x24(%eax),%eax
8010747b:	85 c0                	test   %eax,%eax
8010747d:	0f 84 06 02 00 00    	je     80107689 <trap+0x24b>
      exit();
80107483:	e8 85 d7 ff ff       	call   80104c0d <exit>
    return;
80107488:	e9 fc 01 00 00       	jmp    80107689 <trap+0x24b>
  }

  switch(tf->trapno){
8010748d:	8b 45 08             	mov    0x8(%ebp),%eax
80107490:	8b 40 30             	mov    0x30(%eax),%eax
80107493:	83 e8 20             	sub    $0x20,%eax
80107496:	83 f8 1f             	cmp    $0x1f,%eax
80107499:	0f 87 b5 00 00 00    	ja     80107554 <trap+0x116>
8010749f:	8b 04 85 a0 95 10 80 	mov    -0x7fef6a60(,%eax,4),%eax
801074a6:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801074a8:	e8 db d1 ff ff       	call   80104688 <cpuid>
801074ad:	85 c0                	test   %eax,%eax
801074af:	75 3d                	jne    801074ee <trap+0xb0>
      acquire(&tickslock);
801074b1:	83 ec 0c             	sub    $0xc,%esp
801074b4:	68 20 6e 11 80       	push   $0x80116e20
801074b9:	e8 46 e5 ff ff       	call   80105a04 <acquire>
801074be:	83 c4 10             	add    $0x10,%esp
      ticks++;
801074c1:	a1 54 6e 11 80       	mov    0x80116e54,%eax
801074c6:	83 c0 01             	add    $0x1,%eax
801074c9:	a3 54 6e 11 80       	mov    %eax,0x80116e54
      wakeup(&ticks);
801074ce:	83 ec 0c             	sub    $0xc,%esp
801074d1:	68 54 6e 11 80       	push   $0x80116e54
801074d6:	e8 c9 e1 ff ff       	call   801056a4 <wakeup>
801074db:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801074de:	83 ec 0c             	sub    $0xc,%esp
801074e1:	68 20 6e 11 80       	push   $0x80116e20
801074e6:	e8 87 e5 ff ff       	call   80105a72 <release>
801074eb:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801074ee:	e8 a5 bf ff ff       	call   80103498 <lapiceoi>
    break;
801074f3:	e9 11 01 00 00       	jmp    80107609 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801074f8:	e8 89 b3 ff ff       	call   80102886 <ideintr>
    lapiceoi();
801074fd:	e8 96 bf ff ff       	call   80103498 <lapiceoi>
    break;
80107502:	e9 02 01 00 00       	jmp    80107609 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107507:	e8 4b b9 ff ff       	call   80102e57 <kbdintr>
    lapiceoi();
8010750c:	e8 87 bf ff ff       	call   80103498 <lapiceoi>
    break;
80107511:	e9 f3 00 00 00       	jmp    80107609 <trap+0x1cb>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107516:	e8 42 03 00 00       	call   8010785d <uartintr>
    lapiceoi();
8010751b:	e8 78 bf ff ff       	call   80103498 <lapiceoi>
    break;
80107520:	e9 e4 00 00 00       	jmp    80107609 <trap+0x1cb>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107525:	8b 45 08             	mov    0x8(%ebp),%eax
80107528:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010752b:	8b 45 08             	mov    0x8(%ebp),%eax
8010752e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107532:	0f b7 d8             	movzwl %ax,%ebx
80107535:	e8 4e d1 ff ff       	call   80104688 <cpuid>
8010753a:	56                   	push   %esi
8010753b:	53                   	push   %ebx
8010753c:	50                   	push   %eax
8010753d:	68 00 95 10 80       	push   $0x80109500
80107542:	e8 b7 8e ff ff       	call   801003fe <cprintf>
80107547:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010754a:	e8 49 bf ff ff       	call   80103498 <lapiceoi>
    break;
8010754f:	e9 b5 00 00 00       	jmp    80107609 <trap+0x1cb>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80107554:	e8 c2 d1 ff ff       	call   8010471b <myproc>
80107559:	85 c0                	test   %eax,%eax
8010755b:	74 11                	je     8010756e <trap+0x130>
8010755d:	8b 45 08             	mov    0x8(%ebp),%eax
80107560:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107564:	0f b7 c0             	movzwl %ax,%eax
80107567:	83 e0 03             	and    $0x3,%eax
8010756a:	85 c0                	test   %eax,%eax
8010756c:	75 39                	jne    801075a7 <trap+0x169>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010756e:	e8 2c fd ff ff       	call   8010729f <rcr2>
80107573:	89 c3                	mov    %eax,%ebx
80107575:	8b 45 08             	mov    0x8(%ebp),%eax
80107578:	8b 70 38             	mov    0x38(%eax),%esi
8010757b:	e8 08 d1 ff ff       	call   80104688 <cpuid>
80107580:	8b 55 08             	mov    0x8(%ebp),%edx
80107583:	8b 52 30             	mov    0x30(%edx),%edx
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	53                   	push   %ebx
8010758a:	56                   	push   %esi
8010758b:	50                   	push   %eax
8010758c:	52                   	push   %edx
8010758d:	68 24 95 10 80       	push   $0x80109524
80107592:	e8 67 8e ff ff       	call   801003fe <cprintf>
80107597:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	68 56 95 10 80       	push   $0x80109556
801075a2:	e8 0c 90 ff ff       	call   801005b3 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801075a7:	e8 f3 fc ff ff       	call   8010729f <rcr2>
801075ac:	89 c6                	mov    %eax,%esi
801075ae:	8b 45 08             	mov    0x8(%ebp),%eax
801075b1:	8b 40 38             	mov    0x38(%eax),%eax
801075b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075b7:	e8 cc d0 ff ff       	call   80104688 <cpuid>
801075bc:	89 c3                	mov    %eax,%ebx
801075be:	8b 45 08             	mov    0x8(%ebp),%eax
801075c1:	8b 48 34             	mov    0x34(%eax),%ecx
801075c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801075c7:	8b 45 08             	mov    0x8(%ebp),%eax
801075ca:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801075cd:	e8 49 d1 ff ff       	call   8010471b <myproc>
801075d2:	8d 50 6c             	lea    0x6c(%eax),%edx
801075d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
801075d8:	e8 3e d1 ff ff       	call   8010471b <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801075dd:	8b 40 10             	mov    0x10(%eax),%eax
801075e0:	56                   	push   %esi
801075e1:	ff 75 e4             	push   -0x1c(%ebp)
801075e4:	53                   	push   %ebx
801075e5:	ff 75 e0             	push   -0x20(%ebp)
801075e8:	57                   	push   %edi
801075e9:	ff 75 dc             	push   -0x24(%ebp)
801075ec:	50                   	push   %eax
801075ed:	68 5c 95 10 80       	push   $0x8010955c
801075f2:	e8 07 8e ff ff       	call   801003fe <cprintf>
801075f7:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801075fa:	e8 1c d1 ff ff       	call   8010471b <myproc>
801075ff:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107606:	eb 01                	jmp    80107609 <trap+0x1cb>
    break;
80107608:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107609:	e8 0d d1 ff ff       	call   8010471b <myproc>
8010760e:	85 c0                	test   %eax,%eax
80107610:	74 23                	je     80107635 <trap+0x1f7>
80107612:	e8 04 d1 ff ff       	call   8010471b <myproc>
80107617:	8b 40 24             	mov    0x24(%eax),%eax
8010761a:	85 c0                	test   %eax,%eax
8010761c:	74 17                	je     80107635 <trap+0x1f7>
8010761e:	8b 45 08             	mov    0x8(%ebp),%eax
80107621:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107625:	0f b7 c0             	movzwl %ax,%eax
80107628:	83 e0 03             	and    $0x3,%eax
8010762b:	83 f8 03             	cmp    $0x3,%eax
8010762e:	75 05                	jne    80107635 <trap+0x1f7>
    exit();
80107630:	e8 d8 d5 ff ff       	call   80104c0d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107635:	e8 e1 d0 ff ff       	call   8010471b <myproc>
8010763a:	85 c0                	test   %eax,%eax
8010763c:	74 1d                	je     8010765b <trap+0x21d>
8010763e:	e8 d8 d0 ff ff       	call   8010471b <myproc>
80107643:	8b 40 0c             	mov    0xc(%eax),%eax
80107646:	83 f8 04             	cmp    $0x4,%eax
80107649:	75 10                	jne    8010765b <trap+0x21d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
8010764b:	8b 45 08             	mov    0x8(%ebp),%eax
8010764e:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80107651:	83 f8 20             	cmp    $0x20,%eax
80107654:	75 05                	jne    8010765b <trap+0x21d>
    yield();
80107656:	e8 df de ff ff       	call   8010553a <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010765b:	e8 bb d0 ff ff       	call   8010471b <myproc>
80107660:	85 c0                	test   %eax,%eax
80107662:	74 26                	je     8010768a <trap+0x24c>
80107664:	e8 b2 d0 ff ff       	call   8010471b <myproc>
80107669:	8b 40 24             	mov    0x24(%eax),%eax
8010766c:	85 c0                	test   %eax,%eax
8010766e:	74 1a                	je     8010768a <trap+0x24c>
80107670:	8b 45 08             	mov    0x8(%ebp),%eax
80107673:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107677:	0f b7 c0             	movzwl %ax,%eax
8010767a:	83 e0 03             	and    $0x3,%eax
8010767d:	83 f8 03             	cmp    $0x3,%eax
80107680:	75 08                	jne    8010768a <trap+0x24c>
    exit();
80107682:	e8 86 d5 ff ff       	call   80104c0d <exit>
80107687:	eb 01                	jmp    8010768a <trap+0x24c>
    return;
80107689:	90                   	nop
}
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret

80107692 <inb>:
{
80107692:	55                   	push   %ebp
80107693:	89 e5                	mov    %esp,%ebp
80107695:	83 ec 14             	sub    $0x14,%esp
80107698:	8b 45 08             	mov    0x8(%ebp),%eax
8010769b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010769f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801076a3:	89 c2                	mov    %eax,%edx
801076a5:	ec                   	in     (%dx),%al
801076a6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801076a9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801076ad:	c9                   	leave
801076ae:	c3                   	ret

801076af <outb>:
{
801076af:	55                   	push   %ebp
801076b0:	89 e5                	mov    %esp,%ebp
801076b2:	83 ec 08             	sub    $0x8,%esp
801076b5:	8b 55 08             	mov    0x8(%ebp),%edx
801076b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801076bb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801076bf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801076c2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801076c6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801076ca:	ee                   	out    %al,(%dx)
}
801076cb:	90                   	nop
801076cc:	c9                   	leave
801076cd:	c3                   	ret

801076ce <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801076ce:	55                   	push   %ebp
801076cf:	89 e5                	mov    %esp,%ebp
801076d1:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801076d4:	6a 00                	push   $0x0
801076d6:	68 fa 03 00 00       	push   $0x3fa
801076db:	e8 cf ff ff ff       	call   801076af <outb>
801076e0:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801076e3:	68 80 00 00 00       	push   $0x80
801076e8:	68 fb 03 00 00       	push   $0x3fb
801076ed:	e8 bd ff ff ff       	call   801076af <outb>
801076f2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801076f5:	6a 0c                	push   $0xc
801076f7:	68 f8 03 00 00       	push   $0x3f8
801076fc:	e8 ae ff ff ff       	call   801076af <outb>
80107701:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107704:	6a 00                	push   $0x0
80107706:	68 f9 03 00 00       	push   $0x3f9
8010770b:	e8 9f ff ff ff       	call   801076af <outb>
80107710:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107713:	6a 03                	push   $0x3
80107715:	68 fb 03 00 00       	push   $0x3fb
8010771a:	e8 90 ff ff ff       	call   801076af <outb>
8010771f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107722:	6a 00                	push   $0x0
80107724:	68 fc 03 00 00       	push   $0x3fc
80107729:	e8 81 ff ff ff       	call   801076af <outb>
8010772e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107731:	6a 01                	push   $0x1
80107733:	68 f9 03 00 00       	push   $0x3f9
80107738:	e8 72 ff ff ff       	call   801076af <outb>
8010773d:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107740:	68 fd 03 00 00       	push   $0x3fd
80107745:	e8 48 ff ff ff       	call   80107692 <inb>
8010774a:	83 c4 04             	add    $0x4,%esp
8010774d:	3c ff                	cmp    $0xff,%al
8010774f:	74 61                	je     801077b2 <uartinit+0xe4>
    return;
  uart = 1;
80107751:	c7 05 58 6e 11 80 01 	movl   $0x1,0x80116e58
80107758:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010775b:	68 fa 03 00 00       	push   $0x3fa
80107760:	e8 2d ff ff ff       	call   80107692 <inb>
80107765:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107768:	68 f8 03 00 00       	push   $0x3f8
8010776d:	e8 20 ff ff ff       	call   80107692 <inb>
80107772:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80107775:	83 ec 08             	sub    $0x8,%esp
80107778:	6a 00                	push   $0x0
8010777a:	6a 04                	push   $0x4
8010777c:	e8 a3 b3 ff ff       	call   80102b24 <ioapicenable>
80107781:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107784:	c7 45 f4 20 96 10 80 	movl   $0x80109620,-0xc(%ebp)
8010778b:	eb 19                	jmp    801077a6 <uartinit+0xd8>
    uartputc(*p);
8010778d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107790:	0f b6 00             	movzbl (%eax),%eax
80107793:	0f be c0             	movsbl %al,%eax
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	50                   	push   %eax
8010779a:	e8 16 00 00 00       	call   801077b5 <uartputc>
8010779f:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801077a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801077a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a9:	0f b6 00             	movzbl (%eax),%eax
801077ac:	84 c0                	test   %al,%al
801077ae:	75 dd                	jne    8010778d <uartinit+0xbf>
801077b0:	eb 01                	jmp    801077b3 <uartinit+0xe5>
    return;
801077b2:	90                   	nop
}
801077b3:	c9                   	leave
801077b4:	c3                   	ret

801077b5 <uartputc>:

void
uartputc(int c)
{
801077b5:	55                   	push   %ebp
801077b6:	89 e5                	mov    %esp,%ebp
801077b8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801077bb:	a1 58 6e 11 80       	mov    0x80116e58,%eax
801077c0:	85 c0                	test   %eax,%eax
801077c2:	74 53                	je     80107817 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801077c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801077cb:	eb 11                	jmp    801077de <uartputc+0x29>
    microdelay(10);
801077cd:	83 ec 0c             	sub    $0xc,%esp
801077d0:	6a 0a                	push   $0xa
801077d2:	e8 dc bc ff ff       	call   801034b3 <microdelay>
801077d7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801077da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801077de:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801077e2:	7f 1a                	jg     801077fe <uartputc+0x49>
801077e4:	83 ec 0c             	sub    $0xc,%esp
801077e7:	68 fd 03 00 00       	push   $0x3fd
801077ec:	e8 a1 fe ff ff       	call   80107692 <inb>
801077f1:	83 c4 10             	add    $0x10,%esp
801077f4:	0f b6 c0             	movzbl %al,%eax
801077f7:	83 e0 20             	and    $0x20,%eax
801077fa:	85 c0                	test   %eax,%eax
801077fc:	74 cf                	je     801077cd <uartputc+0x18>
  outb(COM1+0, c);
801077fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107801:	0f b6 c0             	movzbl %al,%eax
80107804:	83 ec 08             	sub    $0x8,%esp
80107807:	50                   	push   %eax
80107808:	68 f8 03 00 00       	push   $0x3f8
8010780d:	e8 9d fe ff ff       	call   801076af <outb>
80107812:	83 c4 10             	add    $0x10,%esp
80107815:	eb 01                	jmp    80107818 <uartputc+0x63>
    return;
80107817:	90                   	nop
}
80107818:	c9                   	leave
80107819:	c3                   	ret

8010781a <uartgetc>:

static int
uartgetc(void)
{
8010781a:	55                   	push   %ebp
8010781b:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010781d:	a1 58 6e 11 80       	mov    0x80116e58,%eax
80107822:	85 c0                	test   %eax,%eax
80107824:	75 07                	jne    8010782d <uartgetc+0x13>
    return -1;
80107826:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010782b:	eb 2e                	jmp    8010785b <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010782d:	68 fd 03 00 00       	push   $0x3fd
80107832:	e8 5b fe ff ff       	call   80107692 <inb>
80107837:	83 c4 04             	add    $0x4,%esp
8010783a:	0f b6 c0             	movzbl %al,%eax
8010783d:	83 e0 01             	and    $0x1,%eax
80107840:	85 c0                	test   %eax,%eax
80107842:	75 07                	jne    8010784b <uartgetc+0x31>
    return -1;
80107844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107849:	eb 10                	jmp    8010785b <uartgetc+0x41>
  return inb(COM1+0);
8010784b:	68 f8 03 00 00       	push   $0x3f8
80107850:	e8 3d fe ff ff       	call   80107692 <inb>
80107855:	83 c4 04             	add    $0x4,%esp
80107858:	0f b6 c0             	movzbl %al,%eax
}
8010785b:	c9                   	leave
8010785c:	c3                   	ret

8010785d <uartintr>:

void
uartintr(void)
{
8010785d:	55                   	push   %ebp
8010785e:	89 e5                	mov    %esp,%ebp
80107860:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107863:	83 ec 0c             	sub    $0xc,%esp
80107866:	68 1a 78 10 80       	push   $0x8010781a
8010786b:	e8 d9 8f ff ff       	call   80100849 <consoleintr>
80107870:	83 c4 10             	add    $0x10,%esp
}
80107873:	90                   	nop
80107874:	c9                   	leave
80107875:	c3                   	ret

80107876 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107876:	6a 00                	push   $0x0
  pushl $0
80107878:	6a 00                	push   $0x0
  jmp alltraps
8010787a:	e9 d3 f9 ff ff       	jmp    80107252 <alltraps>

8010787f <vector1>:
.globl vector1
vector1:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $1
80107881:	6a 01                	push   $0x1
  jmp alltraps
80107883:	e9 ca f9 ff ff       	jmp    80107252 <alltraps>

80107888 <vector2>:
.globl vector2
vector2:
  pushl $0
80107888:	6a 00                	push   $0x0
  pushl $2
8010788a:	6a 02                	push   $0x2
  jmp alltraps
8010788c:	e9 c1 f9 ff ff       	jmp    80107252 <alltraps>

80107891 <vector3>:
.globl vector3
vector3:
  pushl $0
80107891:	6a 00                	push   $0x0
  pushl $3
80107893:	6a 03                	push   $0x3
  jmp alltraps
80107895:	e9 b8 f9 ff ff       	jmp    80107252 <alltraps>

8010789a <vector4>:
.globl vector4
vector4:
  pushl $0
8010789a:	6a 00                	push   $0x0
  pushl $4
8010789c:	6a 04                	push   $0x4
  jmp alltraps
8010789e:	e9 af f9 ff ff       	jmp    80107252 <alltraps>

801078a3 <vector5>:
.globl vector5
vector5:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $5
801078a5:	6a 05                	push   $0x5
  jmp alltraps
801078a7:	e9 a6 f9 ff ff       	jmp    80107252 <alltraps>

801078ac <vector6>:
.globl vector6
vector6:
  pushl $0
801078ac:	6a 00                	push   $0x0
  pushl $6
801078ae:	6a 06                	push   $0x6
  jmp alltraps
801078b0:	e9 9d f9 ff ff       	jmp    80107252 <alltraps>

801078b5 <vector7>:
.globl vector7
vector7:
  pushl $0
801078b5:	6a 00                	push   $0x0
  pushl $7
801078b7:	6a 07                	push   $0x7
  jmp alltraps
801078b9:	e9 94 f9 ff ff       	jmp    80107252 <alltraps>

801078be <vector8>:
.globl vector8
vector8:
  pushl $8
801078be:	6a 08                	push   $0x8
  jmp alltraps
801078c0:	e9 8d f9 ff ff       	jmp    80107252 <alltraps>

801078c5 <vector9>:
.globl vector9
vector9:
  pushl $0
801078c5:	6a 00                	push   $0x0
  pushl $9
801078c7:	6a 09                	push   $0x9
  jmp alltraps
801078c9:	e9 84 f9 ff ff       	jmp    80107252 <alltraps>

801078ce <vector10>:
.globl vector10
vector10:
  pushl $10
801078ce:	6a 0a                	push   $0xa
  jmp alltraps
801078d0:	e9 7d f9 ff ff       	jmp    80107252 <alltraps>

801078d5 <vector11>:
.globl vector11
vector11:
  pushl $11
801078d5:	6a 0b                	push   $0xb
  jmp alltraps
801078d7:	e9 76 f9 ff ff       	jmp    80107252 <alltraps>

801078dc <vector12>:
.globl vector12
vector12:
  pushl $12
801078dc:	6a 0c                	push   $0xc
  jmp alltraps
801078de:	e9 6f f9 ff ff       	jmp    80107252 <alltraps>

801078e3 <vector13>:
.globl vector13
vector13:
  pushl $13
801078e3:	6a 0d                	push   $0xd
  jmp alltraps
801078e5:	e9 68 f9 ff ff       	jmp    80107252 <alltraps>

801078ea <vector14>:
.globl vector14
vector14:
  pushl $14
801078ea:	6a 0e                	push   $0xe
  jmp alltraps
801078ec:	e9 61 f9 ff ff       	jmp    80107252 <alltraps>

801078f1 <vector15>:
.globl vector15
vector15:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $15
801078f3:	6a 0f                	push   $0xf
  jmp alltraps
801078f5:	e9 58 f9 ff ff       	jmp    80107252 <alltraps>

801078fa <vector16>:
.globl vector16
vector16:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $16
801078fc:	6a 10                	push   $0x10
  jmp alltraps
801078fe:	e9 4f f9 ff ff       	jmp    80107252 <alltraps>

80107903 <vector17>:
.globl vector17
vector17:
  pushl $17
80107903:	6a 11                	push   $0x11
  jmp alltraps
80107905:	e9 48 f9 ff ff       	jmp    80107252 <alltraps>

8010790a <vector18>:
.globl vector18
vector18:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $18
8010790c:	6a 12                	push   $0x12
  jmp alltraps
8010790e:	e9 3f f9 ff ff       	jmp    80107252 <alltraps>

80107913 <vector19>:
.globl vector19
vector19:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $19
80107915:	6a 13                	push   $0x13
  jmp alltraps
80107917:	e9 36 f9 ff ff       	jmp    80107252 <alltraps>

8010791c <vector20>:
.globl vector20
vector20:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $20
8010791e:	6a 14                	push   $0x14
  jmp alltraps
80107920:	e9 2d f9 ff ff       	jmp    80107252 <alltraps>

80107925 <vector21>:
.globl vector21
vector21:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $21
80107927:	6a 15                	push   $0x15
  jmp alltraps
80107929:	e9 24 f9 ff ff       	jmp    80107252 <alltraps>

8010792e <vector22>:
.globl vector22
vector22:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $22
80107930:	6a 16                	push   $0x16
  jmp alltraps
80107932:	e9 1b f9 ff ff       	jmp    80107252 <alltraps>

80107937 <vector23>:
.globl vector23
vector23:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $23
80107939:	6a 17                	push   $0x17
  jmp alltraps
8010793b:	e9 12 f9 ff ff       	jmp    80107252 <alltraps>

80107940 <vector24>:
.globl vector24
vector24:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $24
80107942:	6a 18                	push   $0x18
  jmp alltraps
80107944:	e9 09 f9 ff ff       	jmp    80107252 <alltraps>

80107949 <vector25>:
.globl vector25
vector25:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $25
8010794b:	6a 19                	push   $0x19
  jmp alltraps
8010794d:	e9 00 f9 ff ff       	jmp    80107252 <alltraps>

80107952 <vector26>:
.globl vector26
vector26:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $26
80107954:	6a 1a                	push   $0x1a
  jmp alltraps
80107956:	e9 f7 f8 ff ff       	jmp    80107252 <alltraps>

8010795b <vector27>:
.globl vector27
vector27:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $27
8010795d:	6a 1b                	push   $0x1b
  jmp alltraps
8010795f:	e9 ee f8 ff ff       	jmp    80107252 <alltraps>

80107964 <vector28>:
.globl vector28
vector28:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $28
80107966:	6a 1c                	push   $0x1c
  jmp alltraps
80107968:	e9 e5 f8 ff ff       	jmp    80107252 <alltraps>

8010796d <vector29>:
.globl vector29
vector29:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $29
8010796f:	6a 1d                	push   $0x1d
  jmp alltraps
80107971:	e9 dc f8 ff ff       	jmp    80107252 <alltraps>

80107976 <vector30>:
.globl vector30
vector30:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $30
80107978:	6a 1e                	push   $0x1e
  jmp alltraps
8010797a:	e9 d3 f8 ff ff       	jmp    80107252 <alltraps>

8010797f <vector31>:
.globl vector31
vector31:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $31
80107981:	6a 1f                	push   $0x1f
  jmp alltraps
80107983:	e9 ca f8 ff ff       	jmp    80107252 <alltraps>

80107988 <vector32>:
.globl vector32
vector32:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $32
8010798a:	6a 20                	push   $0x20
  jmp alltraps
8010798c:	e9 c1 f8 ff ff       	jmp    80107252 <alltraps>

80107991 <vector33>:
.globl vector33
vector33:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $33
80107993:	6a 21                	push   $0x21
  jmp alltraps
80107995:	e9 b8 f8 ff ff       	jmp    80107252 <alltraps>

8010799a <vector34>:
.globl vector34
vector34:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $34
8010799c:	6a 22                	push   $0x22
  jmp alltraps
8010799e:	e9 af f8 ff ff       	jmp    80107252 <alltraps>

801079a3 <vector35>:
.globl vector35
vector35:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $35
801079a5:	6a 23                	push   $0x23
  jmp alltraps
801079a7:	e9 a6 f8 ff ff       	jmp    80107252 <alltraps>

801079ac <vector36>:
.globl vector36
vector36:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $36
801079ae:	6a 24                	push   $0x24
  jmp alltraps
801079b0:	e9 9d f8 ff ff       	jmp    80107252 <alltraps>

801079b5 <vector37>:
.globl vector37
vector37:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $37
801079b7:	6a 25                	push   $0x25
  jmp alltraps
801079b9:	e9 94 f8 ff ff       	jmp    80107252 <alltraps>

801079be <vector38>:
.globl vector38
vector38:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $38
801079c0:	6a 26                	push   $0x26
  jmp alltraps
801079c2:	e9 8b f8 ff ff       	jmp    80107252 <alltraps>

801079c7 <vector39>:
.globl vector39
vector39:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $39
801079c9:	6a 27                	push   $0x27
  jmp alltraps
801079cb:	e9 82 f8 ff ff       	jmp    80107252 <alltraps>

801079d0 <vector40>:
.globl vector40
vector40:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $40
801079d2:	6a 28                	push   $0x28
  jmp alltraps
801079d4:	e9 79 f8 ff ff       	jmp    80107252 <alltraps>

801079d9 <vector41>:
.globl vector41
vector41:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $41
801079db:	6a 29                	push   $0x29
  jmp alltraps
801079dd:	e9 70 f8 ff ff       	jmp    80107252 <alltraps>

801079e2 <vector42>:
.globl vector42
vector42:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $42
801079e4:	6a 2a                	push   $0x2a
  jmp alltraps
801079e6:	e9 67 f8 ff ff       	jmp    80107252 <alltraps>

801079eb <vector43>:
.globl vector43
vector43:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $43
801079ed:	6a 2b                	push   $0x2b
  jmp alltraps
801079ef:	e9 5e f8 ff ff       	jmp    80107252 <alltraps>

801079f4 <vector44>:
.globl vector44
vector44:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $44
801079f6:	6a 2c                	push   $0x2c
  jmp alltraps
801079f8:	e9 55 f8 ff ff       	jmp    80107252 <alltraps>

801079fd <vector45>:
.globl vector45
vector45:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $45
801079ff:	6a 2d                	push   $0x2d
  jmp alltraps
80107a01:	e9 4c f8 ff ff       	jmp    80107252 <alltraps>

80107a06 <vector46>:
.globl vector46
vector46:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $46
80107a08:	6a 2e                	push   $0x2e
  jmp alltraps
80107a0a:	e9 43 f8 ff ff       	jmp    80107252 <alltraps>

80107a0f <vector47>:
.globl vector47
vector47:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $47
80107a11:	6a 2f                	push   $0x2f
  jmp alltraps
80107a13:	e9 3a f8 ff ff       	jmp    80107252 <alltraps>

80107a18 <vector48>:
.globl vector48
vector48:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $48
80107a1a:	6a 30                	push   $0x30
  jmp alltraps
80107a1c:	e9 31 f8 ff ff       	jmp    80107252 <alltraps>

80107a21 <vector49>:
.globl vector49
vector49:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $49
80107a23:	6a 31                	push   $0x31
  jmp alltraps
80107a25:	e9 28 f8 ff ff       	jmp    80107252 <alltraps>

80107a2a <vector50>:
.globl vector50
vector50:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $50
80107a2c:	6a 32                	push   $0x32
  jmp alltraps
80107a2e:	e9 1f f8 ff ff       	jmp    80107252 <alltraps>

80107a33 <vector51>:
.globl vector51
vector51:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $51
80107a35:	6a 33                	push   $0x33
  jmp alltraps
80107a37:	e9 16 f8 ff ff       	jmp    80107252 <alltraps>

80107a3c <vector52>:
.globl vector52
vector52:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $52
80107a3e:	6a 34                	push   $0x34
  jmp alltraps
80107a40:	e9 0d f8 ff ff       	jmp    80107252 <alltraps>

80107a45 <vector53>:
.globl vector53
vector53:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $53
80107a47:	6a 35                	push   $0x35
  jmp alltraps
80107a49:	e9 04 f8 ff ff       	jmp    80107252 <alltraps>

80107a4e <vector54>:
.globl vector54
vector54:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $54
80107a50:	6a 36                	push   $0x36
  jmp alltraps
80107a52:	e9 fb f7 ff ff       	jmp    80107252 <alltraps>

80107a57 <vector55>:
.globl vector55
vector55:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $55
80107a59:	6a 37                	push   $0x37
  jmp alltraps
80107a5b:	e9 f2 f7 ff ff       	jmp    80107252 <alltraps>

80107a60 <vector56>:
.globl vector56
vector56:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $56
80107a62:	6a 38                	push   $0x38
  jmp alltraps
80107a64:	e9 e9 f7 ff ff       	jmp    80107252 <alltraps>

80107a69 <vector57>:
.globl vector57
vector57:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $57
80107a6b:	6a 39                	push   $0x39
  jmp alltraps
80107a6d:	e9 e0 f7 ff ff       	jmp    80107252 <alltraps>

80107a72 <vector58>:
.globl vector58
vector58:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $58
80107a74:	6a 3a                	push   $0x3a
  jmp alltraps
80107a76:	e9 d7 f7 ff ff       	jmp    80107252 <alltraps>

80107a7b <vector59>:
.globl vector59
vector59:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $59
80107a7d:	6a 3b                	push   $0x3b
  jmp alltraps
80107a7f:	e9 ce f7 ff ff       	jmp    80107252 <alltraps>

80107a84 <vector60>:
.globl vector60
vector60:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $60
80107a86:	6a 3c                	push   $0x3c
  jmp alltraps
80107a88:	e9 c5 f7 ff ff       	jmp    80107252 <alltraps>

80107a8d <vector61>:
.globl vector61
vector61:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $61
80107a8f:	6a 3d                	push   $0x3d
  jmp alltraps
80107a91:	e9 bc f7 ff ff       	jmp    80107252 <alltraps>

80107a96 <vector62>:
.globl vector62
vector62:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $62
80107a98:	6a 3e                	push   $0x3e
  jmp alltraps
80107a9a:	e9 b3 f7 ff ff       	jmp    80107252 <alltraps>

80107a9f <vector63>:
.globl vector63
vector63:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $63
80107aa1:	6a 3f                	push   $0x3f
  jmp alltraps
80107aa3:	e9 aa f7 ff ff       	jmp    80107252 <alltraps>

80107aa8 <vector64>:
.globl vector64
vector64:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $64
80107aaa:	6a 40                	push   $0x40
  jmp alltraps
80107aac:	e9 a1 f7 ff ff       	jmp    80107252 <alltraps>

80107ab1 <vector65>:
.globl vector65
vector65:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $65
80107ab3:	6a 41                	push   $0x41
  jmp alltraps
80107ab5:	e9 98 f7 ff ff       	jmp    80107252 <alltraps>

80107aba <vector66>:
.globl vector66
vector66:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $66
80107abc:	6a 42                	push   $0x42
  jmp alltraps
80107abe:	e9 8f f7 ff ff       	jmp    80107252 <alltraps>

80107ac3 <vector67>:
.globl vector67
vector67:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $67
80107ac5:	6a 43                	push   $0x43
  jmp alltraps
80107ac7:	e9 86 f7 ff ff       	jmp    80107252 <alltraps>

80107acc <vector68>:
.globl vector68
vector68:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $68
80107ace:	6a 44                	push   $0x44
  jmp alltraps
80107ad0:	e9 7d f7 ff ff       	jmp    80107252 <alltraps>

80107ad5 <vector69>:
.globl vector69
vector69:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $69
80107ad7:	6a 45                	push   $0x45
  jmp alltraps
80107ad9:	e9 74 f7 ff ff       	jmp    80107252 <alltraps>

80107ade <vector70>:
.globl vector70
vector70:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $70
80107ae0:	6a 46                	push   $0x46
  jmp alltraps
80107ae2:	e9 6b f7 ff ff       	jmp    80107252 <alltraps>

80107ae7 <vector71>:
.globl vector71
vector71:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $71
80107ae9:	6a 47                	push   $0x47
  jmp alltraps
80107aeb:	e9 62 f7 ff ff       	jmp    80107252 <alltraps>

80107af0 <vector72>:
.globl vector72
vector72:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $72
80107af2:	6a 48                	push   $0x48
  jmp alltraps
80107af4:	e9 59 f7 ff ff       	jmp    80107252 <alltraps>

80107af9 <vector73>:
.globl vector73
vector73:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $73
80107afb:	6a 49                	push   $0x49
  jmp alltraps
80107afd:	e9 50 f7 ff ff       	jmp    80107252 <alltraps>

80107b02 <vector74>:
.globl vector74
vector74:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $74
80107b04:	6a 4a                	push   $0x4a
  jmp alltraps
80107b06:	e9 47 f7 ff ff       	jmp    80107252 <alltraps>

80107b0b <vector75>:
.globl vector75
vector75:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $75
80107b0d:	6a 4b                	push   $0x4b
  jmp alltraps
80107b0f:	e9 3e f7 ff ff       	jmp    80107252 <alltraps>

80107b14 <vector76>:
.globl vector76
vector76:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $76
80107b16:	6a 4c                	push   $0x4c
  jmp alltraps
80107b18:	e9 35 f7 ff ff       	jmp    80107252 <alltraps>

80107b1d <vector77>:
.globl vector77
vector77:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $77
80107b1f:	6a 4d                	push   $0x4d
  jmp alltraps
80107b21:	e9 2c f7 ff ff       	jmp    80107252 <alltraps>

80107b26 <vector78>:
.globl vector78
vector78:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $78
80107b28:	6a 4e                	push   $0x4e
  jmp alltraps
80107b2a:	e9 23 f7 ff ff       	jmp    80107252 <alltraps>

80107b2f <vector79>:
.globl vector79
vector79:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $79
80107b31:	6a 4f                	push   $0x4f
  jmp alltraps
80107b33:	e9 1a f7 ff ff       	jmp    80107252 <alltraps>

80107b38 <vector80>:
.globl vector80
vector80:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $80
80107b3a:	6a 50                	push   $0x50
  jmp alltraps
80107b3c:	e9 11 f7 ff ff       	jmp    80107252 <alltraps>

80107b41 <vector81>:
.globl vector81
vector81:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $81
80107b43:	6a 51                	push   $0x51
  jmp alltraps
80107b45:	e9 08 f7 ff ff       	jmp    80107252 <alltraps>

80107b4a <vector82>:
.globl vector82
vector82:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $82
80107b4c:	6a 52                	push   $0x52
  jmp alltraps
80107b4e:	e9 ff f6 ff ff       	jmp    80107252 <alltraps>

80107b53 <vector83>:
.globl vector83
vector83:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $83
80107b55:	6a 53                	push   $0x53
  jmp alltraps
80107b57:	e9 f6 f6 ff ff       	jmp    80107252 <alltraps>

80107b5c <vector84>:
.globl vector84
vector84:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $84
80107b5e:	6a 54                	push   $0x54
  jmp alltraps
80107b60:	e9 ed f6 ff ff       	jmp    80107252 <alltraps>

80107b65 <vector85>:
.globl vector85
vector85:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $85
80107b67:	6a 55                	push   $0x55
  jmp alltraps
80107b69:	e9 e4 f6 ff ff       	jmp    80107252 <alltraps>

80107b6e <vector86>:
.globl vector86
vector86:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $86
80107b70:	6a 56                	push   $0x56
  jmp alltraps
80107b72:	e9 db f6 ff ff       	jmp    80107252 <alltraps>

80107b77 <vector87>:
.globl vector87
vector87:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $87
80107b79:	6a 57                	push   $0x57
  jmp alltraps
80107b7b:	e9 d2 f6 ff ff       	jmp    80107252 <alltraps>

80107b80 <vector88>:
.globl vector88
vector88:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $88
80107b82:	6a 58                	push   $0x58
  jmp alltraps
80107b84:	e9 c9 f6 ff ff       	jmp    80107252 <alltraps>

80107b89 <vector89>:
.globl vector89
vector89:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $89
80107b8b:	6a 59                	push   $0x59
  jmp alltraps
80107b8d:	e9 c0 f6 ff ff       	jmp    80107252 <alltraps>

80107b92 <vector90>:
.globl vector90
vector90:
  pushl $0
80107b92:	6a 00                	push   $0x0
  pushl $90
80107b94:	6a 5a                	push   $0x5a
  jmp alltraps
80107b96:	e9 b7 f6 ff ff       	jmp    80107252 <alltraps>

80107b9b <vector91>:
.globl vector91
vector91:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $91
80107b9d:	6a 5b                	push   $0x5b
  jmp alltraps
80107b9f:	e9 ae f6 ff ff       	jmp    80107252 <alltraps>

80107ba4 <vector92>:
.globl vector92
vector92:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $92
80107ba6:	6a 5c                	push   $0x5c
  jmp alltraps
80107ba8:	e9 a5 f6 ff ff       	jmp    80107252 <alltraps>

80107bad <vector93>:
.globl vector93
vector93:
  pushl $0
80107bad:	6a 00                	push   $0x0
  pushl $93
80107baf:	6a 5d                	push   $0x5d
  jmp alltraps
80107bb1:	e9 9c f6 ff ff       	jmp    80107252 <alltraps>

80107bb6 <vector94>:
.globl vector94
vector94:
  pushl $0
80107bb6:	6a 00                	push   $0x0
  pushl $94
80107bb8:	6a 5e                	push   $0x5e
  jmp alltraps
80107bba:	e9 93 f6 ff ff       	jmp    80107252 <alltraps>

80107bbf <vector95>:
.globl vector95
vector95:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $95
80107bc1:	6a 5f                	push   $0x5f
  jmp alltraps
80107bc3:	e9 8a f6 ff ff       	jmp    80107252 <alltraps>

80107bc8 <vector96>:
.globl vector96
vector96:
  pushl $0
80107bc8:	6a 00                	push   $0x0
  pushl $96
80107bca:	6a 60                	push   $0x60
  jmp alltraps
80107bcc:	e9 81 f6 ff ff       	jmp    80107252 <alltraps>

80107bd1 <vector97>:
.globl vector97
vector97:
  pushl $0
80107bd1:	6a 00                	push   $0x0
  pushl $97
80107bd3:	6a 61                	push   $0x61
  jmp alltraps
80107bd5:	e9 78 f6 ff ff       	jmp    80107252 <alltraps>

80107bda <vector98>:
.globl vector98
vector98:
  pushl $0
80107bda:	6a 00                	push   $0x0
  pushl $98
80107bdc:	6a 62                	push   $0x62
  jmp alltraps
80107bde:	e9 6f f6 ff ff       	jmp    80107252 <alltraps>

80107be3 <vector99>:
.globl vector99
vector99:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $99
80107be5:	6a 63                	push   $0x63
  jmp alltraps
80107be7:	e9 66 f6 ff ff       	jmp    80107252 <alltraps>

80107bec <vector100>:
.globl vector100
vector100:
  pushl $0
80107bec:	6a 00                	push   $0x0
  pushl $100
80107bee:	6a 64                	push   $0x64
  jmp alltraps
80107bf0:	e9 5d f6 ff ff       	jmp    80107252 <alltraps>

80107bf5 <vector101>:
.globl vector101
vector101:
  pushl $0
80107bf5:	6a 00                	push   $0x0
  pushl $101
80107bf7:	6a 65                	push   $0x65
  jmp alltraps
80107bf9:	e9 54 f6 ff ff       	jmp    80107252 <alltraps>

80107bfe <vector102>:
.globl vector102
vector102:
  pushl $0
80107bfe:	6a 00                	push   $0x0
  pushl $102
80107c00:	6a 66                	push   $0x66
  jmp alltraps
80107c02:	e9 4b f6 ff ff       	jmp    80107252 <alltraps>

80107c07 <vector103>:
.globl vector103
vector103:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $103
80107c09:	6a 67                	push   $0x67
  jmp alltraps
80107c0b:	e9 42 f6 ff ff       	jmp    80107252 <alltraps>

80107c10 <vector104>:
.globl vector104
vector104:
  pushl $0
80107c10:	6a 00                	push   $0x0
  pushl $104
80107c12:	6a 68                	push   $0x68
  jmp alltraps
80107c14:	e9 39 f6 ff ff       	jmp    80107252 <alltraps>

80107c19 <vector105>:
.globl vector105
vector105:
  pushl $0
80107c19:	6a 00                	push   $0x0
  pushl $105
80107c1b:	6a 69                	push   $0x69
  jmp alltraps
80107c1d:	e9 30 f6 ff ff       	jmp    80107252 <alltraps>

80107c22 <vector106>:
.globl vector106
vector106:
  pushl $0
80107c22:	6a 00                	push   $0x0
  pushl $106
80107c24:	6a 6a                	push   $0x6a
  jmp alltraps
80107c26:	e9 27 f6 ff ff       	jmp    80107252 <alltraps>

80107c2b <vector107>:
.globl vector107
vector107:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $107
80107c2d:	6a 6b                	push   $0x6b
  jmp alltraps
80107c2f:	e9 1e f6 ff ff       	jmp    80107252 <alltraps>

80107c34 <vector108>:
.globl vector108
vector108:
  pushl $0
80107c34:	6a 00                	push   $0x0
  pushl $108
80107c36:	6a 6c                	push   $0x6c
  jmp alltraps
80107c38:	e9 15 f6 ff ff       	jmp    80107252 <alltraps>

80107c3d <vector109>:
.globl vector109
vector109:
  pushl $0
80107c3d:	6a 00                	push   $0x0
  pushl $109
80107c3f:	6a 6d                	push   $0x6d
  jmp alltraps
80107c41:	e9 0c f6 ff ff       	jmp    80107252 <alltraps>

80107c46 <vector110>:
.globl vector110
vector110:
  pushl $0
80107c46:	6a 00                	push   $0x0
  pushl $110
80107c48:	6a 6e                	push   $0x6e
  jmp alltraps
80107c4a:	e9 03 f6 ff ff       	jmp    80107252 <alltraps>

80107c4f <vector111>:
.globl vector111
vector111:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $111
80107c51:	6a 6f                	push   $0x6f
  jmp alltraps
80107c53:	e9 fa f5 ff ff       	jmp    80107252 <alltraps>

80107c58 <vector112>:
.globl vector112
vector112:
  pushl $0
80107c58:	6a 00                	push   $0x0
  pushl $112
80107c5a:	6a 70                	push   $0x70
  jmp alltraps
80107c5c:	e9 f1 f5 ff ff       	jmp    80107252 <alltraps>

80107c61 <vector113>:
.globl vector113
vector113:
  pushl $0
80107c61:	6a 00                	push   $0x0
  pushl $113
80107c63:	6a 71                	push   $0x71
  jmp alltraps
80107c65:	e9 e8 f5 ff ff       	jmp    80107252 <alltraps>

80107c6a <vector114>:
.globl vector114
vector114:
  pushl $0
80107c6a:	6a 00                	push   $0x0
  pushl $114
80107c6c:	6a 72                	push   $0x72
  jmp alltraps
80107c6e:	e9 df f5 ff ff       	jmp    80107252 <alltraps>

80107c73 <vector115>:
.globl vector115
vector115:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $115
80107c75:	6a 73                	push   $0x73
  jmp alltraps
80107c77:	e9 d6 f5 ff ff       	jmp    80107252 <alltraps>

80107c7c <vector116>:
.globl vector116
vector116:
  pushl $0
80107c7c:	6a 00                	push   $0x0
  pushl $116
80107c7e:	6a 74                	push   $0x74
  jmp alltraps
80107c80:	e9 cd f5 ff ff       	jmp    80107252 <alltraps>

80107c85 <vector117>:
.globl vector117
vector117:
  pushl $0
80107c85:	6a 00                	push   $0x0
  pushl $117
80107c87:	6a 75                	push   $0x75
  jmp alltraps
80107c89:	e9 c4 f5 ff ff       	jmp    80107252 <alltraps>

80107c8e <vector118>:
.globl vector118
vector118:
  pushl $0
80107c8e:	6a 00                	push   $0x0
  pushl $118
80107c90:	6a 76                	push   $0x76
  jmp alltraps
80107c92:	e9 bb f5 ff ff       	jmp    80107252 <alltraps>

80107c97 <vector119>:
.globl vector119
vector119:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $119
80107c99:	6a 77                	push   $0x77
  jmp alltraps
80107c9b:	e9 b2 f5 ff ff       	jmp    80107252 <alltraps>

80107ca0 <vector120>:
.globl vector120
vector120:
  pushl $0
80107ca0:	6a 00                	push   $0x0
  pushl $120
80107ca2:	6a 78                	push   $0x78
  jmp alltraps
80107ca4:	e9 a9 f5 ff ff       	jmp    80107252 <alltraps>

80107ca9 <vector121>:
.globl vector121
vector121:
  pushl $0
80107ca9:	6a 00                	push   $0x0
  pushl $121
80107cab:	6a 79                	push   $0x79
  jmp alltraps
80107cad:	e9 a0 f5 ff ff       	jmp    80107252 <alltraps>

80107cb2 <vector122>:
.globl vector122
vector122:
  pushl $0
80107cb2:	6a 00                	push   $0x0
  pushl $122
80107cb4:	6a 7a                	push   $0x7a
  jmp alltraps
80107cb6:	e9 97 f5 ff ff       	jmp    80107252 <alltraps>

80107cbb <vector123>:
.globl vector123
vector123:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $123
80107cbd:	6a 7b                	push   $0x7b
  jmp alltraps
80107cbf:	e9 8e f5 ff ff       	jmp    80107252 <alltraps>

80107cc4 <vector124>:
.globl vector124
vector124:
  pushl $0
80107cc4:	6a 00                	push   $0x0
  pushl $124
80107cc6:	6a 7c                	push   $0x7c
  jmp alltraps
80107cc8:	e9 85 f5 ff ff       	jmp    80107252 <alltraps>

80107ccd <vector125>:
.globl vector125
vector125:
  pushl $0
80107ccd:	6a 00                	push   $0x0
  pushl $125
80107ccf:	6a 7d                	push   $0x7d
  jmp alltraps
80107cd1:	e9 7c f5 ff ff       	jmp    80107252 <alltraps>

80107cd6 <vector126>:
.globl vector126
vector126:
  pushl $0
80107cd6:	6a 00                	push   $0x0
  pushl $126
80107cd8:	6a 7e                	push   $0x7e
  jmp alltraps
80107cda:	e9 73 f5 ff ff       	jmp    80107252 <alltraps>

80107cdf <vector127>:
.globl vector127
vector127:
  pushl $0
80107cdf:	6a 00                	push   $0x0
  pushl $127
80107ce1:	6a 7f                	push   $0x7f
  jmp alltraps
80107ce3:	e9 6a f5 ff ff       	jmp    80107252 <alltraps>

80107ce8 <vector128>:
.globl vector128
vector128:
  pushl $0
80107ce8:	6a 00                	push   $0x0
  pushl $128
80107cea:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107cef:	e9 5e f5 ff ff       	jmp    80107252 <alltraps>

80107cf4 <vector129>:
.globl vector129
vector129:
  pushl $0
80107cf4:	6a 00                	push   $0x0
  pushl $129
80107cf6:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107cfb:	e9 52 f5 ff ff       	jmp    80107252 <alltraps>

80107d00 <vector130>:
.globl vector130
vector130:
  pushl $0
80107d00:	6a 00                	push   $0x0
  pushl $130
80107d02:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107d07:	e9 46 f5 ff ff       	jmp    80107252 <alltraps>

80107d0c <vector131>:
.globl vector131
vector131:
  pushl $0
80107d0c:	6a 00                	push   $0x0
  pushl $131
80107d0e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107d13:	e9 3a f5 ff ff       	jmp    80107252 <alltraps>

80107d18 <vector132>:
.globl vector132
vector132:
  pushl $0
80107d18:	6a 00                	push   $0x0
  pushl $132
80107d1a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107d1f:	e9 2e f5 ff ff       	jmp    80107252 <alltraps>

80107d24 <vector133>:
.globl vector133
vector133:
  pushl $0
80107d24:	6a 00                	push   $0x0
  pushl $133
80107d26:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107d2b:	e9 22 f5 ff ff       	jmp    80107252 <alltraps>

80107d30 <vector134>:
.globl vector134
vector134:
  pushl $0
80107d30:	6a 00                	push   $0x0
  pushl $134
80107d32:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107d37:	e9 16 f5 ff ff       	jmp    80107252 <alltraps>

80107d3c <vector135>:
.globl vector135
vector135:
  pushl $0
80107d3c:	6a 00                	push   $0x0
  pushl $135
80107d3e:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107d43:	e9 0a f5 ff ff       	jmp    80107252 <alltraps>

80107d48 <vector136>:
.globl vector136
vector136:
  pushl $0
80107d48:	6a 00                	push   $0x0
  pushl $136
80107d4a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107d4f:	e9 fe f4 ff ff       	jmp    80107252 <alltraps>

80107d54 <vector137>:
.globl vector137
vector137:
  pushl $0
80107d54:	6a 00                	push   $0x0
  pushl $137
80107d56:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107d5b:	e9 f2 f4 ff ff       	jmp    80107252 <alltraps>

80107d60 <vector138>:
.globl vector138
vector138:
  pushl $0
80107d60:	6a 00                	push   $0x0
  pushl $138
80107d62:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107d67:	e9 e6 f4 ff ff       	jmp    80107252 <alltraps>

80107d6c <vector139>:
.globl vector139
vector139:
  pushl $0
80107d6c:	6a 00                	push   $0x0
  pushl $139
80107d6e:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107d73:	e9 da f4 ff ff       	jmp    80107252 <alltraps>

80107d78 <vector140>:
.globl vector140
vector140:
  pushl $0
80107d78:	6a 00                	push   $0x0
  pushl $140
80107d7a:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107d7f:	e9 ce f4 ff ff       	jmp    80107252 <alltraps>

80107d84 <vector141>:
.globl vector141
vector141:
  pushl $0
80107d84:	6a 00                	push   $0x0
  pushl $141
80107d86:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107d8b:	e9 c2 f4 ff ff       	jmp    80107252 <alltraps>

80107d90 <vector142>:
.globl vector142
vector142:
  pushl $0
80107d90:	6a 00                	push   $0x0
  pushl $142
80107d92:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107d97:	e9 b6 f4 ff ff       	jmp    80107252 <alltraps>

80107d9c <vector143>:
.globl vector143
vector143:
  pushl $0
80107d9c:	6a 00                	push   $0x0
  pushl $143
80107d9e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107da3:	e9 aa f4 ff ff       	jmp    80107252 <alltraps>

80107da8 <vector144>:
.globl vector144
vector144:
  pushl $0
80107da8:	6a 00                	push   $0x0
  pushl $144
80107daa:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107daf:	e9 9e f4 ff ff       	jmp    80107252 <alltraps>

80107db4 <vector145>:
.globl vector145
vector145:
  pushl $0
80107db4:	6a 00                	push   $0x0
  pushl $145
80107db6:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107dbb:	e9 92 f4 ff ff       	jmp    80107252 <alltraps>

80107dc0 <vector146>:
.globl vector146
vector146:
  pushl $0
80107dc0:	6a 00                	push   $0x0
  pushl $146
80107dc2:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107dc7:	e9 86 f4 ff ff       	jmp    80107252 <alltraps>

80107dcc <vector147>:
.globl vector147
vector147:
  pushl $0
80107dcc:	6a 00                	push   $0x0
  pushl $147
80107dce:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107dd3:	e9 7a f4 ff ff       	jmp    80107252 <alltraps>

80107dd8 <vector148>:
.globl vector148
vector148:
  pushl $0
80107dd8:	6a 00                	push   $0x0
  pushl $148
80107dda:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107ddf:	e9 6e f4 ff ff       	jmp    80107252 <alltraps>

80107de4 <vector149>:
.globl vector149
vector149:
  pushl $0
80107de4:	6a 00                	push   $0x0
  pushl $149
80107de6:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107deb:	e9 62 f4 ff ff       	jmp    80107252 <alltraps>

80107df0 <vector150>:
.globl vector150
vector150:
  pushl $0
80107df0:	6a 00                	push   $0x0
  pushl $150
80107df2:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107df7:	e9 56 f4 ff ff       	jmp    80107252 <alltraps>

80107dfc <vector151>:
.globl vector151
vector151:
  pushl $0
80107dfc:	6a 00                	push   $0x0
  pushl $151
80107dfe:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107e03:	e9 4a f4 ff ff       	jmp    80107252 <alltraps>

80107e08 <vector152>:
.globl vector152
vector152:
  pushl $0
80107e08:	6a 00                	push   $0x0
  pushl $152
80107e0a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107e0f:	e9 3e f4 ff ff       	jmp    80107252 <alltraps>

80107e14 <vector153>:
.globl vector153
vector153:
  pushl $0
80107e14:	6a 00                	push   $0x0
  pushl $153
80107e16:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107e1b:	e9 32 f4 ff ff       	jmp    80107252 <alltraps>

80107e20 <vector154>:
.globl vector154
vector154:
  pushl $0
80107e20:	6a 00                	push   $0x0
  pushl $154
80107e22:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107e27:	e9 26 f4 ff ff       	jmp    80107252 <alltraps>

80107e2c <vector155>:
.globl vector155
vector155:
  pushl $0
80107e2c:	6a 00                	push   $0x0
  pushl $155
80107e2e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107e33:	e9 1a f4 ff ff       	jmp    80107252 <alltraps>

80107e38 <vector156>:
.globl vector156
vector156:
  pushl $0
80107e38:	6a 00                	push   $0x0
  pushl $156
80107e3a:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107e3f:	e9 0e f4 ff ff       	jmp    80107252 <alltraps>

80107e44 <vector157>:
.globl vector157
vector157:
  pushl $0
80107e44:	6a 00                	push   $0x0
  pushl $157
80107e46:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107e4b:	e9 02 f4 ff ff       	jmp    80107252 <alltraps>

80107e50 <vector158>:
.globl vector158
vector158:
  pushl $0
80107e50:	6a 00                	push   $0x0
  pushl $158
80107e52:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107e57:	e9 f6 f3 ff ff       	jmp    80107252 <alltraps>

80107e5c <vector159>:
.globl vector159
vector159:
  pushl $0
80107e5c:	6a 00                	push   $0x0
  pushl $159
80107e5e:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107e63:	e9 ea f3 ff ff       	jmp    80107252 <alltraps>

80107e68 <vector160>:
.globl vector160
vector160:
  pushl $0
80107e68:	6a 00                	push   $0x0
  pushl $160
80107e6a:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107e6f:	e9 de f3 ff ff       	jmp    80107252 <alltraps>

80107e74 <vector161>:
.globl vector161
vector161:
  pushl $0
80107e74:	6a 00                	push   $0x0
  pushl $161
80107e76:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107e7b:	e9 d2 f3 ff ff       	jmp    80107252 <alltraps>

80107e80 <vector162>:
.globl vector162
vector162:
  pushl $0
80107e80:	6a 00                	push   $0x0
  pushl $162
80107e82:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107e87:	e9 c6 f3 ff ff       	jmp    80107252 <alltraps>

80107e8c <vector163>:
.globl vector163
vector163:
  pushl $0
80107e8c:	6a 00                	push   $0x0
  pushl $163
80107e8e:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107e93:	e9 ba f3 ff ff       	jmp    80107252 <alltraps>

80107e98 <vector164>:
.globl vector164
vector164:
  pushl $0
80107e98:	6a 00                	push   $0x0
  pushl $164
80107e9a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107e9f:	e9 ae f3 ff ff       	jmp    80107252 <alltraps>

80107ea4 <vector165>:
.globl vector165
vector165:
  pushl $0
80107ea4:	6a 00                	push   $0x0
  pushl $165
80107ea6:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107eab:	e9 a2 f3 ff ff       	jmp    80107252 <alltraps>

80107eb0 <vector166>:
.globl vector166
vector166:
  pushl $0
80107eb0:	6a 00                	push   $0x0
  pushl $166
80107eb2:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107eb7:	e9 96 f3 ff ff       	jmp    80107252 <alltraps>

80107ebc <vector167>:
.globl vector167
vector167:
  pushl $0
80107ebc:	6a 00                	push   $0x0
  pushl $167
80107ebe:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107ec3:	e9 8a f3 ff ff       	jmp    80107252 <alltraps>

80107ec8 <vector168>:
.globl vector168
vector168:
  pushl $0
80107ec8:	6a 00                	push   $0x0
  pushl $168
80107eca:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107ecf:	e9 7e f3 ff ff       	jmp    80107252 <alltraps>

80107ed4 <vector169>:
.globl vector169
vector169:
  pushl $0
80107ed4:	6a 00                	push   $0x0
  pushl $169
80107ed6:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107edb:	e9 72 f3 ff ff       	jmp    80107252 <alltraps>

80107ee0 <vector170>:
.globl vector170
vector170:
  pushl $0
80107ee0:	6a 00                	push   $0x0
  pushl $170
80107ee2:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107ee7:	e9 66 f3 ff ff       	jmp    80107252 <alltraps>

80107eec <vector171>:
.globl vector171
vector171:
  pushl $0
80107eec:	6a 00                	push   $0x0
  pushl $171
80107eee:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107ef3:	e9 5a f3 ff ff       	jmp    80107252 <alltraps>

80107ef8 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ef8:	6a 00                	push   $0x0
  pushl $172
80107efa:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107eff:	e9 4e f3 ff ff       	jmp    80107252 <alltraps>

80107f04 <vector173>:
.globl vector173
vector173:
  pushl $0
80107f04:	6a 00                	push   $0x0
  pushl $173
80107f06:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107f0b:	e9 42 f3 ff ff       	jmp    80107252 <alltraps>

80107f10 <vector174>:
.globl vector174
vector174:
  pushl $0
80107f10:	6a 00                	push   $0x0
  pushl $174
80107f12:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107f17:	e9 36 f3 ff ff       	jmp    80107252 <alltraps>

80107f1c <vector175>:
.globl vector175
vector175:
  pushl $0
80107f1c:	6a 00                	push   $0x0
  pushl $175
80107f1e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107f23:	e9 2a f3 ff ff       	jmp    80107252 <alltraps>

80107f28 <vector176>:
.globl vector176
vector176:
  pushl $0
80107f28:	6a 00                	push   $0x0
  pushl $176
80107f2a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107f2f:	e9 1e f3 ff ff       	jmp    80107252 <alltraps>

80107f34 <vector177>:
.globl vector177
vector177:
  pushl $0
80107f34:	6a 00                	push   $0x0
  pushl $177
80107f36:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107f3b:	e9 12 f3 ff ff       	jmp    80107252 <alltraps>

80107f40 <vector178>:
.globl vector178
vector178:
  pushl $0
80107f40:	6a 00                	push   $0x0
  pushl $178
80107f42:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107f47:	e9 06 f3 ff ff       	jmp    80107252 <alltraps>

80107f4c <vector179>:
.globl vector179
vector179:
  pushl $0
80107f4c:	6a 00                	push   $0x0
  pushl $179
80107f4e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107f53:	e9 fa f2 ff ff       	jmp    80107252 <alltraps>

80107f58 <vector180>:
.globl vector180
vector180:
  pushl $0
80107f58:	6a 00                	push   $0x0
  pushl $180
80107f5a:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107f5f:	e9 ee f2 ff ff       	jmp    80107252 <alltraps>

80107f64 <vector181>:
.globl vector181
vector181:
  pushl $0
80107f64:	6a 00                	push   $0x0
  pushl $181
80107f66:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107f6b:	e9 e2 f2 ff ff       	jmp    80107252 <alltraps>

80107f70 <vector182>:
.globl vector182
vector182:
  pushl $0
80107f70:	6a 00                	push   $0x0
  pushl $182
80107f72:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107f77:	e9 d6 f2 ff ff       	jmp    80107252 <alltraps>

80107f7c <vector183>:
.globl vector183
vector183:
  pushl $0
80107f7c:	6a 00                	push   $0x0
  pushl $183
80107f7e:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107f83:	e9 ca f2 ff ff       	jmp    80107252 <alltraps>

80107f88 <vector184>:
.globl vector184
vector184:
  pushl $0
80107f88:	6a 00                	push   $0x0
  pushl $184
80107f8a:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107f8f:	e9 be f2 ff ff       	jmp    80107252 <alltraps>

80107f94 <vector185>:
.globl vector185
vector185:
  pushl $0
80107f94:	6a 00                	push   $0x0
  pushl $185
80107f96:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107f9b:	e9 b2 f2 ff ff       	jmp    80107252 <alltraps>

80107fa0 <vector186>:
.globl vector186
vector186:
  pushl $0
80107fa0:	6a 00                	push   $0x0
  pushl $186
80107fa2:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107fa7:	e9 a6 f2 ff ff       	jmp    80107252 <alltraps>

80107fac <vector187>:
.globl vector187
vector187:
  pushl $0
80107fac:	6a 00                	push   $0x0
  pushl $187
80107fae:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107fb3:	e9 9a f2 ff ff       	jmp    80107252 <alltraps>

80107fb8 <vector188>:
.globl vector188
vector188:
  pushl $0
80107fb8:	6a 00                	push   $0x0
  pushl $188
80107fba:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107fbf:	e9 8e f2 ff ff       	jmp    80107252 <alltraps>

80107fc4 <vector189>:
.globl vector189
vector189:
  pushl $0
80107fc4:	6a 00                	push   $0x0
  pushl $189
80107fc6:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107fcb:	e9 82 f2 ff ff       	jmp    80107252 <alltraps>

80107fd0 <vector190>:
.globl vector190
vector190:
  pushl $0
80107fd0:	6a 00                	push   $0x0
  pushl $190
80107fd2:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107fd7:	e9 76 f2 ff ff       	jmp    80107252 <alltraps>

80107fdc <vector191>:
.globl vector191
vector191:
  pushl $0
80107fdc:	6a 00                	push   $0x0
  pushl $191
80107fde:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107fe3:	e9 6a f2 ff ff       	jmp    80107252 <alltraps>

80107fe8 <vector192>:
.globl vector192
vector192:
  pushl $0
80107fe8:	6a 00                	push   $0x0
  pushl $192
80107fea:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107fef:	e9 5e f2 ff ff       	jmp    80107252 <alltraps>

80107ff4 <vector193>:
.globl vector193
vector193:
  pushl $0
80107ff4:	6a 00                	push   $0x0
  pushl $193
80107ff6:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ffb:	e9 52 f2 ff ff       	jmp    80107252 <alltraps>

80108000 <vector194>:
.globl vector194
vector194:
  pushl $0
80108000:	6a 00                	push   $0x0
  pushl $194
80108002:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108007:	e9 46 f2 ff ff       	jmp    80107252 <alltraps>

8010800c <vector195>:
.globl vector195
vector195:
  pushl $0
8010800c:	6a 00                	push   $0x0
  pushl $195
8010800e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108013:	e9 3a f2 ff ff       	jmp    80107252 <alltraps>

80108018 <vector196>:
.globl vector196
vector196:
  pushl $0
80108018:	6a 00                	push   $0x0
  pushl $196
8010801a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010801f:	e9 2e f2 ff ff       	jmp    80107252 <alltraps>

80108024 <vector197>:
.globl vector197
vector197:
  pushl $0
80108024:	6a 00                	push   $0x0
  pushl $197
80108026:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010802b:	e9 22 f2 ff ff       	jmp    80107252 <alltraps>

80108030 <vector198>:
.globl vector198
vector198:
  pushl $0
80108030:	6a 00                	push   $0x0
  pushl $198
80108032:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108037:	e9 16 f2 ff ff       	jmp    80107252 <alltraps>

8010803c <vector199>:
.globl vector199
vector199:
  pushl $0
8010803c:	6a 00                	push   $0x0
  pushl $199
8010803e:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108043:	e9 0a f2 ff ff       	jmp    80107252 <alltraps>

80108048 <vector200>:
.globl vector200
vector200:
  pushl $0
80108048:	6a 00                	push   $0x0
  pushl $200
8010804a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010804f:	e9 fe f1 ff ff       	jmp    80107252 <alltraps>

80108054 <vector201>:
.globl vector201
vector201:
  pushl $0
80108054:	6a 00                	push   $0x0
  pushl $201
80108056:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010805b:	e9 f2 f1 ff ff       	jmp    80107252 <alltraps>

80108060 <vector202>:
.globl vector202
vector202:
  pushl $0
80108060:	6a 00                	push   $0x0
  pushl $202
80108062:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108067:	e9 e6 f1 ff ff       	jmp    80107252 <alltraps>

8010806c <vector203>:
.globl vector203
vector203:
  pushl $0
8010806c:	6a 00                	push   $0x0
  pushl $203
8010806e:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108073:	e9 da f1 ff ff       	jmp    80107252 <alltraps>

80108078 <vector204>:
.globl vector204
vector204:
  pushl $0
80108078:	6a 00                	push   $0x0
  pushl $204
8010807a:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010807f:	e9 ce f1 ff ff       	jmp    80107252 <alltraps>

80108084 <vector205>:
.globl vector205
vector205:
  pushl $0
80108084:	6a 00                	push   $0x0
  pushl $205
80108086:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010808b:	e9 c2 f1 ff ff       	jmp    80107252 <alltraps>

80108090 <vector206>:
.globl vector206
vector206:
  pushl $0
80108090:	6a 00                	push   $0x0
  pushl $206
80108092:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108097:	e9 b6 f1 ff ff       	jmp    80107252 <alltraps>

8010809c <vector207>:
.globl vector207
vector207:
  pushl $0
8010809c:	6a 00                	push   $0x0
  pushl $207
8010809e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801080a3:	e9 aa f1 ff ff       	jmp    80107252 <alltraps>

801080a8 <vector208>:
.globl vector208
vector208:
  pushl $0
801080a8:	6a 00                	push   $0x0
  pushl $208
801080aa:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801080af:	e9 9e f1 ff ff       	jmp    80107252 <alltraps>

801080b4 <vector209>:
.globl vector209
vector209:
  pushl $0
801080b4:	6a 00                	push   $0x0
  pushl $209
801080b6:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801080bb:	e9 92 f1 ff ff       	jmp    80107252 <alltraps>

801080c0 <vector210>:
.globl vector210
vector210:
  pushl $0
801080c0:	6a 00                	push   $0x0
  pushl $210
801080c2:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801080c7:	e9 86 f1 ff ff       	jmp    80107252 <alltraps>

801080cc <vector211>:
.globl vector211
vector211:
  pushl $0
801080cc:	6a 00                	push   $0x0
  pushl $211
801080ce:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801080d3:	e9 7a f1 ff ff       	jmp    80107252 <alltraps>

801080d8 <vector212>:
.globl vector212
vector212:
  pushl $0
801080d8:	6a 00                	push   $0x0
  pushl $212
801080da:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801080df:	e9 6e f1 ff ff       	jmp    80107252 <alltraps>

801080e4 <vector213>:
.globl vector213
vector213:
  pushl $0
801080e4:	6a 00                	push   $0x0
  pushl $213
801080e6:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801080eb:	e9 62 f1 ff ff       	jmp    80107252 <alltraps>

801080f0 <vector214>:
.globl vector214
vector214:
  pushl $0
801080f0:	6a 00                	push   $0x0
  pushl $214
801080f2:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801080f7:	e9 56 f1 ff ff       	jmp    80107252 <alltraps>

801080fc <vector215>:
.globl vector215
vector215:
  pushl $0
801080fc:	6a 00                	push   $0x0
  pushl $215
801080fe:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108103:	e9 4a f1 ff ff       	jmp    80107252 <alltraps>

80108108 <vector216>:
.globl vector216
vector216:
  pushl $0
80108108:	6a 00                	push   $0x0
  pushl $216
8010810a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010810f:	e9 3e f1 ff ff       	jmp    80107252 <alltraps>

80108114 <vector217>:
.globl vector217
vector217:
  pushl $0
80108114:	6a 00                	push   $0x0
  pushl $217
80108116:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010811b:	e9 32 f1 ff ff       	jmp    80107252 <alltraps>

80108120 <vector218>:
.globl vector218
vector218:
  pushl $0
80108120:	6a 00                	push   $0x0
  pushl $218
80108122:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108127:	e9 26 f1 ff ff       	jmp    80107252 <alltraps>

8010812c <vector219>:
.globl vector219
vector219:
  pushl $0
8010812c:	6a 00                	push   $0x0
  pushl $219
8010812e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108133:	e9 1a f1 ff ff       	jmp    80107252 <alltraps>

80108138 <vector220>:
.globl vector220
vector220:
  pushl $0
80108138:	6a 00                	push   $0x0
  pushl $220
8010813a:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010813f:	e9 0e f1 ff ff       	jmp    80107252 <alltraps>

80108144 <vector221>:
.globl vector221
vector221:
  pushl $0
80108144:	6a 00                	push   $0x0
  pushl $221
80108146:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010814b:	e9 02 f1 ff ff       	jmp    80107252 <alltraps>

80108150 <vector222>:
.globl vector222
vector222:
  pushl $0
80108150:	6a 00                	push   $0x0
  pushl $222
80108152:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108157:	e9 f6 f0 ff ff       	jmp    80107252 <alltraps>

8010815c <vector223>:
.globl vector223
vector223:
  pushl $0
8010815c:	6a 00                	push   $0x0
  pushl $223
8010815e:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108163:	e9 ea f0 ff ff       	jmp    80107252 <alltraps>

80108168 <vector224>:
.globl vector224
vector224:
  pushl $0
80108168:	6a 00                	push   $0x0
  pushl $224
8010816a:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010816f:	e9 de f0 ff ff       	jmp    80107252 <alltraps>

80108174 <vector225>:
.globl vector225
vector225:
  pushl $0
80108174:	6a 00                	push   $0x0
  pushl $225
80108176:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010817b:	e9 d2 f0 ff ff       	jmp    80107252 <alltraps>

80108180 <vector226>:
.globl vector226
vector226:
  pushl $0
80108180:	6a 00                	push   $0x0
  pushl $226
80108182:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108187:	e9 c6 f0 ff ff       	jmp    80107252 <alltraps>

8010818c <vector227>:
.globl vector227
vector227:
  pushl $0
8010818c:	6a 00                	push   $0x0
  pushl $227
8010818e:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108193:	e9 ba f0 ff ff       	jmp    80107252 <alltraps>

80108198 <vector228>:
.globl vector228
vector228:
  pushl $0
80108198:	6a 00                	push   $0x0
  pushl $228
8010819a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010819f:	e9 ae f0 ff ff       	jmp    80107252 <alltraps>

801081a4 <vector229>:
.globl vector229
vector229:
  pushl $0
801081a4:	6a 00                	push   $0x0
  pushl $229
801081a6:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801081ab:	e9 a2 f0 ff ff       	jmp    80107252 <alltraps>

801081b0 <vector230>:
.globl vector230
vector230:
  pushl $0
801081b0:	6a 00                	push   $0x0
  pushl $230
801081b2:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801081b7:	e9 96 f0 ff ff       	jmp    80107252 <alltraps>

801081bc <vector231>:
.globl vector231
vector231:
  pushl $0
801081bc:	6a 00                	push   $0x0
  pushl $231
801081be:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801081c3:	e9 8a f0 ff ff       	jmp    80107252 <alltraps>

801081c8 <vector232>:
.globl vector232
vector232:
  pushl $0
801081c8:	6a 00                	push   $0x0
  pushl $232
801081ca:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801081cf:	e9 7e f0 ff ff       	jmp    80107252 <alltraps>

801081d4 <vector233>:
.globl vector233
vector233:
  pushl $0
801081d4:	6a 00                	push   $0x0
  pushl $233
801081d6:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801081db:	e9 72 f0 ff ff       	jmp    80107252 <alltraps>

801081e0 <vector234>:
.globl vector234
vector234:
  pushl $0
801081e0:	6a 00                	push   $0x0
  pushl $234
801081e2:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801081e7:	e9 66 f0 ff ff       	jmp    80107252 <alltraps>

801081ec <vector235>:
.globl vector235
vector235:
  pushl $0
801081ec:	6a 00                	push   $0x0
  pushl $235
801081ee:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801081f3:	e9 5a f0 ff ff       	jmp    80107252 <alltraps>

801081f8 <vector236>:
.globl vector236
vector236:
  pushl $0
801081f8:	6a 00                	push   $0x0
  pushl $236
801081fa:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801081ff:	e9 4e f0 ff ff       	jmp    80107252 <alltraps>

80108204 <vector237>:
.globl vector237
vector237:
  pushl $0
80108204:	6a 00                	push   $0x0
  pushl $237
80108206:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010820b:	e9 42 f0 ff ff       	jmp    80107252 <alltraps>

80108210 <vector238>:
.globl vector238
vector238:
  pushl $0
80108210:	6a 00                	push   $0x0
  pushl $238
80108212:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108217:	e9 36 f0 ff ff       	jmp    80107252 <alltraps>

8010821c <vector239>:
.globl vector239
vector239:
  pushl $0
8010821c:	6a 00                	push   $0x0
  pushl $239
8010821e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108223:	e9 2a f0 ff ff       	jmp    80107252 <alltraps>

80108228 <vector240>:
.globl vector240
vector240:
  pushl $0
80108228:	6a 00                	push   $0x0
  pushl $240
8010822a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010822f:	e9 1e f0 ff ff       	jmp    80107252 <alltraps>

80108234 <vector241>:
.globl vector241
vector241:
  pushl $0
80108234:	6a 00                	push   $0x0
  pushl $241
80108236:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010823b:	e9 12 f0 ff ff       	jmp    80107252 <alltraps>

80108240 <vector242>:
.globl vector242
vector242:
  pushl $0
80108240:	6a 00                	push   $0x0
  pushl $242
80108242:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108247:	e9 06 f0 ff ff       	jmp    80107252 <alltraps>

8010824c <vector243>:
.globl vector243
vector243:
  pushl $0
8010824c:	6a 00                	push   $0x0
  pushl $243
8010824e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108253:	e9 fa ef ff ff       	jmp    80107252 <alltraps>

80108258 <vector244>:
.globl vector244
vector244:
  pushl $0
80108258:	6a 00                	push   $0x0
  pushl $244
8010825a:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010825f:	e9 ee ef ff ff       	jmp    80107252 <alltraps>

80108264 <vector245>:
.globl vector245
vector245:
  pushl $0
80108264:	6a 00                	push   $0x0
  pushl $245
80108266:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010826b:	e9 e2 ef ff ff       	jmp    80107252 <alltraps>

80108270 <vector246>:
.globl vector246
vector246:
  pushl $0
80108270:	6a 00                	push   $0x0
  pushl $246
80108272:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108277:	e9 d6 ef ff ff       	jmp    80107252 <alltraps>

8010827c <vector247>:
.globl vector247
vector247:
  pushl $0
8010827c:	6a 00                	push   $0x0
  pushl $247
8010827e:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108283:	e9 ca ef ff ff       	jmp    80107252 <alltraps>

80108288 <vector248>:
.globl vector248
vector248:
  pushl $0
80108288:	6a 00                	push   $0x0
  pushl $248
8010828a:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010828f:	e9 be ef ff ff       	jmp    80107252 <alltraps>

80108294 <vector249>:
.globl vector249
vector249:
  pushl $0
80108294:	6a 00                	push   $0x0
  pushl $249
80108296:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010829b:	e9 b2 ef ff ff       	jmp    80107252 <alltraps>

801082a0 <vector250>:
.globl vector250
vector250:
  pushl $0
801082a0:	6a 00                	push   $0x0
  pushl $250
801082a2:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801082a7:	e9 a6 ef ff ff       	jmp    80107252 <alltraps>

801082ac <vector251>:
.globl vector251
vector251:
  pushl $0
801082ac:	6a 00                	push   $0x0
  pushl $251
801082ae:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801082b3:	e9 9a ef ff ff       	jmp    80107252 <alltraps>

801082b8 <vector252>:
.globl vector252
vector252:
  pushl $0
801082b8:	6a 00                	push   $0x0
  pushl $252
801082ba:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801082bf:	e9 8e ef ff ff       	jmp    80107252 <alltraps>

801082c4 <vector253>:
.globl vector253
vector253:
  pushl $0
801082c4:	6a 00                	push   $0x0
  pushl $253
801082c6:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801082cb:	e9 82 ef ff ff       	jmp    80107252 <alltraps>

801082d0 <vector254>:
.globl vector254
vector254:
  pushl $0
801082d0:	6a 00                	push   $0x0
  pushl $254
801082d2:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801082d7:	e9 76 ef ff ff       	jmp    80107252 <alltraps>

801082dc <vector255>:
.globl vector255
vector255:
  pushl $0
801082dc:	6a 00                	push   $0x0
  pushl $255
801082de:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801082e3:	e9 6a ef ff ff       	jmp    80107252 <alltraps>

801082e8 <lgdt>:
{
801082e8:	55                   	push   %ebp
801082e9:	89 e5                	mov    %esp,%ebp
801082eb:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801082ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801082f1:	83 e8 01             	sub    $0x1,%eax
801082f4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801082f8:	8b 45 08             	mov    0x8(%ebp),%eax
801082fb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801082ff:	8b 45 08             	mov    0x8(%ebp),%eax
80108302:	c1 e8 10             	shr    $0x10,%eax
80108305:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108309:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010830c:	0f 01 10             	lgdtl  (%eax)
}
8010830f:	90                   	nop
80108310:	c9                   	leave
80108311:	c3                   	ret

80108312 <ltr>:
{
80108312:	55                   	push   %ebp
80108313:	89 e5                	mov    %esp,%ebp
80108315:	83 ec 04             	sub    $0x4,%esp
80108318:	8b 45 08             	mov    0x8(%ebp),%eax
8010831b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010831f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108323:	0f 00 d8             	ltr    %eax
}
80108326:	90                   	nop
80108327:	c9                   	leave
80108328:	c3                   	ret

80108329 <lcr3>:

static inline void
lcr3(uint val)
{
80108329:	55                   	push   %ebp
8010832a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010832c:	8b 45 08             	mov    0x8(%ebp),%eax
8010832f:	0f 22 d8             	mov    %eax,%cr3
}
80108332:	90                   	nop
80108333:	5d                   	pop    %ebp
80108334:	c3                   	ret

80108335 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108335:	55                   	push   %ebp
80108336:	89 e5                	mov    %esp,%ebp
80108338:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010833b:	e8 48 c3 ff ff       	call   80104688 <cpuid>
80108340:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108346:	05 40 3c 11 80       	add    $0x80113c40,%eax
8010834b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010834e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108351:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108363:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010836e:	83 e2 f0             	and    $0xfffffff0,%edx
80108371:	83 ca 0a             	or     $0xa,%edx
80108374:	88 50 7d             	mov    %dl,0x7d(%eax)
80108377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010837e:	83 ca 10             	or     $0x10,%edx
80108381:	88 50 7d             	mov    %dl,0x7d(%eax)
80108384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108387:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010838b:	83 e2 9f             	and    $0xffffff9f,%edx
8010838e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108394:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108398:	83 ca 80             	or     $0xffffff80,%edx
8010839b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010839e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801083a5:	83 ca 0f             	or     $0xf,%edx
801083a8:	88 50 7e             	mov    %dl,0x7e(%eax)
801083ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ae:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801083b2:	83 e2 ef             	and    $0xffffffef,%edx
801083b5:	88 50 7e             	mov    %dl,0x7e(%eax)
801083b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801083bf:	83 e2 df             	and    $0xffffffdf,%edx
801083c2:	88 50 7e             	mov    %dl,0x7e(%eax)
801083c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801083cc:	83 ca 40             	or     $0x40,%edx
801083cf:	88 50 7e             	mov    %dl,0x7e(%eax)
801083d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801083d9:	83 ca 80             	or     $0xffffff80,%edx
801083dc:	88 50 7e             	mov    %dl,0x7e(%eax)
801083df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e2:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801083e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e9:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801083f0:	ff ff 
801083f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f5:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801083fc:	00 00 
801083fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108401:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108412:	83 e2 f0             	and    $0xfffffff0,%edx
80108415:	83 ca 02             	or     $0x2,%edx
80108418:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010841e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108421:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108428:	83 ca 10             	or     $0x10,%edx
8010842b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108434:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010843b:	83 e2 9f             	and    $0xffffff9f,%edx
8010843e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108447:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010844e:	83 ca 80             	or     $0xffffff80,%edx
80108451:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108461:	83 ca 0f             	or     $0xf,%edx
80108464:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010846a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010846d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108474:	83 e2 ef             	and    $0xffffffef,%edx
80108477:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010847d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108480:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108487:	83 e2 df             	and    $0xffffffdf,%edx
8010848a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108490:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108493:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010849a:	83 ca 40             	or     $0x40,%edx
8010849d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801084a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801084ad:	83 ca 80             	or     $0xffffff80,%edx
801084b0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801084b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b9:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801084c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c3:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801084ca:	ff ff 
801084cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084cf:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801084d6:	00 00 
801084d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084db:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801084e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801084ec:	83 e2 f0             	and    $0xfffffff0,%edx
801084ef:	83 ca 0a             	or     $0xa,%edx
801084f2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801084f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108502:	83 ca 10             	or     $0x10,%edx
80108505:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010850b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010850e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108515:	83 ca 60             	or     $0x60,%edx
80108518:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010851e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108521:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108528:	83 ca 80             	or     $0xffffff80,%edx
8010852b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108534:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010853b:	83 ca 0f             	or     $0xf,%edx
8010853e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108544:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108547:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010854e:	83 e2 ef             	and    $0xffffffef,%edx
80108551:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108561:	83 e2 df             	and    $0xffffffdf,%edx
80108564:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010856a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010856d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108574:	83 ca 40             	or     $0x40,%edx
80108577:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108580:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108587:	83 ca 80             	or     $0xffffff80,%edx
8010858a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108593:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010859a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801085a4:	ff ff 
801085a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a9:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801085b0:	00 00 
801085b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b5:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801085bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085bf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085c6:	83 e2 f0             	and    $0xfffffff0,%edx
801085c9:	83 ca 02             	or     $0x2,%edx
801085cc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085dc:	83 ca 10             	or     $0x10,%edx
801085df:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085ef:	83 ca 60             	or     $0x60,%edx
801085f2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108602:	83 ca 80             	or     $0xffffff80,%edx
80108605:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010860b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108615:	83 ca 0f             	or     $0xf,%edx
80108618:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010861e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108621:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108628:	83 e2 ef             	and    $0xffffffef,%edx
8010862b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108634:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010863b:	83 e2 df             	and    $0xffffffdf,%edx
8010863e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108647:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010864e:	83 ca 40             	or     $0x40,%edx
80108651:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108661:	83 ca 80             	or     $0xffffff80,%edx
80108664:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010866a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010866d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80108674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108677:	83 c0 70             	add    $0x70,%eax
8010867a:	83 ec 08             	sub    $0x8,%esp
8010867d:	6a 30                	push   $0x30
8010867f:	50                   	push   %eax
80108680:	e8 63 fc ff ff       	call   801082e8 <lgdt>
80108685:	83 c4 10             	add    $0x10,%esp
}
80108688:	90                   	nop
80108689:	c9                   	leave
8010868a:	c3                   	ret

8010868b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010868b:	55                   	push   %ebp
8010868c:	89 e5                	mov    %esp,%ebp
8010868e:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108691:	8b 45 0c             	mov    0xc(%ebp),%eax
80108694:	c1 e8 16             	shr    $0x16,%eax
80108697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010869e:	8b 45 08             	mov    0x8(%ebp),%eax
801086a1:	01 d0                	add    %edx,%eax
801086a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801086a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a9:	8b 00                	mov    (%eax),%eax
801086ab:	83 e0 01             	and    $0x1,%eax
801086ae:	85 c0                	test   %eax,%eax
801086b0:	74 14                	je     801086c6 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801086b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b5:	8b 00                	mov    (%eax),%eax
801086b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086bc:	05 00 00 00 80       	add    $0x80000000,%eax
801086c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086c4:	eb 42                	jmp    80108708 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801086c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801086ca:	74 0e                	je     801086da <walkpgdir+0x4f>
801086cc:	e8 c5 a5 ff ff       	call   80102c96 <kalloc>
801086d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801086d8:	75 07                	jne    801086e1 <walkpgdir+0x56>
      return 0;
801086da:	b8 00 00 00 00       	mov    $0x0,%eax
801086df:	eb 3e                	jmp    8010871f <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801086e1:	83 ec 04             	sub    $0x4,%esp
801086e4:	68 00 10 00 00       	push   $0x1000
801086e9:	6a 00                	push   $0x0
801086eb:	ff 75 f4             	push   -0xc(%ebp)
801086ee:	e8 97 d5 ff ff       	call   80105c8a <memset>
801086f3:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801086f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f9:	05 00 00 00 80       	add    $0x80000000,%eax
801086fe:	83 c8 07             	or     $0x7,%eax
80108701:	89 c2                	mov    %eax,%edx
80108703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108706:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108708:	8b 45 0c             	mov    0xc(%ebp),%eax
8010870b:	c1 e8 0c             	shr    $0xc,%eax
8010870e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108713:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010871a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871d:	01 d0                	add    %edx,%eax
}
8010871f:	c9                   	leave
80108720:	c3                   	ret

80108721 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108721:	55                   	push   %ebp
80108722:	89 e5                	mov    %esp,%ebp
80108724:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108727:	8b 45 0c             	mov    0xc(%ebp),%eax
8010872a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010872f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108732:	8b 55 0c             	mov    0xc(%ebp),%edx
80108735:	8b 45 10             	mov    0x10(%ebp),%eax
80108738:	01 d0                	add    %edx,%eax
8010873a:	83 e8 01             	sub    $0x1,%eax
8010873d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108745:	83 ec 04             	sub    $0x4,%esp
80108748:	6a 01                	push   $0x1
8010874a:	ff 75 f4             	push   -0xc(%ebp)
8010874d:	ff 75 08             	push   0x8(%ebp)
80108750:	e8 36 ff ff ff       	call   8010868b <walkpgdir>
80108755:	83 c4 10             	add    $0x10,%esp
80108758:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010875b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010875f:	75 07                	jne    80108768 <mappages+0x47>
      return -1;
80108761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108766:	eb 47                	jmp    801087af <mappages+0x8e>
    if(*pte & PTE_P)
80108768:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010876b:	8b 00                	mov    (%eax),%eax
8010876d:	83 e0 01             	and    $0x1,%eax
80108770:	85 c0                	test   %eax,%eax
80108772:	74 0d                	je     80108781 <mappages+0x60>
      panic("remap");
80108774:	83 ec 0c             	sub    $0xc,%esp
80108777:	68 28 96 10 80       	push   $0x80109628
8010877c:	e8 32 7e ff ff       	call   801005b3 <panic>
    *pte = pa | perm | PTE_P;
80108781:	8b 45 18             	mov    0x18(%ebp),%eax
80108784:	0b 45 14             	or     0x14(%ebp),%eax
80108787:	83 c8 01             	or     $0x1,%eax
8010878a:	89 c2                	mov    %eax,%edx
8010878c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010878f:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108794:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108797:	74 10                	je     801087a9 <mappages+0x88>
      break;
    a += PGSIZE;
80108799:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801087a0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801087a7:	eb 9c                	jmp    80108745 <mappages+0x24>
      break;
801087a9:	90                   	nop
  }
  return 0;
801087aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801087af:	c9                   	leave
801087b0:	c3                   	ret

801087b1 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801087b1:	55                   	push   %ebp
801087b2:	89 e5                	mov    %esp,%ebp
801087b4:	53                   	push   %ebx
801087b5:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801087b8:	e8 d9 a4 ff ff       	call   80102c96 <kalloc>
801087bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087c4:	75 07                	jne    801087cd <setupkvm+0x1c>
    return 0;
801087c6:	b8 00 00 00 00       	mov    $0x0,%eax
801087cb:	eb 78                	jmp    80108845 <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
801087cd:	83 ec 04             	sub    $0x4,%esp
801087d0:	68 00 10 00 00       	push   $0x1000
801087d5:	6a 00                	push   $0x0
801087d7:	ff 75 f0             	push   -0x10(%ebp)
801087da:	e8 ab d4 ff ff       	call   80105c8a <memset>
801087df:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801087e2:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801087e9:	eb 4e                	jmp    80108839 <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801087eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ee:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801087f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f4:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801087f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087fa:	8b 58 08             	mov    0x8(%eax),%ebx
801087fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108800:	8b 40 04             	mov    0x4(%eax),%eax
80108803:	29 c3                	sub    %eax,%ebx
80108805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108808:	8b 00                	mov    (%eax),%eax
8010880a:	83 ec 0c             	sub    $0xc,%esp
8010880d:	51                   	push   %ecx
8010880e:	52                   	push   %edx
8010880f:	53                   	push   %ebx
80108810:	50                   	push   %eax
80108811:	ff 75 f0             	push   -0x10(%ebp)
80108814:	e8 08 ff ff ff       	call   80108721 <mappages>
80108819:	83 c4 20             	add    $0x20,%esp
8010881c:	85 c0                	test   %eax,%eax
8010881e:	79 15                	jns    80108835 <setupkvm+0x84>
      freevm(pgdir);
80108820:	83 ec 0c             	sub    $0xc,%esp
80108823:	ff 75 f0             	push   -0x10(%ebp)
80108826:	e8 f5 04 00 00       	call   80108d20 <freevm>
8010882b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010882e:	b8 00 00 00 00       	mov    $0x0,%eax
80108833:	eb 10                	jmp    80108845 <setupkvm+0x94>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108835:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108839:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108840:	72 a9                	jb     801087eb <setupkvm+0x3a>
    }
  return pgdir;
80108842:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108848:	c9                   	leave
80108849:	c3                   	ret

8010884a <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010884a:	55                   	push   %ebp
8010884b:	89 e5                	mov    %esp,%ebp
8010884d:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108850:	e8 5c ff ff ff       	call   801087b1 <setupkvm>
80108855:	a3 5c 6e 11 80       	mov    %eax,0x80116e5c
  switchkvm();
8010885a:	e8 03 00 00 00       	call   80108862 <switchkvm>
}
8010885f:	90                   	nop
80108860:	c9                   	leave
80108861:	c3                   	ret

80108862 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108862:	55                   	push   %ebp
80108863:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108865:	a1 5c 6e 11 80       	mov    0x80116e5c,%eax
8010886a:	05 00 00 00 80       	add    $0x80000000,%eax
8010886f:	50                   	push   %eax
80108870:	e8 b4 fa ff ff       	call   80108329 <lcr3>
80108875:	83 c4 04             	add    $0x4,%esp
}
80108878:	90                   	nop
80108879:	c9                   	leave
8010887a:	c3                   	ret

8010887b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010887b:	55                   	push   %ebp
8010887c:	89 e5                	mov    %esp,%ebp
8010887e:	56                   	push   %esi
8010887f:	53                   	push   %ebx
80108880:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80108883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108887:	75 0d                	jne    80108896 <switchuvm+0x1b>
    panic("switchuvm: no process");
80108889:	83 ec 0c             	sub    $0xc,%esp
8010888c:	68 2e 96 10 80       	push   $0x8010962e
80108891:	e8 1d 7d ff ff       	call   801005b3 <panic>
  if(p->kstack == 0)
80108896:	8b 45 08             	mov    0x8(%ebp),%eax
80108899:	8b 40 08             	mov    0x8(%eax),%eax
8010889c:	85 c0                	test   %eax,%eax
8010889e:	75 0d                	jne    801088ad <switchuvm+0x32>
    panic("switchuvm: no kstack");
801088a0:	83 ec 0c             	sub    $0xc,%esp
801088a3:	68 44 96 10 80       	push   $0x80109644
801088a8:	e8 06 7d ff ff       	call   801005b3 <panic>
  if(p->pgdir == 0)
801088ad:	8b 45 08             	mov    0x8(%ebp),%eax
801088b0:	8b 40 04             	mov    0x4(%eax),%eax
801088b3:	85 c0                	test   %eax,%eax
801088b5:	75 0d                	jne    801088c4 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801088b7:	83 ec 0c             	sub    $0xc,%esp
801088ba:	68 59 96 10 80       	push   $0x80109659
801088bf:	e8 ef 7c ff ff       	call   801005b3 <panic>

  pushcli();
801088c4:	e8 b6 d2 ff ff       	call   80105b7f <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801088c9:	e8 d5 bd ff ff       	call   801046a3 <mycpu>
801088ce:	89 c3                	mov    %eax,%ebx
801088d0:	e8 ce bd ff ff       	call   801046a3 <mycpu>
801088d5:	83 c0 08             	add    $0x8,%eax
801088d8:	89 c6                	mov    %eax,%esi
801088da:	e8 c4 bd ff ff       	call   801046a3 <mycpu>
801088df:	83 c0 08             	add    $0x8,%eax
801088e2:	c1 e8 10             	shr    $0x10,%eax
801088e5:	88 45 f7             	mov    %al,-0x9(%ebp)
801088e8:	e8 b6 bd ff ff       	call   801046a3 <mycpu>
801088ed:	83 c0 08             	add    $0x8,%eax
801088f0:	c1 e8 18             	shr    $0x18,%eax
801088f3:	89 c2                	mov    %eax,%edx
801088f5:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801088fc:	67 00 
801088fe:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80108905:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80108909:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010890f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108916:	83 e0 f0             	and    $0xfffffff0,%eax
80108919:	83 c8 09             	or     $0x9,%eax
8010891c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108922:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108929:	83 c8 10             	or     $0x10,%eax
8010892c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108932:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108939:	83 e0 9f             	and    $0xffffff9f,%eax
8010893c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108942:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108949:	83 c8 80             	or     $0xffffff80,%eax
8010894c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108952:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108959:	83 e0 f0             	and    $0xfffffff0,%eax
8010895c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108962:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108969:	83 e0 ef             	and    $0xffffffef,%eax
8010896c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108972:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108979:	83 e0 df             	and    $0xffffffdf,%eax
8010897c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108982:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108989:	83 c8 40             	or     $0x40,%eax
8010898c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108992:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108999:	83 e0 7f             	and    $0x7f,%eax
8010899c:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801089a2:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801089a8:	e8 f6 bc ff ff       	call   801046a3 <mycpu>
801089ad:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801089b4:	83 e2 ef             	and    $0xffffffef,%edx
801089b7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801089bd:	e8 e1 bc ff ff       	call   801046a3 <mycpu>
801089c2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801089c8:	8b 45 08             	mov    0x8(%ebp),%eax
801089cb:	8b 40 08             	mov    0x8(%eax),%eax
801089ce:	89 c3                	mov    %eax,%ebx
801089d0:	e8 ce bc ff ff       	call   801046a3 <mycpu>
801089d5:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801089db:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801089de:	e8 c0 bc ff ff       	call   801046a3 <mycpu>
801089e3:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801089e9:	83 ec 0c             	sub    $0xc,%esp
801089ec:	6a 28                	push   $0x28
801089ee:	e8 1f f9 ff ff       	call   80108312 <ltr>
801089f3:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801089f6:	8b 45 08             	mov    0x8(%ebp),%eax
801089f9:	8b 40 04             	mov    0x4(%eax),%eax
801089fc:	05 00 00 00 80       	add    $0x80000000,%eax
80108a01:	83 ec 0c             	sub    $0xc,%esp
80108a04:	50                   	push   %eax
80108a05:	e8 1f f9 ff ff       	call   80108329 <lcr3>
80108a0a:	83 c4 10             	add    $0x10,%esp
  popcli();
80108a0d:	e8 ba d1 ff ff       	call   80105bcc <popcli>
}
80108a12:	90                   	nop
80108a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a16:	5b                   	pop    %ebx
80108a17:	5e                   	pop    %esi
80108a18:	5d                   	pop    %ebp
80108a19:	c3                   	ret

80108a1a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108a1a:	55                   	push   %ebp
80108a1b:	89 e5                	mov    %esp,%ebp
80108a1d:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108a20:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108a27:	76 0d                	jbe    80108a36 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108a29:	83 ec 0c             	sub    $0xc,%esp
80108a2c:	68 6d 96 10 80       	push   $0x8010966d
80108a31:	e8 7d 7b ff ff       	call   801005b3 <panic>
  mem = kalloc();
80108a36:	e8 5b a2 ff ff       	call   80102c96 <kalloc>
80108a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108a3e:	83 ec 04             	sub    $0x4,%esp
80108a41:	68 00 10 00 00       	push   $0x1000
80108a46:	6a 00                	push   $0x0
80108a48:	ff 75 f4             	push   -0xc(%ebp)
80108a4b:	e8 3a d2 ff ff       	call   80105c8a <memset>
80108a50:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a56:	05 00 00 00 80       	add    $0x80000000,%eax
80108a5b:	83 ec 0c             	sub    $0xc,%esp
80108a5e:	6a 06                	push   $0x6
80108a60:	50                   	push   %eax
80108a61:	68 00 10 00 00       	push   $0x1000
80108a66:	6a 00                	push   $0x0
80108a68:	ff 75 08             	push   0x8(%ebp)
80108a6b:	e8 b1 fc ff ff       	call   80108721 <mappages>
80108a70:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108a73:	83 ec 04             	sub    $0x4,%esp
80108a76:	ff 75 10             	push   0x10(%ebp)
80108a79:	ff 75 0c             	push   0xc(%ebp)
80108a7c:	ff 75 f4             	push   -0xc(%ebp)
80108a7f:	e8 c5 d2 ff ff       	call   80105d49 <memmove>
80108a84:	83 c4 10             	add    $0x10,%esp
}
80108a87:	90                   	nop
80108a88:	c9                   	leave
80108a89:	c3                   	ret

80108a8a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108a8a:	55                   	push   %ebp
80108a8b:	89 e5                	mov    %esp,%ebp
80108a8d:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108a90:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a93:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a98:	85 c0                	test   %eax,%eax
80108a9a:	74 0d                	je     80108aa9 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108a9c:	83 ec 0c             	sub    $0xc,%esp
80108a9f:	68 88 96 10 80       	push   $0x80109688
80108aa4:	e8 0a 7b ff ff       	call   801005b3 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108aa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ab0:	e9 8f 00 00 00       	jmp    80108b44 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abb:	01 d0                	add    %edx,%eax
80108abd:	83 ec 04             	sub    $0x4,%esp
80108ac0:	6a 00                	push   $0x0
80108ac2:	50                   	push   %eax
80108ac3:	ff 75 08             	push   0x8(%ebp)
80108ac6:	e8 c0 fb ff ff       	call   8010868b <walkpgdir>
80108acb:	83 c4 10             	add    $0x10,%esp
80108ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108ad1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ad5:	75 0d                	jne    80108ae4 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80108ad7:	83 ec 0c             	sub    $0xc,%esp
80108ada:	68 ab 96 10 80       	push   $0x801096ab
80108adf:	e8 cf 7a ff ff       	call   801005b3 <panic>
    pa = PTE_ADDR(*pte);
80108ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ae7:	8b 00                	mov    (%eax),%eax
80108ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108af1:	8b 45 18             	mov    0x18(%ebp),%eax
80108af4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108af7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108afc:	77 0b                	ja     80108b09 <loaduvm+0x7f>
      n = sz - i;
80108afe:	8b 45 18             	mov    0x18(%ebp),%eax
80108b01:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b07:	eb 07                	jmp    80108b10 <loaduvm+0x86>
    else
      n = PGSIZE;
80108b09:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108b10:	8b 55 14             	mov    0x14(%ebp),%edx
80108b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b16:	01 d0                	add    %edx,%eax
80108b18:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108b1b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108b21:	ff 75 f0             	push   -0x10(%ebp)
80108b24:	50                   	push   %eax
80108b25:	52                   	push   %edx
80108b26:	ff 75 10             	push   0x10(%ebp)
80108b29:	e8 da 93 ff ff       	call   80101f08 <readi>
80108b2e:	83 c4 10             	add    $0x10,%esp
80108b31:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108b34:	74 07                	je     80108b3d <loaduvm+0xb3>
      return -1;
80108b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b3b:	eb 18                	jmp    80108b55 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80108b3d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b47:	3b 45 18             	cmp    0x18(%ebp),%eax
80108b4a:	0f 82 65 ff ff ff    	jb     80108ab5 <loaduvm+0x2b>
  }
  return 0;
80108b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b55:	c9                   	leave
80108b56:	c3                   	ret

80108b57 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108b57:	55                   	push   %ebp
80108b58:	89 e5                	mov    %esp,%ebp
80108b5a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108b5d:	8b 45 10             	mov    0x10(%ebp),%eax
80108b60:	85 c0                	test   %eax,%eax
80108b62:	79 0a                	jns    80108b6e <allocuvm+0x17>
    return 0;
80108b64:	b8 00 00 00 00       	mov    $0x0,%eax
80108b69:	e9 ec 00 00 00       	jmp    80108c5a <allocuvm+0x103>
  if(newsz < oldsz)
80108b6e:	8b 45 10             	mov    0x10(%ebp),%eax
80108b71:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b74:	73 08                	jae    80108b7e <allocuvm+0x27>
    return oldsz;
80108b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b79:	e9 dc 00 00 00       	jmp    80108c5a <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80108b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b81:	05 ff 0f 00 00       	add    $0xfff,%eax
80108b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108b8e:	e9 b8 00 00 00       	jmp    80108c4b <allocuvm+0xf4>
    mem = kalloc();
80108b93:	e8 fe a0 ff ff       	call   80102c96 <kalloc>
80108b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b9f:	75 2e                	jne    80108bcf <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80108ba1:	83 ec 0c             	sub    $0xc,%esp
80108ba4:	68 c9 96 10 80       	push   $0x801096c9
80108ba9:	e8 50 78 ff ff       	call   801003fe <cprintf>
80108bae:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108bb1:	83 ec 04             	sub    $0x4,%esp
80108bb4:	ff 75 0c             	push   0xc(%ebp)
80108bb7:	ff 75 10             	push   0x10(%ebp)
80108bba:	ff 75 08             	push   0x8(%ebp)
80108bbd:	e8 9a 00 00 00       	call   80108c5c <deallocuvm>
80108bc2:	83 c4 10             	add    $0x10,%esp
      return 0;
80108bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80108bca:	e9 8b 00 00 00       	jmp    80108c5a <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80108bcf:	83 ec 04             	sub    $0x4,%esp
80108bd2:	68 00 10 00 00       	push   $0x1000
80108bd7:	6a 00                	push   $0x0
80108bd9:	ff 75 f0             	push   -0x10(%ebp)
80108bdc:	e8 a9 d0 ff ff       	call   80105c8a <memset>
80108be1:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108be7:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf0:	83 ec 0c             	sub    $0xc,%esp
80108bf3:	6a 06                	push   $0x6
80108bf5:	52                   	push   %edx
80108bf6:	68 00 10 00 00       	push   $0x1000
80108bfb:	50                   	push   %eax
80108bfc:	ff 75 08             	push   0x8(%ebp)
80108bff:	e8 1d fb ff ff       	call   80108721 <mappages>
80108c04:	83 c4 20             	add    $0x20,%esp
80108c07:	85 c0                	test   %eax,%eax
80108c09:	79 39                	jns    80108c44 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80108c0b:	83 ec 0c             	sub    $0xc,%esp
80108c0e:	68 e1 96 10 80       	push   $0x801096e1
80108c13:	e8 e6 77 ff ff       	call   801003fe <cprintf>
80108c18:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108c1b:	83 ec 04             	sub    $0x4,%esp
80108c1e:	ff 75 0c             	push   0xc(%ebp)
80108c21:	ff 75 10             	push   0x10(%ebp)
80108c24:	ff 75 08             	push   0x8(%ebp)
80108c27:	e8 30 00 00 00       	call   80108c5c <deallocuvm>
80108c2c:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108c2f:	83 ec 0c             	sub    $0xc,%esp
80108c32:	ff 75 f0             	push   -0x10(%ebp)
80108c35:	e8 c2 9f ff ff       	call   80102bfc <kfree>
80108c3a:	83 c4 10             	add    $0x10,%esp
      return 0;
80108c3d:	b8 00 00 00 00       	mov    $0x0,%eax
80108c42:	eb 16                	jmp    80108c5a <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80108c44:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4e:	3b 45 10             	cmp    0x10(%ebp),%eax
80108c51:	0f 82 3c ff ff ff    	jb     80108b93 <allocuvm+0x3c>
    }
  }
  return newsz;
80108c57:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108c5a:	c9                   	leave
80108c5b:	c3                   	ret

80108c5c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108c5c:	55                   	push   %ebp
80108c5d:	89 e5                	mov    %esp,%ebp
80108c5f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108c62:	8b 45 10             	mov    0x10(%ebp),%eax
80108c65:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c68:	72 08                	jb     80108c72 <deallocuvm+0x16>
    return oldsz;
80108c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c6d:	e9 ac 00 00 00       	jmp    80108d1e <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80108c72:	8b 45 10             	mov    0x10(%ebp),%eax
80108c75:	05 ff 0f 00 00       	add    $0xfff,%eax
80108c7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108c82:	e9 88 00 00 00       	jmp    80108d0f <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8a:	83 ec 04             	sub    $0x4,%esp
80108c8d:	6a 00                	push   $0x0
80108c8f:	50                   	push   %eax
80108c90:	ff 75 08             	push   0x8(%ebp)
80108c93:	e8 f3 f9 ff ff       	call   8010868b <walkpgdir>
80108c98:	83 c4 10             	add    $0x10,%esp
80108c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ca2:	75 16                	jne    80108cba <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca7:	c1 e8 16             	shr    $0x16,%eax
80108caa:	83 c0 01             	add    $0x1,%eax
80108cad:	c1 e0 16             	shl    $0x16,%eax
80108cb0:	2d 00 10 00 00       	sub    $0x1000,%eax
80108cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108cb8:	eb 4e                	jmp    80108d08 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80108cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cbd:	8b 00                	mov    (%eax),%eax
80108cbf:	83 e0 01             	and    $0x1,%eax
80108cc2:	85 c0                	test   %eax,%eax
80108cc4:	74 42                	je     80108d08 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80108cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc9:	8b 00                	mov    (%eax),%eax
80108ccb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108cd7:	75 0d                	jne    80108ce6 <deallocuvm+0x8a>
        panic("kfree");
80108cd9:	83 ec 0c             	sub    $0xc,%esp
80108cdc:	68 fd 96 10 80       	push   $0x801096fd
80108ce1:	e8 cd 78 ff ff       	call   801005b3 <panic>
      char *v = P2V(pa);
80108ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ce9:	05 00 00 00 80       	add    $0x80000000,%eax
80108cee:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108cf1:	83 ec 0c             	sub    $0xc,%esp
80108cf4:	ff 75 e8             	push   -0x18(%ebp)
80108cf7:	e8 00 9f ff ff       	call   80102bfc <kfree>
80108cfc:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108d08:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d12:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d15:	0f 82 6c ff ff ff    	jb     80108c87 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108d1b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108d1e:	c9                   	leave
80108d1f:	c3                   	ret

80108d20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108d20:	55                   	push   %ebp
80108d21:	89 e5                	mov    %esp,%ebp
80108d23:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108d2a:	75 0d                	jne    80108d39 <freevm+0x19>
    panic("freevm: no pgdir");
80108d2c:	83 ec 0c             	sub    $0xc,%esp
80108d2f:	68 03 97 10 80       	push   $0x80109703
80108d34:	e8 7a 78 ff ff       	call   801005b3 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108d39:	83 ec 04             	sub    $0x4,%esp
80108d3c:	6a 00                	push   $0x0
80108d3e:	68 00 00 00 80       	push   $0x80000000
80108d43:	ff 75 08             	push   0x8(%ebp)
80108d46:	e8 11 ff ff ff       	call   80108c5c <deallocuvm>
80108d4b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108d4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d55:	eb 48                	jmp    80108d9f <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80108d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108d61:	8b 45 08             	mov    0x8(%ebp),%eax
80108d64:	01 d0                	add    %edx,%eax
80108d66:	8b 00                	mov    (%eax),%eax
80108d68:	83 e0 01             	and    $0x1,%eax
80108d6b:	85 c0                	test   %eax,%eax
80108d6d:	74 2c                	je     80108d9b <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108d79:	8b 45 08             	mov    0x8(%ebp),%eax
80108d7c:	01 d0                	add    %edx,%eax
80108d7e:	8b 00                	mov    (%eax),%eax
80108d80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d85:	05 00 00 00 80       	add    $0x80000000,%eax
80108d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108d8d:	83 ec 0c             	sub    $0xc,%esp
80108d90:	ff 75 f0             	push   -0x10(%ebp)
80108d93:	e8 64 9e ff ff       	call   80102bfc <kfree>
80108d98:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108d9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108d9f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108da6:	76 af                	jbe    80108d57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108da8:	83 ec 0c             	sub    $0xc,%esp
80108dab:	ff 75 08             	push   0x8(%ebp)
80108dae:	e8 49 9e ff ff       	call   80102bfc <kfree>
80108db3:	83 c4 10             	add    $0x10,%esp
}
80108db6:	90                   	nop
80108db7:	c9                   	leave
80108db8:	c3                   	ret

80108db9 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108db9:	55                   	push   %ebp
80108dba:	89 e5                	mov    %esp,%ebp
80108dbc:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108dbf:	83 ec 04             	sub    $0x4,%esp
80108dc2:	6a 00                	push   $0x0
80108dc4:	ff 75 0c             	push   0xc(%ebp)
80108dc7:	ff 75 08             	push   0x8(%ebp)
80108dca:	e8 bc f8 ff ff       	call   8010868b <walkpgdir>
80108dcf:	83 c4 10             	add    $0x10,%esp
80108dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108dd9:	75 0d                	jne    80108de8 <clearpteu+0x2f>
    panic("clearpteu");
80108ddb:	83 ec 0c             	sub    $0xc,%esp
80108dde:	68 14 97 10 80       	push   $0x80109714
80108de3:	e8 cb 77 ff ff       	call   801005b3 <panic>
  *pte &= ~PTE_U;
80108de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108deb:	8b 00                	mov    (%eax),%eax
80108ded:	83 e0 fb             	and    $0xfffffffb,%eax
80108df0:	89 c2                	mov    %eax,%edx
80108df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df5:	89 10                	mov    %edx,(%eax)
}
80108df7:	90                   	nop
80108df8:	c9                   	leave
80108df9:	c3                   	ret

80108dfa <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108dfa:	55                   	push   %ebp
80108dfb:	89 e5                	mov    %esp,%ebp
80108dfd:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108e00:	e8 ac f9 ff ff       	call   801087b1 <setupkvm>
80108e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108e08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108e0c:	75 0a                	jne    80108e18 <copyuvm+0x1e>
    return 0;
80108e0e:	b8 00 00 00 00       	mov    $0x0,%eax
80108e13:	e9 f8 00 00 00       	jmp    80108f10 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80108e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e1f:	e9 c7 00 00 00       	jmp    80108eeb <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e27:	83 ec 04             	sub    $0x4,%esp
80108e2a:	6a 00                	push   $0x0
80108e2c:	50                   	push   %eax
80108e2d:	ff 75 08             	push   0x8(%ebp)
80108e30:	e8 56 f8 ff ff       	call   8010868b <walkpgdir>
80108e35:	83 c4 10             	add    $0x10,%esp
80108e38:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108e3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108e3f:	75 0d                	jne    80108e4e <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80108e41:	83 ec 0c             	sub    $0xc,%esp
80108e44:	68 1e 97 10 80       	push   $0x8010971e
80108e49:	e8 65 77 ff ff       	call   801005b3 <panic>
    if(!(*pte & PTE_P))
80108e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e51:	8b 00                	mov    (%eax),%eax
80108e53:	83 e0 01             	and    $0x1,%eax
80108e56:	85 c0                	test   %eax,%eax
80108e58:	75 0d                	jne    80108e67 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80108e5a:	83 ec 0c             	sub    $0xc,%esp
80108e5d:	68 38 97 10 80       	push   $0x80109738
80108e62:	e8 4c 77 ff ff       	call   801005b3 <panic>
    pa = PTE_ADDR(*pte);
80108e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e6a:	8b 00                	mov    (%eax),%eax
80108e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e77:	8b 00                	mov    (%eax),%eax
80108e79:	25 ff 0f 00 00       	and    $0xfff,%eax
80108e7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108e81:	e8 10 9e ff ff       	call   80102c96 <kalloc>
80108e86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108e89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108e8d:	74 6d                	je     80108efc <copyuvm+0x102>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108e8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e92:	05 00 00 00 80       	add    $0x80000000,%eax
80108e97:	83 ec 04             	sub    $0x4,%esp
80108e9a:	68 00 10 00 00       	push   $0x1000
80108e9f:	50                   	push   %eax
80108ea0:	ff 75 e0             	push   -0x20(%ebp)
80108ea3:	e8 a1 ce ff ff       	call   80105d49 <memmove>
80108ea8:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108eab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108eb1:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eba:	83 ec 0c             	sub    $0xc,%esp
80108ebd:	52                   	push   %edx
80108ebe:	51                   	push   %ecx
80108ebf:	68 00 10 00 00       	push   $0x1000
80108ec4:	50                   	push   %eax
80108ec5:	ff 75 f0             	push   -0x10(%ebp)
80108ec8:	e8 54 f8 ff ff       	call   80108721 <mappages>
80108ecd:	83 c4 20             	add    $0x20,%esp
80108ed0:	85 c0                	test   %eax,%eax
80108ed2:	79 10                	jns    80108ee4 <copyuvm+0xea>
      kfree(mem);
80108ed4:	83 ec 0c             	sub    $0xc,%esp
80108ed7:	ff 75 e0             	push   -0x20(%ebp)
80108eda:	e8 1d 9d ff ff       	call   80102bfc <kfree>
80108edf:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108ee2:	eb 19                	jmp    80108efd <copyuvm+0x103>
  for(i = 0; i < sz; i += PGSIZE){
80108ee4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eee:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ef1:	0f 82 2d ff ff ff    	jb     80108e24 <copyuvm+0x2a>
    }
  }
  return d;
80108ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108efa:	eb 14                	jmp    80108f10 <copyuvm+0x116>
      goto bad;
80108efc:	90                   	nop

bad:
  freevm(d);
80108efd:	83 ec 0c             	sub    $0xc,%esp
80108f00:	ff 75 f0             	push   -0x10(%ebp)
80108f03:	e8 18 fe ff ff       	call   80108d20 <freevm>
80108f08:	83 c4 10             	add    $0x10,%esp
  return 0;
80108f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f10:	c9                   	leave
80108f11:	c3                   	ret

80108f12 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108f12:	55                   	push   %ebp
80108f13:	89 e5                	mov    %esp,%ebp
80108f15:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108f18:	83 ec 04             	sub    $0x4,%esp
80108f1b:	6a 00                	push   $0x0
80108f1d:	ff 75 0c             	push   0xc(%ebp)
80108f20:	ff 75 08             	push   0x8(%ebp)
80108f23:	e8 63 f7 ff ff       	call   8010868b <walkpgdir>
80108f28:	83 c4 10             	add    $0x10,%esp
80108f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f31:	8b 00                	mov    (%eax),%eax
80108f33:	83 e0 01             	and    $0x1,%eax
80108f36:	85 c0                	test   %eax,%eax
80108f38:	75 07                	jne    80108f41 <uva2ka+0x2f>
    return 0;
80108f3a:	b8 00 00 00 00       	mov    $0x0,%eax
80108f3f:	eb 22                	jmp    80108f63 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80108f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f44:	8b 00                	mov    (%eax),%eax
80108f46:	83 e0 04             	and    $0x4,%eax
80108f49:	85 c0                	test   %eax,%eax
80108f4b:	75 07                	jne    80108f54 <uva2ka+0x42>
    return 0;
80108f4d:	b8 00 00 00 00       	mov    $0x0,%eax
80108f52:	eb 0f                	jmp    80108f63 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80108f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f57:	8b 00                	mov    (%eax),%eax
80108f59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f5e:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108f63:	c9                   	leave
80108f64:	c3                   	ret

80108f65 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108f65:	55                   	push   %ebp
80108f66:	89 e5                	mov    %esp,%ebp
80108f68:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108f6b:	8b 45 10             	mov    0x10(%ebp),%eax
80108f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108f71:	eb 7f                	jmp    80108ff2 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108f73:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f81:	83 ec 08             	sub    $0x8,%esp
80108f84:	50                   	push   %eax
80108f85:	ff 75 08             	push   0x8(%ebp)
80108f88:	e8 85 ff ff ff       	call   80108f12 <uva2ka>
80108f8d:	83 c4 10             	add    $0x10,%esp
80108f90:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108f93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108f97:	75 07                	jne    80108fa0 <copyout+0x3b>
      return -1;
80108f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f9e:	eb 61                	jmp    80109001 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fa3:	2b 45 0c             	sub    0xc(%ebp),%eax
80108fa6:	05 00 10 00 00       	add    $0x1000,%eax
80108fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fb1:	39 45 14             	cmp    %eax,0x14(%ebp)
80108fb4:	73 06                	jae    80108fbc <copyout+0x57>
      n = len;
80108fb6:	8b 45 14             	mov    0x14(%ebp),%eax
80108fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fbf:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108fc2:	89 c2                	mov    %eax,%edx
80108fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fc7:	01 d0                	add    %edx,%eax
80108fc9:	83 ec 04             	sub    $0x4,%esp
80108fcc:	ff 75 f0             	push   -0x10(%ebp)
80108fcf:	ff 75 f4             	push   -0xc(%ebp)
80108fd2:	50                   	push   %eax
80108fd3:	e8 71 cd ff ff       	call   80105d49 <memmove>
80108fd8:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fde:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fe4:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fea:	05 00 10 00 00       	add    $0x1000,%eax
80108fef:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108ff2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ff6:	0f 85 77 ff ff ff    	jne    80108f73 <copyout+0xe>
  }
  return 0;
80108ffc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109001:	c9                   	leave
80109002:	c3                   	ret
