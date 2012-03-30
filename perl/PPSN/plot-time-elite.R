time.elite.r32 <- read.table('time-elite-r32.dat')
time.elite.r64 <- read.table('time-elite-r64.dat')
time.elite.r128 <- read.table('time-elite-r128.dat')
time.elite.r256 <- read.table('time-elite-r256.dat')

boxplot(  time.elite.r256$V1, time.elite.r128$V1,
        time.elite.r64$V1, time.elite.r32$V1,
        main='SofEA-Elite Average time to solution',  sub='MaxOnes (256)',
        xlab='Configuration',
        ylab='Time to solution (s)' )
axis(1,at=c(1:4),labels =c('256','128','64', '32' ))
