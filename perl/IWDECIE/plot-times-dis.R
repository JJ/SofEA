times.dis <- read.table('times-dis.dat')
times.dis.a8 <- read.table('times-dis-a8.dat')
times.dis.96 <- read.table('times-dis-96.dat')
times.base <- read.table('../GECCO/time-ip128-e16-r64.dat')
boxplot( times.base$V1,
        times.dis$V1,   times.dis.a8$V1,   times.dis.96$V1,
        main='SofEA 1, Time to Solution',  sub='Diverse block size and number of clients',
        xlab='Configuration',
        ylab='Time (s)' )
axis(1,at=c(1:4),mgp=c(5,2,0),
     labels =c('SofEA0', 'r64+r32+r16', 'r96+r64\n+r32+r16', 'r64+r32\n+r16+r8' ))
