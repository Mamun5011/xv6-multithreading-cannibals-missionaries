
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	39 03                	cmp    %eax,(%ebx)
  25:	7e 07                	jle    2e <main+0x2e>
  27:	b9 46 0a 00 00       	mov    $0xa46,%ecx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	b9 48 0a 00 00       	mov    $0xa48,%ecx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	51                   	push   %ecx
  45:	50                   	push   %eax
  46:	68 4a 0a 00 00       	push   $0xa4a
  4b:	6a 01                	push   $0x1
  4d:	e8 36 04 00 00       	call   488 <printf>
  52:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
  exit();
  60:	e8 57 02 00 00       	call   2bc <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 55 0c             	mov    0xc(%ebp),%edx
  9b:	8d 42 01             	lea    0x1(%edx),%eax
  9e:	89 45 0c             	mov    %eax,0xc(%ebp)
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	8d 48 01             	lea    0x1(%eax),%ecx
  a7:	89 4d 08             	mov    %ecx,0x8(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave
  ba:	c3                   	ret

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret

000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave
 120:	c3                   	ret

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	push   0xc(%ebp)
 12b:	ff 75 08             	push   0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave
 13a:	c3                   	ret

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 45 fc             	cmp    %al,-0x4(%ebp)
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave
 16d:	c3                   	ret

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 47 01 00 00       	call   2d4 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1c8:	7f b3                	jg     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
      break;
 1cc:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave
 1dc:	c3                   	ret

000001dd <stat>:

int
stat(const char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	push   0x8(%ebp)
 1eb:	e8 0c 01 00 00       	call   2fc <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	push   0xc(%ebp)
 209:	ff 75 f4             	push   -0xc(%ebp)
 20c:	e8 03 01 00 00       	call   314 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	push   -0xc(%ebp)
 21d:	e8 c2 00 00 00       	call   2e4 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave
 229:	c3                   	ret

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave
 276:	c3                   	ret

00000277 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28e:	8d 42 01             	lea    0x1(%edx),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
 294:	8b 45 fc             	mov    -0x4(%ebp),%eax
 297:	8d 48 01             	lea    0x1(%eax),%ecx
 29a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave
 2b3:	c3                   	ret

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret

0000035c <clone>:

SYSCALL(clone)
 35c:	b8 16 00 00 00       	mov    $0x16,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret

00000364 <join>:
SYSCALL(join)
 364:	b8 17 00 00 00       	mov    $0x17,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret

0000036c <thread_exit>:
SYSCALL(thread_exit)
 36c:	b8 18 00 00 00       	mov    $0x18,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret

00000374 <randconfig>:
SYSCALL(randconfig)
 374:	b8 19 00 00 00       	mov    $0x19,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret

0000037c <yield>:
SYSCALL(yield)
 37c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret

00000384 <lock_create>:
SYSCALL(lock_create)
 384:	b8 1b 00 00 00       	mov    $0x1b,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret

0000038c <lock_acquire>:
SYSCALL(lock_acquire)
 38c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret

00000394 <lock_release>:
SYSCALL(lock_release)
 394:	b8 1d 00 00 00       	mov    $0x1d,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret

0000039c <sem_create>:
SYSCALL(sem_create)
 39c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret

000003a4 <sem_wait>:
SYSCALL(sem_wait)
 3a4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret

000003ac <sem_post>:
SYSCALL(sem_post)
 3ac:	b8 20 00 00 00       	mov    $0x20,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret

000003b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	83 ec 18             	sub    $0x18,%esp
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c0:	83 ec 04             	sub    $0x4,%esp
 3c3:	6a 01                	push   $0x1
 3c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c8:	50                   	push   %eax
 3c9:	ff 75 08             	push   0x8(%ebp)
 3cc:	e8 0b ff ff ff       	call   2dc <write>
 3d1:	83 c4 10             	add    $0x10,%esp
}
 3d4:	90                   	nop
 3d5:	c9                   	leave
 3d6:	c3                   	ret

000003d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e8:	74 17                	je     401 <printint+0x2a>
 3ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ee:	79 11                	jns    401 <printint+0x2a>
    neg = 1;
 3f0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fa:	f7 d8                	neg    %eax
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ff:	eb 06                	jmp    407 <printint+0x30>
  } else {
    x = xx;
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 f1                	div    %ecx
 41b:	89 d1                	mov    %edx,%ecx
 41d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 420:	8d 50 01             	lea    0x1(%eax),%edx
 423:	89 55 f4             	mov    %edx,-0xc(%ebp)
 426:	0f b6 91 f8 0d 00 00 	movzbl 0xdf8(%ecx),%edx
 42d:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 431:	8b 4d 10             	mov    0x10(%ebp),%ecx
 434:	8b 45 ec             	mov    -0x14(%ebp),%eax
 437:	ba 00 00 00 00       	mov    $0x0,%edx
 43c:	f7 f1                	div    %ecx
 43e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 445:	75 c7                	jne    40e <printint+0x37>
  if(neg)
 447:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44b:	74 2d                	je     47a <printint+0xa3>
    buf[i++] = '-';
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	8d 50 01             	lea    0x1(%eax),%edx
 453:	89 55 f4             	mov    %edx,-0xc(%ebp)
 456:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45b:	eb 1d                	jmp    47a <printint+0xa3>
    putc(fd, buf[i]);
 45d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 460:	8b 45 f4             	mov    -0xc(%ebp),%eax
 463:	01 d0                	add    %edx,%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	0f be c0             	movsbl %al,%eax
 46b:	83 ec 08             	sub    $0x8,%esp
 46e:	50                   	push   %eax
 46f:	ff 75 08             	push   0x8(%ebp)
 472:	e8 3d ff ff ff       	call   3b4 <putc>
 477:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 47a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 482:	79 d9                	jns    45d <printint+0x86>
}
 484:	90                   	nop
 485:	90                   	nop
 486:	c9                   	leave
 487:	c3                   	ret

