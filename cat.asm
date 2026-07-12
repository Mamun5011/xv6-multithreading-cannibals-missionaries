
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 31                	jmp    39 <cat+0x39>
    if (write(1, buf, n) != n) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 20 0f 00 00       	push   $0xf20
  13:	6a 01                	push   $0x1
  15:	e8 88 03 00 00       	call   3a2 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  20:	74 17                	je     39 <cat+0x39>
      printf(1, "cat: write error\n");
  22:	83 ec 08             	sub    $0x8,%esp
  25:	68 0c 0b 00 00       	push   $0xb0c
  2a:	6a 01                	push   $0x1
  2c:	e8 1d 05 00 00       	call   54e <printf>
  31:	83 c4 10             	add    $0x10,%esp
      exit();
  34:	e8 49 03 00 00       	call   382 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	68 00 02 00 00       	push   $0x200
  41:	68 20 0f 00 00       	push   $0xf20
  46:	ff 75 08             	push   0x8(%ebp)
  49:	e8 4c 03 00 00       	call   39a <read>
  4e:	83 c4 10             	add    $0x10,%esp
  51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  58:	7f ae                	jg     8 <cat+0x8>
    }
  }
  if(n < 0){
  5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5e:	79 17                	jns    77 <cat+0x77>
    printf(1, "cat: read error\n");
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 1e 0b 00 00       	push   $0xb1e
  68:	6a 01                	push   $0x1
  6a:	e8 df 04 00 00       	call   54e <printf>
  6f:	83 c4 10             	add    $0x10,%esp
    exit();
  72:	e8 0b 03 00 00       	call   382 <exit>
  }
}
  77:	90                   	nop
  78:	c9                   	leave
  79:	c3                   	ret

0000007a <main>:

int
main(int argc, char *argv[])
{
  7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7e:	83 e4 f0             	and    $0xfffffff0,%esp
  81:	ff 71 fc             	push   -0x4(%ecx)
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	51                   	push   %ecx
  89:	83 ec 10             	sub    $0x10,%esp
  8c:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  8e:	83 3b 01             	cmpl   $0x1,(%ebx)
  91:	7f 12                	jg     a5 <main+0x2b>
    cat(0);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	6a 00                	push   $0x0
  98:	e8 63 ff ff ff       	call   0 <cat>
  9d:	83 c4 10             	add    $0x10,%esp
    exit();
  a0:	e8 dd 02 00 00       	call   382 <exit>
  }

  for(i = 1; i < argc; i++){
  a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  ac:	eb 71                	jmp    11f <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  b8:	8b 43 04             	mov    0x4(%ebx),%eax
  bb:	01 d0                	add    %edx,%eax
  bd:	8b 00                	mov    (%eax),%eax
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	6a 00                	push   $0x0
  c4:	50                   	push   %eax
  c5:	e8 f8 02 00 00       	call   3c2 <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  d4:	79 29                	jns    ff <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e0:	8b 43 04             	mov    0x4(%ebx),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 00                	mov    (%eax),%eax
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	50                   	push   %eax
  eb:	68 2f 0b 00 00       	push   $0xb2f
  f0:	6a 01                	push   $0x1
  f2:	e8 57 04 00 00       	call   54e <printf>
  f7:	83 c4 10             	add    $0x10,%esp
      exit();
  fa:	e8 83 02 00 00       	call   382 <exit>
    }
    cat(fd);
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	ff 75 f0             	push   -0x10(%ebp)
 105:	e8 f6 fe ff ff       	call   0 <cat>
 10a:	83 c4 10             	add    $0x10,%esp
    close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 75 f0             	push   -0x10(%ebp)
 113:	e8 92 02 00 00       	call   3aa <close>
 118:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 11b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 11f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 122:	3b 03                	cmp    (%ebx),%eax
 124:	7c 88                	jl     ae <main+0x34>
  }
  exit();
 126:	e8 57 02 00 00       	call   382 <exit>

0000012b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 55 10             	mov    0x10(%ebp),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 cb                	mov    %ecx,%ebx
 13b:	89 df                	mov    %ebx,%edi
 13d:	89 d1                	mov    %edx,%ecx
 13f:	fc                   	cld
 140:	f3 aa                	rep stos %al,%es:(%edi)
 142:	89 ca                	mov    %ecx,%edx
 144:	89 fb                	mov    %edi,%ebx
 146:	89 5d 08             	mov    %ebx,0x8(%ebp)
 149:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14c:	90                   	nop
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret

