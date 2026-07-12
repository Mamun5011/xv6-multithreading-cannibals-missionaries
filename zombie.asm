
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 42 01             	lea    0x1(%edx),%eax
  65:	89 45 0c             	mov    %eax,0xc(%ebp)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8d 48 01             	lea    0x1(%eax),%ecx
  6e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave
  81:	c3                   	ret

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret

000000c1 <strlen>:

uint
strlen(const char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave
  e7:	c3                   	ret

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	push   0xc(%ebp)
  f2:	ff 75 08             	push   0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave
 101:	c3                   	ret

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 45 fc             	cmp    %al,-0x4(%ebp)
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave
 134:	c3                   	ret

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18f:	7f b3                	jg     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
      break;
 193:	90                   	nop
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave
 1a3:	c3                   	ret

000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	push   0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	push   0xc(%ebp)
 1d0:	ff 75 f4             	push   -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	push   -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave
 1f0:	c3                   	ret

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave
 23d:	c3                   	ret

0000023e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 55 f8             	mov    -0x8(%ebp),%edx
 255:	8d 42 01             	lea    0x1(%edx),%eax
 258:	89 45 f8             	mov    %eax,-0x8(%ebp)
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25e:	8d 48 01             	lea    0x1(%eax),%ecx
 261:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave
 27a:	c3                   	ret

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <clone>:

SYSCALL(clone)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <join>:
SYSCALL(join)
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <thread_exit>:
SYSCALL(thread_exit)
 333:	b8 18 00 00 00       	mov    $0x18,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <randconfig>:
SYSCALL(randconfig)
 33b:	b8 19 00 00 00       	mov    $0x19,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <yield>:
SYSCALL(yield)
 343:	b8 1a 00 00 00       	mov    $0x1a,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <lock_create>:
SYSCALL(lock_create)
 34b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <lock_acquire>:
SYSCALL(lock_acquire)
 353:	b8 1c 00 00 00       	mov    $0x1c,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <lock_release>:
SYSCALL(lock_release)
 35b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <sem_create>:
SYSCALL(sem_create)
 363:	b8 1e 00 00 00       	mov    $0x1e,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <sem_wait>:
SYSCALL(sem_wait)
 36b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <sem_post>:
SYSCALL(sem_post)
 373:	b8 20 00 00 00       	mov    $0x20,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 18             	sub    $0x18,%esp
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 387:	83 ec 04             	sub    $0x4,%esp
 38a:	6a 01                	push   $0x1
 38c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38f:	50                   	push   %eax
 390:	ff 75 08             	push   0x8(%ebp)
 393:	e8 0b ff ff ff       	call   2a3 <write>
 398:	83 c4 10             	add    $0x10,%esp
}
 39b:	90                   	nop
 39c:	c9                   	leave
 39d:	c3                   	ret

0000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ab:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3af:	74 17                	je     3c8 <printint+0x2a>
 3b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b5:	79 11                	jns    3c8 <printint+0x2a>
    neg = 1;
 3b7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	f7 d8                	neg    %eax
 3c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c6:	eb 06                	jmp    3ce <printint+0x30>
  } else {
    x = xx;
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3db:	ba 00 00 00 00       	mov    $0x0,%edx
 3e0:	f7 f1                	div    %ecx
 3e2:	89 d1                	mov    %edx,%ecx
 3e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e7:	8d 50 01             	lea    0x1(%eax),%edx
 3ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ed:	0f b6 91 b0 0d 00 00 	movzbl 0xdb0(%ecx),%edx
 3f4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fe:	ba 00 00 00 00       	mov    $0x0,%edx
 403:	f7 f1                	div    %ecx
 405:	89 45 ec             	mov    %eax,-0x14(%ebp)
 408:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40c:	75 c7                	jne    3d5 <printint+0x37>
  if(neg)
 40e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 412:	74 2d                	je     441 <printint+0xa3>
    buf[i++] = '-';
 414:	8b 45 f4             	mov    -0xc(%ebp),%eax
 417:	8d 50 01             	lea    0x1(%eax),%edx
 41a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 422:	eb 1d                	jmp    441 <printint+0xa3>
    putc(fd, buf[i]);
 424:	8d 55 dc             	lea    -0x24(%ebp),%edx
 427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42a:	01 d0                	add    %edx,%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	0f be c0             	movsbl %al,%eax
 432:	83 ec 08             	sub    $0x8,%esp
 435:	50                   	push   %eax
 436:	ff 75 08             	push   0x8(%ebp)
 439:	e8 3d ff ff ff       	call   37b <putc>
 43e:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 441:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 449:	79 d9                	jns    424 <printint+0x86>
}
 44b:	90                   	nop
 44c:	90                   	nop
 44d:	c9                   	leave
 44e:	c3                   	ret

