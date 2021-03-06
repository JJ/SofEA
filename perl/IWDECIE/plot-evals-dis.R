evals.dis <- read.table('evals-dis.dat')
evals.dis.a8 <- read.table('evals-dis-a8.dat')
evals.dis.96 <- read.table('evals-dis-96.dat')
evals.base <- read.table('../GECCO/evals-ip128-e16-r64.dat')
boxplot( evals.base$V1,
        evals.dis$V1,   evals.dis.a8$V1,   evals.dis.96$V1,
        main='SofEA 1, Evaluations to solution',  sub='Diverse block size',
        xlab='Configuration',
        ylab='# Evaluations' )
axis(1,at=c(1:4),labels =c('SofEA0', 'r64+r32+r16', 'r96+r64+r32+r16', 'r64+32+r16r8' ))
