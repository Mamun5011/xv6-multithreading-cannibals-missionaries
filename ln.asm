
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 55 0a 00 00       	push   $0xa55
  1e:	6a 02                	push   $0x2
  20:	e8 72 04 00 00       	call   497 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 68 0a 00 00       	push   $0xa68
  65:	6a 02                	push   $0x2
  67:	e8 2b 04 00 00       	call   497 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 42 01             	lea    0x1(%edx),%eax
  ad:	89 45 0c             	mov    %eax,0xc(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 48 01             	lea    0x1(%eax),%ecx
  b6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave
  c9:	c3                   	ret

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret

00000109 <strlen>:

uint
strlen(const char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave
 12f:	c3                   	ret

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	push   0xc(%ebp)
 13a:	ff 75 08             	push   0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave
 149:	c3                   	ret

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave
 17c:	c3                   	ret

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d7:	7f b3                	jg     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave
 1eb:	c3                   	ret

000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	push   0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 f4             	push   -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	push   -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave
 238:	c3                   	ret

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave
 285:	c3                   	ret

00000286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 42 01             	lea    0x1(%edx),%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 48 01             	lea    0x1(%eax),%ecx
 2a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave
 2c2:	c3                   	ret

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <clone>:

SYSCALL(clone)
 36b:	b8 16 00 00 00       	mov    $0x16,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <join>:
SYSCALL(join)
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <thread_exit>:
SYSCALL(thread_exit)
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <randconfig>:
SYSCALL(randconfig)
 383:	b8 19 00 00 00       	mov    $0x19,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <yield>:
SYSCALL(yield)
 38b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <lock_create>:
SYSCALL(lock_create)
 393:	b8 1b 00 00 00       	mov    $0x1b,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <lock_acquire>:
SYSCALL(lock_acquire)
 39b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <lock_release>:
SYSCALL(lock_release)
 3a3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <sem_create>:
SYSCALL(sem_create)
 3ab:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <sem_wait>:
SYSCALL(sem_wait)
 3b3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <sem_post>:
SYSCALL(sem_post)
 3bb:	b8 20 00 00 00       	mov    $0x20,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 18             	sub    $0x18,%esp
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3cf:	83 ec 04             	sub    $0x4,%esp
 3d2:	6a 01                	push   $0x1
 3d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d7:	50                   	push   %eax
 3d8:	ff 75 08             	push   0x8(%ebp)
 3db:	e8 0b ff ff ff       	call   2eb <write>
 3e0:	83 c4 10             	add    $0x10,%esp
}
 3e3:	90                   	nop
 3e4:	c9                   	leave
 3e5:	c3                   	ret

000003e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f7:	74 17                	je     410 <printint+0x2a>
 3f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3fd:	79 11                	jns    410 <printint+0x2a>
    neg = 1;
 3ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 406:	8b 45 0c             	mov    0xc(%ebp),%eax
 409:	f7 d8                	neg    %eax
 40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40e:	eb 06                	jmp    416 <printint+0x30>
  } else {
    x = xx;
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 420:	8b 45 ec             	mov    -0x14(%ebp),%eax
 423:	ba 00 00 00 00       	mov    $0x0,%edx
 428:	f7 f1                	div    %ecx
 42a:	89 d1                	mov    %edx,%ecx
 42c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42f:	8d 50 01             	lea    0x1(%eax),%edx
 432:	89 55 f4             	mov    %edx,-0xc(%ebp)
 435:	0f b6 91 24 0e 00 00 	movzbl 0xe24(%ecx),%edx
 43c:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 440:	8b 4d 10             	mov    0x10(%ebp),%ecx
 443:	8b 45 ec             	mov    -0x14(%ebp),%eax
 446:	ba 00 00 00 00       	mov    $0x0,%edx
 44b:	f7 f1                	div    %ecx
 44d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 454:	75 c7                	jne    41d <printint+0x37>
  if(neg)
 456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45a:	74 2d                	je     489 <printint+0xa3>
    buf[i++] = '-';
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	8d 50 01             	lea    0x1(%eax),%edx
 462:	89 55 f4             	mov    %edx,-0xc(%ebp)
 465:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 46a:	eb 1d                	jmp    489 <printint+0xa3>
    putc(fd, buf[i]);
 46c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	01 d0                	add    %edx,%eax
 474:	0f b6 00             	movzbl (%eax),%eax
 477:	0f be c0             	movsbl %al,%eax
 47a:	83 ec 08             	sub    $0x8,%esp
 47d:	50                   	push   %eax
 47e:	ff 75 08             	push   0x8(%ebp)
 481:	e8 3d ff ff ff       	call   3c3 <putc>
 486:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 489:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 491:	79 d9                	jns    46c <printint+0x86>
}
 493:	90                   	nop
 494:	90                   	nop
 495:	c9                   	leave
 496:	c3                   	ret

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 497:	55                   	push   %ebp
 498:	89 e5                	mov    %esp,%ebp
 49a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a7:	83 c0 04             	add    $0x4,%eax
 4aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b4:	e9 59 01 00 00       	jmp    612 <printf+0x17b>
    c = fmt[i] & 0xff;
 4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	25 ff 00 00 00       	and    $0xff,%eax
 4cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 2c                	jne    501 <printf+0x6a>
      if(c == '%'){
 4d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d9:	75 0c                	jne    4e7 <printf+0x50>
        state = '%';
 4db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e2:	e9 27 01 00 00       	jmp    60e <printf+0x177>
      } else {
        putc(fd, c);
 4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	83 ec 08             	sub    $0x8,%esp
 4f0:	50                   	push   %eax
 4f1:	ff 75 08             	push   0x8(%ebp)
 4f4:	e8 ca fe ff ff       	call   3c3 <putc>
 4f9:	83 c4 10             	add    $0x10,%esp
 4fc:	e9 0d 01 00 00       	jmp    60e <printf+0x177>
      }
    } else if(state == '%'){
 501:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 505:	0f 85 03 01 00 00    	jne    60e <printf+0x177>
      if(c == 'd'){
 50b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50f:	75 1e                	jne    52f <printf+0x98>
        printint(fd, *ap, 10, 1);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	6a 01                	push   $0x1
 518:	6a 0a                	push   $0xa
 51a:	50                   	push   %eax
 51b:	ff 75 08             	push   0x8(%ebp)
 51e:	e8 c3 fe ff ff       	call   3e6 <printint>
 523:	83 c4 10             	add    $0x10,%esp
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52a:	e9 d8 00 00 00       	jmp    607 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 52f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 533:	74 06                	je     53b <printf+0xa4>
 535:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 539:	75 1e                	jne    559 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	6a 00                	push   $0x0
 542:	6a 10                	push   $0x10
 544:	50                   	push   %eax
 545:	ff 75 08             	push   0x8(%ebp)
 548:	e8 99 fe ff ff       	call   3e6 <printint>
 54d:	83 c4 10             	add    $0x10,%esp
        ap++;
 550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 554:	e9 ae 00 00 00       	jmp    607 <printf+0x170>
      } else if(c == 's'){
 559:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55d:	75 43                	jne    5a2 <printf+0x10b>
        s = (char*)*ap;
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 567:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56f:	75 25                	jne    596 <printf+0xff>
          s = "(null)";
 571:	c7 45 f4 7c 0a 00 00 	movl   $0xa7c,-0xc(%ebp)
        while(*s != 0){
 578:	eb 1c                	jmp    596 <printf+0xff>
          putc(fd, *s);
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	push   0x8(%ebp)
 58a:	e8 34 fe ff ff       	call   3c3 <putc>
 58f:	83 c4 10             	add    $0x10,%esp
          s++;
 592:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 596:	8b 45 f4             	mov    -0xc(%ebp),%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	84 c0                	test   %al,%al
 59e:	75 da                	jne    57a <printf+0xe3>
 5a0:	eb 65                	jmp    607 <printf+0x170>
        }
      } else if(c == 'c'){
 5a2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a6:	75 1d                	jne    5c5 <printf+0x12e>
        putc(fd, *ap);
 5a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	50                   	push   %eax
 5b4:	ff 75 08             	push   0x8(%ebp)
 5b7:	e8 07 fe ff ff       	call   3c3 <putc>
 5bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c3:	eb 42                	jmp    607 <printf+0x170>
      } else if(c == '%'){
 5c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c9:	75 17                	jne    5e2 <printf+0x14b>
        putc(fd, c);
 5cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	push   0x8(%ebp)
 5d8:	e8 e6 fd ff ff       	call   3c3 <putc>
 5dd:	83 c4 10             	add    $0x10,%esp
 5e0:	eb 25                	jmp    607 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	6a 25                	push   $0x25
 5e7:	ff 75 08             	push   0x8(%ebp)
 5ea:	e8 d4 fd ff ff       	call   3c3 <putc>
 5ef:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 ec 08             	sub    $0x8,%esp
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	push   0x8(%ebp)
 5ff:	e8 bf fd ff ff       	call   3c3 <putc>
 604:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 607:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 60e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 612:	8b 55 0c             	mov    0xc(%ebp),%edx
 615:	8b 45 f0             	mov    -0x10(%ebp),%eax
 618:	01 d0                	add    %edx,%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	84 c0                	test   %al,%al
 61f:	0f 85 94 fe ff ff    	jne    4b9 <printf+0x22>
    }
  }
}
 625:	90                   	nop
 626:	90                   	nop
 627:	c9                   	leave
 628:	c3                   	ret

