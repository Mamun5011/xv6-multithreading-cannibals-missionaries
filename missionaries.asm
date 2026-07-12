
_missionaries:     file format elf32-i386


Disassembly of section .text:

00000000 <try_form_boat>:
static sem_t mpermit, cpermit;
static int waiting_m, waiting_c, boat_busy, boarded, boatno;
static int boat_m, boat_c;

static void try_form_boat(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int i;
  if(boat_busy) return;
   6:	a1 28 14 00 00       	mov    0x1428,%eax
   b:	85 c0                	test   %eax,%eax
   d:	0f 85 28 01 00 00    	jne    13b <try_form_boat+0x13b>
  boat_m=boat_c=0;
  13:	c7 05 38 14 00 00 00 	movl   $0x0,0x1438
  1a:	00 00 00 
  1d:	a1 38 14 00 00       	mov    0x1438,%eax
  22:	a3 34 14 00 00       	mov    %eax,0x1434
  // Prefer a mixed safe boat, then homogeneous boats.
  if(waiting_m>=2 && waiting_c>=1){ boat_m=2; boat_c=1; }
  27:	a1 20 14 00 00       	mov    0x1420,%eax
  2c:	83 f8 01             	cmp    $0x1,%eax
  2f:	7e 1f                	jle    50 <try_form_boat+0x50>
  31:	a1 24 14 00 00       	mov    0x1424,%eax
  36:	85 c0                	test   %eax,%eax
  38:	7e 16                	jle    50 <try_form_boat+0x50>
  3a:	c7 05 34 14 00 00 02 	movl   $0x2,0x1434
  41:	00 00 00 
  44:	c7 05 38 14 00 00 01 	movl   $0x1,0x1438
  4b:	00 00 00 
  4e:	eb 2e                	jmp    7e <try_form_boat+0x7e>
  else if(waiting_m>=3){ boat_m=3; }
  50:	a1 20 14 00 00       	mov    0x1420,%eax
  55:	83 f8 02             	cmp    $0x2,%eax
  58:	7e 0c                	jle    66 <try_form_boat+0x66>
  5a:	c7 05 34 14 00 00 03 	movl   $0x3,0x1434
  61:	00 00 00 
  64:	eb 18                	jmp    7e <try_form_boat+0x7e>
  else if(waiting_c>=3){ boat_c=3; }
  66:	a1 24 14 00 00       	mov    0x1424,%eax
  6b:	83 f8 02             	cmp    $0x2,%eax
  6e:	0f 8e ca 00 00 00    	jle    13e <try_form_boat+0x13e>
  74:	c7 05 38 14 00 00 03 	movl   $0x3,0x1438
  7b:	00 00 00 
  else return;
  waiting_m-=boat_m; waiting_c-=boat_c; boat_busy=1; boarded=0; boatno++;
  7e:	8b 15 20 14 00 00    	mov    0x1420,%edx
  84:	a1 34 14 00 00       	mov    0x1434,%eax
  89:	29 c2                	sub    %eax,%edx
  8b:	89 15 20 14 00 00    	mov    %edx,0x1420
  91:	8b 15 24 14 00 00    	mov    0x1424,%edx
  97:	a1 38 14 00 00       	mov    0x1438,%eax
  9c:	29 c2                	sub    %eax,%edx
  9e:	89 15 24 14 00 00    	mov    %edx,0x1424
  a4:	c7 05 28 14 00 00 01 	movl   $0x1,0x1428
  ab:	00 00 00 
  ae:	c7 05 2c 14 00 00 00 	movl   $0x0,0x142c
  b5:	00 00 00 
  b8:	a1 30 14 00 00       	mov    0x1430,%eax
  bd:	83 c0 01             	add    $0x1,%eax
  c0:	a3 30 14 00 00       	mov    %eax,0x1430
  printf(1,"boat %d selected: %d missionaries, %d cannibals\n",boatno,boat_m,boat_c);
  c5:	8b 0d 38 14 00 00    	mov    0x1438,%ecx
  cb:	8b 15 34 14 00 00    	mov    0x1434,%edx
  d1:	a1 30 14 00 00       	mov    0x1430,%eax
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	51                   	push   %ecx
  da:	52                   	push   %edx
  db:	50                   	push   %eax
  dc:	68 d0 0e 00 00       	push   $0xed0
  e1:	6a 01                	push   $0x1
  e3:	e8 29 08 00 00       	call   911 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
  for(i=0;i<boat_m;i++) sem_post_u(&mpermit);
  eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  f2:	eb 14                	jmp    108 <try_form_boat+0x108>
  f4:	83 ec 0c             	sub    $0xc,%esp
  f7:	68 18 14 00 00       	push   $0x1418
  fc:	e8 9b 0d 00 00       	call   e9c <sem_post_u>
 101:	83 c4 10             	add    $0x10,%esp
 104:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 108:	a1 34 14 00 00       	mov    0x1434,%eax
 10d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 110:	7c e2                	jl     f4 <try_form_boat+0xf4>
  for(i=0;i<boat_c;i++) sem_post_u(&cpermit);
 112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 119:	eb 14                	jmp    12f <try_form_boat+0x12f>
 11b:	83 ec 0c             	sub    $0xc,%esp
 11e:	68 1c 14 00 00       	push   $0x141c
 123:	e8 74 0d 00 00       	call   e9c <sem_post_u>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 12f:	a1 38 14 00 00       	mov    0x1438,%eax
 134:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 137:	7c e2                	jl     11b <try_form_boat+0x11b>
 139:	eb 04                	jmp    13f <try_form_boat+0x13f>
  if(boat_busy) return;
 13b:	90                   	nop
 13c:	eb 01                	jmp    13f <try_form_boat+0x13f>
  else return;
 13e:	90                   	nop
}
 13f:	c9                   	leave
 140:	c3                   	ret

00000141 <board>:

static void board(char kind, int id)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 28             	sub    $0x28,%esp
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 45 e4             	mov    %al,-0x1c(%ebp)
  int last=0, bm=0, bc=0, bn=0;
 14d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 154:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 15b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 162:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  pthread_mutex_lock(&mu);
 169:	83 ec 0c             	sub    $0xc,%esp
 16c:	68 14 14 00 00       	push   $0x1414
 171:	e8 aa 0c 00 00       	call   e20 <pthread_mutex_lock>
 176:	83 c4 10             	add    $0x10,%esp
  boarded++;
 179:	a1 2c 14 00 00       	mov    0x142c,%eax
 17e:	83 c0 01             	add    $0x1,%eax
 181:	a3 2c 14 00 00       	mov    %eax,0x142c
  printf(1,"  %c%d boarded boat %d (%d/3)\n",kind,id,boatno,boarded);
 186:	8b 0d 2c 14 00 00    	mov    0x142c,%ecx
 18c:	8b 15 30 14 00 00    	mov    0x1430,%edx
 192:	0f be 45 e4          	movsbl -0x1c(%ebp),%eax
 196:	83 ec 08             	sub    $0x8,%esp
 199:	51                   	push   %ecx
 19a:	52                   	push   %edx
 19b:	ff 75 0c             	push   0xc(%ebp)
 19e:	50                   	push   %eax
 19f:	68 04 0f 00 00       	push   $0xf04
 1a4:	6a 01                	push   $0x1
 1a6:	e8 66 07 00 00       	call   911 <printf>
 1ab:	83 c4 20             	add    $0x20,%esp
  if(boarded==3){ last=1; bm=boat_m; bc=boat_c; bn=boatno; }
 1ae:	a1 2c 14 00 00       	mov    0x142c,%eax
 1b3:	83 f8 03             	cmp    $0x3,%eax
 1b6:	75 1f                	jne    1d7 <board+0x96>
 1b8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 1bf:	a1 34 14 00 00       	mov    0x1434,%eax
 1c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 1c7:	a1 38 14 00 00       	mov    0x1438,%eax
 1cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1cf:	a1 30 14 00 00       	mov    0x1430,%eax
 1d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  pthread_mutex_unlock(&mu);
 1d7:	83 ec 0c             	sub    $0xc,%esp
 1da:	68 14 14 00 00       	push   $0x1414
 1df:	e8 55 0c 00 00       	call   e39 <pthread_mutex_unlock>
 1e4:	83 c4 10             	add    $0x10,%esp

  if(last){
 1e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1eb:	0f 84 81 00 00 00    	je     272 <board+0x131>
    // Only the third passenger rows. Each line is one write syscall, so
    // stochastic switching cannot split the line itself.
    printf(1,"ROW boat %d: M=%d C=%d SAFE=%s\n",bn,bm,bc,(bc==2&&bm==1)?"NO":"YES");
 1f1:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
 1f5:	75 0d                	jne    204 <board+0xc3>
 1f7:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
 1fb:	75 07                	jne    204 <board+0xc3>
 1fd:	b8 23 0f 00 00       	mov    $0xf23,%eax
 202:	eb 05                	jmp    209 <board+0xc8>
 204:	b8 26 0f 00 00       	mov    $0xf26,%eax
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	50                   	push   %eax
 20d:	ff 75 ec             	push   -0x14(%ebp)
 210:	ff 75 f0             	push   -0x10(%ebp)
 213:	ff 75 e8             	push   -0x18(%ebp)
 216:	68 2c 0f 00 00       	push   $0xf2c
 21b:	6a 01                	push   $0x1
 21d:	e8 ef 06 00 00       	call   911 <printf>
 222:	83 c4 20             	add    $0x20,%esp
    pthread_mutex_lock(&mu);
 225:	83 ec 0c             	sub    $0xc,%esp
 228:	68 14 14 00 00       	push   $0x1414
 22d:	e8 ee 0b 00 00       	call   e20 <pthread_mutex_lock>
 232:	83 c4 10             	add    $0x10,%esp
    boat_busy=0; boarded=0; boat_m=boat_c=0;
 235:	c7 05 28 14 00 00 00 	movl   $0x0,0x1428
 23c:	00 00 00 
 23f:	c7 05 2c 14 00 00 00 	movl   $0x0,0x142c
 246:	00 00 00 
 249:	c7 05 38 14 00 00 00 	movl   $0x0,0x1438
 250:	00 00 00 
 253:	a1 38 14 00 00       	mov    0x1438,%eax
 258:	a3 34 14 00 00       	mov    %eax,0x1434
    try_form_boat();
 25d:	e8 9e fd ff ff       	call   0 <try_form_boat>
    pthread_mutex_unlock(&mu);
 262:	83 ec 0c             	sub    $0xc,%esp
 265:	68 14 14 00 00       	push   $0x1414
 26a:	e8 ca 0b 00 00       	call   e39 <pthread_mutex_unlock>
 26f:	83 c4 10             	add    $0x10,%esp
  }
}
 272:	90                   	nop
 273:	c9                   	leave
 274:	c3                   	ret

00000275 <missionary>:

static void *missionary(void *x)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 18             	sub    $0x18,%esp
  int id=(int)x;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pthread_mutex_lock(&mu); waiting_m++; printf(1,"M%d arrives\n",id); try_form_boat(); pthread_mutex_unlock(&mu);
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	68 14 14 00 00       	push   $0x1414
 289:	e8 92 0b 00 00       	call   e20 <pthread_mutex_lock>
 28e:	83 c4 10             	add    $0x10,%esp
 291:	a1 20 14 00 00       	mov    0x1420,%eax
 296:	83 c0 01             	add    $0x1,%eax
 299:	a3 20 14 00 00       	mov    %eax,0x1420
 29e:	83 ec 04             	sub    $0x4,%esp
 2a1:	ff 75 f4             	push   -0xc(%ebp)
 2a4:	68 4c 0f 00 00       	push   $0xf4c
 2a9:	6a 01                	push   $0x1
 2ab:	e8 61 06 00 00       	call   911 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	e8 48 fd ff ff       	call   0 <try_form_boat>
 2b8:	83 ec 0c             	sub    $0xc,%esp
 2bb:	68 14 14 00 00       	push   $0x1414
 2c0:	e8 74 0b 00 00       	call   e39 <pthread_mutex_unlock>
 2c5:	83 c4 10             	add    $0x10,%esp
  sem_wait_u(&mpermit); board('M',id); return 0;
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	68 18 14 00 00       	push   $0x1418
 2d0:	e8 ae 0b 00 00       	call   e83 <sem_wait_u>
 2d5:	83 c4 10             	add    $0x10,%esp
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	ff 75 f4             	push   -0xc(%ebp)
 2de:	6a 4d                	push   $0x4d
 2e0:	e8 5c fe ff ff       	call   141 <board>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ed:	c9                   	leave
 2ee:	c3                   	ret

000002ef <cannibal>:

static void *cannibal(void *x)
{
 2ef:	55                   	push   %ebp
 2f0:	89 e5                	mov    %esp,%ebp
 2f2:	83 ec 18             	sub    $0x18,%esp
  int id=(int)x;
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pthread_mutex_lock(&mu); waiting_c++; printf(1,"C%d arrives\n",id); try_form_boat(); pthread_mutex_unlock(&mu);
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 14 14 00 00       	push   $0x1414
 303:	e8 18 0b 00 00       	call   e20 <pthread_mutex_lock>
 308:	83 c4 10             	add    $0x10,%esp
 30b:	a1 24 14 00 00       	mov    0x1424,%eax
 310:	83 c0 01             	add    $0x1,%eax
 313:	a3 24 14 00 00       	mov    %eax,0x1424
 318:	83 ec 04             	sub    $0x4,%esp
 31b:	ff 75 f4             	push   -0xc(%ebp)
 31e:	68 59 0f 00 00       	push   $0xf59
 323:	6a 01                	push   $0x1
 325:	e8 e7 05 00 00       	call   911 <printf>
 32a:	83 c4 10             	add    $0x10,%esp
 32d:	e8 ce fc ff ff       	call   0 <try_form_boat>
 332:	83 ec 0c             	sub    $0xc,%esp
 335:	68 14 14 00 00       	push   $0x1414
 33a:	e8 fa 0a 00 00       	call   e39 <pthread_mutex_unlock>
 33f:	83 c4 10             	add    $0x10,%esp
  sem_wait_u(&cpermit); board('C',id); return 0;
 342:	83 ec 0c             	sub    $0xc,%esp
 345:	68 1c 14 00 00       	push   $0x141c
 34a:	e8 34 0b 00 00       	call   e83 <sem_wait_u>
 34f:	83 c4 10             	add    $0x10,%esp
 352:	83 ec 08             	sub    $0x8,%esp
 355:	ff 75 f4             	push   -0xc(%ebp)
 358:	6a 43                	push   $0x43
 35a:	e8 e2 fd ff ff       	call   141 <board>
 35f:	83 c4 10             	add    $0x10,%esp
 362:	b8 00 00 00 00       	mov    $0x0,%eax
}
 367:	c9                   	leave
 368:	c3                   	ret

00000369 <main>:

