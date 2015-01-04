times.i64.p128.r64.R1 <- read.table('times-R-i64-p128-r64-r1.dat')
times.i64.p128.r64.R2 <- read.table('times-R-i64-p128-r64-r2.dat')
times.i64.p128.r32.R3 <- read.table('times-R-i64-p128-r32-R3.dat')
times.i64.p128.r32.R4 <- read.table('times-R-i64-p128-r32-R4.dat')
times.i64.p128.r16.R5 <- read.table('times-R-i64-p128-r16-R5.dat')
times.i64.p128.r16.R6 <- read.table('times-R-i64-p128-r16-R6.dat')
times.base <- read.table('../GECCO/time-ip128-e16-r64.dat')
boxplot( times.base$V1,
        times.i64.p128.r64.R1$V1, times.i64.p128.r64.R2$V1,
        times.i64.p128.r32.R3$V1, times.i64.p128.r32.R4$V1,
        times.i64.p128.r16.R5$V1, times.i64.p128.r16.R6$V1,
        main='SofEA 1, Time to Solution',  sub='Initial pop = 64, population = 128',
        xlab='Configuration',
        ylab='Time (s)' )
axis(1,at=c(1:7),labels =c('SofEA0','r64R1', 'r64R2', 'r32R3', 'r32R4','r16R5', 'r16R6' ))
