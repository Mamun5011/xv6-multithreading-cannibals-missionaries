
_rm:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 71 0a 00 00       	push   $0xa71
  21:	6a 02                	push   $0x2
  23:	e8 8b 04 00 00       	call   4b3 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 b7 02 00 00       	call   2e7 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 02 00 00       	call   337 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 85 0a 00 00       	push   $0xa85
  74:	6a 02                	push   $0x2
  76:	e8 38 04 00 00       	call   4b3 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
    }
  }

  exit();
  8b:	e8 57 02 00 00       	call   2e7 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  c6:	8d 42 01             	lea    0x1(%edx),%eax
  c9:	89 45 0c             	mov    %eax,0xc(%ebp)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8d 48 01             	lea    0x1(%eax),%ecx
  d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave
  e5:	c3                   	ret

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c0             	movzbl %al,%eax
 11f:	29 c2                	sub    %eax,%edx
 121:	89 d0                	mov    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret

00000125 <strlen>:

uint
strlen(const char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave
 14b:	c3                   	ret

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	push   0xc(%ebp)
 156:	ff 75 08             	push   0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave
 165:	c3                   	ret

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 45 fc             	cmp    %al,-0x4(%ebp)
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave
 198:	c3                   	ret

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 47 01 00 00       	call   2ff <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f3:	7f b3                	jg     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave
 207:	c3                   	ret

00000208 <stat>:

int
stat(const char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	push   0x8(%ebp)
 216:	e8 0c 01 00 00       	call   327 <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	push   0xc(%ebp)
 234:	ff 75 f4             	push   -0xc(%ebp)
 237:	e8 03 01 00 00       	call   33f <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	push   -0xc(%ebp)
 248:	e8 c2 00 00 00       	call   30f <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave
 254:	c3                   	ret

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 25                	jmp    289 <atoi+0x34>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c1                	mov    %eax,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8d 50 01             	lea    0x1(%eax),%edx
 278:	89 55 08             	mov    %edx,0x8(%ebp)
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f be c0             	movsbl %al,%eax
 281:	01 c8                	add    %ecx,%eax
 283:	83 e8 30             	sub    $0x30,%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x48>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c7                	jle    264 <atoi+0xf>
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave
 2a1:	c3                   	ret

000002a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 17                	jmp    2cd <memmove+0x2b>
    *dst++ = *src++;
 2b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b9:	8d 42 01             	lea    0x1(%edx),%eax
 2bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c2:	8d 48 01             	lea    0x1(%eax),%ecx
 2c5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2cd:	8b 45 10             	mov    0x10(%ebp),%eax
 2d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d3:	89 55 10             	mov    %edx,0x10(%ebp)
 2d6:	85 c0                	test   %eax,%eax
 2d8:	7f dc                	jg     2b6 <memmove+0x14>
  return vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dd:	c9                   	leave
 2de:	c3                   	ret

000002df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2df:	b8 01 00 00 00       	mov    $0x1,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <exit>:
SYSCALL(exit)
 2e7:	b8 02 00 00 00       	mov    $0x2,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <wait>:
SYSCALL(wait)
 2ef:	b8 03 00 00 00       	mov    $0x3,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <pipe>:
SYSCALL(pipe)
 2f7:	b8 04 00 00 00       	mov    $0x4,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <read>:
SYSCALL(read)
 2ff:	b8 05 00 00 00       	mov    $0x5,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <write>:
SYSCALL(write)
 307:	b8 10 00 00 00       	mov    $0x10,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <close>:
SYSCALL(close)
 30f:	b8 15 00 00 00       	mov    $0x15,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <kill>:
SYSCALL(kill)
 317:	b8 06 00 00 00       	mov    $0x6,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <exec>:
SYSCALL(exec)
 31f:	b8 07 00 00 00       	mov    $0x7,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <open>:
SYSCALL(open)
 327:	b8 0f 00 00 00       	mov    $0xf,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <mknod>:
SYSCALL(mknod)
 32f:	b8 11 00 00 00       	mov    $0x11,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <unlink>:
SYSCALL(unlink)
 337:	b8 12 00 00 00       	mov    $0x12,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <fstat>:
SYSCALL(fstat)
 33f:	b8 08 00 00 00       	mov    $0x8,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <link>:
SYSCALL(link)
 347:	b8 13 00 00 00       	mov    $0x13,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <mkdir>:
SYSCALL(mkdir)
 34f:	b8 14 00 00 00       	mov    $0x14,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <chdir>:
SYSCALL(chdir)
 357:	b8 09 00 00 00       	mov    $0x9,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <dup>:
SYSCALL(dup)
 35f:	b8 0a 00 00 00       	mov    $0xa,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <getpid>:
SYSCALL(getpid)
 367:	b8 0b 00 00 00       	mov    $0xb,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <sbrk>:
SYSCALL(sbrk)
 36f:	b8 0c 00 00 00       	mov    $0xc,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <sleep>:
SYSCALL(sleep)
 377:	b8 0d 00 00 00       	mov    $0xd,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <uptime>:
SYSCALL(uptime)
 37f:	b8 0e 00 00 00       	mov    $0xe,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <clone>:

SYSCALL(clone)
 387:	b8 16 00 00 00       	mov    $0x16,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <join>:
SYSCALL(join)
 38f:	b8 17 00 00 00       	mov    $0x17,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <thread_exit>:
SYSCALL(thread_exit)
 397:	b8 18 00 00 00       	mov    $0x18,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <randconfig>:
SYSCALL(randconfig)
 39f:	b8 19 00 00 00       	mov    $0x19,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <yield>:
SYSCALL(yield)
 3a7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret

000003af <lock_create>:
SYSCALL(lock_create)
 3af:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret

000003b7 <lock_acquire>:
SYSCALL(lock_acquire)
 3b7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret

000003bf <lock_release>:
SYSCALL(lock_release)
 3bf:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret

000003c7 <sem_create>:
SYSCALL(sem_create)
 3c7:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret

000003cf <sem_wait>:
SYSCALL(sem_wait)
 3cf:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret

000003d7 <sem_post>:
SYSCALL(sem_post)
 3d7:	b8 20 00 00 00       	mov    $0x20,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret

000003df <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
 3e2:	83 ec 18             	sub    $0x18,%esp
 3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3eb:	83 ec 04             	sub    $0x4,%esp
 3ee:	6a 01                	push   $0x1
 3f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f3:	50                   	push   %eax
 3f4:	ff 75 08             	push   0x8(%ebp)
 3f7:	e8 0b ff ff ff       	call   307 <write>
 3fc:	83 c4 10             	add    $0x10,%esp
}
 3ff:	90                   	nop
 400:	c9                   	leave
 401:	c3                   	ret

00000402 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 408:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 40f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 413:	74 17                	je     42c <printint+0x2a>
 415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 419:	79 11                	jns    42c <printint+0x2a>
    neg = 1;
 41b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	f7 d8                	neg    %eax
 427:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42a:	eb 06                	jmp    432 <printint+0x30>
  } else {
    x = xx;
 42c:	8b 45 0c             	mov    0xc(%ebp),%eax
 42f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 439:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43f:	ba 00 00 00 00       	mov    $0x0,%edx
 444:	f7 f1                	div    %ecx
 446:	89 d1                	mov    %edx,%ecx
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	8d 50 01             	lea    0x1(%eax),%edx
 44e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 451:	0f b6 91 48 0e 00 00 	movzbl 0xe48(%ecx),%edx
 458:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 45c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 462:	ba 00 00 00 00       	mov    $0x0,%edx
 467:	f7 f1                	div    %ecx
 469:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 470:	75 c7                	jne    439 <printint+0x37>
  if(neg)
 472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 476:	74 2d                	je     4a5 <printint+0xa3>
    buf[i++] = '-';
 478:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47b:	8d 50 01             	lea    0x1(%eax),%edx
 47e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 481:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 486:	eb 1d                	jmp    4a5 <printint+0xa3>
    putc(fd, buf[i]);
 488:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48e:	01 d0                	add    %edx,%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	83 ec 08             	sub    $0x8,%esp
 499:	50                   	push   %eax
 49a:	ff 75 08             	push   0x8(%ebp)
 49d:	e8 3d ff ff ff       	call   3df <putc>
 4a2:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4a5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ad:	79 d9                	jns    488 <printint+0x86>
}
 4af:	90                   	nop
 4b0:	90                   	nop
 4b1:	c9                   	leave
 4b2:	c3                   	ret