int main(int argc, char **argv)
{
 369:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 36d:	83 e4 f0             	and    $0xfffffff0,%esp
 370:	ff 71 fc             	push   -0x4(%ecx)
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	53                   	push   %ebx
 377:	51                   	push   %ecx
 378:	83 ec 40             	sub    $0x40,%esp
 37b:	89 cb                	mov    %ecx,%ebx
  pthread_t tm[NM],tc[NC]; int i,seed=1,pct=35;
 37d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 384:	c7 45 ec 23 00 00 00 	movl   $0x23,-0x14(%ebp)
  if(argc>1) seed=atoi(argv[1]);
 38b:	83 3b 01             	cmpl   $0x1,(%ebx)
 38e:	7e 17                	jle    3a7 <main+0x3e>
 390:	8b 43 04             	mov    0x4(%ebx),%eax
 393:	83 c0 04             	add    $0x4,%eax
 396:	8b 00                	mov    (%eax),%eax
 398:	83 ec 0c             	sub    $0xc,%esp
 39b:	50                   	push   %eax
 39c:	e8 12 03 00 00       	call   6b3 <atoi>
 3a1:	83 c4 10             	add    $0x10,%esp
 3a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(argc>2) pct=atoi(argv[2]);
 3a7:	83 3b 02             	cmpl   $0x2,(%ebx)
 3aa:	7e 17                	jle    3c3 <main+0x5a>
 3ac:	8b 43 04             	mov    0x4(%ebx),%eax
 3af:	83 c0 08             	add    $0x8,%eax
 3b2:	8b 00                	mov    (%eax),%eax
 3b4:	83 ec 0c             	sub    $0xc,%esp
 3b7:	50                   	push   %eax
 3b8:	e8 f6 02 00 00       	call   6b3 <atoi>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pthread_mutex_init(&mu,0); sem_init(&mpermit,0,0); sem_init(&cpermit,0,0);
 3c3:	83 ec 08             	sub    $0x8,%esp
 3c6:	6a 00                	push   $0x0
 3c8:	68 14 14 00 00       	push   $0x1414
 3cd:	e8 27 0a 00 00       	call   df9 <pthread_mutex_init>
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	83 ec 04             	sub    $0x4,%esp
 3d8:	6a 00                	push   $0x0
 3da:	6a 00                	push   $0x0
 3dc:	68 18 14 00 00       	push   $0x1418
 3e1:	e8 6c 0a 00 00       	call   e52 <sem_init>
 3e6:	83 c4 10             	add    $0x10,%esp
 3e9:	83 ec 04             	sub    $0x4,%esp
 3ec:	6a 00                	push   $0x0
 3ee:	6a 00                	push   $0x0
 3f0:	68 1c 14 00 00       	push   $0x141c
 3f5:	e8 58 0a 00 00       	call   e52 <sem_init>
 3fa:	83 c4 10             	add    $0x10,%esp
  stochastic_schedule(seed,pct);
 3fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 400:	83 ec 08             	sub    $0x8,%esp
 403:	ff 75 ec             	push   -0x14(%ebp)
 406:	50                   	push   %eax
 407:	e8 a9 0a 00 00       	call   eb5 <stochastic_schedule>
 40c:	83 c4 10             	add    $0x10,%esp
  printf(1,"missionaries/cannibals: seed=%d stochastic-yield=%d%%\n",seed,pct);
 40f:	ff 75 ec             	push   -0x14(%ebp)
 412:	ff 75 f0             	push   -0x10(%ebp)
 415:	68 68 0f 00 00       	push   $0xf68
 41a:	6a 01                	push   $0x1
 41c:	e8 f0 04 00 00       	call   911 <printf>
 421:	83 c4 10             	add    $0x10,%esp
  // Deliberately interleave creation order; scheduler adds further variation.
  for(i=0;i<NM || i<NC;i++){
 424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 42b:	eb 4e                	jmp    47b <main+0x112>
    if(i<NC) pthread_create(&tc[i],0,cannibal,(void*)i);
 42d:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 431:	7f 1f                	jg     452 <main+0xe9>
 433:	8b 45 f4             	mov    -0xc(%ebp),%eax
 436:	8d 55 bc             	lea    -0x44(%ebp),%edx
 439:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 43c:	c1 e1 02             	shl    $0x2,%ecx
 43f:	01 ca                	add    %ecx,%edx
 441:	50                   	push   %eax
 442:	68 ef 02 00 00       	push   $0x2ef
 447:	6a 00                	push   $0x0
 449:	52                   	push   %edx
 44a:	e8 a1 08 00 00       	call   cf0 <pthread_create>
 44f:	83 c4 10             	add    $0x10,%esp
    if(i<NM) pthread_create(&tm[i],0,missionary,(void*)i);
 452:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 456:	7f 1f                	jg     477 <main+0x10e>
 458:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
 45e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 461:	c1 e1 02             	shl    $0x2,%ecx
 464:	01 ca                	add    %ecx,%edx
 466:	50                   	push   %eax
 467:	68 75 02 00 00       	push   $0x275
 46c:	6a 00                	push   $0x0
 46e:	52                   	push   %edx
 46f:	e8 7c 08 00 00       	call   cf0 <pthread_create>
 474:	83 c4 10             	add    $0x10,%esp
  for(i=0;i<NM || i<NC;i++){
 477:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 47b:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 47f:	7e ac                	jle    42d <main+0xc4>
 481:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 485:	7e a6                	jle    42d <main+0xc4>
  }
  for(i=0;i<NM;i++) pthread_join(tm[i],0);
 487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 48e:	eb 19                	jmp    4a9 <main+0x140>
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
 497:	83 ec 08             	sub    $0x8,%esp
 49a:	6a 00                	push   $0x0
 49c:	50                   	push   %eax
 49d:	e8 14 09 00 00       	call   db6 <pthread_join>
 4a2:	83 c4 10             	add    $0x10,%esp
 4a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4a9:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 4ad:	7e e1                	jle    490 <main+0x127>
  for(i=0;i<NC;i++) pthread_join(tc[i],0);
 4af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4b6:	eb 19                	jmp    4d1 <main+0x168>
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
 4bf:	83 ec 08             	sub    $0x8,%esp
 4c2:	6a 00                	push   $0x0
 4c4:	50                   	push   %eax
 4c5:	e8 ec 08 00 00       	call   db6 <pthread_join>
 4ca:	83 c4 10             	add    $0x10,%esp
 4cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4d1:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 4d5:	7e e1                	jle    4b8 <main+0x14f>
  printf(1,"PASS: all 12 passengers crossed in four safe full boats\n");
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	68 a0 0f 00 00       	push   $0xfa0
 4df:	6a 01                	push   $0x1
 4e1:	e8 2b 04 00 00       	call   911 <printf>
 4e6:	83 c4 10             	add    $0x10,%esp
  exit();
 4e9:	e8 57 02 00 00       	call   745 <exit>

000004ee <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
 4f1:	57                   	push   %edi
 4f2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 4f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4f6:	8b 55 10             	mov    0x10(%ebp),%edx
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	89 cb                	mov    %ecx,%ebx
 4fe:	89 df                	mov    %ebx,%edi
 500:	89 d1                	mov    %edx,%ecx
 502:	fc                   	cld
 503:	f3 aa                	rep stos %al,%es:(%edi)
 505:	89 ca                	mov    %ecx,%edx
 507:	89 fb                	mov    %edi,%ebx
 509:	89 5d 08             	mov    %ebx,0x8(%ebp)
 50c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 50f:	90                   	nop
 510:	5b                   	pop    %ebx
 511:	5f                   	pop    %edi
 512:	5d                   	pop    %ebp
 513:	c3                   	ret

00000514 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 520:	90                   	nop
 521:	8b 55 0c             	mov    0xc(%ebp),%edx
 524:	8d 42 01             	lea    0x1(%edx),%eax
 527:	89 45 0c             	mov    %eax,0xc(%ebp)
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	8d 48 01             	lea    0x1(%eax),%ecx
 530:	89 4d 08             	mov    %ecx,0x8(%ebp)
 533:	0f b6 12             	movzbl (%edx),%edx
 536:	88 10                	mov    %dl,(%eax)
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	84 c0                	test   %al,%al
 53d:	75 e2                	jne    521 <strcpy+0xd>
    ;
  return os;
 53f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 542:	c9                   	leave
 543:	c3                   	ret

00000544 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 547:	eb 08                	jmp    551 <strcmp+0xd>
    p++, q++;
 549:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 54d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	84 c0                	test   %al,%al
 559:	74 10                	je     56b <strcmp+0x27>
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	0f b6 10             	movzbl (%eax),%edx
 561:	8b 45 0c             	mov    0xc(%ebp),%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	38 c2                	cmp    %al,%dl
 569:	74 de                	je     549 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f b6 d0             	movzbl %al,%edx
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	0f b6 c0             	movzbl %al,%eax
 57d:	29 c2                	sub    %eax,%edx
 57f:	89 d0                	mov    %edx,%eax
}
 581:	5d                   	pop    %ebp
 582:	c3                   	ret

00000583 <strlen>:

uint
strlen(const char *s)
{
 583:	55                   	push   %ebp
 584:	89 e5                	mov    %esp,%ebp
 586:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 589:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 590:	eb 04                	jmp    596 <strlen+0x13>
 592:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 596:	8b 55 fc             	mov    -0x4(%ebp),%edx
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	01 d0                	add    %edx,%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	84 c0                	test   %al,%al
 5a3:	75 ed                	jne    592 <strlen+0xf>
    ;
  return n;
 5a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5a8:	c9                   	leave
 5a9:	c3                   	ret

000005aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 5aa:	55                   	push   %ebp
 5ab:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 5ad:	8b 45 10             	mov    0x10(%ebp),%eax
 5b0:	50                   	push   %eax
 5b1:	ff 75 0c             	push   0xc(%ebp)
 5b4:	ff 75 08             	push   0x8(%ebp)
 5b7:	e8 32 ff ff ff       	call   4ee <stosb>
 5bc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c2:	c9                   	leave
 5c3:	c3                   	ret

000005c4 <strchr>:

char*
strchr(const char *s, char c)
{
 5c4:	55                   	push   %ebp
 5c5:	89 e5                	mov    %esp,%ebp
 5c7:	83 ec 04             	sub    $0x4,%esp
 5ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5d0:	eb 14                	jmp    5e6 <strchr+0x22>
    if(*s == c)
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	38 45 fc             	cmp    %al,-0x4(%ebp)
 5db:	75 05                	jne    5e2 <strchr+0x1e>
      return (char*)s;
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	eb 13                	jmp    5f5 <strchr+0x31>
  for(; *s; s++)
 5e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	0f b6 00             	movzbl (%eax),%eax
 5ec:	84 c0                	test   %al,%al
 5ee:	75 e2                	jne    5d2 <strchr+0xe>
  return 0;
 5f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5f5:	c9                   	leave
 5f6:	c3                   	ret

000005f7 <gets>:

char*
gets(char *buf, int max)
{
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 604:	eb 42                	jmp    648 <gets+0x51>
    cc = read(0, &c, 1);
 606:	83 ec 04             	sub    $0x4,%esp
 609:	6a 01                	push   $0x1
 60b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 60e:	50                   	push   %eax
 60f:	6a 00                	push   $0x0
 611:	e8 47 01 00 00       	call   75d <read>
 616:	83 c4 10             	add    $0x10,%esp
 619:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 61c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 620:	7e 33                	jle    655 <gets+0x5e>
      break;
    buf[i++] = c;
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	8d 50 01             	lea    0x1(%eax),%edx
 628:	89 55 f4             	mov    %edx,-0xc(%ebp)
 62b:	89 c2                	mov    %eax,%edx
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	01 c2                	add    %eax,%edx
 632:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 636:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 638:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 63c:	3c 0a                	cmp    $0xa,%al
 63e:	74 16                	je     656 <gets+0x5f>
 640:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 644:	3c 0d                	cmp    $0xd,%al
 646:	74 0e                	je     656 <gets+0x5f>
  for(i=0; i+1 < max; ){
 648:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64b:	83 c0 01             	add    $0x1,%eax
 64e:	39 45 0c             	cmp    %eax,0xc(%ebp)
 651:	7f b3                	jg     606 <gets+0xf>
 653:	eb 01                	jmp    656 <gets+0x5f>
      break;
 655:	90                   	nop
      break;
  }
  buf[i] = '\0';
 656:	8b 55 f4             	mov    -0xc(%ebp),%edx
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	01 d0                	add    %edx,%eax
 65e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
}
 664:	c9                   	leave
 665:	c3                   	ret

00000666 <stat>:

int
stat(const char *n, struct stat *st)
{
 666:	55                   	push   %ebp
 667:	89 e5                	mov    %esp,%ebp
 669:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	6a 00                	push   $0x0
 671:	ff 75 08             	push   0x8(%ebp)
 674:	e8 0c 01 00 00       	call   785 <open>
 679:	83 c4 10             	add    $0x10,%esp
 67c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 67f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 683:	79 07                	jns    68c <stat+0x26>
    return -1;
 685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 68a:	eb 25                	jmp    6b1 <stat+0x4b>
  r = fstat(fd, st);
 68c:	83 ec 08             	sub    $0x8,%esp
 68f:	ff 75 0c             	push   0xc(%ebp)
 692:	ff 75 f4             	push   -0xc(%ebp)
 695:	e8 03 01 00 00       	call   79d <fstat>
 69a:	83 c4 10             	add    $0x10,%esp
 69d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	ff 75 f4             	push   -0xc(%ebp)
 6a6:	e8 c2 00 00 00       	call   76d <close>
 6ab:	83 c4 10             	add    $0x10,%esp
  return r;
 6ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6b1:	c9                   	leave
 6b2:	c3                   	ret

000006b3 <atoi>:

int
atoi(const char *s)
{
 6b3:	55                   	push   %ebp
 6b4:	89 e5                	mov    %esp,%ebp
 6b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6c0:	eb 25                	jmp    6e7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 6c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6c5:	89 d0                	mov    %edx,%eax
 6c7:	c1 e0 02             	shl    $0x2,%eax
 6ca:	01 d0                	add    %edx,%eax
 6cc:	01 c0                	add    %eax,%eax
 6ce:	89 c1                	mov    %eax,%ecx
 6d0:	8b 45 08             	mov    0x8(%ebp),%eax
 6d3:	8d 50 01             	lea    0x1(%eax),%edx
 6d6:	89 55 08             	mov    %edx,0x8(%ebp)
 6d9:	0f b6 00             	movzbl (%eax),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	01 c8                	add    %ecx,%eax
 6e1:	83 e8 30             	sub    $0x30,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	3c 2f                	cmp    $0x2f,%al
 6ef:	7e 0a                	jle    6fb <atoi+0x48>
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	3c 39                	cmp    $0x39,%al
 6f9:	7e c7                	jle    6c2 <atoi+0xf>
  return n;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6fe:	c9                   	leave
 6ff:	c3                   	ret

00000700 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 70c:	8b 45 0c             	mov    0xc(%ebp),%eax
 70f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 712:	eb 17                	jmp    72b <memmove+0x2b>
    *dst++ = *src++;
 714:	8b 55 f8             	mov    -0x8(%ebp),%edx
 717:	8d 42 01             	lea    0x1(%edx),%eax
 71a:	89 45 f8             	mov    %eax,-0x8(%ebp)
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8d 48 01             	lea    0x1(%eax),%ecx
 723:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 726:	0f b6 12             	movzbl (%edx),%edx
 729:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 72b:	8b 45 10             	mov    0x10(%ebp),%eax
 72e:	8d 50 ff             	lea    -0x1(%eax),%edx
 731:	89 55 10             	mov    %edx,0x10(%ebp)
 734:	85 c0                	test   %eax,%eax
 736:	7f dc                	jg     714 <memmove+0x14>
  return vdst;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
}
 73b:	c9                   	leave
 73c:	c3                   	ret

0000073d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 73d:	b8 01 00 00 00       	mov    $0x1,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret

00000745 <exit>:
SYSCALL(exit)
 745:	b8 02 00 00 00       	mov    $0x2,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret

0000074d <wait>:
SYSCALL(wait)
 74d:	b8 03 00 00 00       	mov    $0x3,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret

00000755 <pipe>:
SYSCALL(pipe)
 755:	b8 04 00 00 00       	mov    $0x4,%eax
 75a:	cd 40                	int    $0x40
 75c:	c3                   	ret

0000075d <read>:
SYSCALL(read)
 75d:	b8 05 00 00 00       	mov    $0x5,%eax
 762:	cd 40                	int    $0x40
 764:	c3                   	ret

00000765 <write>:
SYSCALL(write)
 765:	b8 10 00 00 00       	mov    $0x10,%eax
 76a:	cd 40                	int    $0x40
 76c:	c3                   	ret

0000076d <close>:
SYSCALL(close)
 76d:	b8 15 00 00 00       	mov    $0x15,%eax
 772:	cd 40                	int    $0x40
 774:	c3                   	ret

00000775 <kill>:
SYSCALL(kill)
 775:	b8 06 00 00 00       	mov    $0x6,%eax
 77a:	cd 40                	int    $0x40
 77c:	c3                   	ret

0000077d <exec>:
SYSCALL(exec)
 77d:	b8 07 00 00 00       	mov    $0x7,%eax
 782:	cd 40                	int    $0x40
 784:	c3                   	ret

00000785 <open>:
SYSCALL(open)
 785:	b8 0f 00 00 00       	mov    $0xf,%eax
 78a:	cd 40                	int    $0x40
 78c:	c3                   	ret

0000078d <mknod>:
SYSCALL(mknod)
 78d:	b8 11 00 00 00       	mov    $0x11,%eax
 792:	cd 40                	int    $0x40
 794:	c3                   	ret

00000795 <unlink>:
SYSCALL(unlink)
 795:	b8 12 00 00 00       	mov    $0x12,%eax
 79a:	cd 40                	int    $0x40
 79c:	c3                   	ret

0000079d <fstat>:
SYSCALL(fstat)
 79d:	b8 08 00 00 00       	mov    $0x8,%eax
 7a2:	cd 40                	int    $0x40
 7a4:	c3                   	ret

000007a5 <link>:
SYSCALL(link)
 7a5:	b8 13 00 00 00       	mov    $0x13,%eax
 7aa:	cd 40                	int    $0x40
 7ac:	c3                   	ret

000007ad <mkdir>:
SYSCALL(mkdir)
 7ad:	b8 14 00 00 00       	mov    $0x14,%eax
 7b2:	cd 40                	int    $0x40
 7b4:	c3                   	ret

000007b5 <chdir>:
SYSCALL(chdir)
 7b5:	b8 09 00 00 00       	mov    $0x9,%eax
 7ba:	cd 40                	int    $0x40
 7bc:	c3                   	ret

000007bd <dup>:
SYSCALL(dup)
 7bd:	b8 0a 00 00 00       	mov    $0xa,%eax
 7c2:	cd 40                	int    $0x40
 7c4:	c3                   	ret

000007c5 <getpid>:
SYSCALL(getpid)
 7c5:	b8 0b 00 00 00       	mov    $0xb,%eax
 7ca:	cd 40                	int    $0x40
 7cc:	c3                   	ret

000007cd <sbrk>:
SYSCALL(sbrk)
 7cd:	b8 0c 00 00 00       	mov    $0xc,%eax
 7d2:	cd 40                	int    $0x40
 7d4:	c3                   	ret

000007d5 <sleep>:
SYSCALL(sleep)
 7d5:	b8 0d 00 00 00       	mov    $0xd,%eax
 7da:	cd 40                	int    $0x40
 7dc:	c3                   	ret

000007dd <uptime>:
SYSCALL(uptime)
 7dd:	b8 0e 00 00 00       	mov    $0xe,%eax
 7e2:	cd 40                	int    $0x40
 7e4:	c3                   	ret

000007e5 <clone>:

SYSCALL(clone)
 7e5:	b8 16 00 00 00       	mov    $0x16,%eax
 7ea:	cd 40                	int    $0x40
 7ec:	c3                   	ret

000007ed <join>:
SYSCALL(join)
 7ed:	b8 17 00 00 00       	mov    $0x17,%eax
 7f2:	cd 40                	int    $0x40
 7f4:	c3                   	ret

000007f5 <thread_exit>:
SYSCALL(thread_exit)
 7f5:	b8 18 00 00 00       	mov    $0x18,%eax
 7fa:	cd 40                	int    $0x40
 7fc:	c3                   	ret

000007fd <randconfig>:
SYSCALL(randconfig)
 7fd:	b8 19 00 00 00       	mov    $0x19,%eax
 802:	cd 40                	int    $0x40
 804:	c3                   	ret

00000805 <yield>:
SYSCALL(yield)
 805:	b8 1a 00 00 00       	mov    $0x1a,%eax
 80a:	cd 40                	int    $0x40
 80c:	c3                   	ret

0000080d <lock_create>:
SYSCALL(lock_create)
 80d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 812:	cd 40                	int    $0x40
 814:	c3                   	ret

00000815 <lock_acquire>:
SYSCALL(lock_acquire)
 815:	b8 1c 00 00 00       	mov    $0x1c,%eax
 81a:	cd 40                	int    $0x40
 81c:	c3                   	ret

0000081d <lock_release>:
SYSCALL(lock_release)
 81d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 822:	cd 40                	int    $0x40
 824:	c3                   	ret

00000825 <sem_create>:
SYSCALL(sem_create)
 825:	b8 1e 00 00 00       	mov    $0x1e,%eax
 82a:	cd 40                	int    $0x40
 82c:	c3                   	ret

0000082d <sem_wait>:
SYSCALL(sem_wait)
 82d:	b8 1f 00 00 00       	mov    $0x1f,%eax
 832:	cd 40                	int    $0x40
 834:	c3                   	ret

00000835 <sem_post>:
SYSCALL(sem_post)
 835:	b8 20 00 00 00       	mov    $0x20,%eax
 83a:	cd 40                	int    $0x40
 83c:	c3                   	ret

0000083d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 18             	sub    $0x18,%esp
 843:	8b 45 0c             	mov    0xc(%ebp),%eax
 846:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 849:	83 ec 04             	sub    $0x4,%esp
 84c:	6a 01                	push   $0x1
 84e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 851:	50                   	push   %eax
 852:	ff 75 08             	push   0x8(%ebp)
 855:	e8 0b ff ff ff       	call   765 <write>
 85a:	83 c4 10             	add    $0x10,%esp
}
 85d:	90                   	nop
 85e:	c9                   	leave
 85f:	c3                   	ret

00000860 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 866:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 86d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 871:	74 17                	je     88a <printint+0x2a>
 873:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 877:	79 11                	jns    88a <printint+0x2a>
    neg = 1;
 879:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 880:	8b 45 0c             	mov    0xc(%ebp),%eax
 883:	f7 d8                	neg    %eax
 885:	89 45 ec             	mov    %eax,-0x14(%ebp)
 888:	eb 06                	jmp    890 <printint+0x30>
  } else {
    x = xx;
 88a:	8b 45 0c             	mov    0xc(%ebp),%eax
 88d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 897:	8b 4d 10             	mov    0x10(%ebp),%ecx
 89a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89d:	ba 00 00 00 00       	mov    $0x0,%edx
 8a2:	f7 f1                	div    %ecx
 8a4:	89 d1                	mov    %edx,%ecx
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8d 50 01             	lea    0x1(%eax),%edx
 8ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8af:	0f b6 91 00 14 00 00 	movzbl 0x1400(%ecx),%edx
 8b6:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 8ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c0:	ba 00 00 00 00       	mov    $0x0,%edx
 8c5:	f7 f1                	div    %ecx
 8c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8ce:	75 c7                	jne    897 <printint+0x37>
  if(neg)
 8d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d4:	74 2d                	je     903 <printint+0xa3>
    buf[i++] = '-';
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8d 50 01             	lea    0x1(%eax),%edx
 8dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8df:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8e4:	eb 1d                	jmp    903 <printint+0xa3>
    putc(fd, buf[i]);
 8e6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	01 d0                	add    %edx,%eax
 8ee:	0f b6 00             	movzbl (%eax),%eax
 8f1:	0f be c0             	movsbl %al,%eax
 8f4:	83 ec 08             	sub    $0x8,%esp
 8f7:	50                   	push   %eax
 8f8:	ff 75 08             	push   0x8(%ebp)
 8fb:	e8 3d ff ff ff       	call   83d <putc>
 900:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 903:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90b:	79 d9                	jns    8e6 <printint+0x86>
}
 90d:	90                   	nop
 90e:	90                   	nop
 90f:	c9                   	leave
 910:	c3                   	ret

00000911 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 911:	55                   	push   %ebp
 912:	89 e5                	mov    %esp,%ebp
 914:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 917:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 91e:	8d 45 0c             	lea    0xc(%ebp),%eax
 921:	83 c0 04             	add    $0x4,%eax
 924:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 927:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 92e:	e9 59 01 00 00       	jmp    a8c <printf+0x17b>
    c = fmt[i] & 0xff;
 933:	8b 55 0c             	mov    0xc(%ebp),%edx
 936:	8b 45 f0             	mov    -0x10(%ebp),%eax
 939:	01 d0                	add    %edx,%eax
 93b:	0f b6 00             	movzbl (%eax),%eax
 93e:	0f be c0             	movsbl %al,%eax
 941:	25 ff 00 00 00       	and    $0xff,%eax
 946:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 949:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 94d:	75 2c                	jne    97b <printf+0x6a>
      if(c == '%'){
 94f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 953:	75 0c                	jne    961 <printf+0x50>
        state = '%';
 955:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 95c:	e9 27 01 00 00       	jmp    a88 <printf+0x177>
      } else {
        putc(fd, c);
 961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 964:	0f be c0             	movsbl %al,%eax
 967:	83 ec 08             	sub    $0x8,%esp
 96a:	50                   	push   %eax
 96b:	ff 75 08             	push   0x8(%ebp)
 96e:	e8 ca fe ff ff       	call   83d <putc>
 973:	83 c4 10             	add    $0x10,%esp
 976:	e9 0d 01 00 00       	jmp    a88 <printf+0x177>
      }
    } else if(state == '%'){
 97b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 97f:	0f 85 03 01 00 00    	jne    a88 <printf+0x177>
      if(c == 'd'){
 985:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 989:	75 1e                	jne    9a9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 98b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98e:	8b 00                	mov    (%eax),%eax
 990:	6a 01                	push   $0x1
 992:	6a 0a                	push   $0xa
 994:	50                   	push   %eax
 995:	ff 75 08             	push   0x8(%ebp)
 998:	e8 c3 fe ff ff       	call   860 <printint>
 99d:	83 c4 10             	add    $0x10,%esp
        ap++;
 9a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9a4:	e9 d8 00 00 00       	jmp    a81 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 9a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9ad:	74 06                	je     9b5 <printf+0xa4>
 9af:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9b3:	75 1e                	jne    9d3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 9b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	6a 00                	push   $0x0
 9bc:	6a 10                	push   $0x10
 9be:	50                   	push   %eax
 9bf:	ff 75 08             	push   0x8(%ebp)
 9c2:	e8 99 fe ff ff       	call   860 <printint>
 9c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 9ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9ce:	e9 ae 00 00 00       	jmp    a81 <printf+0x170>
      } else if(c == 's'){
 9d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9d7:	75 43                	jne    a1c <printf+0x10b>
        s = (char*)*ap;
 9d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9dc:	8b 00                	mov    (%eax),%eax
 9de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e9:	75 25                	jne    a10 <printf+0xff>
          s = "(null)";
 9eb:	c7 45 f4 d9 0f 00 00 	movl   $0xfd9,-0xc(%ebp)
        while(*s != 0){
 9f2:	eb 1c                	jmp    a10 <printf+0xff>
          putc(fd, *s);
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	0f b6 00             	movzbl (%eax),%eax
 9fa:	0f be c0             	movsbl %al,%eax
 9fd:	83 ec 08             	sub    $0x8,%esp
 a00:	50                   	push   %eax
 a01:	ff 75 08             	push   0x8(%ebp)
 a04:	e8 34 fe ff ff       	call   83d <putc>
 a09:	83 c4 10             	add    $0x10,%esp
          s++;
 a0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	0f b6 00             	movzbl (%eax),%eax
 a16:	84 c0                	test   %al,%al
 a18:	75 da                	jne    9f4 <printf+0xe3>
 a1a:	eb 65                	jmp    a81 <printf+0x170>
        }
      } else if(c == 'c'){
 a1c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a20:	75 1d                	jne    a3f <printf+0x12e>
        putc(fd, *ap);
 a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a25:	8b 00                	mov    (%eax),%eax
 a27:	0f be c0             	movsbl %al,%eax
 a2a:	83 ec 08             	sub    $0x8,%esp
 a2d:	50                   	push   %eax
 a2e:	ff 75 08             	push   0x8(%ebp)
 a31:	e8 07 fe ff ff       	call   83d <putc>
 a36:	83 c4 10             	add    $0x10,%esp
        ap++;
 a39:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a3d:	eb 42                	jmp    a81 <printf+0x170>
      } else if(c == '%'){
 a3f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a43:	75 17                	jne    a5c <printf+0x14b>
        putc(fd, c);
 a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a48:	0f be c0             	movsbl %al,%eax
 a4b:	83 ec 08             	sub    $0x8,%esp
 a4e:	50                   	push   %eax
 a4f:	ff 75 08             	push   0x8(%ebp)
 a52:	e8 e6 fd ff ff       	call   83d <putc>
 a57:	83 c4 10             	add    $0x10,%esp
 a5a:	eb 25                	jmp    a81 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a5c:	83 ec 08             	sub    $0x8,%esp
 a5f:	6a 25                	push   $0x25
 a61:	ff 75 08             	push   0x8(%ebp)
 a64:	e8 d4 fd ff ff       	call   83d <putc>
 a69:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a6f:	0f be c0             	movsbl %al,%eax
 a72:	83 ec 08             	sub    $0x8,%esp
 a75:	50                   	push   %eax
 a76:	ff 75 08             	push   0x8(%ebp)
 a79:	e8 bf fd ff ff       	call   83d <putc>
 a7e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a88:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
 a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a92:	01 d0                	add    %edx,%eax
 a94:	0f b6 00             	movzbl (%eax),%eax
 a97:	84 c0                	test   %al,%al
 a99:	0f 85 94 fe ff ff    	jne    933 <printf+0x22>
    }
  }
}
 a9f:	90                   	nop
 aa0:	90                   	nop
 aa1:	c9                   	leave
 aa2:	c3                   	ret