00000488 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 495:	8d 45 0c             	lea    0xc(%ebp),%eax
 498:	83 c0 04             	add    $0x4,%eax
 49b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a5:	e9 59 01 00 00       	jmp    603 <printf+0x17b>
    c = fmt[i] & 0xff;
 4aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	25 ff 00 00 00       	and    $0xff,%eax
 4bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c4:	75 2c                	jne    4f2 <printf+0x6a>
      if(c == '%'){
 4c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ca:	75 0c                	jne    4d8 <printf+0x50>
        state = '%';
 4cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d3:	e9 27 01 00 00       	jmp    5ff <printf+0x177>
      } else {
        putc(fd, c);
 4d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	83 ec 08             	sub    $0x8,%esp
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	push   0x8(%ebp)
 4e5:	e8 ca fe ff ff       	call   3b4 <putc>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	e9 0d 01 00 00       	jmp    5ff <printf+0x177>
      }
    } else if(state == '%'){
 4f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f6:	0f 85 03 01 00 00    	jne    5ff <printf+0x177>
      if(c == 'd'){
 4fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 500:	75 1e                	jne    520 <printf+0x98>
        printint(fd, *ap, 10, 1);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	6a 01                	push   $0x1
 509:	6a 0a                	push   $0xa
 50b:	50                   	push   %eax
 50c:	ff 75 08             	push   0x8(%ebp)
 50f:	e8 c3 fe ff ff       	call   3d7 <printint>
 514:	83 c4 10             	add    $0x10,%esp
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 d8 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 520:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 524:	74 06                	je     52c <printf+0xa4>
 526:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52a:	75 1e                	jne    54a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	6a 00                	push   $0x0
 533:	6a 10                	push   $0x10
 535:	50                   	push   %eax
 536:	ff 75 08             	push   0x8(%ebp)
 539:	e8 99 fe ff ff       	call   3d7 <printint>
 53e:	83 c4 10             	add    $0x10,%esp
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 545:	e9 ae 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 's'){
 54a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54e:	75 43                	jne    593 <printf+0x10b>
        s = (char*)*ap;
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	75 25                	jne    587 <printf+0xff>
          s = "(null)";
 562:	c7 45 f4 4f 0a 00 00 	movl   $0xa4f,-0xc(%ebp)
        while(*s != 0){
 569:	eb 1c                	jmp    587 <printf+0xff>
          putc(fd, *s);
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	83 ec 08             	sub    $0x8,%esp
 577:	50                   	push   %eax
 578:	ff 75 08             	push   0x8(%ebp)
 57b:	e8 34 fe ff ff       	call   3b4 <putc>
 580:	83 c4 10             	add    $0x10,%esp
          s++;
 583:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	84 c0                	test   %al,%al
 58f:	75 da                	jne    56b <printf+0xe3>
 591:	eb 65                	jmp    5f8 <printf+0x170>
        }
      } else if(c == 'c'){
 593:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 597:	75 1d                	jne    5b6 <printf+0x12e>
        putc(fd, *ap);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	push   0x8(%ebp)
 5a8:	e8 07 fe ff ff       	call   3b4 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	eb 42                	jmp    5f8 <printf+0x170>
      } else if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 17                	jne    5d3 <printf+0x14b>
        putc(fd, c);
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	50                   	push   %eax
 5c6:	ff 75 08             	push   0x8(%ebp)
 5c9:	e8 e6 fd ff ff       	call   3b4 <putc>
 5ce:	83 c4 10             	add    $0x10,%esp
 5d1:	eb 25                	jmp    5f8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	6a 25                	push   $0x25
 5d8:	ff 75 08             	push   0x8(%ebp)
 5db:	e8 d4 fd ff ff       	call   3b4 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	push   0x8(%ebp)
 5f0:	e8 bf fd ff ff       	call   3b4 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ff:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 603:	8b 55 0c             	mov    0xc(%ebp),%edx
 606:	8b 45 f0             	mov    -0x10(%ebp),%eax
 609:	01 d0                	add    %edx,%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	84 c0                	test   %al,%al
 610:	0f 85 94 fe ff ff    	jne    4aa <printf+0x22>
    }
  }
}
 616:	90                   	nop
 617:	90                   	nop
 618:	c9                   	leave
 619:	c3                   	ret

