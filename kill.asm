
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 53 0a 00 00       	push   $0xa53
  21:	6a 02                	push   $0x2
  23:	e8 6d 04 00 00       	call   495 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave
  c7:	c3                   	ret

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret

00000107 <strlen>:

uint
strlen(const char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave
 12d:	c3                   	ret

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	push   0xc(%ebp)
 138:	ff 75 08             	push   0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave
 147:	c3                   	ret

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave
 17a:	c3                   	ret

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave
 1e9:	c3                   	ret

000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	push   0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	ff 75 f4             	push   -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	push   -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave
 236:	c3                   	ret

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave
 283:	c3                   	ret

00000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave
 2c0:	c3                   	ret

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret

00000369 <clone>:

SYSCALL(clone)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret

00000371 <join>:
SYSCALL(join)
 371:	b8 17 00 00 00       	mov    $0x17,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret

00000379 <thread_exit>:
SYSCALL(thread_exit)
 379:	b8 18 00 00 00       	mov    $0x18,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret

00000381 <randconfig>:
SYSCALL(randconfig)
 381:	b8 19 00 00 00       	mov    $0x19,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret

00000389 <yield>:
SYSCALL(yield)
 389:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret

00000391 <lock_create>:
SYSCALL(lock_create)
 391:	b8 1b 00 00 00       	mov    $0x1b,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret

00000399 <lock_acquire>:
SYSCALL(lock_acquire)
 399:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret

000003a1 <lock_release>:
SYSCALL(lock_release)
 3a1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret

000003a9 <sem_create>:
SYSCALL(sem_create)
 3a9:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret

000003b1 <sem_wait>:
SYSCALL(sem_wait)
 3b1:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret

000003b9 <sem_post>:
SYSCALL(sem_post)
 3b9:	b8 20 00 00 00       	mov    $0x20,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret

000003c1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	83 ec 18             	sub    $0x18,%esp
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3cd:	83 ec 04             	sub    $0x4,%esp
 3d0:	6a 01                	push   $0x1
 3d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d5:	50                   	push   %eax
 3d6:	ff 75 08             	push   0x8(%ebp)
 3d9:	e8 0b ff ff ff       	call   2e9 <write>
 3de:	83 c4 10             	add    $0x10,%esp
}
 3e1:	90                   	nop
 3e2:	c9                   	leave
 3e3:	c3                   	ret

000003e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f5:	74 17                	je     40e <printint+0x2a>
 3f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3fb:	79 11                	jns    40e <printint+0x2a>
    neg = 1;
 3fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 404:	8b 45 0c             	mov    0xc(%ebp),%eax
 407:	f7 d8                	neg    %eax
 409:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40c:	eb 06                	jmp    414 <printint+0x30>
  } else {
    x = xx;
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 421:	ba 00 00 00 00       	mov    $0x0,%edx
 426:	f7 f1                	div    %ecx
 428:	89 d1                	mov    %edx,%ecx
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	8d 50 01             	lea    0x1(%eax),%edx
 430:	89 55 f4             	mov    %edx,-0xc(%ebp)
 433:	0f b6 91 10 0e 00 00 	movzbl 0xe10(%ecx),%edx
 43a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 43e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 441:	8b 45 ec             	mov    -0x14(%ebp),%eax
 444:	ba 00 00 00 00       	mov    $0x0,%edx
 449:	f7 f1                	div    %ecx
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 452:	75 c7                	jne    41b <printint+0x37>
  if(neg)
 454:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 458:	74 2d                	je     487 <printint+0xa3>
    buf[i++] = '-';
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	8d 50 01             	lea    0x1(%eax),%edx
 460:	89 55 f4             	mov    %edx,-0xc(%ebp)
 463:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 468:	eb 1d                	jmp    487 <printint+0xa3>
    putc(fd, buf[i]);
 46a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 470:	01 d0                	add    %edx,%eax
 472:	0f b6 00             	movzbl (%eax),%eax
 475:	0f be c0             	movsbl %al,%eax
 478:	83 ec 08             	sub    $0x8,%esp
 47b:	50                   	push   %eax
 47c:	ff 75 08             	push   0x8(%ebp)
 47f:	e8 3d ff ff ff       	call   3c1 <putc>
 484:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 487:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48f:	79 d9                	jns    46a <printint+0x86>
}
 491:	90                   	nop
 492:	90                   	nop
 493:	c9                   	leave
 494:	c3                   	ret