0000044f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45c:	8d 45 0c             	lea    0xc(%ebp),%eax
 45f:	83 c0 04             	add    $0x4,%eax
 462:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46c:	e9 59 01 00 00       	jmp    5ca <printf+0x17b>
    c = fmt[i] & 0xff;
 471:	8b 55 0c             	mov    0xc(%ebp),%edx
 474:	8b 45 f0             	mov    -0x10(%ebp),%eax
 477:	01 d0                	add    %edx,%eax
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	0f be c0             	movsbl %al,%eax
 47f:	25 ff 00 00 00       	and    $0xff,%eax
 484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48b:	75 2c                	jne    4b9 <printf+0x6a>
      if(c == '%'){
 48d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 491:	75 0c                	jne    49f <printf+0x50>
        state = '%';
 493:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49a:	e9 27 01 00 00       	jmp    5c6 <printf+0x177>
      } else {
        putc(fd, c);
 49f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	50                   	push   %eax
 4a9:	ff 75 08             	push   0x8(%ebp)
 4ac:	e8 ca fe ff ff       	call   37b <putc>
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	e9 0d 01 00 00       	jmp    5c6 <printf+0x177>
      }
    } else if(state == '%'){
 4b9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bd:	0f 85 03 01 00 00    	jne    5c6 <printf+0x177>
      if(c == 'd'){
 4c3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c7:	75 1e                	jne    4e7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cc:	8b 00                	mov    (%eax),%eax
 4ce:	6a 01                	push   $0x1
 4d0:	6a 0a                	push   $0xa
 4d2:	50                   	push   %eax
 4d3:	ff 75 08             	push   0x8(%ebp)
 4d6:	e8 c3 fe ff ff       	call   39e <printint>
 4db:	83 c4 10             	add    $0x10,%esp
        ap++;
 4de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e2:	e9 d8 00 00 00       	jmp    5bf <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4eb:	74 06                	je     4f3 <printf+0xa4>
 4ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f1:	75 1e                	jne    511 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	6a 00                	push   $0x0
 4fa:	6a 10                	push   $0x10
 4fc:	50                   	push   %eax
 4fd:	ff 75 08             	push   0x8(%ebp)
 500:	e8 99 fe ff ff       	call   39e <printint>
 505:	83 c4 10             	add    $0x10,%esp
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50c:	e9 ae 00 00 00       	jmp    5bf <printf+0x170>
      } else if(c == 's'){
 511:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 515:	75 43                	jne    55a <printf+0x10b>
        s = (char*)*ap;
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 527:	75 25                	jne    54e <printf+0xff>
          s = "(null)";
 529:	c7 45 f4 0d 0a 00 00 	movl   $0xa0d,-0xc(%ebp)
        while(*s != 0){
 530:	eb 1c                	jmp    54e <printf+0xff>
          putc(fd, *s);
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	push   0x8(%ebp)
 542:	e8 34 fe ff ff       	call   37b <putc>
 547:	83 c4 10             	add    $0x10,%esp
          s++;
 54a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	84 c0                	test   %al,%al
 556:	75 da                	jne    532 <printf+0xe3>
 558:	eb 65                	jmp    5bf <printf+0x170>
        }
      } else if(c == 'c'){
 55a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55e:	75 1d                	jne    57d <printf+0x12e>
        putc(fd, *ap);
 560:	8b 45 e8             	mov    -0x18(%ebp),%eax
 563:	8b 00                	mov    (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	83 ec 08             	sub    $0x8,%esp
 56b:	50                   	push   %eax
 56c:	ff 75 08             	push   0x8(%ebp)
 56f:	e8 07 fe ff ff       	call   37b <putc>
 574:	83 c4 10             	add    $0x10,%esp
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57b:	eb 42                	jmp    5bf <printf+0x170>
      } else if(c == '%'){
 57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 581:	75 17                	jne    59a <printf+0x14b>
        putc(fd, c);
 583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	83 ec 08             	sub    $0x8,%esp
 58c:	50                   	push   %eax
 58d:	ff 75 08             	push   0x8(%ebp)
 590:	e8 e6 fd ff ff       	call   37b <putc>
 595:	83 c4 10             	add    $0x10,%esp
 598:	eb 25                	jmp    5bf <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	6a 25                	push   $0x25
 59f:	ff 75 08             	push   0x8(%ebp)
 5a2:	e8 d4 fd ff ff       	call   37b <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	50                   	push   %eax
 5b4:	ff 75 08             	push   0x8(%ebp)
 5b7:	e8 bf fd ff ff       	call   37b <putc>
 5bc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	84 c0                	test   %al,%al
 5d7:	0f 85 94 fe ff ff    	jne    471 <printf+0x22>
    }
  }
}
 5dd:	90                   	nop
 5de:	90                   	nop
 5df:	c9                   	leave
 5e0:	c3                   	ret