00000151 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15d:	90                   	nop
 15e:	8b 55 0c             	mov    0xc(%ebp),%edx
 161:	8d 42 01             	lea    0x1(%edx),%eax
 164:	89 45 0c             	mov    %eax,0xc(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8d 48 01             	lea    0x1(%eax),%ecx
 16d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
    ;
  return os;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave
 180:	c3                   	ret

00000181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 184:	eb 08                	jmp    18e <strcmp+0xd>
    p++, q++;
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c0             	movzbl %al,%eax
 1ba:	29 c2                	sub    %eax,%edx
 1bc:	89 d0                	mov    %edx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret

000001c0 <strlen>:

uint
strlen(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
    ;
  return n;
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e5:	c9                   	leave
 1e6:	c3                   	ret

000001e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ea:	8b 45 10             	mov    0x10(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	ff 75 0c             	push   0xc(%ebp)
 1f1:	ff 75 08             	push   0x8(%ebp)
 1f4:	e8 32 ff ff ff       	call   12b <stosb>
 1f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave
 200:	c3                   	ret

00000201 <strchr>:

char*
strchr(const char *s, char c)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x22>
    if(*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x1e>
      return (char*)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x31>
  for(; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0xe>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave
 233:	c3                   	ret

00000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 241:	eb 42                	jmp    285 <gets+0x51>
    cc = read(0, &c, 1);
 243:	83 ec 04             	sub    $0x4,%esp
 246:	6a 01                	push   $0x1
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	6a 00                	push   $0x0
 24e:	e8 47 01 00 00       	call   39a <read>
 253:	83 c4 10             	add    $0x10,%esp
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 33                	jle    292 <gets+0x5e>
      break;
    buf[i++] = c;
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 f4             	mov    %edx,-0xc(%ebp)
 268:	89 c2                	mov    %eax,%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 c2                	add    %eax,%edx
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 16                	je     293 <gets+0x5f>
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0d                	cmp    $0xd,%al
 283:	74 0e                	je     293 <gets+0x5f>
  for(i=0; i+1 < max; ){
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	83 c0 01             	add    $0x1,%eax
 28b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28e:	7f b3                	jg     243 <gets+0xf>
 290:	eb 01                	jmp    293 <gets+0x5f>
      break;
 292:	90                   	nop
      break;
  }
  buf[i] = '\0';
 293:	8b 55 f4             	mov    -0xc(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave
 2a2:	c3                   	ret

000002a3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	push   0x8(%ebp)
 2b1:	e8 0c 01 00 00       	call   3c2 <open>
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x26>
    return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 25                	jmp    2ee <stat+0x4b>
  r = fstat(fd, st);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 0c             	push   0xc(%ebp)
 2cf:	ff 75 f4             	push   -0xc(%ebp)
 2d2:	e8 03 01 00 00       	call   3da <fstat>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	83 ec 0c             	sub    $0xc,%esp
 2e0:	ff 75 f4             	push   -0xc(%ebp)
 2e3:	e8 c2 00 00 00       	call   3aa <close>
 2e8:	83 c4 10             	add    $0x10,%esp
  return r;
 2eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ee:	c9                   	leave
 2ef:	c3                   	ret

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fd:	eb 25                	jmp    324 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 302:	89 d0                	mov    %edx,%eax
 304:	c1 e0 02             	shl    $0x2,%eax
 307:	01 d0                	add    %edx,%eax
 309:	01 c0                	add    %eax,%eax
 30b:	89 c1                	mov    %eax,%ecx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 08             	mov    %edx,0x8(%ebp)
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2f                	cmp    $0x2f,%al
 32c:	7e 0a                	jle    338 <atoi+0x48>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 39                	cmp    $0x39,%al
 336:	7e c7                	jle    2ff <atoi+0xf>
  return n;
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33b:	c9                   	leave
 33c:	c3                   	ret

0000033d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34f:	eb 17                	jmp    368 <memmove+0x2b>
    *dst++ = *src++;
 351:	8b 55 f8             	mov    -0x8(%ebp),%edx
 354:	8d 42 01             	lea    0x1(%edx),%eax
 357:	89 45 f8             	mov    %eax,-0x8(%ebp)
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35d:	8d 48 01             	lea    0x1(%eax),%ecx
 360:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 363:	0f b6 12             	movzbl (%edx),%edx
 366:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 368:	8b 45 10             	mov    0x10(%ebp),%eax
 36b:	8d 50 ff             	lea    -0x1(%eax),%edx
 36e:	89 55 10             	mov    %edx,0x10(%ebp)
 371:	85 c0                	test   %eax,%eax
 373:	7f dc                	jg     351 <memmove+0x14>
  return vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
}
 378:	c9                   	leave
 379:	c3                   	ret

0000037a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret

00000382 <exit>:
SYSCALL(exit)
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret

0000038a <wait>:
SYSCALL(wait)
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret

00000392 <pipe>:
SYSCALL(pipe)
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret

0000039a <read>:
SYSCALL(read)
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret

000003a2 <write>:
SYSCALL(write)
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret

000003aa <close>:
SYSCALL(close)
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret

000003b2 <kill>:
SYSCALL(kill)
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret

000003ba <exec>:
SYSCALL(exec)
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret

000003c2 <open>:
SYSCALL(open)
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret

000003ca <mknod>:
SYSCALL(mknod)
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret

000003d2 <unlink>:
SYSCALL(unlink)
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret

000003da <fstat>:
SYSCALL(fstat)
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret

000003e2 <link>:
SYSCALL(link)
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret

000003ea <mkdir>:
SYSCALL(mkdir)
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret

000003f2 <chdir>:
SYSCALL(chdir)
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret

000003fa <dup>:
SYSCALL(dup)
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret

00000402 <getpid>:
SYSCALL(getpid)
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret

0000040a <sbrk>:
SYSCALL(sbrk)
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret

00000412 <sleep>:
SYSCALL(sleep)
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret

0000041a <uptime>:
SYSCALL(uptime)
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret

00000422 <clone>:

SYSCALL(clone)
 422:	b8 16 00 00 00       	mov    $0x16,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret

0000042a <join>:
SYSCALL(join)
 42a:	b8 17 00 00 00       	mov    $0x17,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret

00000432 <thread_exit>:
SYSCALL(thread_exit)
 432:	b8 18 00 00 00       	mov    $0x18,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret

0000043a <randconfig>:
SYSCALL(randconfig)
 43a:	b8 19 00 00 00       	mov    $0x19,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret

00000442 <yield>:
SYSCALL(yield)
 442:	b8 1a 00 00 00       	mov    $0x1a,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret

0000044a <lock_create>:
SYSCALL(lock_create)
 44a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret

00000452 <lock_acquire>:
SYSCALL(lock_acquire)
 452:	b8 1c 00 00 00       	mov    $0x1c,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret

0000045a <lock_release>:
SYSCALL(lock_release)
 45a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret

00000462 <sem_create>:
SYSCALL(sem_create)
 462:	b8 1e 00 00 00       	mov    $0x1e,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret

0000046a <sem_wait>:
SYSCALL(sem_wait)
 46a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret

00000472 <sem_post>:
SYSCALL(sem_post)
 472:	b8 20 00 00 00       	mov    $0x20,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret

0000047a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 18             	sub    $0x18,%esp
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 486:	83 ec 04             	sub    $0x4,%esp
 489:	6a 01                	push   $0x1
 48b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 48e:	50                   	push   %eax
 48f:	ff 75 08             	push   0x8(%ebp)
 492:	e8 0b ff ff ff       	call   3a2 <write>
 497:	83 c4 10             	add    $0x10,%esp
}
 49a:	90                   	nop
 49b:	c9                   	leave
 49c:	c3                   	ret

0000049d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ae:	74 17                	je     4c7 <printint+0x2a>
 4b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b4:	79 11                	jns    4c7 <printint+0x2a>
    neg = 1;
 4b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	f7 d8                	neg    %eax
 4c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c5:	eb 06                	jmp    4cd <printint+0x30>
  } else {
    x = xx;
 4c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4da:	ba 00 00 00 00       	mov    $0x0,%edx
 4df:	f7 f1                	div    %ecx
 4e1:	89 d1                	mov    %edx,%ecx
 4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e6:	8d 50 01             	lea    0x1(%eax),%edx
 4e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ec:	0f b6 91 0c 0f 00 00 	movzbl 0xf0c(%ecx),%edx
 4f3:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fd:	ba 00 00 00 00       	mov    $0x0,%edx
 502:	f7 f1                	div    %ecx
 504:	89 45 ec             	mov    %eax,-0x14(%ebp)
 507:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50b:	75 c7                	jne    4d4 <printint+0x37>
  if(neg)
 50d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 511:	74 2d                	je     540 <printint+0xa3>
    buf[i++] = '-';
 513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 516:	8d 50 01             	lea    0x1(%eax),%edx
 519:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 521:	eb 1d                	jmp    540 <printint+0xa3>
    putc(fd, buf[i]);
 523:	8d 55 dc             	lea    -0x24(%ebp),%edx
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	01 d0                	add    %edx,%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	83 ec 08             	sub    $0x8,%esp
 534:	50                   	push   %eax
 535:	ff 75 08             	push   0x8(%ebp)
 538:	e8 3d ff ff ff       	call   47a <putc>
 53d:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 540:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 548:	79 d9                	jns    523 <printint+0x86>
}
 54a:	90                   	nop
 54b:	90                   	nop
 54c:	c9                   	leave
 54d:	c3                   	ret

0000054e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 554:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 55b:	8d 45 0c             	lea    0xc(%ebp),%eax
 55e:	83 c0 04             	add    $0x4,%eax
 561:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 564:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 56b:	e9 59 01 00 00       	jmp    6c9 <printf+0x17b>
    c = fmt[i] & 0xff;
 570:	8b 55 0c             	mov    0xc(%ebp),%edx
 573:	8b 45 f0             	mov    -0x10(%ebp),%eax
 576:	01 d0                	add    %edx,%eax
 578:	0f b6 00             	movzbl (%eax),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	25 ff 00 00 00       	and    $0xff,%eax
 583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58a:	75 2c                	jne    5b8 <printf+0x6a>
      if(c == '%'){
 58c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 590:	75 0c                	jne    59e <printf+0x50>
        state = '%';
 592:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 599:	e9 27 01 00 00       	jmp    6c5 <printf+0x177>
      } else {
        putc(fd, c);
 59e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	83 ec 08             	sub    $0x8,%esp
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	push   0x8(%ebp)
 5ab:	e8 ca fe ff ff       	call   47a <putc>
 5b0:	83 c4 10             	add    $0x10,%esp
 5b3:	e9 0d 01 00 00       	jmp    6c5 <printf+0x177>
      }
    } else if(state == '%'){
 5b8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5bc:	0f 85 03 01 00 00    	jne    6c5 <printf+0x177>
      if(c == 'd'){
 5c2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5c6:	75 1e                	jne    5e6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	6a 01                	push   $0x1
 5cf:	6a 0a                	push   $0xa
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	push   0x8(%ebp)
 5d5:	e8 c3 fe ff ff       	call   49d <printint>
 5da:	83 c4 10             	add    $0x10,%esp
        ap++;
 5dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e1:	e9 d8 00 00 00       	jmp    6be <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5e6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ea:	74 06                	je     5f2 <printf+0xa4>
 5ec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f0:	75 1e                	jne    610 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	6a 00                	push   $0x0
 5f9:	6a 10                	push   $0x10
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	push   0x8(%ebp)
 5ff:	e8 99 fe ff ff       	call   49d <printint>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	e9 ae 00 00 00       	jmp    6be <printf+0x170>
      } else if(c == 's'){
 610:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 614:	75 43                	jne    659 <printf+0x10b>
        s = (char*)*ap;
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 626:	75 25                	jne    64d <printf+0xff>
          s = "(null)";
 628:	c7 45 f4 44 0b 00 00 	movl   $0xb44,-0xc(%ebp)
        while(*s != 0){
 62f:	eb 1c                	jmp    64d <printf+0xff>
          putc(fd, *s);
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	0f b6 00             	movzbl (%eax),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	83 ec 08             	sub    $0x8,%esp
 63d:	50                   	push   %eax
 63e:	ff 75 08             	push   0x8(%ebp)
 641:	e8 34 fe ff ff       	call   47a <putc>
 646:	83 c4 10             	add    $0x10,%esp
          s++;
 649:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 64d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	84 c0                	test   %al,%al
 655:	75 da                	jne    631 <printf+0xe3>
 657:	eb 65                	jmp    6be <printf+0x170>
        }
      } else if(c == 'c'){
 659:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65d:	75 1d                	jne    67c <printf+0x12e>
        putc(fd, *ap);
 65f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	83 ec 08             	sub    $0x8,%esp
 66a:	50                   	push   %eax
 66b:	ff 75 08             	push   0x8(%ebp)
 66e:	e8 07 fe ff ff       	call   47a <putc>
 673:	83 c4 10             	add    $0x10,%esp
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	eb 42                	jmp    6be <printf+0x170>
      } else if(c == '%'){
 67c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 680:	75 17                	jne    699 <printf+0x14b>
        putc(fd, c);
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	83 ec 08             	sub    $0x8,%esp
 68b:	50                   	push   %eax
 68c:	ff 75 08             	push   0x8(%ebp)
 68f:	e8 e6 fd ff ff       	call   47a <putc>
 694:	83 c4 10             	add    $0x10,%esp
 697:	eb 25                	jmp    6be <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	6a 25                	push   $0x25
 69e:	ff 75 08             	push   0x8(%ebp)
 6a1:	e8 d4 fd ff ff       	call   47a <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	83 ec 08             	sub    $0x8,%esp
 6b2:	50                   	push   %eax
 6b3:	ff 75 08             	push   0x8(%ebp)
 6b6:	e8 bf fd ff ff       	call   47a <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6c5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cf:	01 d0                	add    %edx,%eax
 6d1:	0f b6 00             	movzbl (%eax),%eax
 6d4:	84 c0                	test   %al,%al
 6d6:	0f 85 94 fe ff ff    	jne    570 <printf+0x22>
    }
  }
}
 6dc:	90                   	nop
 6dd:	90                   	nop
 6de:	c9                   	leave
 6df:	c3                   	ret

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	83 e8 08             	sub    $0x8,%eax
 6ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ef:	a1 28 11 00 00       	mov    0x1128,%eax
 6f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f7:	eb 24                	jmp    71d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 701:	72 12                	jb     715 <free+0x35>
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 709:	72 24                	jb     72f <free+0x4f>
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 713:	72 1a                	jb     72f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 723:	73 d4                	jae    6f9 <free+0x19>
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 72d:	73 ca                	jae    6f9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 40 04             	mov    0x4(%eax),%eax
 735:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	01 c2                	add    %eax,%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	39 c2                	cmp    %eax,%edx
 748:	75 24                	jne    76e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	01 c2                	add    %eax,%edx
 75a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
 76c:	eb 0a                	jmp    778 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	01 d0                	add    %edx,%eax
 78a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 78d:	75 20                	jne    7af <free+0xcf>
    p->s.size += bp->s.size;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 50 04             	mov    0x4(%eax),%edx
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	01 c2                	add    %eax,%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	89 10                	mov    %edx,(%eax)
 7ad:	eb 08                	jmp    7b7 <free+0xd7>
  } else
    p->s.ptr = bp;
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	a3 28 11 00 00       	mov    %eax,0x1128
}
 7bf:	90                   	nop
 7c0:	c9                   	leave
 7c1:	c3                   	ret

