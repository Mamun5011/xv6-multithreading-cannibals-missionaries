
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 c0 0f 00 00       	add    $0xfc0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 c0 0f 00 00       	add    $0xfc0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 9e 0b 00 00       	push   $0xb9e
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 c0 0f 00 00       	push   $0xfc0
  98:	ff 75 08             	push   0x8(%ebp)
  9b:	e8 8c 03 00 00       	call   42c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 a4 0b 00 00       	push   $0xba4
  be:	6a 01                	push   $0x1
  c0:	e8 1b 05 00 00       	call   5e0 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 47 03 00 00       	call   414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	push   0xc(%ebp)
  d3:	ff 75 e8             	push   -0x18(%ebp)
  d6:	ff 75 ec             	push   -0x14(%ebp)
  d9:	ff 75 f0             	push   -0x10(%ebp)
  dc:	68 b4 0b 00 00       	push   $0xbb4
  e1:	6a 01                	push   $0x1
  e3:	e8 f8 04 00 00       	call   5e0 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave
  ed:	c3                   	ret

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	push   -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 c1 0b 00 00       	push   $0xbc1
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 f6 02 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 0e 03 00 00       	call   454 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 c2 0b 00 00       	push   $0xbc2
 16c:	6a 01                	push   $0x1
 16e:	e8 6d 04 00 00       	call   5e0 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 99 02 00 00       	call   414 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	push   -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	push   -0x10(%ebp)
 1a1:	e8 96 02 00 00       	call   43c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
  }
  exit();
 1b8:	e8 57 02 00 00       	call   414 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f3:	8d 42 01             	lea    0x1(%edx),%eax
 1f6:	89 45 0c             	mov    %eax,0xc(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8d 48 01             	lea    0x1(%eax),%ecx
 1ff:	89 4d 08             	mov    %ecx,0x8(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave
 212:	c3                   	ret

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret

00000252 <strlen>:

uint
strlen(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave
 278:	c3                   	ret

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	push   0xc(%ebp)
 283:	ff 75 08             	push   0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave
 292:	c3                   	ret

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave
 2c5:	c3                   	ret

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 47 01 00 00       	call   42c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 320:	7f b3                	jg     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
      break;
 324:	90                   	nop
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave
 334:	c3                   	ret

00000335 <stat>:

int
stat(const char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	push   0x8(%ebp)
 343:	e8 0c 01 00 00       	call   454 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	push   0xc(%ebp)
 361:	ff 75 f4             	push   -0xc(%ebp)
 364:	e8 03 01 00 00       	call   46c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	push   -0xc(%ebp)
 375:	e8 c2 00 00 00       	call   43c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave
 381:	c3                   	ret

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave
 3ce:	c3                   	ret

000003cf <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e6:	8d 42 01             	lea    0x1(%edx),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ef:	8d 48 01             	lea    0x1(%eax),%ecx
 3f2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave
 40b:	c3                   	ret

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret

000004b4 <clone>:

SYSCALL(clone)
 4b4:	b8 16 00 00 00       	mov    $0x16,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret

000004bc <join>:
SYSCALL(join)
 4bc:	b8 17 00 00 00       	mov    $0x17,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret

000004c4 <thread_exit>:
SYSCALL(thread_exit)
 4c4:	b8 18 00 00 00       	mov    $0x18,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret

000004cc <randconfig>:
SYSCALL(randconfig)
 4cc:	b8 19 00 00 00       	mov    $0x19,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret

000004d4 <yield>:
SYSCALL(yield)
 4d4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret

000004dc <lock_create>:
SYSCALL(lock_create)
 4dc:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret

000004e4 <lock_acquire>:
SYSCALL(lock_acquire)
 4e4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret

000004ec <lock_release>:
SYSCALL(lock_release)
 4ec:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret

000004f4 <sem_create>:
SYSCALL(sem_create)
 4f4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret

000004fc <sem_wait>:
SYSCALL(sem_wait)
 4fc:	b8 1f 00 00 00       	mov    $0x1f,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret

00000504 <sem_post>:
SYSCALL(sem_post)
 504:	b8 20 00 00 00       	mov    $0x20,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret

0000050c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 18             	sub    $0x18,%esp
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 518:	83 ec 04             	sub    $0x4,%esp
 51b:	6a 01                	push   $0x1
 51d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 520:	50                   	push   %eax
 521:	ff 75 08             	push   0x8(%ebp)
 524:	e8 0b ff ff ff       	call   434 <write>
 529:	83 c4 10             	add    $0x10,%esp
}
 52c:	90                   	nop
 52d:	c9                   	leave
 52e:	c3                   	ret

0000052f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 53c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 540:	74 17                	je     559 <printint+0x2a>
 542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 546:	79 11                	jns    559 <printint+0x2a>
    neg = 1;
 548:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 54f:	8b 45 0c             	mov    0xc(%ebp),%eax
 552:	f7 d8                	neg    %eax
 554:	89 45 ec             	mov    %eax,-0x14(%ebp)
 557:	eb 06                	jmp    55f <printint+0x30>
  } else {
    x = xx;
 559:	8b 45 0c             	mov    0xc(%ebp),%eax
 55c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 55f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 566:	8b 4d 10             	mov    0x10(%ebp),%ecx
 569:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56c:	ba 00 00 00 00       	mov    $0x0,%edx
 571:	f7 f1                	div    %ecx
 573:	89 d1                	mov    %edx,%ecx
 575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 578:	8d 50 01             	lea    0x1(%eax),%edx
 57b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 57e:	0f b6 91 a0 0f 00 00 	movzbl 0xfa0(%ecx),%edx
 585:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 589:	8b 4d 10             	mov    0x10(%ebp),%ecx
 58c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58f:	ba 00 00 00 00       	mov    $0x0,%edx
 594:	f7 f1                	div    %ecx
 596:	89 45 ec             	mov    %eax,-0x14(%ebp)
 599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59d:	75 c7                	jne    566 <printint+0x37>
  if(neg)
 59f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a3:	74 2d                	je     5d2 <printint+0xa3>
    buf[i++] = '-';
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	8d 50 01             	lea    0x1(%eax),%edx
 5ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ae:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5b3:	eb 1d                	jmp    5d2 <printint+0xa3>
    putc(fd, buf[i]);
 5b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	01 d0                	add    %edx,%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	83 ec 08             	sub    $0x8,%esp
 5c6:	50                   	push   %eax
 5c7:	ff 75 08             	push   0x8(%ebp)
 5ca:	e8 3d ff ff ff       	call   50c <putc>
 5cf:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5da:	79 d9                	jns    5b5 <printint+0x86>
}
 5dc:	90                   	nop
 5dd:	90                   	nop
 5de:	c9                   	leave
 5df:	c3                   	ret

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f0:	83 c0 04             	add    $0x4,%eax
 5f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5fd:	e9 59 01 00 00       	jmp    75b <printf+0x17b>
    c = fmt[i] & 0xff;
 602:	8b 55 0c             	mov    0xc(%ebp),%edx
 605:	8b 45 f0             	mov    -0x10(%ebp),%eax
 608:	01 d0                	add    %edx,%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	25 ff 00 00 00       	and    $0xff,%eax
 615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 618:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61c:	75 2c                	jne    64a <printf+0x6a>
      if(c == '%'){
 61e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 622:	75 0c                	jne    630 <printf+0x50>
        state = '%';
 624:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 62b:	e9 27 01 00 00       	jmp    757 <printf+0x177>
      } else {
        putc(fd, c);
 630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	push   0x8(%ebp)
 63d:	e8 ca fe ff ff       	call   50c <putc>
 642:	83 c4 10             	add    $0x10,%esp
 645:	e9 0d 01 00 00       	jmp    757 <printf+0x177>
      }
    } else if(state == '%'){
 64a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 64e:	0f 85 03 01 00 00    	jne    757 <printf+0x177>
      if(c == 'd'){
 654:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 658:	75 1e                	jne    678 <printf+0x98>
        printint(fd, *ap, 10, 1);
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	6a 01                	push   $0x1
 661:	6a 0a                	push   $0xa
 663:	50                   	push   %eax
 664:	ff 75 08             	push   0x8(%ebp)
 667:	e8 c3 fe ff ff       	call   52f <printint>
 66c:	83 c4 10             	add    $0x10,%esp
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 673:	e9 d8 00 00 00       	jmp    750 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 678:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 67c:	74 06                	je     684 <printf+0xa4>
 67e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 682:	75 1e                	jne    6a2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 684:	8b 45 e8             	mov    -0x18(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	6a 00                	push   $0x0
 68b:	6a 10                	push   $0x10
 68d:	50                   	push   %eax
 68e:	ff 75 08             	push   0x8(%ebp)
 691:	e8 99 fe ff ff       	call   52f <printint>
 696:	83 c4 10             	add    $0x10,%esp
        ap++;
 699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69d:	e9 ae 00 00 00       	jmp    750 <printf+0x170>
      } else if(c == 's'){
 6a2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a6:	75 43                	jne    6eb <printf+0x10b>
        s = (char*)*ap;
 6a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b8:	75 25                	jne    6df <printf+0xff>
          s = "(null)";
 6ba:	c7 45 f4 d6 0b 00 00 	movl   $0xbd6,-0xc(%ebp)
        while(*s != 0){
 6c1:	eb 1c                	jmp    6df <printf+0xff>
          putc(fd, *s);
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	0f b6 00             	movzbl (%eax),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	50                   	push   %eax
 6d0:	ff 75 08             	push   0x8(%ebp)
 6d3:	e8 34 fe ff ff       	call   50c <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
          s++;
 6db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	84 c0                	test   %al,%al
 6e7:	75 da                	jne    6c3 <printf+0xe3>
 6e9:	eb 65                	jmp    750 <printf+0x170>
        }
      } else if(c == 'c'){
 6eb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ef:	75 1d                	jne    70e <printf+0x12e>
        putc(fd, *ap);
 6f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	push   0x8(%ebp)
 700:	e8 07 fe ff ff       	call   50c <putc>
 705:	83 c4 10             	add    $0x10,%esp
        ap++;
 708:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70c:	eb 42                	jmp    750 <printf+0x170>
      } else if(c == '%'){
 70e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 712:	75 17                	jne    72b <printf+0x14b>
        putc(fd, c);
 714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 717:	0f be c0             	movsbl %al,%eax
 71a:	83 ec 08             	sub    $0x8,%esp
 71d:	50                   	push   %eax
 71e:	ff 75 08             	push   0x8(%ebp)
 721:	e8 e6 fd ff ff       	call   50c <putc>
 726:	83 c4 10             	add    $0x10,%esp
 729:	eb 25                	jmp    750 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72b:	83 ec 08             	sub    $0x8,%esp
 72e:	6a 25                	push   $0x25
 730:	ff 75 08             	push   0x8(%ebp)
 733:	e8 d4 fd ff ff       	call   50c <putc>
 738:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 73b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73e:	0f be c0             	movsbl %al,%eax
 741:	83 ec 08             	sub    $0x8,%esp
 744:	50                   	push   %eax
 745:	ff 75 08             	push   0x8(%ebp)
 748:	e8 bf fd ff ff       	call   50c <putc>
 74d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 750:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 757:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 75b:	8b 55 0c             	mov    0xc(%ebp),%edx
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	01 d0                	add    %edx,%eax
 763:	0f b6 00             	movzbl (%eax),%eax
 766:	84 c0                	test   %al,%al
 768:	0f 85 94 fe ff ff    	jne    602 <printf+0x22>
    }
  }
}
 76e:	90                   	nop
 76f:	90                   	nop
 770:	c9                   	leave
 771:	c3                   	ret

00000772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 772:	55                   	push   %ebp
 773:	89 e5                	mov    %esp,%ebp
 775:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 778:	8b 45 08             	mov    0x8(%ebp),%eax
 77b:	83 e8 08             	sub    $0x8,%eax
 77e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 781:	a1 c8 11 00 00       	mov    0x11c8,%eax
 786:	89 45 fc             	mov    %eax,-0x4(%ebp)
 789:	eb 24                	jmp    7af <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 793:	72 12                	jb     7a7 <free+0x35>
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 79b:	72 24                	jb     7c1 <free+0x4f>
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7a5:	72 1a                	jb     7c1 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7b5:	73 d4                	jae    78b <free+0x19>
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7bf:	73 ca                	jae    78b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	01 c2                	add    %eax,%edx
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	39 c2                	cmp    %eax,%edx
 7da:	75 24                	jne    800 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	8b 50 04             	mov    0x4(%eax),%edx
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	01 c2                	add    %eax,%edx
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	8b 10                	mov    (%eax),%edx
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	89 10                	mov    %edx,(%eax)
 7fe:	eb 0a                	jmp    80a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	01 d0                	add    %edx,%eax
 81c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 81f:	75 20                	jne    841 <free+0xcf>
    p->s.size += bp->s.size;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 50 04             	mov    0x4(%eax),%edx
 827:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	01 c2                	add    %eax,%edx
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 835:	8b 45 f8             	mov    -0x8(%ebp),%eax
 838:	8b 10                	mov    (%eax),%edx
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	89 10                	mov    %edx,(%eax)
 83f:	eb 08                	jmp    849 <free+0xd7>
  } else
    p->s.ptr = bp;
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 55 f8             	mov    -0x8(%ebp),%edx
 847:	89 10                	mov    %edx,(%eax)
  freep = p;
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	a3 c8 11 00 00       	mov    %eax,0x11c8
}
 851:	90                   	nop
 852:	c9                   	leave
 853:	c3                   	ret