00000495 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a5:	83 c0 04             	add    $0x4,%eax
 4a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b2:	e9 59 01 00 00       	jmp    610 <printf+0x17b>
    c = fmt[i] & 0xff;
 4b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bd:	01 d0                	add    %edx,%eax
 4bf:	0f b6 00             	movzbl (%eax),%eax
 4c2:	0f be c0             	movsbl %al,%eax
 4c5:	25 ff 00 00 00       	and    $0xff,%eax
 4ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d1:	75 2c                	jne    4ff <printf+0x6a>
      if(c == '%'){
 4d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d7:	75 0c                	jne    4e5 <printf+0x50>
        state = '%';
 4d9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e0:	e9 27 01 00 00       	jmp    60c <printf+0x177>
      } else {
        putc(fd, c);
 4e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	83 ec 08             	sub    $0x8,%esp
 4ee:	50                   	push   %eax
 4ef:	ff 75 08             	push   0x8(%ebp)
 4f2:	e8 ca fe ff ff       	call   3c1 <putc>
 4f7:	83 c4 10             	add    $0x10,%esp
 4fa:	e9 0d 01 00 00       	jmp    60c <printf+0x177>
      }
    } else if(state == '%'){
 4ff:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 503:	0f 85 03 01 00 00    	jne    60c <printf+0x177>
      if(c == 'd'){
 509:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50d:	75 1e                	jne    52d <printf+0x98>
        printint(fd, *ap, 10, 1);
 50f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 512:	8b 00                	mov    (%eax),%eax
 514:	6a 01                	push   $0x1
 516:	6a 0a                	push   $0xa
 518:	50                   	push   %eax
 519:	ff 75 08             	push   0x8(%ebp)
 51c:	e8 c3 fe ff ff       	call   3e4 <printint>
 521:	83 c4 10             	add    $0x10,%esp
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 528:	e9 d8 00 00 00       	jmp    605 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 52d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 531:	74 06                	je     539 <printf+0xa4>
 533:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 537:	75 1e                	jne    557 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	6a 00                	push   $0x0
 540:	6a 10                	push   $0x10
 542:	50                   	push   %eax
 543:	ff 75 08             	push   0x8(%ebp)
 546:	e8 99 fe ff ff       	call   3e4 <printint>
 54b:	83 c4 10             	add    $0x10,%esp
        ap++;
 54e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 552:	e9 ae 00 00 00       	jmp    605 <printf+0x170>
      } else if(c == 's'){
 557:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55b:	75 43                	jne    5a0 <printf+0x10b>
        s = (char*)*ap;
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56d:	75 25                	jne    594 <printf+0xff>
          s = "(null)";
 56f:	c7 45 f4 67 0a 00 00 	movl   $0xa67,-0xc(%ebp)
        while(*s != 0){
 576:	eb 1c                	jmp    594 <printf+0xff>
          putc(fd, *s);
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	0f b6 00             	movzbl (%eax),%eax
 57e:	0f be c0             	movsbl %al,%eax
 581:	83 ec 08             	sub    $0x8,%esp
 584:	50                   	push   %eax
 585:	ff 75 08             	push   0x8(%ebp)
 588:	e8 34 fe ff ff       	call   3c1 <putc>
 58d:	83 c4 10             	add    $0x10,%esp
          s++;
 590:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	0f b6 00             	movzbl (%eax),%eax
 59a:	84 c0                	test   %al,%al
 59c:	75 da                	jne    578 <printf+0xe3>
 59e:	eb 65                	jmp    605 <printf+0x170>
        }
      } else if(c == 'c'){
 5a0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a4:	75 1d                	jne    5c3 <printf+0x12e>
        putc(fd, *ap);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	8b 00                	mov    (%eax),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	83 ec 08             	sub    $0x8,%esp
 5b1:	50                   	push   %eax
 5b2:	ff 75 08             	push   0x8(%ebp)
 5b5:	e8 07 fe ff ff       	call   3c1 <putc>
 5ba:	83 c4 10             	add    $0x10,%esp
        ap++;
 5bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c1:	eb 42                	jmp    605 <printf+0x170>
      } else if(c == '%'){
 5c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c7:	75 17                	jne    5e0 <printf+0x14b>
        putc(fd, c);
 5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	83 ec 08             	sub    $0x8,%esp
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	push   0x8(%ebp)
 5d6:	e8 e6 fd ff ff       	call   3c1 <putc>
 5db:	83 c4 10             	add    $0x10,%esp
 5de:	eb 25                	jmp    605 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	6a 25                	push   $0x25
 5e5:	ff 75 08             	push   0x8(%ebp)
 5e8:	e8 d4 fd ff ff       	call   3c1 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	83 ec 08             	sub    $0x8,%esp
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	push   0x8(%ebp)
 5fd:	e8 bf fd ff ff       	call   3c1 <putc>
 602:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 605:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 60c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 610:	8b 55 0c             	mov    0xc(%ebp),%edx
 613:	8b 45 f0             	mov    -0x10(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	84 c0                	test   %al,%al
 61d:	0f 85 94 fe ff ff    	jne    4b7 <printf+0x22>
    }
  }
}
 623:	90                   	nop
 624:	90                   	nop
 625:	c9                   	leave
 626:	c3                   	ret

