time.island.r32 <- read.table('time-island-r32.dat')
time.island.r64 <- read.table('time-island-r64.dat')
time.island.r128 <- read.table('time-island-r128.dat')
time.island.r256 <- read.table('time-island-r256.dat')

boxplot(  time.island.r256$V1, time.island.r128$V1,
        time.island.r64$V1, time.island.r32$V1,
        main='SofEA-Island Average time to solution',  sub='MaxOnes (256)',
        xlab='Configuration',
        ylab='Time to solution (s)' )
axis(1,at=c(1:4),labels =c('256','128','64', '32' ))
