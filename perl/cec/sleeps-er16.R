sleeps.i128.p128.er16.eval1.repro1 <- read.table('sleeps-i128-p128-er16-eval1-repro1.dat')
sleeps.i128.p128.er16.eval6.repro2 <- read.table('sleeps-i128-p128-er16-eval6-repro2.dat')
sleeps.i128.p128.er16.eval4.repro1 <- read.table('sleeps-i128-p128-er16-eval4-repro1.dat')
sleeps.i128.p128.er16.eval9.repro3 <- read.table('sleeps-i128-p128-er16-eval9-repro3.dat')
sleeps.er16.df <- data.frame( Configuration=c(rep('E1R1',length(sleeps.i128.p128.er16.eval1.repro1$V1)), 
                                rep('E4R1',length(sleeps.i128.p128.er16.eval4.repro1$V1)),
                                rep('E6R2',length(sleeps.i128.p128.er16.eval6.repro2$V1)),
                                rep('E9R3',length(sleeps.i128.p128.er16.eval9.repro3$V1)) ),
                            Sleeps=c(sleeps.i128.p128.er16.eval1.repro1$V1,
                              sleeps.i128.p128.er16.eval4.repro1$V1,
                              sleeps.i128.p128.er16.eval6.repro2$V1,
                              sleeps.i128.p128.er16.eval9.repro3$V1));
boxplot(sleeps.er16.df$Sleeps ~ sleeps.er16.df$Configuration,main='Average Sleeping periods (s)',
        sub='Evaluator and reproducer packet size = 16',xlab='Configuration Evaluators and Reproducers',ylab='Sleeping periods (s)' )