00000627 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 627:	55                   	push   %ebp
 628:	89 e5                	mov    %esp,%ebp
 62a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	83 e8 08             	sub    $0x8,%eax
 633:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 636:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 63b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63e:	eb 24                	jmp    664 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 648:	72 12                	jb     65c <free+0x35>
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 650:	72 24                	jb     676 <free+0x4f>
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 65a:	72 1a                	jb     676 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66a:	73 d4                	jae    640 <free+0x19>
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 674:	73 ca                	jae    640 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	01 c2                	add    %eax,%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	39 c2                	cmp    %eax,%edx
 68f:	75 24                	jne    6b5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 50 04             	mov    0x4(%eax),%edx
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	8b 10                	mov    (%eax),%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	89 10                	mov    %edx,(%eax)
 6b3:	eb 0a                	jmp    6bf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	01 d0                	add    %edx,%eax
 6d1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d4:	75 20                	jne    6f6 <free+0xcf>
    p->s.size += bp->s.size;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 50 04             	mov    0x4(%eax),%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 40 04             	mov    0x4(%eax),%eax
 6e2:	01 c2                	add    %eax,%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	89 10                	mov    %edx,(%eax)
 6f4:	eb 08                	jmp    6fe <free+0xd7>
  } else
    p->s.ptr = bp;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	a3 2c 0e 00 00       	mov    %eax,0xe2c
}
 706:	90                   	nop
 707:	c9                   	leave
 708:	c3                   	ret

00000709 <morecore>:

static Header*
morecore(uint nu)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 716:	77 07                	ja     71f <morecore+0x16>
    nu = 4096;
 718:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	c1 e0 03             	shl    $0x3,%eax
 725:	83 ec 0c             	sub    $0xc,%esp
 728:	50                   	push   %eax
 729:	e8 23 fc ff ff       	call   351 <sbrk>
 72e:	83 c4 10             	add    $0x10,%esp
 731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 734:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 738:	75 07                	jne    741 <morecore+0x38>
    return 0;
 73a:	b8 00 00 00 00       	mov    $0x0,%eax
 73f:	eb 26                	jmp    767 <morecore+0x5e>
  hp = (Header*)p;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	8b 55 08             	mov    0x8(%ebp),%edx
 74d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	83 c0 08             	add    $0x8,%eax
 756:	83 ec 0c             	sub    $0xc,%esp
 759:	50                   	push   %eax
 75a:	e8 c8 fe ff ff       	call   627 <free>
 75f:	83 c4 10             	add    $0x10,%esp
  return freep;
 762:	a1 2c 0e 00 00       	mov    0xe2c,%eax
}
 767:	c9                   	leave
 768:	c3                   	ret