00000aa3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aa3:	55                   	push   %ebp
 aa4:	89 e5                	mov    %esp,%ebp
 aa6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa9:	8b 45 08             	mov    0x8(%ebp),%eax
 aac:	83 e8 08             	sub    $0x8,%eax
 aaf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab2:	a1 44 14 00 00       	mov    0x1444,%eax
 ab7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aba:	eb 24                	jmp    ae0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abf:	8b 00                	mov    (%eax),%eax
 ac1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 ac4:	72 12                	jb     ad8 <free+0x35>
 ac6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 acc:	72 24                	jb     af2 <free+0x4f>
 ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad1:	8b 00                	mov    (%eax),%eax
 ad3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ad6:	72 1a                	jb     af2 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 ae6:	73 d4                	jae    abc <free+0x19>
 ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aeb:	8b 00                	mov    (%eax),%eax
 aed:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 af0:	73 ca                	jae    abc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af5:	8b 40 04             	mov    0x4(%eax),%eax
 af8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b02:	01 c2                	add    %eax,%edx
 b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b07:	8b 00                	mov    (%eax),%eax
 b09:	39 c2                	cmp    %eax,%edx
 b0b:	75 24                	jne    b31 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b10:	8b 50 04             	mov    0x4(%eax),%edx
 b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b16:	8b 00                	mov    (%eax),%eax
 b18:	8b 40 04             	mov    0x4(%eax),%eax
 b1b:	01 c2                	add    %eax,%edx
 b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b20:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b23:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b26:	8b 00                	mov    (%eax),%eax
 b28:	8b 10                	mov    (%eax),%edx
 b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b2d:	89 10                	mov    %edx,(%eax)
 b2f:	eb 0a                	jmp    b3b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b34:	8b 10                	mov    (%eax),%edx
 b36:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b39:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3e:	8b 40 04             	mov    0x4(%eax),%eax
 b41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4b:	01 d0                	add    %edx,%eax
 b4d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b50:	75 20                	jne    b72 <free+0xcf>
    p->s.size += bp->s.size;
 b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b55:	8b 50 04             	mov    0x4(%eax),%edx
 b58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b5b:	8b 40 04             	mov    0x4(%eax),%eax
 b5e:	01 c2                	add    %eax,%edx
 b60:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b63:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b66:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b69:	8b 10                	mov    (%eax),%edx
 b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6e:	89 10                	mov    %edx,(%eax)
 b70:	eb 08                	jmp    b7a <free+0xd7>
  } else
    p->s.ptr = bp;
 b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b75:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b78:	89 10                	mov    %edx,(%eax)
  freep = p;
 b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b7d:	a3 44 14 00 00       	mov    %eax,0x1444
}
 b82:	90                   	nop
 b83:	c9                   	leave
 b84:	c3                   	ret