00000854 <morecore>:

static Header*
morecore(uint nu)
{
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 861:	77 07                	ja     86a <morecore+0x16>
    nu = 4096;
 863:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	c1 e0 03             	shl    $0x3,%eax
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	50                   	push   %eax
 874:	e8 23 fc ff ff       	call   49c <sbrk>
 879:	83 c4 10             	add    $0x10,%esp
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 87f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 883:	75 07                	jne    88c <morecore+0x38>
    return 0;
 885:	b8 00 00 00 00       	mov    $0x0,%eax
 88a:	eb 26                	jmp    8b2 <morecore+0x5e>
  hp = (Header*)p;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	8b 55 08             	mov    0x8(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	83 ec 0c             	sub    $0xc,%esp
 8a4:	50                   	push   %eax
 8a5:	e8 c8 fe ff ff       	call   772 <free>
 8aa:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ad:	a1 c8 11 00 00       	mov    0x11c8,%eax
}
 8b2:	c9                   	leave
 8b3:	c3                   	ret

000008b4 <malloc>:

void*
malloc(uint nbytes)
{
 8b4:	55                   	push   %ebp
 8b5:	89 e5                	mov    %esp,%ebp
 8b7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	8b 45 08             	mov    0x8(%ebp),%eax
 8bd:	83 c0 07             	add    $0x7,%eax
 8c0:	c1 e8 03             	shr    $0x3,%eax
 8c3:	83 c0 01             	add    $0x1,%eax
 8c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c9:	a1 c8 11 00 00       	mov    0x11c8,%eax
 8ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d5:	75 23                	jne    8fa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d7:	c7 45 f0 c0 11 00 00 	movl   $0x11c0,-0x10(%ebp)
 8de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e1:	a3 c8 11 00 00       	mov    %eax,0x11c8
 8e6:	a1 c8 11 00 00       	mov    0x11c8,%eax
 8eb:	a3 c0 11 00 00       	mov    %eax,0x11c0
    base.s.size = 0;
 8f0:	c7 05 c4 11 00 00 00 	movl   $0x0,0x11c4
 8f7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 90b:	72 4d                	jb     95a <malloc+0xa6>
      if(p->s.size == nunits)
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	8b 40 04             	mov    0x4(%eax),%eax
 913:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 916:	75 0c                	jne    924 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 10                	mov    (%eax),%edx
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	89 10                	mov    %edx,(%eax)
 922:	eb 26                	jmp    94a <malloc+0x96>
      else {
        p->s.size -= nunits;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 92d:	89 c2                	mov    %eax,%edx
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	c1 e0 03             	shl    $0x3,%eax
 93e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 55 ec             	mov    -0x14(%ebp),%edx
 947:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 94a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94d:	a3 c8 11 00 00       	mov    %eax,0x11c8
      return (void*)(p + 1);
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	83 c0 08             	add    $0x8,%eax
 958:	eb 3b                	jmp    995 <malloc+0xe1>
    }
    if(p == freep)
 95a:	a1 c8 11 00 00       	mov    0x11c8,%eax
 95f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 962:	75 1e                	jne    982 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 964:	83 ec 0c             	sub    $0xc,%esp
 967:	ff 75 ec             	push   -0x14(%ebp)
 96a:	e8 e5 fe ff ff       	call   854 <morecore>
 96f:	83 c4 10             	add    $0x10,%esp
 972:	89 45 f4             	mov    %eax,-0xc(%ebp)
 975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 979:	75 07                	jne    982 <malloc+0xce>
        return 0;
 97b:	b8 00 00 00 00       	mov    $0x0,%eax
 980:	eb 13                	jmp    995 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	8b 45 f4             	mov    -0xc(%ebp),%eax
 985:	89 45 f0             	mov    %eax,-0x10(%ebp)
 988:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 990:	e9 6d ff ff ff       	jmp    902 <malloc+0x4e>
  }
}
 995:	c9                   	leave
 996:	c3                   	ret

