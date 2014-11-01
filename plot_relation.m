load ls_balsai_rel;

%133(33) ir lyginkim su 130(30), 52(28), 33(24), 141(39)



figure; hold on;
%plot([1:2008],k133(j),'k-');
%plot([1:2008],k33(j),'g-');
%plot([1:2008],k141(j),'r-');
%plot([1:2008],k130(j),'m-');
%plot([1:2008],k52(j),'b-');
subplot(3,4,1); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,79),ls_balsai_rel(:,103),'k.'); title('79 vs 103');
subplot(3,4,2); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,103),ls_balsai_rel(:,106),'k.'); title('103 vs 106');
subplot(3,4,3); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,106),ls_balsai_rel(:,80),'k.'); title('106 vs 80');
subplot(3,4,4); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,80),ls_balsai_rel(:,135),'k.'); title('80 vs 135');
subplot(3,4,5); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,79),ls_balsai_rel(:,106),'k.'); title('79 vs 106');
subplot(3,4,6); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,79),ls_balsai_rel(:,80),'k.'); title('79 vs 80');
subplot(3,4,7); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,79),ls_balsai_rel(:,135),'k.'); title('79 vs 135');
subplot(3,4,8); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,103),ls_balsai_rel(:,80),'k.'); title('103 vs 80');
subplot(3,4,9); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,103),ls_balsai_rel(:,135),'k.'); title('103 vs 135');
subplot(3,4,10); hold on; axis square; axis([0 0.2 0 0.2]);
plot(ls_balsai_rel(:,106),ls_balsai_rel(:,135),'k.'); title('106 vs 135');


figure; hold on; axis square; title('86 vs 17');
plot(ls_balsai_rel(:,86),ls_balsai_rel(:,17),'k.');
