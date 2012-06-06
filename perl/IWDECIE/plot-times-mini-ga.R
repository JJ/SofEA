times.mini.ga.r32.3 <- read.table('time-mini-ga-ip128-r32-3.dat')
times.mini.ga.r32.4 <- read.table('time-mini-ga-ip128-r32-4.dat')
times.mini.ga.r32.6 <- read.table('times-mini-ga-ip128-r32-6.dat')
times.mini.ga.r64.3 <- read.table('times-mini-ga-ip128-r64-3.dat')
boxplot( times.ip128.r16.R5$V1,
        times.mini.ga.r32.3$V1, times.mini.ga.r32.4$V1,
        times.mini.ga.r32.6$V1, times.mini.ga.r64.3$V1,
        main='SofEA 2, Time to solution',  sub='Initial population = Population = 128',
        xlab='Configuration',
        ylab='Time (s)' )
axis(1,at=c(1:5),labels =c('SofEA1','r32R3', 'r32R4', 'r32R6', 'r64R3' ))