00000629 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 629:	55                   	push   %ebp
 62a:	89 e5                	mov    %esp,%ebp
 62c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	83 e8 08             	sub    $0x8,%eax
 635:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 638:	a1 40 0e 00 00       	mov    0xe40,%eax
 63d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 640:	eb 24                	jmp    666 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 64a:	72 12                	jb     65e <free+0x35>
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 652:	72 24                	jb     678 <free+0x4f>
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 65c:	72 1a                	jb     678 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	89 45 fc             	mov    %eax,-0x4(%ebp)
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66c:	73 d4                	jae    642 <free+0x19>
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 676:	73 ca                	jae    642 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	01 c2                	add    %eax,%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	39 c2                	cmp    %eax,%edx
 691:	75 24                	jne    6b7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	8b 50 04             	mov    0x4(%eax),%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	8b 40 04             	mov    0x4(%eax),%eax
 6a1:	01 c2                	add    %eax,%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
 6b5:	eb 0a                	jmp    6c1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 10                	mov    (%eax),%edx
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 40 04             	mov    0x4(%eax),%eax
 6c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	01 d0                	add    %edx,%eax
 6d3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d6:	75 20                	jne    6f8 <free+0xcf>
    p->s.size += bp->s.size;
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 50 04             	mov    0x4(%eax),%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	8b 10                	mov    (%eax),%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	89 10                	mov    %edx,(%eax)
 6f6:	eb 08                	jmp    700 <free+0xd7>
  } else
    p->s.ptr = bp;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fe:	89 10                	mov    %edx,(%eax)
  freep = p;
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	a3 40 0e 00 00       	mov    %eax,0xe40
}
 708:	90                   	nop
 709:	c9                   	leave
 70a:	c3                   	ret