0000061a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	83 e8 08             	sub    $0x8,%eax
 626:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 629:	a1 14 0e 00 00       	mov    0xe14,%eax
 62e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 631:	eb 24                	jmp    657 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 63b:	72 12                	jb     64f <free+0x35>
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 643:	72 24                	jb     669 <free+0x4f>
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 64d:	72 1a                	jb     669 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 65d:	73 d4                	jae    633 <free+0x19>
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 667:	73 ca                	jae    633 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	01 c2                	add    %eax,%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	39 c2                	cmp    %eax,%edx
 682:	75 24                	jne    6a8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	8b 50 04             	mov    0x4(%eax),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	8b 10                	mov    (%eax),%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	89 10                	mov    %edx,(%eax)
 6a6:	eb 0a                	jmp    6b2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 10                	mov    (%eax),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	01 d0                	add    %edx,%eax
 6c4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c7:	75 20                	jne    6e9 <free+0xcf>
    p->s.size += bp->s.size;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 08                	jmp    6f1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	a3 14 0e 00 00       	mov    %eax,0xe14
}
 6f9:	90                   	nop
 6fa:	c9                   	leave
 6fb:	c3                   	ret

000006fc <morecore>:

static Header*
morecore(uint nu)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 702:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 709:	77 07                	ja     712 <morecore+0x16>
    nu = 4096;
 70b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	c1 e0 03             	shl    $0x3,%eax
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	50                   	push   %eax
 71c:	e8 23 fc ff ff       	call   344 <sbrk>
 721:	83 c4 10             	add    $0x10,%esp
 724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 727:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72b:	75 07                	jne    734 <morecore+0x38>
    return 0;
 72d:	b8 00 00 00 00       	mov    $0x0,%eax
 732:	eb 26                	jmp    75a <morecore+0x5e>
  hp = (Header*)p;
 734:	8b 45 f4             	mov    -0xc(%ebp),%eax
 737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73d:	8b 55 08             	mov    0x8(%ebp),%edx
 740:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	83 c0 08             	add    $0x8,%eax
 749:	83 ec 0c             	sub    $0xc,%esp
 74c:	50                   	push   %eax
 74d:	e8 c8 fe ff ff       	call   61a <free>
 752:	83 c4 10             	add    $0x10,%esp
  return freep;
 755:	a1 14 0e 00 00       	mov    0xe14,%eax
}
 75a:	c9                   	leave
 75b:	c3                   	ret

