boxplot( times.base$V1,
        times.dis$V1,   times.ip128.r16.R5$V1,   times.i64.p128.r32.R3$V1,
        main='SofEA 1, Time to Solution',  sub='Diverse block size and number of clients',
        xlab='Configuration',
        ylab='Time (s)' )
axis(1,at=c(1:4),labels =c('SofEA0', 'r64+r32+r16', 'i128r16R5', 'i64r32R3' ))