00000b85 <morecore>:

static Header*
morecore(uint nu)
{
 b85:	55                   	push   %ebp
 b86:	89 e5                	mov    %esp,%ebp
 b88:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b8b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b92:	77 07                	ja     b9b <morecore+0x16>
    nu = 4096;
 b94:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	c1 e0 03             	shl    $0x3,%eax
 ba1:	83 ec 0c             	sub    $0xc,%esp
 ba4:	50                   	push   %eax
 ba5:	e8 23 fc ff ff       	call   7cd <sbrk>
 baa:	83 c4 10             	add    $0x10,%esp
 bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bb0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bb4:	75 07                	jne    bbd <morecore+0x38>
    return 0;
 bb6:	b8 00 00 00 00       	mov    $0x0,%eax
 bbb:	eb 26                	jmp    be3 <morecore+0x5e>
  hp = (Header*)p;
 bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc6:	8b 55 08             	mov    0x8(%ebp),%edx
 bc9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bcf:	83 c0 08             	add    $0x8,%eax
 bd2:	83 ec 0c             	sub    $0xc,%esp
 bd5:	50                   	push   %eax
 bd6:	e8 c8 fe ff ff       	call   aa3 <free>
 bdb:	83 c4 10             	add    $0x10,%esp
  return freep;
 bde:	a1 44 14 00 00       	mov    0x1444,%eax
}
 be3:	c9                   	leave
 be4:	c3                   	ret