00000769 <malloc>:

void*
malloc(uint nbytes)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	83 c0 07             	add    $0x7,%eax
 775:	c1 e8 03             	shr    $0x3,%eax
 778:	83 c0 01             	add    $0x1,%eax
 77b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 77e:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 783:	89 45 f0             	mov    %eax,-0x10(%ebp)
 786:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78a:	75 23                	jne    7af <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78c:	c7 45 f0 24 0e 00 00 	movl   $0xe24,-0x10(%ebp)
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	a3 2c 0e 00 00       	mov    %eax,0xe2c
 79b:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 7a0:	a3 24 0e 00 00       	mov    %eax,0xe24
    base.s.size = 0;
 7a5:	c7 05 28 0e 00 00 00 	movl   $0x0,0xe28
 7ac:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c0:	72 4d                	jb     80f <malloc+0xa6>
      if(p->s.size == nunits)
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7cb:	75 0c                	jne    7d9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 10                	mov    (%eax),%edx
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	89 10                	mov    %edx,(%eax)
 7d7:	eb 26                	jmp    7ff <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e2:	89 c2                	mov    %eax,%edx
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	8b 40 04             	mov    0x4(%eax),%eax
 7f0:	c1 e0 03             	shl    $0x3,%eax
 7f3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7fc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	a3 2c 0e 00 00       	mov    %eax,0xe2c
      return (void*)(p + 1);
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	83 c0 08             	add    $0x8,%eax
 80d:	eb 3b                	jmp    84a <malloc+0xe1>
    }
    if(p == freep)
 80f:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 814:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 817:	75 1e                	jne    837 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 819:	83 ec 0c             	sub    $0xc,%esp
 81c:	ff 75 ec             	push   -0x14(%ebp)
 81f:	e8 e5 fe ff ff       	call   709 <morecore>
 824:	83 c4 10             	add    $0x10,%esp
 827:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82e:	75 07                	jne    837 <malloc+0xce>
        return 0;
 830:	b8 00 00 00 00       	mov    $0x0,%eax
 835:	eb 13                	jmp    84a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 00                	mov    (%eax),%eax
 842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 845:	e9 6d ff ff ff       	jmp    7b7 <malloc+0x4e>
  }
}
 84a:	c9                   	leave
 84b:	c3                   	ret

0000084c <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 18             	sub    $0x18,%esp
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	8b 50 04             	mov    0x4(%eax),%edx
 858:	8b 00                	mov    (%eax),%eax
 85a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	8b 55 f4             	mov    -0xc(%ebp),%edx
 866:	83 ec 0c             	sub    $0xc,%esp
 869:	52                   	push   %edx
 86a:	ff d0                	call   *%eax
 86c:	83 c4 10             	add    $0x10,%esp
 86f:	e8 05 fb ff ff       	call   379 <thread_exit>

