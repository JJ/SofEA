time.i128.p128.er16.eval1.repro1 <- read.table('time-i128-p128-er16-eval1-repro1.dat')
time.i128.p128.er16.eval2.repro1 <- read.table('time-i128-p128-er16-eval2-repro1.dat')
time.i128.p128.er16.eval2.repro1.id1 <- read.table('time-i128-p128-er16-eval2-repro1-id1.dat')
time.i128.p128.er16.eval6.repro2 <- read.table('time-i128-p128-er16-eval6-repro2.dat')
time.i128.p128.er16.eval4.repro1 <- read.table('time-i128-p128-er16-eval4-repro1.dat')
time.i128.p128.er16.eval8.repro2 <- read.table('time-i128-p128-er16-eval8-repro2.dat')
time.er16.df <- data.frame( Configuration=c(rep('E1R1',10), rep('E2R1',10), rep('E4R1',10), rep('E6R2',20), rep('E8R2',20) ),
                            Time=c(time.i128.p128.er16.eval1.repro1$V1,
                              time.i128.p128.er16.eval2.repro1$V1, time.i128.p128.er16.eval4.repro1$V1,
                              time.i128.p128.er16.eval6.repro2$V1, time.i128.p128.er16.eval8.repro2$V1));
boxplot(time.er16.df$Time ~ time.er16.df$Configuration,main='Average Time (in seconds) to Solution',
        sub='Evaluator and reproducer packet size = 16',xlab='Configuration Evaluators and Reproducers',ylab='Seconds' )
time.er16.eval2.df <- data.frame( Configuration=c(rep('No delay',10), rep('Delay',10) ),
                            Time=c(time.i128.p128.er16.eval2.repro1$V1,
                              time.i128.p128.er16.eval2.repro1.id1$V1));
boxplot(time.er16.eval2.df$Time ~ time.er16.eval2.df$Configuration,main='Average Time (in seconds) to Solution',
        sub='Evaluator and reproducer packet size = 16. effect of asynchrony',xlab='Delay',ylab='Seconds' )
