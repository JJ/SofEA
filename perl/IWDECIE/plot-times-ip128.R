times.ip128.r32.R3 <- read.table('times-R-ip128-r32-R3.dat')
times.ip128.r16.R5 <- read.table('times-R-ip128-r16-R5.dat')
times.ip128.r16.R6 <- read.table('times-R-ip128-r16-R6.dat')
times.base <- read.table('../GECCO/time-ip128-e16-r64.dat')
boxplot( times.base$V1,
         times.ip128.r32.R3$V1, 
        times.ip128.r16.R5$V1, times.ip128.r16.R6$V1,
        main='SofEA 1, Time to Solution',  sub='Initial pop = 128',
        xlab='Configuration',
        ylab='Time (s)' )
axis(1,at=c(1:4),labels =c('SofEA0', 'r32R3', 'r16R5', 'r16R6' ))