000004b3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c0:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c3:	83 c0 04             	add    $0x4,%eax
 4c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d0:	e9 59 01 00 00       	jmp    62e <printf+0x17b>
    c = fmt[i] & 0xff;
 4d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4db:	01 d0                	add    %edx,%eax
 4dd:	0f b6 00             	movzbl (%eax),%eax
 4e0:	0f be c0             	movsbl %al,%eax
 4e3:	25 ff 00 00 00       	and    $0xff,%eax
 4e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ef:	75 2c                	jne    51d <printf+0x6a>
      if(c == '%'){
 4f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f5:	75 0c                	jne    503 <printf+0x50>
        state = '%';
 4f7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4fe:	e9 27 01 00 00       	jmp    62a <printf+0x177>
      } else {
        putc(fd, c);
 503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 506:	0f be c0             	movsbl %al,%eax
 509:	83 ec 08             	sub    $0x8,%esp
 50c:	50                   	push   %eax
 50d:	ff 75 08             	push   0x8(%ebp)
 510:	e8 ca fe ff ff       	call   3df <putc>
 515:	83 c4 10             	add    $0x10,%esp
 518:	e9 0d 01 00 00       	jmp    62a <printf+0x177>
      }
    } else if(state == '%'){
 51d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 521:	0f 85 03 01 00 00    	jne    62a <printf+0x177>
      if(c == 'd'){
 527:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52b:	75 1e                	jne    54b <printf+0x98>
        printint(fd, *ap, 10, 1);
 52d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 530:	8b 00                	mov    (%eax),%eax
 532:	6a 01                	push   $0x1
 534:	6a 0a                	push   $0xa
 536:	50                   	push   %eax
 537:	ff 75 08             	push   0x8(%ebp)
 53a:	e8 c3 fe ff ff       	call   402 <printint>
 53f:	83 c4 10             	add    $0x10,%esp
        ap++;
 542:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 546:	e9 d8 00 00 00       	jmp    623 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 54b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 54f:	74 06                	je     557 <printf+0xa4>
 551:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 555:	75 1e                	jne    575 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 557:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55a:	8b 00                	mov    (%eax),%eax
 55c:	6a 00                	push   $0x0
 55e:	6a 10                	push   $0x10
 560:	50                   	push   %eax
 561:	ff 75 08             	push   0x8(%ebp)
 564:	e8 99 fe ff ff       	call   402 <printint>
 569:	83 c4 10             	add    $0x10,%esp
        ap++;
 56c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 570:	e9 ae 00 00 00       	jmp    623 <printf+0x170>
      } else if(c == 's'){
 575:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 579:	75 43                	jne    5be <printf+0x10b>
        s = (char*)*ap;
 57b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58b:	75 25                	jne    5b2 <printf+0xff>
          s = "(null)";
 58d:	c7 45 f4 9e 0a 00 00 	movl   $0xa9e,-0xc(%ebp)
        while(*s != 0){
 594:	eb 1c                	jmp    5b2 <printf+0xff>
          putc(fd, *s);
 596:	8b 45 f4             	mov    -0xc(%ebp),%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	push   0x8(%ebp)
 5a6:	e8 34 fe ff ff       	call   3df <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
          s++;
 5ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	0f b6 00             	movzbl (%eax),%eax
 5b8:	84 c0                	test   %al,%al
 5ba:	75 da                	jne    596 <printf+0xe3>
 5bc:	eb 65                	jmp    623 <printf+0x170>
        }
      } else if(c == 'c'){
 5be:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c2:	75 1d                	jne    5e1 <printf+0x12e>
        putc(fd, *ap);
 5c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	push   0x8(%ebp)
 5d3:	e8 07 fe ff ff       	call   3df <putc>
 5d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5df:	eb 42                	jmp    623 <printf+0x170>
      } else if(c == '%'){
 5e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e5:	75 17                	jne    5fe <printf+0x14b>
        putc(fd, c);
 5e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	push   0x8(%ebp)
 5f4:	e8 e6 fd ff ff       	call   3df <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
 5fc:	eb 25                	jmp    623 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	6a 25                	push   $0x25
 603:	ff 75 08             	push   0x8(%ebp)
 606:	e8 d4 fd ff ff       	call   3df <putc>
 60b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 60e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 611:	0f be c0             	movsbl %al,%eax
 614:	83 ec 08             	sub    $0x8,%esp
 617:	50                   	push   %eax
 618:	ff 75 08             	push   0x8(%ebp)
 61b:	e8 bf fd ff ff       	call   3df <putc>
 620:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 623:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 62a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 62e:	8b 55 0c             	mov    0xc(%ebp),%edx
 631:	8b 45 f0             	mov    -0x10(%ebp),%eax
 634:	01 d0                	add    %edx,%eax
 636:	0f b6 00             	movzbl (%eax),%eax
 639:	84 c0                	test   %al,%al
 63b:	0f 85 94 fe ff ff    	jne    4d5 <printf+0x22>
    }
  }
}
 641:	90                   	nop
 642:	90                   	nop
 643:	c9                   	leave
 644:	c3                   	ret