00000be5 <malloc>:

void*
malloc(uint nbytes)
{
 be5:	55                   	push   %ebp
 be6:	89 e5                	mov    %esp,%ebp
 be8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 beb:	8b 45 08             	mov    0x8(%ebp),%eax
 bee:	83 c0 07             	add    $0x7,%eax
 bf1:	c1 e8 03             	shr    $0x3,%eax
 bf4:	83 c0 01             	add    $0x1,%eax
 bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bfa:	a1 44 14 00 00       	mov    0x1444,%eax
 bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c06:	75 23                	jne    c2b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c08:	c7 45 f0 3c 14 00 00 	movl   $0x143c,-0x10(%ebp)
 c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c12:	a3 44 14 00 00       	mov    %eax,0x1444
 c17:	a1 44 14 00 00       	mov    0x1444,%eax
 c1c:	a3 3c 14 00 00       	mov    %eax,0x143c
    base.s.size = 0;
 c21:	c7 05 40 14 00 00 00 	movl   $0x0,0x1440
 c28:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2e:	8b 00                	mov    (%eax),%eax
 c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c36:	8b 40 04             	mov    0x4(%eax),%eax
 c39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c3c:	72 4d                	jb     c8b <malloc+0xa6>
      if(p->s.size == nunits)
 c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c41:	8b 40 04             	mov    0x4(%eax),%eax
 c44:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c47:	75 0c                	jne    c55 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4c:	8b 10                	mov    (%eax),%edx
 c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c51:	89 10                	mov    %edx,(%eax)
 c53:	eb 26                	jmp    c7b <malloc+0x96>
      else {
        p->s.size -= nunits;
 c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c58:	8b 40 04             	mov    0x4(%eax),%eax
 c5b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c5e:	89 c2                	mov    %eax,%edx
 c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c63:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c69:	8b 40 04             	mov    0x4(%eax),%eax
 c6c:	c1 e0 03             	shl    $0x3,%eax
 c6f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c78:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7e:	a3 44 14 00 00       	mov    %eax,0x1444
      return (void*)(p + 1);
 c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c86:	83 c0 08             	add    $0x8,%eax
 c89:	eb 3b                	jmp    cc6 <malloc+0xe1>
    }
    if(p == freep)
 c8b:	a1 44 14 00 00       	mov    0x1444,%eax
 c90:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c93:	75 1e                	jne    cb3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c95:	83 ec 0c             	sub    $0xc,%esp
 c98:	ff 75 ec             	push   -0x14(%ebp)
 c9b:	e8 e5 fe ff ff       	call   b85 <morecore>
 ca0:	83 c4 10             	add    $0x10,%esp
 ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 caa:	75 07                	jne    cb3 <malloc+0xce>
        return 0;
 cac:	b8 00 00 00 00       	mov    $0x0,%eax
 cb1:	eb 13                	jmp    cc6 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbc:	8b 00                	mov    (%eax),%eax
 cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cc1:	e9 6d ff ff ff       	jmp    c33 <malloc+0x4e>
  }
}
 cc6:	c9                   	leave
 cc7:	c3                   	ret

