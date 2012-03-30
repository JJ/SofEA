evals.elite.r32 <- read.table('evals-elite-r32.dat')
evals.elite.r64 <- read.table('evals-elite-r64.dat')
evals.elite.r128 <- read.table('evals-elite-r128.dat')
evals.elite.r256 <- read.table('evals-elite-r256.dat')

boxplot(  evals.elite.r256$V1, evals.elite.r128$V1,
        evals.elite.r64$V1, evals.elite.r32$V1,
        main='SofEA-Elite Evaluations to Solution (per client)',  sub='MaxOnes (256)',
        xlab='Configuration',
        ylab='#Evals to solution' )
axis(1,at=c(1:4),labels =c('256','128','64', '32' ))