00000645 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 645:	55                   	push   %ebp
 646:	89 e5                	mov    %esp,%ebp
 648:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	83 e8 08             	sub    $0x8,%eax
 651:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 654:	a1 64 0e 00 00       	mov    0xe64,%eax
 659:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65c:	eb 24                	jmp    682 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 666:	72 12                	jb     67a <free+0x35>
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66e:	72 24                	jb     694 <free+0x4f>
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 678:	72 1a                	jb     694 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 688:	73 d4                	jae    65e <free+0x19>
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 692:	73 ca                	jae    65e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	8b 40 04             	mov    0x4(%eax),%eax
 69a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	39 c2                	cmp    %eax,%edx
 6ad:	75 24                	jne    6d3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	8b 50 04             	mov    0x4(%eax),%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	01 c2                	add    %eax,%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 0a                	jmp    6dd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 10                	mov    (%eax),%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 40 04             	mov    0x4(%eax),%eax
 6e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	01 d0                	add    %edx,%eax
 6ef:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6f2:	75 20                	jne    714 <free+0xcf>
    p->s.size += bp->s.size;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 50 04             	mov    0x4(%eax),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	01 c2                	add    %eax,%edx
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	8b 10                	mov    (%eax),%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	89 10                	mov    %edx,(%eax)
 712:	eb 08                	jmp    71c <free+0xd7>
  } else
    p->s.ptr = bp;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71a:	89 10                	mov    %edx,(%eax)
  freep = p;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	a3 64 0e 00 00       	mov    %eax,0xe64
}
 724:	90                   	nop
 725:	c9                   	leave
 726:	c3                   	ret