0000070b <morecore>:

static Header*
morecore(uint nu)
{
 70b:	55                   	push   %ebp
 70c:	89 e5                	mov    %esp,%ebp
 70e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 711:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 718:	77 07                	ja     721 <morecore+0x16>
    nu = 4096;
 71a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	c1 e0 03             	shl    $0x3,%eax
 727:	83 ec 0c             	sub    $0xc,%esp
 72a:	50                   	push   %eax
 72b:	e8 23 fc ff ff       	call   353 <sbrk>
 730:	83 c4 10             	add    $0x10,%esp
 733:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 736:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73a:	75 07                	jne    743 <morecore+0x38>
    return 0;
 73c:	b8 00 00 00 00       	mov    $0x0,%eax
 741:	eb 26                	jmp    769 <morecore+0x5e>
  hp = (Header*)p;
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	8b 55 08             	mov    0x8(%ebp),%edx
 74f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	83 c0 08             	add    $0x8,%eax
 758:	83 ec 0c             	sub    $0xc,%esp
 75b:	50                   	push   %eax
 75c:	e8 c8 fe ff ff       	call   629 <free>
 761:	83 c4 10             	add    $0x10,%esp
  return freep;
 764:	a1 40 0e 00 00       	mov    0xe40,%eax
}
 769:	c9                   	leave
 76a:	c3                   	ret