000007c2 <morecore>:

static Header*
morecore(uint nu)
{
 7c2:	55                   	push   %ebp
 7c3:	89 e5                	mov    %esp,%ebp
 7c5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cf:	77 07                	ja     7d8 <morecore+0x16>
    nu = 4096;
 7d1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	c1 e0 03             	shl    $0x3,%eax
 7de:	83 ec 0c             	sub    $0xc,%esp
 7e1:	50                   	push   %eax
 7e2:	e8 23 fc ff ff       	call   40a <sbrk>
 7e7:	83 c4 10             	add    $0x10,%esp
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f1:	75 07                	jne    7fa <morecore+0x38>
    return 0;
 7f3:	b8 00 00 00 00       	mov    $0x0,%eax
 7f8:	eb 26                	jmp    820 <morecore+0x5e>
  hp = (Header*)p;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	8b 55 08             	mov    0x8(%ebp),%edx
 806:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	83 c0 08             	add    $0x8,%eax
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	50                   	push   %eax
 813:	e8 c8 fe ff ff       	call   6e0 <free>
 818:	83 c4 10             	add    $0x10,%esp
  return freep;
 81b:	a1 28 11 00 00       	mov    0x1128,%eax
}
 820:	c9                   	leave
 821:	c3                   	ret

00000822 <malloc>:

void*
malloc(uint nbytes)
{
 822:	55                   	push   %ebp
 823:	89 e5                	mov    %esp,%ebp
 825:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 828:	8b 45 08             	mov    0x8(%ebp),%eax
 82b:	83 c0 07             	add    $0x7,%eax
 82e:	c1 e8 03             	shr    $0x3,%eax
 831:	83 c0 01             	add    $0x1,%eax
 834:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 837:	a1 28 11 00 00       	mov    0x1128,%eax
 83c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 843:	75 23                	jne    868 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 845:	c7 45 f0 20 11 00 00 	movl   $0x1120,-0x10(%ebp)
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	a3 28 11 00 00       	mov    %eax,0x1128
 854:	a1 28 11 00 00       	mov    0x1128,%eax
 859:	a3 20 11 00 00       	mov    %eax,0x1120
    base.s.size = 0;
 85e:	c7 05 24 11 00 00 00 	movl   $0x0,0x1124
 865:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 879:	72 4d                	jb     8c8 <malloc+0xa6>
      if(p->s.size == nunits)
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 40 04             	mov    0x4(%eax),%eax
 881:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 884:	75 0c                	jne    892 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 10                	mov    (%eax),%edx
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	89 10                	mov    %edx,(%eax)
 890:	eb 26                	jmp    8b8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 40 04             	mov    0x4(%eax),%eax
 898:	2b 45 ec             	sub    -0x14(%ebp),%eax
 89b:	89 c2                	mov    %eax,%edx
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 40 04             	mov    0x4(%eax),%eax
 8a9:	c1 e0 03             	shl    $0x3,%eax
 8ac:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	a3 28 11 00 00       	mov    %eax,0x1128
      return (void*)(p + 1);
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	83 c0 08             	add    $0x8,%eax
 8c6:	eb 3b                	jmp    903 <malloc+0xe1>
    }
    if(p == freep)
 8c8:	a1 28 11 00 00       	mov    0x1128,%eax
 8cd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d0:	75 1e                	jne    8f0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8d2:	83 ec 0c             	sub    $0xc,%esp
 8d5:	ff 75 ec             	push   -0x14(%ebp)
 8d8:	e8 e5 fe ff ff       	call   7c2 <morecore>
 8dd:	83 c4 10             	add    $0x10,%esp
 8e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e7:	75 07                	jne    8f0 <malloc+0xce>
        return 0;
 8e9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ee:	eb 13                	jmp    903 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	8b 00                	mov    (%eax),%eax
 8fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8fe:	e9 6d ff ff ff       	jmp    870 <malloc+0x4e>
  }
}
 903:	c9                   	leave
 904:	c3                   	ret