0000075c <malloc>:

void*
malloc(uint nbytes)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	83 c0 07             	add    $0x7,%eax
 768:	c1 e8 03             	shr    $0x3,%eax
 76b:	83 c0 01             	add    $0x1,%eax
 76e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 771:	a1 14 0e 00 00       	mov    0xe14,%eax
 776:	89 45 f0             	mov    %eax,-0x10(%ebp)
 779:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77d:	75 23                	jne    7a2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77f:	c7 45 f0 0c 0e 00 00 	movl   $0xe0c,-0x10(%ebp)
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	a3 14 0e 00 00       	mov    %eax,0xe14
 78e:	a1 14 0e 00 00       	mov    0xe14,%eax
 793:	a3 0c 0e 00 00       	mov    %eax,0xe0c
    base.s.size = 0;
 798:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
 79f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b3:	72 4d                	jb     802 <malloc+0xa6>
      if(p->s.size == nunits)
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7be:	75 0c                	jne    7cc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
 7ca:	eb 26                	jmp    7f2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d5:	89 c2                	mov    %eax,%edx
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	c1 e0 03             	shl    $0x3,%eax
 7e6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	a3 14 0e 00 00       	mov    %eax,0xe14
      return (void*)(p + 1);
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	83 c0 08             	add    $0x8,%eax
 800:	eb 3b                	jmp    83d <malloc+0xe1>
    }
    if(p == freep)
 802:	a1 14 0e 00 00       	mov    0xe14,%eax
 807:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80a:	75 1e                	jne    82a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80c:	83 ec 0c             	sub    $0xc,%esp
 80f:	ff 75 ec             	push   -0x14(%ebp)
 812:	e8 e5 fe ff ff       	call   6fc <morecore>
 817:	83 c4 10             	add    $0x10,%esp
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 821:	75 07                	jne    82a <malloc+0xce>
        return 0;
 823:	b8 00 00 00 00       	mov    $0x0,%eax
 828:	eb 13                	jmp    83d <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 838:	e9 6d ff ff ff       	jmp    7aa <malloc+0x4e>
  }
}
 83d:	c9                   	leave
 83e:	c3                   	ret

0000083f <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 83f:	55                   	push   %ebp
 840:	89 e5                	mov    %esp,%ebp
 842:	83 ec 18             	sub    $0x18,%esp
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	8b 50 04             	mov    0x4(%eax),%edx
 84b:	8b 00                	mov    (%eax),%eax
 84d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 850:	89 55 f4             	mov    %edx,-0xc(%ebp)
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	8b 55 f4             	mov    -0xc(%ebp),%edx
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	52                   	push   %edx
 85d:	ff d0                	call   *%eax
 85f:	83 c4 10             	add    $0x10,%esp
 862:	e8 05 fb ff ff       	call   36c <thread_exit>

