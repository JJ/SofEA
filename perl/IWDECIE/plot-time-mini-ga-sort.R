time.mini.ga.sort.r32.6 <- read.table('time-mini-ga-sort-r32-6.dat')
time.mini.ga.sort.r64.4 <- read.table('time-mini-ga-sort-r64-4.dat')
time.mini.ga.sort.r64.3 <- read.table('time-mini-ga-sort-r64-3.dat')
boxplot( times.ip128.r16.R5$V1,
        times.mini.ga.r32.3$V1,  time.mini.ga.sort.r32.6$V1, 
        time.mini.ga.sort.r64.4$V1, time.mini.ga.sort.r64.3$V1,
        main='SofEA 3, Time to solution',  sub='Initial population = 128',
        xlab='Configuration',
        ylab='Time to solution (s)' )
axis(1,at=c(1:5),labels =c('SofEA1','SofEA2','r32R6', 'r64R4', 'r64R3' ))
