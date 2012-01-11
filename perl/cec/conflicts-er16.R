conflicts.i128.p128.er16.eval2.repro1 <- read.table('conflicts-i128-p128-er16-eval2-repro1.dat')
conflicts.i128.p128.er16.eval6.repro2 <- read.table('conflicts-i128-p128-er16-eval6-repro2.dat')
conflicts.i128.p128.er16.eval4.repro1 <- read.table('conflicts-i128-p128-er16-eval4-repro1.dat')
conflicts.i128.p128.er16.eval9.repro3 <- read.table('conflicts-i128-p128-er16-eval9-repro3.dat')
conflicts.er16.df <- data.frame( Configuration=c(rep('E2R1',length(conflicts.i128.p128.er16.eval2.repro1$V1)), 
                                rep('E4R1',length(conflicts.i128.p128.er16.eval4.repro1$V1)),
                                rep('E6R2',length(conflicts.i128.p128.er16.eval6.repro2$V1)),
                                rep('E9R3',length(conflicts.i128.p128.er16.eval9.repro3$V1)) ),
                            Conflicts=c(conflicts.i128.p128.er16.eval2.repro1$V1,
                              conflicts.i128.p128.er16.eval4.repro1$V1,
                              conflicts.i128.p128.er16.eval6.repro2$V1,
                              conflicts.i128.p128.er16.eval9.repro3$V1));
boxplot(conflicts.er16.df$Conflicts ~ conflicts.er16.df$Configuration,main='Average Number of Conflicts',
        sub='Evaluator and reproducer packet size = 16',xlab='Configuration Evaluators and Reproducers',ylab='Average number of conflicts per client' )