00000874 <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	83 ec 18             	sub    $0x18,%esp
 87a:	83 ec 0c             	sub    $0xc,%esp
 87d:	68 00 20 00 00       	push   $0x2000
 882:	e8 e2 fe ff ff       	call   769 <malloc>
 887:	83 c4 10             	add    $0x10,%esp
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 891:	75 0a                	jne    89d <pthread_create+0x29>
 893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 898:	e9 9b 00 00 00       	jmp    938 <pthread_create+0xc4>
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	05 ff 0f 00 00       	add    $0xfff,%eax
 8a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	6a 08                	push   $0x8
 8b2:	e8 b2 fe ff ff       	call   769 <malloc>
 8b7:	83 c4 10             	add    $0x10,%esp
 8ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8c1:	75 15                	jne    8d8 <pthread_create+0x64>
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	ff 75 f4             	push   -0xc(%ebp)
 8c9:	e8 59 fd ff ff       	call   627 <free>
 8ce:	83 c4 10             	add    $0x10,%esp
 8d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8d6:	eb 60                	jmp    938 <pthread_create+0xc4>
 8d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8db:	8b 55 10             	mov    0x10(%ebp),%edx
 8de:	89 10                	mov    %edx,(%eax)
 8e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e3:	8b 55 14             	mov    0x14(%ebp),%edx
 8e6:	89 50 04             	mov    %edx,0x4(%eax)
 8e9:	83 ec 04             	sub    $0x4,%esp
 8ec:	ff 75 f0             	push   -0x10(%ebp)
 8ef:	ff 75 ec             	push   -0x14(%ebp)
 8f2:	68 4c 08 00 00       	push   $0x84c
 8f7:	e8 6d fa ff ff       	call   369 <clone>
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
 902:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 906:	79 23                	jns    92b <pthread_create+0xb7>
 908:	83 ec 0c             	sub    $0xc,%esp
 90b:	ff 75 ec             	push   -0x14(%ebp)
 90e:	e8 14 fd ff ff       	call   627 <free>
 913:	83 c4 10             	add    $0x10,%esp
 916:	83 ec 0c             	sub    $0xc,%esp
 919:	ff 75 f4             	push   -0xc(%ebp)
 91c:	e8 06 fd ff ff       	call   627 <free>
 921:	83 c4 10             	add    $0x10,%esp
 924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 929:	eb 0d                	jmp    938 <pthread_create+0xc4>
 92b:	8b 45 08             	mov    0x8(%ebp),%eax
 92e:	8b 55 e8             	mov    -0x18(%ebp),%edx
 931:	89 10                	mov    %edx,(%eax)
 933:	b8 00 00 00 00       	mov    $0x0,%eax
 938:	c9                   	leave
 939:	c3                   	ret

0000093a <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 93a:	55                   	push   %ebp
 93b:	89 e5                	mov    %esp,%ebp
 93d:	83 ec 18             	sub    $0x18,%esp
 940:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 947:	83 ec 08             	sub    $0x8,%esp
 94a:	8d 45 f0             	lea    -0x10(%ebp),%eax
 94d:	50                   	push   %eax
 94e:	ff 75 08             	push   0x8(%ebp)
 951:	e8 1b fa ff ff       	call   371 <join>
 956:	83 c4 10             	add    $0x10,%esp
 959:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	3b 45 08             	cmp    0x8(%ebp),%eax
 962:	75 07                	jne    96b <pthread_join+0x31>
 964:	b8 00 00 00 00       	mov    $0x0,%eax
 969:	eb 05                	jmp    970 <pthread_join+0x36>
 96b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 970:	c9                   	leave
 971:	c3                   	ret

00000972 <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 08             	sub    $0x8,%esp
 978:	e8 fc f9 ff ff       	call   379 <thread_exit>