00000727 <morecore>:

static Header*
morecore(uint nu)
{
 727:	55                   	push   %ebp
 728:	89 e5                	mov    %esp,%ebp
 72a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 72d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 734:	77 07                	ja     73d <morecore+0x16>
    nu = 4096;
 736:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	c1 e0 03             	shl    $0x3,%eax
 743:	83 ec 0c             	sub    $0xc,%esp
 746:	50                   	push   %eax
 747:	e8 23 fc ff ff       	call   36f <sbrk>
 74c:	83 c4 10             	add    $0x10,%esp
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 752:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 756:	75 07                	jne    75f <morecore+0x38>
    return 0;
 758:	b8 00 00 00 00       	mov    $0x0,%eax
 75d:	eb 26                	jmp    785 <morecore+0x5e>
  hp = (Header*)p;
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	8b 55 08             	mov    0x8(%ebp),%edx
 76b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	83 c0 08             	add    $0x8,%eax
 774:	83 ec 0c             	sub    $0xc,%esp
 777:	50                   	push   %eax
 778:	e8 c8 fe ff ff       	call   645 <free>
 77d:	83 c4 10             	add    $0x10,%esp
  return freep;
 780:	a1 64 0e 00 00       	mov    0xe64,%eax
}
 785:	c9                   	leave
 786:	c3                   	ret