000005e1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	83 e8 08             	sub    $0x8,%eax
 5ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f0:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 5f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f8:	eb 24                	jmp    61e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 602:	72 12                	jb     616 <free+0x35>
 604:	8b 45 f8             	mov    -0x8(%ebp),%eax
 607:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 60a:	72 24                	jb     630 <free+0x4f>
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 614:	72 1a                	jb     630 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 616:	8b 45 fc             	mov    -0x4(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 624:	73 d4                	jae    5fa <free+0x19>
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 62e:	73 ca                	jae    5fa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	8b 40 04             	mov    0x4(%eax),%eax
 636:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	01 c2                	add    %eax,%edx
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	39 c2                	cmp    %eax,%edx
 649:	75 24                	jne    66f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	8b 50 04             	mov    0x4(%eax),%edx
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	01 c2                	add    %eax,%edx
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	89 10                	mov    %edx,(%eax)
 66d:	eb 0a                	jmp    679 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 10                	mov    (%eax),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 40 04             	mov    0x4(%eax),%eax
 67f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	01 d0                	add    %edx,%eax
 68b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68e:	75 20                	jne    6b0 <free+0xcf>
    p->s.size += bp->s.size;
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 50 04             	mov    0x4(%eax),%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 40 04             	mov    0x4(%eax),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 10                	mov    (%eax),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	89 10                	mov    %edx,(%eax)
 6ae:	eb 08                	jmp    6b8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	a3 cc 0d 00 00       	mov    %eax,0xdcc
}
 6c0:	90                   	nop
 6c1:	c9                   	leave
 6c2:	c3                   	ret

000006c3 <morecore>:

static Header*
morecore(uint nu)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d0:	77 07                	ja     6d9 <morecore+0x16>
    nu = 4096;
 6d2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	c1 e0 03             	shl    $0x3,%eax
 6df:	83 ec 0c             	sub    $0xc,%esp
 6e2:	50                   	push   %eax
 6e3:	e8 23 fc ff ff       	call   30b <sbrk>
 6e8:	83 c4 10             	add    $0x10,%esp
 6eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ee:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f2:	75 07                	jne    6fb <morecore+0x38>
    return 0;
 6f4:	b8 00 00 00 00       	mov    $0x0,%eax
 6f9:	eb 26                	jmp    721 <morecore+0x5e>
  hp = (Header*)p;
 6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	8b 55 08             	mov    0x8(%ebp),%edx
 707:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70d:	83 c0 08             	add    $0x8,%eax
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	50                   	push   %eax
 714:	e8 c8 fe ff ff       	call   5e1 <free>
 719:	83 c4 10             	add    $0x10,%esp
  return freep;
 71c:	a1 cc 0d 00 00       	mov    0xdcc,%eax
}
 721:	c9                   	leave
 722:	c3                   	ret

00000723 <malloc>:

void*
malloc(uint nbytes)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	83 c0 07             	add    $0x7,%eax
 72f:	c1 e8 03             	shr    $0x3,%eax
 732:	83 c0 01             	add    $0x1,%eax
 735:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 738:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 73d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 744:	75 23                	jne    769 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 746:	c7 45 f0 c4 0d 00 00 	movl   $0xdc4,-0x10(%ebp)
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	a3 cc 0d 00 00       	mov    %eax,0xdcc
 755:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 75a:	a3 c4 0d 00 00       	mov    %eax,0xdc4
    base.s.size = 0;
 75f:	c7 05 c8 0d 00 00 00 	movl   $0x0,0xdc8
 766:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77a:	72 4d                	jb     7c9 <malloc+0xa6>
      if(p->s.size == nunits)
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 785:	75 0c                	jne    793 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	89 10                	mov    %edx,(%eax)
 791:	eb 26                	jmp    7b9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	2b 45 ec             	sub    -0x14(%ebp),%eax
 79c:	89 c2                	mov    %eax,%edx
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	c1 e0 03             	shl    $0x3,%eax
 7ad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	a3 cc 0d 00 00       	mov    %eax,0xdcc
      return (void*)(p + 1);
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	83 c0 08             	add    $0x8,%eax
 7c7:	eb 3b                	jmp    804 <malloc+0xe1>
    }
    if(p == freep)
 7c9:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 7ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d1:	75 1e                	jne    7f1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d3:	83 ec 0c             	sub    $0xc,%esp
 7d6:	ff 75 ec             	push   -0x14(%ebp)
 7d9:	e8 e5 fe ff ff       	call   6c3 <morecore>
 7de:	83 c4 10             	add    $0x10,%esp
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e8:	75 07                	jne    7f1 <malloc+0xce>
        return 0;
 7ea:	b8 00 00 00 00       	mov    $0x0,%eax
 7ef:	eb 13                	jmp    804 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ff:	e9 6d ff ff ff       	jmp    771 <malloc+0x4e>
  }
}
 804:	c9                   	leave
 805:	c3                   	ret

00000806 <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 806:	55                   	push   %ebp
 807:	89 e5                	mov    %esp,%ebp
 809:	83 ec 18             	sub    $0x18,%esp
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	8b 50 04             	mov    0x4(%eax),%edx
 812:	8b 00                	mov    (%eax),%eax
 814:	89 45 f0             	mov    %eax,-0x10(%ebp)
 817:	89 55 f4             	mov    %edx,-0xc(%ebp)
 81a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	52                   	push   %edx
 824:	ff d0                	call   *%eax
 826:	83 c4 10             	add    $0x10,%esp
 829:	e8 05 fb ff ff       	call   333 <thread_exit>