0000097d <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 97d:	55                   	push   %ebp
 97e:	89 e5                	mov    %esp,%ebp
 980:	83 ec 08             	sub    $0x8,%esp
 983:	e8 09 fa ff ff       	call   391 <lock_create>
 988:	8b 55 08             	mov    0x8(%ebp),%edx
 98b:	89 02                	mov    %eax,(%edx)
 98d:	8b 45 08             	mov    0x8(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	85 c0                	test   %eax,%eax
 994:	79 07                	jns    99d <pthread_mutex_init+0x20>
 996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 99b:	eb 05                	jmp    9a2 <pthread_mutex_init+0x25>
 99d:	b8 00 00 00 00       	mov    $0x0,%eax
 9a2:	c9                   	leave
 9a3:	c3                   	ret

000009a4 <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 9a4:	55                   	push   %ebp
 9a5:	89 e5                	mov    %esp,%ebp
 9a7:	83 ec 08             	sub    $0x8,%esp
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
 9ad:	8b 00                	mov    (%eax),%eax
 9af:	83 ec 0c             	sub    $0xc,%esp
 9b2:	50                   	push   %eax
 9b3:	e8 e1 f9 ff ff       	call   399 <lock_acquire>
 9b8:	83 c4 10             	add    $0x10,%esp
 9bb:	c9                   	leave
 9bc:	c3                   	ret

000009bd <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 9bd:	55                   	push   %ebp
 9be:	89 e5                	mov    %esp,%ebp
 9c0:	83 ec 08             	sub    $0x8,%esp
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	83 ec 0c             	sub    $0xc,%esp
 9cb:	50                   	push   %eax
 9cc:	e8 d0 f9 ff ff       	call   3a1 <lock_release>
 9d1:	83 c4 10             	add    $0x10,%esp
 9d4:	c9                   	leave
 9d5:	c3                   	ret

000009d6 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 9d6:	55                   	push   %ebp
 9d7:	89 e5                	mov    %esp,%ebp
 9d9:	83 ec 08             	sub    $0x8,%esp
 9dc:	8b 45 10             	mov    0x10(%ebp),%eax
 9df:	83 ec 0c             	sub    $0xc,%esp
 9e2:	50                   	push   %eax
 9e3:	e8 c1 f9 ff ff       	call   3a9 <sem_create>
 9e8:	83 c4 10             	add    $0x10,%esp
 9eb:	8b 55 08             	mov    0x8(%ebp),%edx
 9ee:	89 02                	mov    %eax,(%edx)
 9f0:	8b 45 08             	mov    0x8(%ebp),%eax
 9f3:	8b 00                	mov    (%eax),%eax
 9f5:	85 c0                	test   %eax,%eax
 9f7:	79 07                	jns    a00 <sem_init+0x2a>
 9f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9fe:	eb 05                	jmp    a05 <sem_init+0x2f>
 a00:	b8 00 00 00 00       	mov    $0x0,%eax
 a05:	c9                   	leave
 a06:	c3                   	ret

00000a07 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 a07:	55                   	push   %ebp
 a08:	89 e5                	mov    %esp,%ebp
 a0a:	83 ec 08             	sub    $0x8,%esp
 a0d:	8b 45 08             	mov    0x8(%ebp),%eax
 a10:	8b 00                	mov    (%eax),%eax
 a12:	83 ec 0c             	sub    $0xc,%esp
 a15:	50                   	push   %eax
 a16:	e8 96 f9 ff ff       	call   3b1 <sem_wait>
 a1b:	83 c4 10             	add    $0x10,%esp
 a1e:	c9                   	leave
 a1f:	c3                   	ret

00000a20 <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	83 ec 08             	sub    $0x8,%esp
 a26:	8b 45 08             	mov    0x8(%ebp),%eax
 a29:	8b 00                	mov    (%eax),%eax
 a2b:	83 ec 0c             	sub    $0xc,%esp
 a2e:	50                   	push   %eax
 a2f:	e8 85 f9 ff ff       	call   3b9 <sem_post>
 a34:	83 c4 10             	add    $0x10,%esp
 a37:	c9                   	leave
 a38:	c3                   	ret

00000a39 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 a39:	55                   	push   %ebp
 a3a:	89 e5                	mov    %esp,%ebp
 a3c:	83 ec 08             	sub    $0x8,%esp
 a3f:	83 ec 08             	sub    $0x8,%esp
 a42:	ff 75 0c             	push   0xc(%ebp)
 a45:	ff 75 08             	push   0x8(%ebp)
 a48:	e8 34 f9 ff ff       	call   381 <randconfig>
 a4d:	83 c4 10             	add    $0x10,%esp
 a50:	90                   	nop
 a51:	c9                   	leave
 a52:	c3                   	ret