00000787 <malloc>:

void*
malloc(uint nbytes)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	83 c0 07             	add    $0x7,%eax
 793:	c1 e8 03             	shr    $0x3,%eax
 796:	83 c0 01             	add    $0x1,%eax
 799:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 79c:	a1 64 0e 00 00       	mov    0xe64,%eax
 7a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a8:	75 23                	jne    7cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7aa:	c7 45 f0 5c 0e 00 00 	movl   $0xe5c,-0x10(%ebp)
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	a3 64 0e 00 00       	mov    %eax,0xe64
 7b9:	a1 64 0e 00 00       	mov    0xe64,%eax
 7be:	a3 5c 0e 00 00       	mov    %eax,0xe5c
    base.s.size = 0;
 7c3:	c7 05 60 0e 00 00 00 	movl   $0x0,0xe60
 7ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7de:	72 4d                	jb     82d <malloc+0xa6>
      if(p->s.size == nunits)
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7e9:	75 0c                	jne    7f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 10                	mov    (%eax),%edx
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	89 10                	mov    %edx,(%eax)
 7f5:	eb 26                	jmp    81d <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 800:	89 c2                	mov    %eax,%edx
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 40 04             	mov    0x4(%eax),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 55 ec             	mov    -0x14(%ebp),%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	a3 64 0e 00 00       	mov    %eax,0xe64
      return (void*)(p + 1);
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	83 c0 08             	add    $0x8,%eax
 82b:	eb 3b                	jmp    868 <malloc+0xe1>
    }
    if(p == freep)
 82d:	a1 64 0e 00 00       	mov    0xe64,%eax
 832:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 835:	75 1e                	jne    855 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 837:	83 ec 0c             	sub    $0xc,%esp
 83a:	ff 75 ec             	push   -0x14(%ebp)
 83d:	e8 e5 fe ff ff       	call   727 <morecore>
 842:	83 c4 10             	add    $0x10,%esp
 845:	89 45 f4             	mov    %eax,-0xc(%ebp)
 848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84c:	75 07                	jne    855 <malloc+0xce>
        return 0;
 84e:	b8 00 00 00 00       	mov    $0x0,%eax
 853:	eb 13                	jmp    868 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 00                	mov    (%eax),%eax
 860:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 863:	e9 6d ff ff ff       	jmp    7d5 <malloc+0x4e>
  }
}
 868:	c9                   	leave
 869:	c3                   	ret

0000086a <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
 86d:	83 ec 18             	sub    $0x18,%esp
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	8b 50 04             	mov    0x4(%eax),%edx
 876:	8b 00                	mov    (%eax),%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	8b 55 f4             	mov    -0xc(%ebp),%edx
 884:	83 ec 0c             	sub    $0xc,%esp
 887:	52                   	push   %edx
 888:	ff d0                	call   *%eax
 88a:	83 c4 10             	add    $0x10,%esp
 88d:	e8 05 fb ff ff       	call   397 <thread_exit>