00000867 <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 867:	55                   	push   %ebp
 868:	89 e5                	mov    %esp,%ebp
 86a:	83 ec 18             	sub    $0x18,%esp
 86d:	83 ec 0c             	sub    $0xc,%esp
 870:	68 00 20 00 00       	push   $0x2000
 875:	e8 e2 fe ff ff       	call   75c <malloc>
 87a:	83 c4 10             	add    $0x10,%esp
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 884:	75 0a                	jne    890 <pthread_create+0x29>
 886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 88b:	e9 9b 00 00 00       	jmp    92b <pthread_create+0xc4>
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	05 ff 0f 00 00       	add    $0xfff,%eax
 898:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 89d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	6a 08                	push   $0x8
 8a5:	e8 b2 fe ff ff       	call   75c <malloc>
 8aa:	83 c4 10             	add    $0x10,%esp
 8ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8b4:	75 15                	jne    8cb <pthread_create+0x64>
 8b6:	83 ec 0c             	sub    $0xc,%esp
 8b9:	ff 75 f4             	push   -0xc(%ebp)
 8bc:	e8 59 fd ff ff       	call   61a <free>
 8c1:	83 c4 10             	add    $0x10,%esp
 8c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c9:	eb 60                	jmp    92b <pthread_create+0xc4>
 8cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ce:	8b 55 10             	mov    0x10(%ebp),%edx
 8d1:	89 10                	mov    %edx,(%eax)
 8d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d6:	8b 55 14             	mov    0x14(%ebp),%edx
 8d9:	89 50 04             	mov    %edx,0x4(%eax)
 8dc:	83 ec 04             	sub    $0x4,%esp
 8df:	ff 75 f0             	push   -0x10(%ebp)
 8e2:	ff 75 ec             	push   -0x14(%ebp)
 8e5:	68 3f 08 00 00       	push   $0x83f
 8ea:	e8 6d fa ff ff       	call   35c <clone>
 8ef:	83 c4 10             	add    $0x10,%esp
 8f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 8f9:	79 23                	jns    91e <pthread_create+0xb7>
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	ff 75 ec             	push   -0x14(%ebp)
 901:	e8 14 fd ff ff       	call   61a <free>
 906:	83 c4 10             	add    $0x10,%esp
 909:	83 ec 0c             	sub    $0xc,%esp
 90c:	ff 75 f4             	push   -0xc(%ebp)
 90f:	e8 06 fd ff ff       	call   61a <free>
 914:	83 c4 10             	add    $0x10,%esp
 917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 91c:	eb 0d                	jmp    92b <pthread_create+0xc4>
 91e:	8b 45 08             	mov    0x8(%ebp),%eax
 921:	8b 55 e8             	mov    -0x18(%ebp),%edx
 924:	89 10                	mov    %edx,(%eax)
 926:	b8 00 00 00 00       	mov    $0x0,%eax
 92b:	c9                   	leave
 92c:	c3                   	ret

0000092d <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 92d:	55                   	push   %ebp
 92e:	89 e5                	mov    %esp,%ebp
 930:	83 ec 18             	sub    $0x18,%esp
 933:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 93a:	83 ec 08             	sub    $0x8,%esp
 93d:	8d 45 f0             	lea    -0x10(%ebp),%eax
 940:	50                   	push   %eax
 941:	ff 75 08             	push   0x8(%ebp)
 944:	e8 1b fa ff ff       	call   364 <join>
 949:	83 c4 10             	add    $0x10,%esp
 94c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	3b 45 08             	cmp    0x8(%ebp),%eax
 955:	75 07                	jne    95e <pthread_join+0x31>
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 05                	jmp    963 <pthread_join+0x36>
 95e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 963:	c9                   	leave
 964:	c3                   	ret

00000965 <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 965:	55                   	push   %ebp
 966:	89 e5                	mov    %esp,%ebp
 968:	83 ec 08             	sub    $0x8,%esp
 96b:	e8 fc f9 ff ff       	call   36c <thread_exit>

00000970 <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	83 ec 08             	sub    $0x8,%esp
 976:	e8 09 fa ff ff       	call   384 <lock_create>
 97b:	8b 55 08             	mov    0x8(%ebp),%edx
 97e:	89 02                	mov    %eax,(%edx)
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	85 c0                	test   %eax,%eax
 987:	79 07                	jns    990 <pthread_mutex_init+0x20>
 989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 98e:	eb 05                	jmp    995 <pthread_mutex_init+0x25>
 990:	b8 00 00 00 00       	mov    $0x0,%eax
 995:	c9                   	leave
 996:	c3                   	ret

