evals.mini.ga.sort.adapt.dis <- read.table('evals-mini-ga-sort-adapt-dis.dat')
evals.mini.ga.sort.adapt.i256.r64.R5 <- read.table('evals-mini-ga-sort-adapt-i256-r64-R5.dat')
boxplot( evals.mini.ga.sort.r32.6$V1,
        evals.mini.ga.sort.adapt.r32.7$V1,
        evals.mini.ga.sort.adapt.dis$V1,  evals.mini.ga.sort.adapt.i256.r64.R5$V1,
        main='SofEA 4, Evals to solution',  sub='Initial population = 128,256',
        xlab='Configuration',
        ylab='# Evals to solution' )
axis(1,at=c(1:4),labels =c('SofEA3','r32R7','Dis', 'p256r64R5'))
