times.dis <- read.table('times-dis.dat')
times.dis.a8 <- read.table('times-dis-a8.dat')
times.dis.96 <- read.table('times-dis-96.dat')
times.base <- read.table('../GECCO/time-ip128-e16-r64.dat')
boxplot( times.base$V1,
        times.dis$V1,   times.dis.a8$V1,   times.dis.96$V1,
        main='SofEA 1, Running time',  sub='Diverse block size',
        xlab='Configuration',
        ylab='# Evaluations' )
axis(1,at=c(1:4),labels =c('SofEA0', '64,32,16', '96,64,32,16', '64,32,16,8' ))