0000082e <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 82e:	55                   	push   %ebp
 82f:	89 e5                	mov    %esp,%ebp
 831:	83 ec 18             	sub    $0x18,%esp
 834:	83 ec 0c             	sub    $0xc,%esp
 837:	68 00 20 00 00       	push   $0x2000
 83c:	e8 e2 fe ff ff       	call   723 <malloc>
 841:	83 c4 10             	add    $0x10,%esp
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
 847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84b:	75 0a                	jne    857 <pthread_create+0x29>
 84d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 852:	e9 9b 00 00 00       	jmp    8f2 <pthread_create+0xc4>
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	05 ff 0f 00 00       	add    $0xfff,%eax
 85f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 864:	89 45 f0             	mov    %eax,-0x10(%ebp)
 867:	83 ec 0c             	sub    $0xc,%esp
 86a:	6a 08                	push   $0x8
 86c:	e8 b2 fe ff ff       	call   723 <malloc>
 871:	83 c4 10             	add    $0x10,%esp
 874:	89 45 ec             	mov    %eax,-0x14(%ebp)
 877:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 87b:	75 15                	jne    892 <pthread_create+0x64>
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	ff 75 f4             	push   -0xc(%ebp)
 883:	e8 59 fd ff ff       	call   5e1 <free>
 888:	83 c4 10             	add    $0x10,%esp
 88b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 890:	eb 60                	jmp    8f2 <pthread_create+0xc4>
 892:	8b 45 ec             	mov    -0x14(%ebp),%eax
 895:	8b 55 10             	mov    0x10(%ebp),%edx
 898:	89 10                	mov    %edx,(%eax)
 89a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89d:	8b 55 14             	mov    0x14(%ebp),%edx
 8a0:	89 50 04             	mov    %edx,0x4(%eax)
 8a3:	83 ec 04             	sub    $0x4,%esp
 8a6:	ff 75 f0             	push   -0x10(%ebp)
 8a9:	ff 75 ec             	push   -0x14(%ebp)
 8ac:	68 06 08 00 00       	push   $0x806
 8b1:	e8 6d fa ff ff       	call   323 <clone>
 8b6:	83 c4 10             	add    $0x10,%esp
 8b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 8c0:	79 23                	jns    8e5 <pthread_create+0xb7>
 8c2:	83 ec 0c             	sub    $0xc,%esp
 8c5:	ff 75 ec             	push   -0x14(%ebp)
 8c8:	e8 14 fd ff ff       	call   5e1 <free>
 8cd:	83 c4 10             	add    $0x10,%esp
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	ff 75 f4             	push   -0xc(%ebp)
 8d6:	e8 06 fd ff ff       	call   5e1 <free>
 8db:	83 c4 10             	add    $0x10,%esp
 8de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8e3:	eb 0d                	jmp    8f2 <pthread_create+0xc4>
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
 8eb:	89 10                	mov    %edx,(%eax)
 8ed:	b8 00 00 00 00       	mov    $0x0,%eax
 8f2:	c9                   	leave
 8f3:	c3                   	ret

000008f4 <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 18             	sub    $0x18,%esp
 8fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 901:	83 ec 08             	sub    $0x8,%esp
 904:	8d 45 f0             	lea    -0x10(%ebp),%eax
 907:	50                   	push   %eax
 908:	ff 75 08             	push   0x8(%ebp)
 90b:	e8 1b fa ff ff       	call   32b <join>
 910:	83 c4 10             	add    $0x10,%esp
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	3b 45 08             	cmp    0x8(%ebp),%eax
 91c:	75 07                	jne    925 <pthread_join+0x31>
 91e:	b8 00 00 00 00       	mov    $0x0,%eax
 923:	eb 05                	jmp    92a <pthread_join+0x36>
 925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 92a:	c9                   	leave
 92b:	c3                   	ret

0000092c <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 92c:	55                   	push   %ebp
 92d:	89 e5                	mov    %esp,%ebp
 92f:	83 ec 08             	sub    $0x8,%esp
 932:	e8 fc f9 ff ff       	call   333 <thread_exit>

00000937 <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 937:	55                   	push   %ebp
 938:	89 e5                	mov    %esp,%ebp
 93a:	83 ec 08             	sub    $0x8,%esp
 93d:	e8 09 fa ff ff       	call   34b <lock_create>
 942:	8b 55 08             	mov    0x8(%ebp),%edx
 945:	89 02                	mov    %eax,(%edx)
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	8b 00                	mov    (%eax),%eax
 94c:	85 c0                	test   %eax,%eax
 94e:	79 07                	jns    957 <pthread_mutex_init+0x20>
 950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 955:	eb 05                	jmp    95c <pthread_mutex_init+0x25>
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	c9                   	leave
 95d:	c3                   	ret