00000892 <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 892:	55                   	push   %ebp
 893:	89 e5                	mov    %esp,%ebp
 895:	83 ec 18             	sub    $0x18,%esp
 898:	83 ec 0c             	sub    $0xc,%esp
 89b:	68 00 20 00 00       	push   $0x2000
 8a0:	e8 e2 fe ff ff       	call   787 <malloc>
 8a5:	83 c4 10             	add    $0x10,%esp
 8a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8af:	75 0a                	jne    8bb <pthread_create+0x29>
 8b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8b6:	e9 9b 00 00 00       	jmp    956 <pthread_create+0xc4>
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	05 ff 0f 00 00       	add    $0xfff,%eax
 8c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 8c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	6a 08                	push   $0x8
 8d0:	e8 b2 fe ff ff       	call   787 <malloc>
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8df:	75 15                	jne    8f6 <pthread_create+0x64>
 8e1:	83 ec 0c             	sub    $0xc,%esp
 8e4:	ff 75 f4             	push   -0xc(%ebp)
 8e7:	e8 59 fd ff ff       	call   645 <free>
 8ec:	83 c4 10             	add    $0x10,%esp
 8ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8f4:	eb 60                	jmp    956 <pthread_create+0xc4>
 8f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f9:	8b 55 10             	mov    0x10(%ebp),%edx
 8fc:	89 10                	mov    %edx,(%eax)
 8fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 901:	8b 55 14             	mov    0x14(%ebp),%edx
 904:	89 50 04             	mov    %edx,0x4(%eax)
 907:	83 ec 04             	sub    $0x4,%esp
 90a:	ff 75 f0             	push   -0x10(%ebp)
 90d:	ff 75 ec             	push   -0x14(%ebp)
 910:	68 6a 08 00 00       	push   $0x86a
 915:	e8 6d fa ff ff       	call   387 <clone>
 91a:	83 c4 10             	add    $0x10,%esp
 91d:	89 45 e8             	mov    %eax,-0x18(%ebp)
 920:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 924:	79 23                	jns    949 <pthread_create+0xb7>
 926:	83 ec 0c             	sub    $0xc,%esp
 929:	ff 75 ec             	push   -0x14(%ebp)
 92c:	e8 14 fd ff ff       	call   645 <free>
 931:	83 c4 10             	add    $0x10,%esp
 934:	83 ec 0c             	sub    $0xc,%esp
 937:	ff 75 f4             	push   -0xc(%ebp)
 93a:	e8 06 fd ff ff       	call   645 <free>
 93f:	83 c4 10             	add    $0x10,%esp
 942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 947:	eb 0d                	jmp    956 <pthread_create+0xc4>
 949:	8b 45 08             	mov    0x8(%ebp),%eax
 94c:	8b 55 e8             	mov    -0x18(%ebp),%edx
 94f:	89 10                	mov    %edx,(%eax)
 951:	b8 00 00 00 00       	mov    $0x0,%eax
 956:	c9                   	leave
 957:	c3                   	ret

00000958 <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 958:	55                   	push   %ebp
 959:	89 e5                	mov    %esp,%ebp
 95b:	83 ec 18             	sub    $0x18,%esp
 95e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 965:	83 ec 08             	sub    $0x8,%esp
 968:	8d 45 f0             	lea    -0x10(%ebp),%eax
 96b:	50                   	push   %eax
 96c:	ff 75 08             	push   0x8(%ebp)
 96f:	e8 1b fa ff ff       	call   38f <join>
 974:	83 c4 10             	add    $0x10,%esp
 977:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	3b 45 08             	cmp    0x8(%ebp),%eax
 980:	75 07                	jne    989 <pthread_join+0x31>
 982:	b8 00 00 00 00       	mov    $0x0,%eax
 987:	eb 05                	jmp    98e <pthread_join+0x36>
 989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 98e:	c9                   	leave
 98f:	c3                   	ret

00000990 <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	83 ec 08             	sub    $0x8,%esp
 996:	e8 fc f9 ff ff       	call   397 <thread_exit>

0000099b <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 99b:	55                   	push   %ebp
 99c:	89 e5                	mov    %esp,%ebp
 99e:	83 ec 08             	sub    $0x8,%esp
 9a1:	e8 09 fa ff ff       	call   3af <lock_create>
 9a6:	8b 55 08             	mov    0x8(%ebp),%edx
 9a9:	89 02                	mov    %eax,(%edx)
 9ab:	8b 45 08             	mov    0x8(%ebp),%eax
 9ae:	8b 00                	mov    (%eax),%eax
 9b0:	85 c0                	test   %eax,%eax
 9b2:	79 07                	jns    9bb <pthread_mutex_init+0x20>
 9b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9b9:	eb 05                	jmp    9c0 <pthread_mutex_init+0x25>
 9bb:	b8 00 00 00 00       	mov    $0x0,%eax
 9c0:	c9                   	leave
 9c1:	c3                   	ret