00000997 <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 997:	55                   	push   %ebp
 998:	89 e5                	mov    %esp,%ebp
 99a:	83 ec 18             	sub    $0x18,%esp
 99d:	8b 45 08             	mov    0x8(%ebp),%eax
 9a0:	8b 50 04             	mov    0x4(%eax),%edx
 9a3:	8b 00                	mov    (%eax),%eax
 9a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9b1:	83 ec 0c             	sub    $0xc,%esp
 9b4:	52                   	push   %edx
 9b5:	ff d0                	call   *%eax
 9b7:	83 c4 10             	add    $0x10,%esp
 9ba:	e8 05 fb ff ff       	call   4c4 <thread_exit>

000009bf <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 9bf:	55                   	push   %ebp
 9c0:	89 e5                	mov    %esp,%ebp
 9c2:	83 ec 18             	sub    $0x18,%esp
 9c5:	83 ec 0c             	sub    $0xc,%esp
 9c8:	68 00 20 00 00       	push   $0x2000
 9cd:	e8 e2 fe ff ff       	call   8b4 <malloc>
 9d2:	83 c4 10             	add    $0x10,%esp
 9d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9dc:	75 0a                	jne    9e8 <pthread_create+0x29>
 9de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9e3:	e9 9b 00 00 00       	jmp    a83 <pthread_create+0xc4>
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	05 ff 0f 00 00       	add    $0xfff,%eax
 9f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 9f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f8:	83 ec 0c             	sub    $0xc,%esp
 9fb:	6a 08                	push   $0x8
 9fd:	e8 b2 fe ff ff       	call   8b4 <malloc>
 a02:	83 c4 10             	add    $0x10,%esp
 a05:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a0c:	75 15                	jne    a23 <pthread_create+0x64>
 a0e:	83 ec 0c             	sub    $0xc,%esp
 a11:	ff 75 f4             	push   -0xc(%ebp)
 a14:	e8 59 fd ff ff       	call   772 <free>
 a19:	83 c4 10             	add    $0x10,%esp
 a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a21:	eb 60                	jmp    a83 <pthread_create+0xc4>
 a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a26:	8b 55 10             	mov    0x10(%ebp),%edx
 a29:	89 10                	mov    %edx,(%eax)
 a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a2e:	8b 55 14             	mov    0x14(%ebp),%edx
 a31:	89 50 04             	mov    %edx,0x4(%eax)
 a34:	83 ec 04             	sub    $0x4,%esp
 a37:	ff 75 f0             	push   -0x10(%ebp)
 a3a:	ff 75 ec             	push   -0x14(%ebp)
 a3d:	68 97 09 00 00       	push   $0x997
 a42:	e8 6d fa ff ff       	call   4b4 <clone>
 a47:	83 c4 10             	add    $0x10,%esp
 a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 a4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 a51:	79 23                	jns    a76 <pthread_create+0xb7>
 a53:	83 ec 0c             	sub    $0xc,%esp
 a56:	ff 75 ec             	push   -0x14(%ebp)
 a59:	e8 14 fd ff ff       	call   772 <free>
 a5e:	83 c4 10             	add    $0x10,%esp
 a61:	83 ec 0c             	sub    $0xc,%esp
 a64:	ff 75 f4             	push   -0xc(%ebp)
 a67:	e8 06 fd ff ff       	call   772 <free>
 a6c:	83 c4 10             	add    $0x10,%esp
 a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a74:	eb 0d                	jmp    a83 <pthread_create+0xc4>
 a76:	8b 45 08             	mov    0x8(%ebp),%eax
 a79:	8b 55 e8             	mov    -0x18(%ebp),%edx
 a7c:	89 10                	mov    %edx,(%eax)
 a7e:	b8 00 00 00 00       	mov    $0x0,%eax
 a83:	c9                   	leave
 a84:	c3                   	ret