00000cc8 <trampoline>:
#include "types.h"
#include "user.h"

#define PTHREAD_STACK 4096
struct startinfo { void *(*fn)(void*); void *arg; };
static void trampoline(void *x){ struct startinfo si=*(struct startinfo*)x; si.fn(si.arg); thread_exit(); }
 cc8:	55                   	push   %ebp
 cc9:	89 e5                	mov    %esp,%ebp
 ccb:	83 ec 18             	sub    $0x18,%esp
 cce:	8b 45 08             	mov    0x8(%ebp),%eax
 cd1:	8b 50 04             	mov    0x4(%eax),%edx
 cd4:	8b 00                	mov    (%eax),%eax
 cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ce2:	83 ec 0c             	sub    $0xc,%esp
 ce5:	52                   	push   %edx
 ce6:	ff d0                	call   *%eax
 ce8:	83 c4 10             	add    $0x10,%esp
 ceb:	e8 05 fb ff ff       	call   7f5 <thread_exit>

00000cf0 <pthread_create>:
int pthread_create(pthread_t *t, void *attr, void *(*fn)(void*), void *arg){ void *raw,*stack; struct startinfo *si; int pid; (void)attr; raw=malloc(PTHREAD_STACK*2); if(!raw) return -1; stack=(void*)(((uint)raw+PTHREAD_STACK-1)&~(PTHREAD_STACK-1)); si=malloc(sizeof(*si)); if(!si){ free(raw); return -1; } si->fn=fn; si->arg=arg; pid=clone(trampoline, si, stack); if(pid<0){ free(si); free(raw); return -1; } *t=pid; return 0; }
 cf0:	55                   	push   %ebp
 cf1:	89 e5                	mov    %esp,%ebp
 cf3:	83 ec 18             	sub    $0x18,%esp
 cf6:	83 ec 0c             	sub    $0xc,%esp
 cf9:	68 00 20 00 00       	push   $0x2000
 cfe:	e8 e2 fe ff ff       	call   be5 <malloc>
 d03:	83 c4 10             	add    $0x10,%esp
 d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d0d:	75 0a                	jne    d19 <pthread_create+0x29>
 d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d14:	e9 9b 00 00 00       	jmp    db4 <pthread_create+0xc4>
 d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1c:	05 ff 0f 00 00       	add    $0xfff,%eax
 d21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 d26:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d29:	83 ec 0c             	sub    $0xc,%esp
 d2c:	6a 08                	push   $0x8
 d2e:	e8 b2 fe ff ff       	call   be5 <malloc>
 d33:	83 c4 10             	add    $0x10,%esp
 d36:	89 45 ec             	mov    %eax,-0x14(%ebp)
 d39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d3d:	75 15                	jne    d54 <pthread_create+0x64>
 d3f:	83 ec 0c             	sub    $0xc,%esp
 d42:	ff 75 f4             	push   -0xc(%ebp)
 d45:	e8 59 fd ff ff       	call   aa3 <free>
 d4a:	83 c4 10             	add    $0x10,%esp
 d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d52:	eb 60                	jmp    db4 <pthread_create+0xc4>
 d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d57:	8b 55 10             	mov    0x10(%ebp),%edx
 d5a:	89 10                	mov    %edx,(%eax)
 d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d5f:	8b 55 14             	mov    0x14(%ebp),%edx
 d62:	89 50 04             	mov    %edx,0x4(%eax)
 d65:	83 ec 04             	sub    $0x4,%esp
 d68:	ff 75 f0             	push   -0x10(%ebp)
 d6b:	ff 75 ec             	push   -0x14(%ebp)
 d6e:	68 c8 0c 00 00       	push   $0xcc8
 d73:	e8 6d fa ff ff       	call   7e5 <clone>
 d78:	83 c4 10             	add    $0x10,%esp
 d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 d7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 d82:	79 23                	jns    da7 <pthread_create+0xb7>
 d84:	83 ec 0c             	sub    $0xc,%esp
 d87:	ff 75 ec             	push   -0x14(%ebp)
 d8a:	e8 14 fd ff ff       	call   aa3 <free>
 d8f:	83 c4 10             	add    $0x10,%esp
 d92:	83 ec 0c             	sub    $0xc,%esp
 d95:	ff 75 f4             	push   -0xc(%ebp)
 d98:	e8 06 fd ff ff       	call   aa3 <free>
 d9d:	83 c4 10             	add    $0x10,%esp
 da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 da5:	eb 0d                	jmp    db4 <pthread_create+0xc4>
 da7:	8b 45 08             	mov    0x8(%ebp),%eax
 daa:	8b 55 e8             	mov    -0x18(%ebp),%edx
 dad:	89 10                	mov    %edx,(%eax)
 daf:	b8 00 00 00 00       	mov    $0x0,%eax
 db4:	c9                   	leave
 db5:	c3                   	ret

