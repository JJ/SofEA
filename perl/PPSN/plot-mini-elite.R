evals.elite.e.il128.r32.c3.r30 <- read.table('evals-elite-e-il128-r32-c3-r30.dat')
time.elite.e.il128.r32.c3.r30 <- read.table('time-elite-e-il128-r32-c3-r30.dat')
evals.elite.e.irl128.c3.r30 <- read.table('evals-elite-e-irl128-c3-r30.dat')
time.elite.e.irl128.c3.r30 <- read.table('time-elite-e-irl128-c3-r30.dat')
evals.mini.ga.sort.adapt.il128.r32.c3.r30 <- read.table('evals-mini-ga-sort-adapt-il128-r32-c3-r30.dat')
time.mini.ga.sort.adapt.il128.r32.c3.r30 <- read.table('time-mini-ga-sort-adapt-il128-r32-c3-r30.dat')
boxplot( evals.elite.e.il128.r32.c3.r30$V1, evals.elite.e.irl128.c3.r30$V1, evals.mini.ga.sort.adapt.il128.r32.c3.r30$V1, main='Pool GA comparison', sub='Elite vs. Base', xlab='Configuration',ylab='#Evals per client' );
axis(1,at=c(1:3),labels =c('Elite r32','Elite r128','Baseline'))