00000a85 <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 a85:	55                   	push   %ebp
 a86:	89 e5                	mov    %esp,%ebp
 a88:	83 ec 18             	sub    $0x18,%esp
 a8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a92:	83 ec 08             	sub    $0x8,%esp
 a95:	8d 45 f0             	lea    -0x10(%ebp),%eax
 a98:	50                   	push   %eax
 a99:	ff 75 08             	push   0x8(%ebp)
 a9c:	e8 1b fa ff ff       	call   4bc <join>
 aa1:	83 c4 10             	add    $0x10,%esp
 aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
 aad:	75 07                	jne    ab6 <pthread_join+0x31>
 aaf:	b8 00 00 00 00       	mov    $0x0,%eax
 ab4:	eb 05                	jmp    abb <pthread_join+0x36>
 ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 abb:	c9                   	leave
 abc:	c3                   	ret

00000abd <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 abd:	55                   	push   %ebp
 abe:	89 e5                	mov    %esp,%ebp
 ac0:	83 ec 08             	sub    $0x8,%esp
 ac3:	e8 fc f9 ff ff       	call   4c4 <thread_exit>

00000ac8 <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 ac8:	55                   	push   %ebp
 ac9:	89 e5                	mov    %esp,%ebp
 acb:	83 ec 08             	sub    $0x8,%esp
 ace:	e8 09 fa ff ff       	call   4dc <lock_create>
 ad3:	8b 55 08             	mov    0x8(%ebp),%edx
 ad6:	89 02                	mov    %eax,(%edx)
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	85 c0                	test   %eax,%eax
 adf:	79 07                	jns    ae8 <pthread_mutex_init+0x20>
 ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ae6:	eb 05                	jmp    aed <pthread_mutex_init+0x25>
 ae8:	b8 00 00 00 00       	mov    $0x0,%eax
 aed:	c9                   	leave
 aee:	c3                   	ret