00000997 <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 997:	55                   	push   %ebp
 998:	89 e5                	mov    %esp,%ebp
 99a:	83 ec 08             	sub    $0x8,%esp
 99d:	8b 45 08             	mov    0x8(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	83 ec 0c             	sub    $0xc,%esp
 9a5:	50                   	push   %eax
 9a6:	e8 e1 f9 ff ff       	call   38c <lock_acquire>
 9ab:	83 c4 10             	add    $0x10,%esp
 9ae:	c9                   	leave
 9af:	c3                   	ret

000009b0 <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	83 ec 08             	sub    $0x8,%esp
 9b6:	8b 45 08             	mov    0x8(%ebp),%eax
 9b9:	8b 00                	mov    (%eax),%eax
 9bb:	83 ec 0c             	sub    $0xc,%esp
 9be:	50                   	push   %eax
 9bf:	e8 d0 f9 ff ff       	call   394 <lock_release>
 9c4:	83 c4 10             	add    $0x10,%esp
 9c7:	c9                   	leave
 9c8:	c3                   	ret

000009c9 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 9c9:	55                   	push   %ebp
 9ca:	89 e5                	mov    %esp,%ebp
 9cc:	83 ec 08             	sub    $0x8,%esp
 9cf:	8b 45 10             	mov    0x10(%ebp),%eax
 9d2:	83 ec 0c             	sub    $0xc,%esp
 9d5:	50                   	push   %eax
 9d6:	e8 c1 f9 ff ff       	call   39c <sem_create>
 9db:	83 c4 10             	add    $0x10,%esp
 9de:	8b 55 08             	mov    0x8(%ebp),%edx
 9e1:	89 02                	mov    %eax,(%edx)
 9e3:	8b 45 08             	mov    0x8(%ebp),%eax
 9e6:	8b 00                	mov    (%eax),%eax
 9e8:	85 c0                	test   %eax,%eax
 9ea:	79 07                	jns    9f3 <sem_init+0x2a>
 9ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9f1:	eb 05                	jmp    9f8 <sem_init+0x2f>
 9f3:	b8 00 00 00 00       	mov    $0x0,%eax
 9f8:	c9                   	leave
 9f9:	c3                   	ret

000009fa <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 9fa:	55                   	push   %ebp
 9fb:	89 e5                	mov    %esp,%ebp
 9fd:	83 ec 08             	sub    $0x8,%esp
 a00:	8b 45 08             	mov    0x8(%ebp),%eax
 a03:	8b 00                	mov    (%eax),%eax
 a05:	83 ec 0c             	sub    $0xc,%esp
 a08:	50                   	push   %eax
 a09:	e8 96 f9 ff ff       	call   3a4 <sem_wait>
 a0e:	83 c4 10             	add    $0x10,%esp
 a11:	c9                   	leave
 a12:	c3                   	ret

00000a13 <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 a13:	55                   	push   %ebp
 a14:	89 e5                	mov    %esp,%ebp
 a16:	83 ec 08             	sub    $0x8,%esp
 a19:	8b 45 08             	mov    0x8(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	83 ec 0c             	sub    $0xc,%esp
 a21:	50                   	push   %eax
 a22:	e8 85 f9 ff ff       	call   3ac <sem_post>
 a27:	83 c4 10             	add    $0x10,%esp
 a2a:	c9                   	leave
 a2b:	c3                   	ret

00000a2c <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 a2c:	55                   	push   %ebp
 a2d:	89 e5                	mov    %esp,%ebp
 a2f:	83 ec 08             	sub    $0x8,%esp
 a32:	83 ec 08             	sub    $0x8,%esp
 a35:	ff 75 0c             	push   0xc(%ebp)
 a38:	ff 75 08             	push   0x8(%ebp)
 a3b:	e8 34 f9 ff ff       	call   374 <randconfig>
 a40:	83 c4 10             	add    $0x10,%esp
 a43:	90                   	nop
 a44:	c9                   	leave
 a45:	c3                   	ret
