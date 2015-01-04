evals.mini.ga.sort.r32.6 <- read.table('evals-mini-ga-sort-r32-6.dat')
evals.mini.ga.sort.r64.4 <- read.table('evals-mini-ga-sort-r64-4.dat')
evals.mini.ga.sort.r64.3 <- read.table('evals-mini-ga-sort-r64-3.dat')
boxplot( evals.ip128.r16.R5$V1,
        evals.mini.ga.sort.r32.6$V1, 
        evals.mini.ga.sort.r64.4$V1, evals.mini.ga.sort.r64.3$V1,
        main='SofEA 3, Evaluations to solution',  sub='Initial population = 128',
        xlab='Configuration',
        ylab='# Evals to solution' )
axis(1,at=c(1:4),labels =c('SofEA1','r32R6', 'r64R4', 'r64R3' ))