00000aef <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 aef:	55                   	push   %ebp
 af0:	89 e5                	mov    %esp,%ebp
 af2:	83 ec 08             	sub    $0x8,%esp
 af5:	8b 45 08             	mov    0x8(%ebp),%eax
 af8:	8b 00                	mov    (%eax),%eax
 afa:	83 ec 0c             	sub    $0xc,%esp
 afd:	50                   	push   %eax
 afe:	e8 e1 f9 ff ff       	call   4e4 <lock_acquire>
 b03:	83 c4 10             	add    $0x10,%esp
 b06:	c9                   	leave
 b07:	c3                   	ret

00000b08 <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 b08:	55                   	push   %ebp
 b09:	89 e5                	mov    %esp,%ebp
 b0b:	83 ec 08             	sub    $0x8,%esp
 b0e:	8b 45 08             	mov    0x8(%ebp),%eax
 b11:	8b 00                	mov    (%eax),%eax
 b13:	83 ec 0c             	sub    $0xc,%esp
 b16:	50                   	push   %eax
 b17:	e8 d0 f9 ff ff       	call   4ec <lock_release>
 b1c:	83 c4 10             	add    $0x10,%esp
 b1f:	c9                   	leave
 b20:	c3                   	ret

00000b21 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 b21:	55                   	push   %ebp
 b22:	89 e5                	mov    %esp,%ebp
 b24:	83 ec 08             	sub    $0x8,%esp
 b27:	8b 45 10             	mov    0x10(%ebp),%eax
 b2a:	83 ec 0c             	sub    $0xc,%esp
 b2d:	50                   	push   %eax
 b2e:	e8 c1 f9 ff ff       	call   4f4 <sem_create>
 b33:	83 c4 10             	add    $0x10,%esp
 b36:	8b 55 08             	mov    0x8(%ebp),%edx
 b39:	89 02                	mov    %eax,(%edx)
 b3b:	8b 45 08             	mov    0x8(%ebp),%eax
 b3e:	8b 00                	mov    (%eax),%eax
 b40:	85 c0                	test   %eax,%eax
 b42:	79 07                	jns    b4b <sem_init+0x2a>
 b44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b49:	eb 05                	jmp    b50 <sem_init+0x2f>
 b4b:	b8 00 00 00 00       	mov    $0x0,%eax
 b50:	c9                   	leave
 b51:	c3                   	ret