00000db6 <pthread_join>:
int pthread_join(pthread_t wanted, void **retval){ void *stack=0; int pid; (void)retval; pid=join(wanted,&stack); return pid==wanted?0:-1; }
 db6:	55                   	push   %ebp
 db7:	89 e5                	mov    %esp,%ebp
 db9:	83 ec 18             	sub    $0x18,%esp
 dbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 dc3:	83 ec 08             	sub    $0x8,%esp
 dc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
 dc9:	50                   	push   %eax
 dca:	ff 75 08             	push   0x8(%ebp)
 dcd:	e8 1b fa ff ff       	call   7ed <join>
 dd2:	83 c4 10             	add    $0x10,%esp
 dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ddb:	3b 45 08             	cmp    0x8(%ebp),%eax
 dde:	75 07                	jne    de7 <pthread_join+0x31>
 de0:	b8 00 00 00 00       	mov    $0x0,%eax
 de5:	eb 05                	jmp    dec <pthread_join+0x36>
 de7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dec:	c9                   	leave
 ded:	c3                   	ret

00000dee <pthread_exit>:
void pthread_exit(void *retval){ (void)retval; thread_exit(); }
 dee:	55                   	push   %ebp
 def:	89 e5                	mov    %esp,%ebp
 df1:	83 ec 08             	sub    $0x8,%esp
 df4:	e8 fc f9 ff ff       	call   7f5 <thread_exit>

00000df9 <pthread_mutex_init>:
int pthread_mutex_init(pthread_mutex_t *m, void *attr){ (void)attr; *m=lock_create(); return *m<0?-1:0; }
 df9:	55                   	push   %ebp
 dfa:	89 e5                	mov    %esp,%ebp
 dfc:	83 ec 08             	sub    $0x8,%esp
 dff:	e8 09 fa ff ff       	call   80d <lock_create>
 e04:	8b 55 08             	mov    0x8(%ebp),%edx
 e07:	89 02                	mov    %eax,(%edx)
 e09:	8b 45 08             	mov    0x8(%ebp),%eax
 e0c:	8b 00                	mov    (%eax),%eax
 e0e:	85 c0                	test   %eax,%eax
 e10:	79 07                	jns    e19 <pthread_mutex_init+0x20>
 e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e17:	eb 05                	jmp    e1e <pthread_mutex_init+0x25>
 e19:	b8 00 00 00 00       	mov    $0x0,%eax
 e1e:	c9                   	leave
 e1f:	c3                   	ret

00000e20 <pthread_mutex_lock>:
int pthread_mutex_lock(pthread_mutex_t *m){ return lock_acquire(*m); }
 e20:	55                   	push   %ebp
 e21:	89 e5                	mov    %esp,%ebp
 e23:	83 ec 08             	sub    $0x8,%esp
 e26:	8b 45 08             	mov    0x8(%ebp),%eax
 e29:	8b 00                	mov    (%eax),%eax
 e2b:	83 ec 0c             	sub    $0xc,%esp
 e2e:	50                   	push   %eax
 e2f:	e8 e1 f9 ff ff       	call   815 <lock_acquire>
 e34:	83 c4 10             	add    $0x10,%esp
 e37:	c9                   	leave
 e38:	c3                   	ret

00000e39 <pthread_mutex_unlock>:
int pthread_mutex_unlock(pthread_mutex_t *m){ return lock_release(*m); }
 e39:	55                   	push   %ebp
 e3a:	89 e5                	mov    %esp,%ebp
 e3c:	83 ec 08             	sub    $0x8,%esp
 e3f:	8b 45 08             	mov    0x8(%ebp),%eax
 e42:	8b 00                	mov    (%eax),%eax
 e44:	83 ec 0c             	sub    $0xc,%esp
 e47:	50                   	push   %eax
 e48:	e8 d0 f9 ff ff       	call   81d <lock_release>
 e4d:	83 c4 10             	add    $0x10,%esp
 e50:	c9                   	leave
 e51:	c3                   	ret

00000e52 <sem_init>:
int sem_init(sem_t *s, int pshared, unsigned value){ (void)pshared; *s=sem_create(value); return *s<0?-1:0; }
 e52:	55                   	push   %ebp
 e53:	89 e5                	mov    %esp,%ebp
 e55:	83 ec 08             	sub    $0x8,%esp
 e58:	8b 45 10             	mov    0x10(%ebp),%eax
 e5b:	83 ec 0c             	sub    $0xc,%esp
 e5e:	50                   	push   %eax
 e5f:	e8 c1 f9 ff ff       	call   825 <sem_create>
 e64:	83 c4 10             	add    $0x10,%esp
 e67:	8b 55 08             	mov    0x8(%ebp),%edx
 e6a:	89 02                	mov    %eax,(%edx)
 e6c:	8b 45 08             	mov    0x8(%ebp),%eax
 e6f:	8b 00                	mov    (%eax),%eax
 e71:	85 c0                	test   %eax,%eax
 e73:	79 07                	jns    e7c <sem_init+0x2a>
 e75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 e7a:	eb 05                	jmp    e81 <sem_init+0x2f>
 e7c:	b8 00 00 00 00       	mov    $0x0,%eax
 e81:	c9                   	leave
 e82:	c3                   	ret

00000e83 <sem_wait_u>:
int sem_wait_u(sem_t *s){ return sem_wait(*s); }
 e83:	55                   	push   %ebp
 e84:	89 e5                	mov    %esp,%ebp
 e86:	83 ec 08             	sub    $0x8,%esp
 e89:	8b 45 08             	mov    0x8(%ebp),%eax
 e8c:	8b 00                	mov    (%eax),%eax
 e8e:	83 ec 0c             	sub    $0xc,%esp
 e91:	50                   	push   %eax
 e92:	e8 96 f9 ff ff       	call   82d <sem_wait>
 e97:	83 c4 10             	add    $0x10,%esp
 e9a:	c9                   	leave
 e9b:	c3                   	ret

00000e9c <sem_post_u>:
int sem_post_u(sem_t *s){ return sem_post(*s); }
 e9c:	55                   	push   %ebp
 e9d:	89 e5                	mov    %esp,%ebp
 e9f:	83 ec 08             	sub    $0x8,%esp
 ea2:	8b 45 08             	mov    0x8(%ebp),%eax
 ea5:	8b 00                	mov    (%eax),%eax
 ea7:	83 ec 0c             	sub    $0xc,%esp
 eaa:	50                   	push   %eax
 eab:	e8 85 f9 ff ff       	call   835 <sem_post>
 eb0:	83 c4 10             	add    $0x10,%esp
 eb3:	c9                   	leave
 eb4:	c3                   	ret

00000eb5 <stochastic_schedule>:
void stochastic_schedule(uint seed, int percent){ randconfig(seed, percent); }
 eb5:	55                   	push   %ebp
 eb6:	89 e5                	mov    %esp,%ebp
 eb8:	83 ec 08             	sub    $0x8,%esp
 ebb:	83 ec 08             	sub    $0x8,%esp
 ebe:	ff 75 0c             	push   0xc(%ebp)
 ec1:	ff 75 08             	push   0x8(%ebp)
 ec4:	e8 34 f9 ff ff       	call   7fd <randconfig>
 ec9:	83 c4 10             	add    $0x10,%esp
 ecc:	90                   	nop
 ecd:	c9                   	leave
 ece:	c3                   	ret
