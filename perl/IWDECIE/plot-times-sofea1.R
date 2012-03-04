boxplot( times.base$V1,
        times.dis$V1,   times.ip128.r16.R5$V1,   times.i64.p128.r32.R3$V1,
        main='SofEA 1, Running time',  sub='Diverse block size',
        xlab='Configuration',
        ylab='# Evaluations' )
axis(1,at=c(1:4),labels =c('SofEA0', '64,32,16', 'i128,r16,R5', 'i64,r32,R3' ))