00000905 <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 905:	55                   	push   %ebp
 906:	89 e5                	mov    %esp,%ebp
 908:	83 ec 18             	sub    $0x18,%esp
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	8b 50 04             	mov    0x4(%eax),%edx
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 f0             	mov    %eax,-0x10(%ebp)
 916:	89 55 f4             	mov    %edx,-0xc(%ebp)
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 91f:	83 ec 0c             	sub    $0xc,%esp
 922:	52                   	push   %edx
 923:	ff d0                	call   *%eax
 925:	83 c4 10             	add    $0x10,%esp
 928:	e8 05 fb ff ff       	call   432 <thread_exit>

0000092d <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 92d:	55                   	push   %ebp
 92e:	89 e5                	mov    %esp,%ebp
 930:	83 ec 18             	sub    $0x18,%esp
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	68 00 20 00 00       	push   $0x2000
 93b:	e8 e2 fe ff ff       	call   822 <malloc>
 940:	83 c4 10             	add    $0x10,%esp
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
 946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94a:	75 0a                	jne    956 <pthread_create+0x29>
 94c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 951:	e9 9b 00 00 00       	jmp    9f1 <pthread_create+0xc4>
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	05 ff 0f 00 00       	add    $0xfff,%eax
 95e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 963:	89 45 f0             	mov    %eax,-0x10(%ebp)
 966:	83 ec 0c             	sub    $0xc,%esp
 969:	6a 08                	push   $0x8
 96b:	e8 b2 fe ff ff       	call   822 <malloc>
 970:	83 c4 10             	add    $0x10,%esp
 973:	89 45 ec             	mov    %eax,-0x14(%ebp)
 976:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 97a:	75 15                	jne    991 <pthread_create+0x64>
 97c:	83 ec 0c             	sub    $0xc,%esp
 97f:	ff 75 f4             	push   -0xc(%ebp)
 982:	e8 59 fd ff ff       	call   6e0 <free>
 987:	83 c4 10             	add    $0x10,%esp
 98a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 98f:	eb 60                	jmp    9f1 <pthread_create+0xc4>
 991:	8b 45 ec             	mov    -0x14(%ebp),%eax
 994:	8b 55 10             	mov    0x10(%ebp),%edx
 997:	89 10                	mov    %edx,(%eax)
 999:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99c:	8b 55 14             	mov    0x14(%ebp),%edx
 99f:	89 50 04             	mov    %edx,0x4(%eax)
 9a2:	83 ec 04             	sub    $0x4,%esp
 9a5:	ff 75 f0             	push   -0x10(%ebp)
 9a8:	ff 75 ec             	push   -0x14(%ebp)
 9ab:	68 05 09 00 00       	push   $0x905
 9b0:	e8 6d fa ff ff       	call   422 <clone>
 9b5:	83 c4 10             	add    $0x10,%esp
 9b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 9bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 9bf:	79 23                	jns    9e4 <pthread_create+0xb7>
 9c1:	83 ec 0c             	sub    $0xc,%esp
 9c4:	ff 75 ec             	push   -0x14(%ebp)
 9c7:	e8 14 fd ff ff       	call   6e0 <free>
 9cc:	83 c4 10             	add    $0x10,%esp
 9cf:	83 ec 0c             	sub    $0xc,%esp
 9d2:	ff 75 f4             	push   -0xc(%ebp)
 9d5:	e8 06 fd ff ff       	call   6e0 <free>
 9da:	83 c4 10             	add    $0x10,%esp
 9dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9e2:	eb 0d                	jmp    9f1 <pthread_create+0xc4>
 9e4:	8b 45 08             	mov    0x8(%ebp),%eax
 9e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
 9ea:	89 10                	mov    %edx,(%eax)
 9ec:	b8 00 00 00 00       	mov    $0x0,%eax
 9f1:	c9                   	leave
 9f2:	c3                   	ret