00000b52 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 b52:	55                   	push   %ebp
 b53:	89 e5                	mov    %esp,%ebp
 b55:	83 ec 08             	sub    $0x8,%esp
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	8b 00                	mov    (%eax),%eax
 b5d:	83 ec 0c             	sub    $0xc,%esp
 b60:	50                   	push   %eax
 b61:	e8 96 f9 ff ff       	call   4fc <sem_wait>
 b66:	83 c4 10             	add    $0x10,%esp
 b69:	c9                   	leave
 b6a:	c3                   	ret

00000b6b <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 b6b:	55                   	push   %ebp
 b6c:	89 e5                	mov    %esp,%ebp
 b6e:	83 ec 08             	sub    $0x8,%esp
 b71:	8b 45 08             	mov    0x8(%ebp),%eax
 b74:	8b 00                	mov    (%eax),%eax
 b76:	83 ec 0c             	sub    $0xc,%esp
 b79:	50                   	push   %eax
 b7a:	e8 85 f9 ff ff       	call   504 <sem_post>
 b7f:	83 c4 10             	add    $0x10,%esp
 b82:	c9                   	leave
 b83:	c3                   	ret

00000b84 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 b84:	55                   	push   %ebp
 b85:	89 e5                	mov    %esp,%ebp
 b87:	83 ec 08             	sub    $0x8,%esp
 b8a:	83 ec 08             	sub    $0x8,%esp
 b8d:	ff 75 0c             	push   0xc(%ebp)
 b90:	ff 75 08             	push   0x8(%ebp)
 b93:	e8 34 f9 ff ff       	call   4cc <randconfig>
 b98:	83 c4 10             	add    $0x10,%esp
 b9b:	90                   	nop
 b9c:	c9                   	leave
 b9d:	c3                   	ret
