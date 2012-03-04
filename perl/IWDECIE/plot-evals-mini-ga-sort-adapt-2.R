evals.mini.ga.sort.adapt.r32.4 <- read.table('evals-mini-ga-sort-adapt-i256-r32-4.dat')
evals.mini.ga.sort.adapt.r32.7 <- read.table('evals-mini-ga-sort-adapt-r32-7.dat')
evals.mini.ga.sort.adapt.r64.5 <- read.table('evals-mini-ga-sort-adapt-r64-5.dat')
evals.mini.ga.sort.adapt.r64.4 <- read.table('evals-mini-ga-sort-adapt-r64-4.dat')
evals.mini.ga.sort.adapt.r64.3 <- read.table('evals-mini-ga-sort-adapt-r64-3.dat')
evals.mini.ga.sort.adapt.r64.2 <- read.table('evals-mini-ga-sort-adapt-i256-r64-2.dat')
boxplot( evals.mini.ga.sort.r32.6$V1,
        evals.mini.ga.sort.adapt.r32.7$V1,         evals.mini.ga.sort.adapt.r32.4$V1,
        evals.mini.ga.sort.adapt.r64.5$V1, evals.mini.ga.sort.adapt.r64.4$V1, 
        evals.mini.ga.sort.adapt.r64.3$V1,         evals.mini.ga.sort.adapt.r64.2$V1, 
        main='SofEA 4, Evals to solution',  sub='Initial population = 128',
        xlab='Configuration',
        ylab='# Evals to solution' )
axis(1,at=c(1:7),labels =c('SofEA3','r32R7','r32R4','r64R5', 'r64R4', 'r64R3','r64R2' ))
