evals.ip128.e96.r48.eval1.repro1 <- read.table('evals-ip128-e96-r48-eval1-repro1.dat')
evals.ip128.e96.r48.eval1.repro1.new <- read.table('evals-ip128-e96-r48-eval1-repro1-new.dat')
evals.ip128.e96.r24.eval1.repro2<- read.table('evals-ip128-e96-r24-eval1-repro2.dat')
evals.ip128.e96.r24.eval1.repro2.new <- read.table('evals-ip128-e96-r24-eval1-repro2-new.dat')
evals.df <- data.frame( Configuration=c(rep('ER1',length(evals.ip128.e96.r48.eval1.repro1$V1)), 
                          rep('ER1-New',length(evals.ip128.e96.r48.eval1.repro1.new$V1)),
                          rep('E1R2',length(evals.ip128.e96.r24.eval1.repro2$V1)),
                          rep('E1R2-New',length(evals.ip128.e96.r24.eval1.repro2.new$V1)) ),
                       Evals=c(evals.ip128.e96.r48.eval1.repro1$V1, 
                                evals.ip128.e96.r48.eval1.repro1.new$V1,
                               evals.ip128.e96.r24.eval1.repro2$V1,
                               evals.ip128.e96.r24.eval1.repro2.new$V1)
                       );
boxplot( evals.df$Evals ~ evals.df$Configuration )