0000095e <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 95e:	55                   	push   %ebp
 95f:	89 e5                	mov    %esp,%ebp
 961:	83 ec 08             	sub    $0x8,%esp
 964:	8b 45 08             	mov    0x8(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	83 ec 0c             	sub    $0xc,%esp
 96c:	50                   	push   %eax
 96d:	e8 e1 f9 ff ff       	call   353 <lock_acquire>
 972:	83 c4 10             	add    $0x10,%esp
 975:	c9                   	leave
 976:	c3                   	ret

00000977 <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 977:	55                   	push   %ebp
 978:	89 e5                	mov    %esp,%ebp
 97a:	83 ec 08             	sub    $0x8,%esp
 97d:	8b 45 08             	mov    0x8(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	83 ec 0c             	sub    $0xc,%esp
 985:	50                   	push   %eax
 986:	e8 d0 f9 ff ff       	call   35b <lock_release>
 98b:	83 c4 10             	add    $0x10,%esp
 98e:	c9                   	leave
 98f:	c3                   	ret

00000990 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	83 ec 08             	sub    $0x8,%esp
 996:	8b 45 10             	mov    0x10(%ebp),%eax
 999:	83 ec 0c             	sub    $0xc,%esp
 99c:	50                   	push   %eax
 99d:	e8 c1 f9 ff ff       	call   363 <sem_create>
 9a2:	83 c4 10             	add    $0x10,%esp
 9a5:	8b 55 08             	mov    0x8(%ebp),%edx
 9a8:	89 02                	mov    %eax,(%edx)
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
 9ad:	8b 00                	mov    (%eax),%eax
 9af:	85 c0                	test   %eax,%eax
 9b1:	79 07                	jns    9ba <sem_init+0x2a>
 9b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9b8:	eb 05                	jmp    9bf <sem_init+0x2f>
 9ba:	b8 00 00 00 00       	mov    $0x0,%eax
 9bf:	c9                   	leave
 9c0:	c3                   	ret

000009c1 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 9c1:	55                   	push   %ebp
 9c2:	89 e5                	mov    %esp,%ebp
 9c4:	83 ec 08             	sub    $0x8,%esp
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	8b 00                	mov    (%eax),%eax
 9cc:	83 ec 0c             	sub    $0xc,%esp
 9cf:	50                   	push   %eax
 9d0:	e8 96 f9 ff ff       	call   36b <sem_wait>
 9d5:	83 c4 10             	add    $0x10,%esp
 9d8:	c9                   	leave
 9d9:	c3                   	ret

000009da <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 9da:	55                   	push   %ebp
 9db:	89 e5                	mov    %esp,%ebp
 9dd:	83 ec 08             	sub    $0x8,%esp
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	8b 00                	mov    (%eax),%eax
 9e5:	83 ec 0c             	sub    $0xc,%esp
 9e8:	50                   	push   %eax
 9e9:	e8 85 f9 ff ff       	call   373 <sem_post>
 9ee:	83 c4 10             	add    $0x10,%esp
 9f1:	c9                   	leave
 9f2:	c3                   	ret

000009f3 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 9f3:	55                   	push   %ebp
 9f4:	89 e5                	mov    %esp,%ebp
 9f6:	83 ec 08             	sub    $0x8,%esp
 9f9:	83 ec 08             	sub    $0x8,%esp
 9fc:	ff 75 0c             	push   0xc(%ebp)
 9ff:	ff 75 08             	push   0x8(%ebp)
 a02:	e8 34 f9 ff ff       	call   33b <randconfig>
 a07:	83 c4 10             	add    $0x10,%esp
 a0a:	90                   	nop
 a0b:	c9                   	leave
 a0c:	c3                   	ret