000009c2 <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 9c2:	55                   	push   %ebp
 9c3:	89 e5                	mov    %esp,%ebp
 9c5:	83 ec 08             	sub    $0x8,%esp
 9c8:	8b 45 08             	mov    0x8(%ebp),%eax
 9cb:	8b 00                	mov    (%eax),%eax
 9cd:	83 ec 0c             	sub    $0xc,%esp
 9d0:	50                   	push   %eax
 9d1:	e8 e1 f9 ff ff       	call   3b7 <lock_acquire>
 9d6:	83 c4 10             	add    $0x10,%esp
 9d9:	c9                   	leave
 9da:	c3                   	ret

000009db <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 9db:	55                   	push   %ebp
 9dc:	89 e5                	mov    %esp,%ebp
 9de:	83 ec 08             	sub    $0x8,%esp
 9e1:	8b 45 08             	mov    0x8(%ebp),%eax
 9e4:	8b 00                	mov    (%eax),%eax
 9e6:	83 ec 0c             	sub    $0xc,%esp
 9e9:	50                   	push   %eax
 9ea:	e8 d0 f9 ff ff       	call   3bf <lock_release>
 9ef:	83 c4 10             	add    $0x10,%esp
 9f2:	c9                   	leave
 9f3:	c3                   	ret

000009f4 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 9f4:	55                   	push   %ebp
 9f5:	89 e5                	mov    %esp,%ebp
 9f7:	83 ec 08             	sub    $0x8,%esp
 9fa:	8b 45 10             	mov    0x10(%ebp),%eax
 9fd:	83 ec 0c             	sub    $0xc,%esp
 a00:	50                   	push   %eax
 a01:	e8 c1 f9 ff ff       	call   3c7 <sem_create>
 a06:	83 c4 10             	add    $0x10,%esp
 a09:	8b 55 08             	mov    0x8(%ebp),%edx
 a0c:	89 02                	mov    %eax,(%edx)
 a0e:	8b 45 08             	mov    0x8(%ebp),%eax
 a11:	8b 00                	mov    (%eax),%eax
 a13:	85 c0                	test   %eax,%eax
 a15:	79 07                	jns    a1e <sem_init+0x2a>
 a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a1c:	eb 05                	jmp    a23 <sem_init+0x2f>
 a1e:	b8 00 00 00 00       	mov    $0x0,%eax
 a23:	c9                   	leave
 a24:	c3                   	ret

00000a25 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 a25:	55                   	push   %ebp
 a26:	89 e5                	mov    %esp,%ebp
 a28:	83 ec 08             	sub    $0x8,%esp
 a2b:	8b 45 08             	mov    0x8(%ebp),%eax
 a2e:	8b 00                	mov    (%eax),%eax
 a30:	83 ec 0c             	sub    $0xc,%esp
 a33:	50                   	push   %eax
 a34:	e8 96 f9 ff ff       	call   3cf <sem_wait>
 a39:	83 c4 10             	add    $0x10,%esp
 a3c:	c9                   	leave
 a3d:	c3                   	ret

00000a3e <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 a3e:	55                   	push   %ebp
 a3f:	89 e5                	mov    %esp,%ebp
 a41:	83 ec 08             	sub    $0x8,%esp
 a44:	8b 45 08             	mov    0x8(%ebp),%eax
 a47:	8b 00                	mov    (%eax),%eax
 a49:	83 ec 0c             	sub    $0xc,%esp
 a4c:	50                   	push   %eax
 a4d:	e8 85 f9 ff ff       	call   3d7 <sem_post>
 a52:	83 c4 10             	add    $0x10,%esp
 a55:	c9                   	leave
 a56:	c3                   	ret

00000a57 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 a57:	55                   	push   %ebp
 a58:	89 e5                	mov    %esp,%ebp
 a5a:	83 ec 08             	sub    $0x8,%esp
 a5d:	83 ec 08             	sub    $0x8,%esp
 a60:	ff 75 0c             	push   0xc(%ebp)
 a63:	ff 75 08             	push   0x8(%ebp)
 a66:	e8 34 f9 ff ff       	call   39f <randconfig>
 a6b:	83 c4 10             	add    $0x10,%esp
 a6e:	90                   	nop
 a6f:	c9                   	leave
 a70:	c3                   	ret
