evals.ip128.r32.R3 <- read.table('evals-R-ip128-r32-R3.dat')
evals.ip128.r16.R5 <- read.table('evals-R-ip128-r16-R5.dat')
evals.ip128.r16.R6 <- read.table('evals-R-ip128-r16-R6.dat')
evals.base <- read.table('../GECCO/evals-ip128-e16-r64.dat')
boxplot( evals.base$V1,
         evals.ip128.r32.R3$V1, 
        evals.ip128.r16.R5$V1, evals.ip128.r16.R6$V1,
        main='SofEA 1, Running time',  sub='Initial pop = 128',
        xlab='Configuration',
        ylab='# Evaluations' )
axis(1,at=c(1:4),labels =c('SofEA0', 'r32R3', 'r16R5', 'r16R6' ))
