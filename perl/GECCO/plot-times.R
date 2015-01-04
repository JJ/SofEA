times.ip128.e96.r48.eval1.repro1 <- read.table('times-ip128-e96-r48-eval1-repro1.dat')
times.ip128.e96.r48.eval1.repro1.new <- read.table('times-ip128-e96-r48-eval1-repro1-new.dat')
times.ip128.e96.r24.eval1.repro2<- read.table('times-ip128-e96-r24-eval1-repro2.dat')
times.ip128.e96.r24.eval1.repro2.new <- read.table('times-ip128-e96-r24-eval1-repro2-new.dat')
times.df <- data.frame( Configuration=c(rep('ER1',length(times.ip128.e96.r48.eval1.repro1$V1)), 
                          rep('ER1-New',length(times.ip128.e96.r48.eval1.repro1.new$V1)),
                          rep('E1R2',length(times.ip128.e96.r24.eval1.repro2$V1)),
                          rep('E1R2-New',length(times.ip128.e96.r24.eval1.repro2.new$V1)) ),
                       Times=c(times.ip128.e96.r48.eval1.repro1$V1, 
                                times.ip128.e96.r48.eval1.repro1.new$V1,
                               times.ip128.e96.r24.eval1.repro2$V1,
                               times.ip128.e96.r24.eval1.repro2.new$V1)
                       );
boxplot( times.df$Times ~ times.df$Configuration )