000009f3 <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 9f3:	55                   	push   %ebp
 9f4:	89 e5                	mov    %esp,%ebp
 9f6:	83 ec 18             	sub    $0x18,%esp
 9f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a00:	83 ec 08             	sub    $0x8,%esp
 a03:	8d 45 f0             	lea    -0x10(%ebp),%eax
 a06:	50                   	push   %eax
 a07:	ff 75 08             	push   0x8(%ebp)
 a0a:	e8 1b fa ff ff       	call   42a <join>
 a0f:	83 c4 10             	add    $0x10,%esp
 a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	3b 45 08             	cmp    0x8(%ebp),%eax
 a1b:	75 07                	jne    a24 <pthread_join+0x31>
 a1d:	b8 00 00 00 00       	mov    $0x0,%eax
 a22:	eb 05                	jmp    a29 <pthread_join+0x36>
 a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a29:	c9                   	leave
 a2a:	c3                   	ret

00000a2b <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 a2b:	55                   	push   %ebp
 a2c:	89 e5                	mov    %esp,%ebp
 a2e:	83 ec 08             	sub    $0x8,%esp
 a31:	e8 fc f9 ff ff       	call   432 <thread_exit>

00000a36 <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 a36:	55                   	push   %ebp
 a37:	89 e5                	mov    %esp,%ebp
 a39:	83 ec 08             	sub    $0x8,%esp
 a3c:	e8 09 fa ff ff       	call   44a <lock_create>
 a41:	8b 55 08             	mov    0x8(%ebp),%edx
 a44:	89 02                	mov    %eax,(%edx)
 a46:	8b 45 08             	mov    0x8(%ebp),%eax
 a49:	8b 00                	mov    (%eax),%eax
 a4b:	85 c0                	test   %eax,%eax
 a4d:	79 07                	jns    a56 <pthread_mutex_init+0x20>
 a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a54:	eb 05                	jmp    a5b <pthread_mutex_init+0x25>
 a56:	b8 00 00 00 00       	mov    $0x0,%eax
 a5b:	c9                   	leave
 a5c:	c3                   	ret