0000076b <malloc>:

void*
malloc(uint nbytes)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 771:	8b 45 08             	mov    0x8(%ebp),%eax
 774:	83 c0 07             	add    $0x7,%eax
 777:	c1 e8 03             	shr    $0x3,%eax
 77a:	83 c0 01             	add    $0x1,%eax
 77d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 780:	a1 40 0e 00 00       	mov    0xe40,%eax
 785:	89 45 f0             	mov    %eax,-0x10(%ebp)
 788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78c:	75 23                	jne    7b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78e:	c7 45 f0 38 0e 00 00 	movl   $0xe38,-0x10(%ebp)
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	a3 40 0e 00 00       	mov    %eax,0xe40
 79d:	a1 40 0e 00 00       	mov    0xe40,%eax
 7a2:	a3 38 0e 00 00       	mov    %eax,0xe38
    base.s.size = 0;
 7a7:	c7 05 3c 0e 00 00 00 	movl   $0x0,0xe3c
 7ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c2:	72 4d                	jb     811 <malloc+0xa6>
      if(p->s.size == nunits)
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7cd:	75 0c                	jne    7db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 10                	mov    (%eax),%edx
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	89 10                	mov    %edx,(%eax)
 7d9:	eb 26                	jmp    801 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e4:	89 c2                	mov    %eax,%edx
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	c1 e0 03             	shl    $0x3,%eax
 7f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	a3 40 0e 00 00       	mov    %eax,0xe40
      return (void*)(p + 1);
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	83 c0 08             	add    $0x8,%eax
 80f:	eb 3b                	jmp    84c <malloc+0xe1>
    }
    if(p == freep)
 811:	a1 40 0e 00 00       	mov    0xe40,%eax
 816:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 819:	75 1e                	jne    839 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 81b:	83 ec 0c             	sub    $0xc,%esp
 81e:	ff 75 ec             	push   -0x14(%ebp)
 821:	e8 e5 fe ff ff       	call   70b <morecore>
 826:	83 c4 10             	add    $0x10,%esp
 829:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 830:	75 07                	jne    839 <malloc+0xce>
        return 0;
 832:	b8 00 00 00 00       	mov    $0x0,%eax
 837:	eb 13                	jmp    84c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 847:	e9 6d ff ff ff       	jmp    7b9 <malloc+0x4e>
  }
}
 84c:	c9                   	leave
 84d:	c3                   	ret

0000084e <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 84e:	55                   	push   %ebp
 84f:	89 e5                	mov    %esp,%ebp
 851:	83 ec 18             	sub    $0x18,%esp
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	8b 50 04             	mov    0x4(%eax),%edx
 85a:	8b 00                	mov    (%eax),%eax
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	8b 55 f4             	mov    -0xc(%ebp),%edx
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	52                   	push   %edx
 86c:	ff d0                	call   *%eax
 86e:	83 c4 10             	add    $0x10,%esp
 871:	e8 05 fb ff ff       	call   37b <thread_exit>

