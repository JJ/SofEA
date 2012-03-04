evals.mini.ga.r32.3 <- read.table('evals-mini-ga-ip128-r32-3.dat')
evals.mini.ga.r32.4 <- read.table('evals-mini-ga-ip128-r32-4.dat')
evals.mini.ga.r32.6 <- read.table('evals-mini-ga-ip128-r32-6.dat')
evals.mini.ga.r64.3 <- read.table('evals-mini-ga-ip128-r64-3.dat')
boxplot( evals.ip128.r16.R5$V1,
        evals.mini.ga.r32.3$V1, evals.mini.ga.r32.4$V1,
        evals.mini.ga.r32.6$V1, evals.mini.ga.r64.3$V1,
        main='SofEA 2, Evaluations to solution',  sub='Initial population = 128',
        xlab='Configuration',
        ylab='# Evals to solution' )
axis(1,at=c(1:5),labels =c('SofEA1','r32R3', 'r32R4', 'r32R6', 'r64R3' ))