00000a5d <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 a5d:	55                   	push   %ebp
 a5e:	89 e5                	mov    %esp,%ebp
 a60:	83 ec 08             	sub    $0x8,%esp
 a63:	8b 45 08             	mov    0x8(%ebp),%eax
 a66:	8b 00                	mov    (%eax),%eax
 a68:	83 ec 0c             	sub    $0xc,%esp
 a6b:	50                   	push   %eax
 a6c:	e8 e1 f9 ff ff       	call   452 <lock_acquire>
 a71:	83 c4 10             	add    $0x10,%esp
 a74:	c9                   	leave
 a75:	c3                   	ret

00000a76 <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 a76:	55                   	push   %ebp
 a77:	89 e5                	mov    %esp,%ebp
 a79:	83 ec 08             	sub    $0x8,%esp
 a7c:	8b 45 08             	mov    0x8(%ebp),%eax
 a7f:	8b 00                	mov    (%eax),%eax
 a81:	83 ec 0c             	sub    $0xc,%esp
 a84:	50                   	push   %eax
 a85:	e8 d0 f9 ff ff       	call   45a <lock_release>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	c9                   	leave
 a8e:	c3                   	ret

00000a8f <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 a8f:	55                   	push   %ebp
 a90:	89 e5                	mov    %esp,%ebp
 a92:	83 ec 08             	sub    $0x8,%esp
 a95:	8b 45 10             	mov    0x10(%ebp),%eax
 a98:	83 ec 0c             	sub    $0xc,%esp
 a9b:	50                   	push   %eax
 a9c:	e8 c1 f9 ff ff       	call   462 <sem_create>
 aa1:	83 c4 10             	add    $0x10,%esp
 aa4:	8b 55 08             	mov    0x8(%ebp),%edx
 aa7:	89 02                	mov    %eax,(%edx)
 aa9:	8b 45 08             	mov    0x8(%ebp),%eax
 aac:	8b 00                	mov    (%eax),%eax
 aae:	85 c0                	test   %eax,%eax
 ab0:	79 07                	jns    ab9 <sem_init+0x2a>
 ab2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ab7:	eb 05                	jmp    abe <sem_init+0x2f>
 ab9:	b8 00 00 00 00       	mov    $0x0,%eax
 abe:	c9                   	leave
 abf:	c3                   	ret