00000876 <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 876:	55                   	push   %ebp
 877:	89 e5                	mov    %esp,%ebp
 879:	83 ec 18             	sub    $0x18,%esp
 87c:	83 ec 0c             	sub    $0xc,%esp
 87f:	68 00 20 00 00       	push   $0x2000
 884:	e8 e2 fe ff ff       	call   76b <malloc>
 889:	83 c4 10             	add    $0x10,%esp
 88c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 893:	75 0a                	jne    89f <pthread_create+0x29>
 895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 89a:	e9 9b 00 00 00       	jmp    93a <pthread_create+0xc4>
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	05 ff 0f 00 00       	add    $0xfff,%eax
 8a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 8ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8af:	83 ec 0c             	sub    $0xc,%esp
 8b2:	6a 08                	push   $0x8
 8b4:	e8 b2 fe ff ff       	call   76b <malloc>
 8b9:	83 c4 10             	add    $0x10,%esp
 8bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8c3:	75 15                	jne    8da <pthread_create+0x64>
 8c5:	83 ec 0c             	sub    $0xc,%esp
 8c8:	ff 75 f4             	push   -0xc(%ebp)
 8cb:	e8 59 fd ff ff       	call   629 <free>
 8d0:	83 c4 10             	add    $0x10,%esp
 8d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8d8:	eb 60                	jmp    93a <pthread_create+0xc4>
 8da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8dd:	8b 55 10             	mov    0x10(%ebp),%edx
 8e0:	89 10                	mov    %edx,(%eax)
 8e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e5:	8b 55 14             	mov    0x14(%ebp),%edx
 8e8:	89 50 04             	mov    %edx,0x4(%eax)
 8eb:	83 ec 04             	sub    $0x4,%esp
 8ee:	ff 75 f0             	push   -0x10(%ebp)
 8f1:	ff 75 ec             	push   -0x14(%ebp)
 8f4:	68 4e 08 00 00       	push   $0x84e
 8f9:	e8 6d fa ff ff       	call   36b <clone>
 8fe:	83 c4 10             	add    $0x10,%esp
 901:	89 45 e8             	mov    %eax,-0x18(%ebp)
 904:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 908:	79 23                	jns    92d <pthread_create+0xb7>
 90a:	83 ec 0c             	sub    $0xc,%esp
 90d:	ff 75 ec             	push   -0x14(%ebp)
 910:	e8 14 fd ff ff       	call   629 <free>
 915:	83 c4 10             	add    $0x10,%esp
 918:	83 ec 0c             	sub    $0xc,%esp
 91b:	ff 75 f4             	push   -0xc(%ebp)
 91e:	e8 06 fd ff ff       	call   629 <free>
 923:	83 c4 10             	add    $0x10,%esp
 926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 92b:	eb 0d                	jmp    93a <pthread_create+0xc4>
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	8b 55 e8             	mov    -0x18(%ebp),%edx
 933:	89 10                	mov    %edx,(%eax)
 935:	b8 00 00 00 00       	mov    $0x0,%eax
 93a:	c9                   	leave
 93b:	c3                   	ret

0000093c <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 93c:	55                   	push   %ebp
 93d:	89 e5                	mov    %esp,%ebp
 93f:	83 ec 18             	sub    $0x18,%esp
 942:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 949:	83 ec 08             	sub    $0x8,%esp
 94c:	8d 45 f0             	lea    -0x10(%ebp),%eax
 94f:	50                   	push   %eax
 950:	ff 75 08             	push   0x8(%ebp)
 953:	e8 1b fa ff ff       	call   373 <join>
 958:	83 c4 10             	add    $0x10,%esp
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	3b 45 08             	cmp    0x8(%ebp),%eax
 964:	75 07                	jne    96d <pthread_join+0x31>
 966:	b8 00 00 00 00       	mov    $0x0,%eax
 96b:	eb 05                	jmp    972 <pthread_join+0x36>
 96d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 972:	c9                   	leave
 973:	c3                   	ret

00000974 <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 974:	55                   	push   %ebp
 975:	89 e5                	mov    %esp,%ebp
 977:	83 ec 08             	sub    $0x8,%esp
 97a:	e8 fc f9 ff ff       	call   37b <thread_exit>

0000097f <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 97f:	55                   	push   %ebp
 980:	89 e5                	mov    %esp,%ebp
 982:	83 ec 08             	sub    $0x8,%esp
 985:	e8 09 fa ff ff       	call   393 <lock_create>
 98a:	8b 55 08             	mov    0x8(%ebp),%edx
 98d:	89 02                	mov    %eax,(%edx)
 98f:	8b 45 08             	mov    0x8(%ebp),%eax
 992:	8b 00                	mov    (%eax),%eax
 994:	85 c0                	test   %eax,%eax
 996:	79 07                	jns    99f <pthread_mutex_init+0x20>
 998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 99d:	eb 05                	jmp    9a4 <pthread_mutex_init+0x25>
 99f:	b8 00 00 00 00       	mov    $0x0,%eax
 9a4:	c9                   	leave
 9a5:	c3                   	ret

