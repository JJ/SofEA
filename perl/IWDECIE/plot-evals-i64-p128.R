evals.i64.p128.r64.R1 <- read.table('evals-R-i64-p128-r64-r1.dat')
evals.i64.p128.r64.R2 <- read.table('evals-R-i64-p128-r64-r2.dat')
evals.i64.p128.r32.R3 <- read.table('evals-R-i64-p128-r32-R3.dat')
evals.i64.p128.r32.R4 <- read.table('evals-R-i64-p128-r32-R4.dat')
evals.i64.p128.r16.R5 <- read.table('evals-R-i64-p128-r16-R5.dat')
evals.i64.p128.r16.R6 <- read.table('evals-R-i64-p128-r16-R6.dat')
evals.base <- read.table('../GECCO/evals-ip128-e16-r64.dat')
boxplot( evals.base$V1,
        evals.i64.p128.r64.R1$V1, evals.i64.p128.r64.R2$V1,
         evals.i64.p128.r32.R3$V1, evals.i64.p128.r32.R4$V1,
        evals.i64.p128.r16.R5$V1, evals.i64.p128.r16.R6$V1,
        main='SofEA 1, Running time',  sub='Initial pop = 64',
        xlab='Configuration',
        ylab='# Evaluations' )
axis(1,at=c(1:7),labels =c('SofEA0','r64R1', 'r64R2', 'r32R3', 'r32R4','r16R5', 'r16R6' ))
