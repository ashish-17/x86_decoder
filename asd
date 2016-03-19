 80482f0:	31 ed                	xor    %ebp,%ebp
 80482f2:	5e                   	pop    %esi
 80482f3:	89 e1                	mov    %esp,%ecx
 80482f5:	83 e4 f0             	and    $0xfffffff0,%esp
 80482f8:	50                   	push   %eax
 80482f9:	54                   	push   %esp
 80482fa:	52                   	push   %edx
 80482fb:	68 90 84 04 08       	push   $0x8048490
 8048300:	68 20 84 04 08       	push   $0x8048420
 8048305:	51                   	push   %ecx
 8048306:	56                   	push   %esi
 8048307:	68 eb 83 04 08       	push   $0x80483eb
 804830c:	e8 cf ff ff ff       	call   80482e0 
 8048311:	f4                   	hlt    
 8048312:	66 90                	xchg   %ax,%ax
 8048314:	66 90                	xchg   %ax,%ax
 8048316:	66 90                	xchg   %ax,%ax
 8048318:	66 90                	xchg   %ax,%ax
 804831a:	66 90                	xchg   %ax,%ax
 804831c:	66 90                	xchg   %ax,%ax
 804831e:	66 90                	xchg   %ax,%ax
 8048320:	8b 1c 24             	mov    (%esp),%ebx
 8048323:	c3                   	ret    
 8048324:	66 90                	xchg   %ax,%ax
 8048326:	66 90                	xchg   %ax,%ax
 8048328:	66 90                	xchg   %ax,%ax
 804832a:	66 90                	xchg   %ax,%ax
 804832c:	66 90                	xchg   %ax,%ax
 804832e:	66 90                	xchg   %ax,%ax
 8048330:	b8 1f a0 04 08       	mov    $0x804a01f,%eax
 8048335:	2d 1c a0 04 08       	sub    $0x804a01c,%eax
 804833a:	83 f8 06             	cmp    $0x6,%eax
 804833d:	76 1a                	jbe    8048359 
 804833f:	b8 00 00 00 00       	mov    $0x0,%eax
 8048344:	85 c0                	test   %eax,%eax
 8048346:	74 11                	je     8048359 
 8048348:	55                   	push   %ebp
 8048349:	89 e5                	mov    %esp,%ebp
 804834b:	83 ec 14             	sub    $0x14,%esp
 804834e:	68 1c a0 04 08       	push   $0x804a01c
 8048353:	ff d0                	call   *%eax
 8048355:	83 c4 10             	add    $0x10,%esp
 8048358:	c9                   	leave  
 8048359:	f3 c3                	repz ret 
 804835b:	90                   	nop
 804835c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048360:	b8 1c a0 04 08       	mov    $0x804a01c,%eax
 8048365:	2d 1c a0 04 08       	sub    $0x804a01c,%eax
 804836a:	c1 f8 02             	sar    $0x2,%eax
 804836d:	89 c2                	mov    %eax,%edx
 804836f:	c1 ea 1f             	shr    $0x1f,%edx
 8048372:	01 d0                	add    %edx,%eax
 8048374:	d1 f8                	sar    %eax
 8048376:	74 1b                	je     8048393 
 8048378:	ba 00 00 00 00       	mov    $0x0,%edx
 804837d:	85 d2                	test   %edx,%edx
 804837f:	74 12                	je     8048393 
 8048381:	55                   	push   %ebp
 8048382:	89 e5                	mov    %esp,%ebp
 8048384:	83 ec 10             	sub    $0x10,%esp
 8048387:	50                   	push   %eax
 8048388:	68 1c a0 04 08       	push   $0x804a01c
 804838d:	ff d2                	call   *%edx
 804838f:	83 c4 10             	add    $0x10,%esp
 8048392:	c9                   	leave  
 8048393:	f3 c3                	repz ret 
 8048395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 80483a0:	80 3d 1c a0 04 08 00 	cmpb   $0x0,0x804a01c
 80483a7:	75 13                	jne    80483bc 
 80483a9:	55                   	push   %ebp
 80483aa:	89 e5                	mov    %esp,%ebp
 80483ac:	83 ec 08             	sub    $0x8,%esp
 80483af:	e8 7c ff ff ff       	call   8048330 
 80483b4:	c6 05 1c a0 04 08 01 	movb   $0x1,0x804a01c
 80483bb:	c9                   	leave  
 80483bc:	f3 c3                	repz ret 
 80483be:	66 90                	xchg   %ax,%ax
 80483c0:	b8 10 9f 04 08       	mov    $0x8049f10,%eax
 80483c5:	8b 10                	mov    (%eax),%edx
 80483c7:	85 d2                	test   %edx,%edx
 80483c9:	75 05                	jne    80483d0 
 80483cb:	eb 93                	jmp    8048360 
 80483cd:	8d 76 00             	lea    0x0(%esi),%esi
 80483d0:	ba 00 00 00 00       	mov    $0x0,%edx
 80483d5:	85 d2                	test   %edx,%edx
 80483d7:	74 f2                	je     80483cb 
 80483d9:	55                   	push   %ebp
 80483da:	89 e5                	mov    %esp,%ebp
 80483dc:	83 ec 14             	sub    $0x14,%esp
 80483df:	50                   	push   %eax
 80483e0:	ff d2                	call   *%edx
 80483e2:	83 c4 10             	add    $0x10,%esp
 80483e5:	c9                   	leave  
 80483e6:	e9 75 ff ff ff       	jmp    8048360 
 80483eb:	55                   	push   %ebp
 80483ec:	89 e5                	mov    %esp,%ebp
 80483ee:	83 ec 10             	sub    $0x10,%esp
 80483f1:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
 80483f8:	c7 45 f8 06 00 00 00 	movl   $0x6,-0x8(%ebp)
 80483ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048402:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048405:	01 d0                	add    %edx,%eax
 8048407:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804840a:	b8 00 00 00 00       	mov    $0x0,%eax
 804840f:	c9                   	leave  
 8048410:	c3                   	ret    
 8048411:	66 90                	xchg   %ax,%ax
 8048413:	66 90                	xchg   %ax,%ax
 8048415:	66 90                	xchg   %ax,%ax
 8048417:	66 90                	xchg   %ax,%ax
 8048419:	66 90                	xchg   %ax,%ax
 804841b:	66 90                	xchg   %ax,%ax
 804841d:	66 90                	xchg   %ax,%ax
 804841f:	90                   	nop
 8048420:	55                   	push   %ebp
 8048421:	57                   	push   %edi
 8048422:	31 ff                	xor    %edi,%edi
 8048424:	56                   	push   %esi
 8048425:	53                   	push   %ebx
 8048426:	e8 f5 fe ff ff       	call   8048320 
 804842b:	81 c3 d5 1b 00 00    	add    $0x1bd5,%ebx
 8048431:	83 ec 1c             	sub    $0x1c,%esp
 8048434:	8b 6c 24 30          	mov    0x30(%esp),%ebp
 8048438:	8d b3 0c ff ff ff    	lea    -0xf4(%ebx),%esi
 804843e:	e8 51 fe ff ff       	call   8048294 
 8048443:	8d 83 08 ff ff ff    	lea    -0xf8(%ebx),%eax
 8048449:	29 c6                	sub    %eax,%esi
 804844b:	c1 fe 02             	sar    $0x2,%esi
 804844e:	85 f6                	test   %esi,%esi
 8048450:	74 27                	je     8048479 
 8048452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8048458:	8b 44 24 38          	mov    0x38(%esp),%eax
 804845c:	89 2c 24             	mov    %ebp,(%esp)
 804845f:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048463:	8b 44 24 34          	mov    0x34(%esp),%eax
 8048467:	89 44 24 04          	mov    %eax,0x4(%esp)
 804846b:	ff 94 bb 08 ff ff ff 	call   *-0xf8(%ebx,%edi,4)
 8048472:	83 c7 01             	add    $0x1,%edi
 8048475:	39 f7                	cmp    %esi,%edi
 8048477:	75 df                	jne    8048458 
 8048479:	83 c4 1c             	add    $0x1c,%esp
 804847c:	5b                   	pop    %ebx
 804847d:	5e                   	pop    %esi
 804847e:	5f                   	pop    %edi
 804847f:	5d                   	pop    %ebp
 8048480:	c3                   	ret    
 8048481:	eb 0d                	jmp    8048490 
 8048483:	90                   	nop
 8048484:	90                   	nop
 8048485:	90                   	nop
 8048486:	90                   	nop
 8048487:	90                   	nop
 8048488:	90                   	nop
 8048489:	90                   	nop
 804848a:	90                   	nop
 804848b:	90                   	nop
 804848c:	90                   	nop
 804848d:	90                   	nop
 804848e:	90                   	nop
 804848f:	90                   	nop
 8048490:	f3 c3                	repz ret 