000009a6 <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 9a6:	55                   	push   %ebp
 9a7:	89 e5                	mov    %esp,%ebp
 9a9:	83 ec 08             	sub    $0x8,%esp
 9ac:	8b 45 08             	mov    0x8(%ebp),%eax
 9af:	8b 00                	mov    (%eax),%eax
 9b1:	83 ec 0c             	sub    $0xc,%esp
 9b4:	50                   	push   %eax
 9b5:	e8 e1 f9 ff ff       	call   39b <lock_acquire>
 9ba:	83 c4 10             	add    $0x10,%esp
 9bd:	c9                   	leave
 9be:	c3                   	ret

000009bf <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 9bf:	55                   	push   %ebp
 9c0:	89 e5                	mov    %esp,%ebp
 9c2:	83 ec 08             	sub    $0x8,%esp
 9c5:	8b 45 08             	mov    0x8(%ebp),%eax
 9c8:	8b 00                	mov    (%eax),%eax
 9ca:	83 ec 0c             	sub    $0xc,%esp
 9cd:	50                   	push   %eax
 9ce:	e8 d0 f9 ff ff       	call   3a3 <lock_release>
 9d3:	83 c4 10             	add    $0x10,%esp
 9d6:	c9                   	leave
 9d7:	c3                   	ret

000009d8 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 9d8:	55                   	push   %ebp
 9d9:	89 e5                	mov    %esp,%ebp
 9db:	83 ec 08             	sub    $0x8,%esp
 9de:	8b 45 10             	mov    0x10(%ebp),%eax
 9e1:	83 ec 0c             	sub    $0xc,%esp
 9e4:	50                   	push   %eax
 9e5:	e8 c1 f9 ff ff       	call   3ab <sem_create>
 9ea:	83 c4 10             	add    $0x10,%esp
 9ed:	8b 55 08             	mov    0x8(%ebp),%edx
 9f0:	89 02                	mov    %eax,(%edx)
 9f2:	8b 45 08             	mov    0x8(%ebp),%eax
 9f5:	8b 00                	mov    (%eax),%eax
 9f7:	85 c0                	test   %eax,%eax
 9f9:	79 07                	jns    a02 <sem_init+0x2a>
 9fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a00:	eb 05                	jmp    a07 <sem_init+0x2f>
 a02:	b8 00 00 00 00       	mov    $0x0,%eax
 a07:	c9                   	leave
 a08:	c3                   	ret

00000a09 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 a09:	55                   	push   %ebp
 a0a:	89 e5                	mov    %esp,%ebp
 a0c:	83 ec 08             	sub    $0x8,%esp
 a0f:	8b 45 08             	mov    0x8(%ebp),%eax
 a12:	8b 00                	mov    (%eax),%eax
 a14:	83 ec 0c             	sub    $0xc,%esp
 a17:	50                   	push   %eax
 a18:	e8 96 f9 ff ff       	call   3b3 <sem_wait>
 a1d:	83 c4 10             	add    $0x10,%esp
 a20:	c9                   	leave
 a21:	c3                   	ret

00000a22 <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 a22:	55                   	push   %ebp
 a23:	89 e5                	mov    %esp,%ebp
 a25:	83 ec 08             	sub    $0x8,%esp
 a28:	8b 45 08             	mov    0x8(%ebp),%eax
 a2b:	8b 00                	mov    (%eax),%eax
 a2d:	83 ec 0c             	sub    $0xc,%esp
 a30:	50                   	push   %eax
 a31:	e8 85 f9 ff ff       	call   3bb <sem_post>
 a36:	83 c4 10             	add    $0x10,%esp
 a39:	c9                   	leave
 a3a:	c3                   	ret

00000a3b <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 a3b:	55                   	push   %ebp
 a3c:	89 e5                	mov    %esp,%ebp
 a3e:	83 ec 08             	sub    $0x8,%esp
 a41:	83 ec 08             	sub    $0x8,%esp
 a44:	ff 75 0c             	push   0xc(%ebp)
 a47:	ff 75 08             	push   0x8(%ebp)
 a4a:	e8 34 f9 ff ff       	call   383 <randconfig>
 a4f:	83 c4 10             	add    $0x10,%esp
 a52:	90                   	nop
 a53:	c9                   	leave
 a54:	c3                   	ret