00000ac0 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	83 ec 08             	sub    $0x8,%esp
 ac6:	8b 45 08             	mov    0x8(%ebp),%eax
 ac9:	8b 00                	mov    (%eax),%eax
 acb:	83 ec 0c             	sub    $0xc,%esp
 ace:	50                   	push   %eax
 acf:	e8 96 f9 ff ff       	call   46a <sem_wait>
 ad4:	83 c4 10             	add    $0x10,%esp
 ad7:	c9                   	leave
 ad8:	c3                   	ret

00000ad9 <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 ad9:	55                   	push   %ebp
 ada:	89 e5                	mov    %esp,%ebp
 adc:	83 ec 08             	sub    $0x8,%esp
 adf:	8b 45 08             	mov    0x8(%ebp),%eax
 ae2:	8b 00                	mov    (%eax),%eax
 ae4:	83 ec 0c             	sub    $0xc,%esp
 ae7:	50                   	push   %eax
 ae8:	e8 85 f9 ff ff       	call   472 <sem_post>
 aed:	83 c4 10             	add    $0x10,%esp
 af0:	c9                   	leave
 af1:	c3                   	ret

00000af2 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 af2:	55                   	push   %ebp
 af3:	89 e5                	mov    %esp,%ebp
 af5:	83 ec 08             	sub    $0x8,%esp
 af8:	83 ec 08             	sub    $0x8,%esp
 afb:	ff 75 0c             	push   0xc(%ebp)
 afe:	ff 75 08             	push   0x8(%ebp)
 b01:	e8 34 f9 ff ff       	call   43a <randconfig>
 b06:	83 c4 10             	add    $0x10,%esp
 b09:	90                   	nop
 b0a:	c9                   	leave
 b0b:	c3                   	ret
